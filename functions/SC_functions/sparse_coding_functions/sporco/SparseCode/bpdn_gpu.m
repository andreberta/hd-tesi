function [Y, optinf] = bpdn_gpu(D, S, lambda, opt)

% bpdn -- Basis Pursuit DeNoising (GPU version)
%
%         argmin_x (1/2)||D*x - s||_2^2 + lambda*||x||_1
%
%         The solution of the BPDN problem (see chen-1998-atomic) is
%         computed using the ADMM approach (see boyd-2010-distributed).
%
% Usage:
%       [Y, optinf] = bpdn(D, S, lambda, opt)
%
% Input:
%       D           Dictionary matrix
%       S           Signal vector (or matrix)
%       lambda      Regularization parameter
%       opt         Options/algorithm parameters structure (see below)
%
% Output:
%       Y           Dictionary coefficient vector (or matrix)
%       optinf      Details of optimisation
%
%
% Options structure fields:
%   Verbose           Flag determining whether iteration status is displayed.
%                     Fields are iteration number, functional value,
%                     data fidelity term, l1 regularisation term, and
%                     primal and dual residuals (see Sec. 3.3 of
%                     boyd-2010-distributed). The value of rho is also
%                     displayed if options request that it is automatically
%                     adjusted.
%   MaxMainIter       Maximum main iterations
%   AbsStopTol        Absolute convergence tolerance (see Sec. 3.3.1 of
%                     boyd-2010-distributed)
%   RelStopTol        Relative convergence tolerance (see Sec. 3.3.1 of
%                     boyd-2010-distributed)
%   L1Weight          Weighting array for coefficients in l1 norm of X
%   Y0                Initial value for Y
%   U0                Initial value for U
%   rho               ADMM penalty parameter
%   AutoRho           Flag determining whether rho is automatically updated
%                     (see Sec. 3.4.1 of boyd-2010-distributed)
%   AutoRhoPeriod     Iteration period on which rho is updated
%   RhoRsdlRatio      Primal/dual residual ratio in rho update test
%   RhoScaling        Multiplier applied to rho when updated
%   AutoRhoScaling    Flag determining whether RhoScaling value is
%                     adaptively determined (see wohlberg-2015-adaptive). If
%                     enabled, RhoScaling specifies a maximum allowed
%                     multiplier instead of a fixed multiplier.
%   RhoRsdlTarget     Residual ratio targeted by auto rho update policy.
%   StdResiduals      Flag determining whether standard residual definitions
%                     (see Sec 3.3 of boyd-2010-distributed) are used instead
%                     of normalised residuals (see wohlberg-2015-adaptive)
%   RelaxParam        Relaxation parameter (see Sec. 3.4.3 of
%                     boyd-2010-distributed)
%   AuxVarObj         Flag determining whether objective function is computed
%                     using the auxiliary (split) variable
%
%
% Author: Brendt Wohlberg <brendt@lanl.gov>  Modified: 2015-07-23
%
% This file is part of the SPORCO library. Details of the copyright
% and user license can be found in the 'License' file distributed with
% the library.

gS = gpuArray(S);
gD = gpuArray(D);
glambda = gpuArray(lambda);

if nargin < 4,
    opt = [];
end
checkopt(opt, defaultopts([]));
opt = defaultopts(opt);

% Default lambda is 1/10 times the lambda value beyond which the
% solution is a zero vector
if nargin < 3 | isempty(lambda),
    lambda = 0.1*max(vec(abs(D'*S)));
end

% Set up status display for verbose operation
hstr = 'Itn   Fnc       DFid      l1        r         s      ';
sfms = '%4d %9.2e %9.2e %9.2e %9.2e %9.2e';
nsep = 54;
if opt.AutoRho,
    hstr = [hstr '   rho   '];
    sfms = [sfms ' %9.2e'];
    nsep = nsep + 10;
end
if opt.Verbose && opt.MaxMainIter > 0,
    disp(hstr);
    disp(char('-' * ones(1,nsep)));
end

% Start timer
tstart = tic;

% Set up algorithm parameters and initialise variables
grho = gpuArray(opt.rho);
gRelaxParam = gpuArray(opt.RelaxParam);
gL1Weight = gpuArray(opt.L1Weight);
gAbsStopTol = gpuArray(opt.AbsStopTol);
gRelStopTol = gpuArray(opt.RelStopTol);
if isempty(grho), grho = 50*glambda+1; end;
[Nr, Nc] = size(D);
Nm = size(S,2);
Nx = Nc*Nm;
gNx = gpuArray(Nx);
gDTS = gD'*gS;
[gluL, gluU] = factorise(gD, grho);
optinf = struct('itstat', [], 'opt', opt);
gr = gpuArray(Inf);
gs = gpuArray(Inf);
gepri = gpuArray(0);
gedua = gpuArray(0);

% Initialise main working variables
% X = [];
if isempty(opt.Y0),
%     Y = zeros(Nc,Nm);
    gY = gpuArray.zeros([Nc Nm]);
else
    gY = gpuArray(opt.Y0);
end
gYprv = gY;
if isempty(opt.U0),
    if isempty(opt.Y0),
%         U = zeros(Nc,Nm);
        gU = gpuArray.zeros([Nc Nm]);
    else
        gU = (glambda/grho)*sign(gY);
    end
else
    gU = gpuArray(opt.U0);
end

% Main loop
k = 1;
while k <= opt.MaxMainIter && (gr > gepri || gs > gedua),
    
    % Solve X subproblem
    gX = linsolve(gD, grho, gluL, gluU, gDTS + grho*(gY - gU));
    
    % See pg. 21 of boyd-2010-distributed
    if opt.RelaxParam == 1,
        gXr = gX;
    else
        gXr = gRelaxParam*gX + (1-gRelaxParam)*gY;
    end
    
    % Solve Y subproblem
    gY = shrink(gXr + gU, (glambda/grho)*gL1Weight);
    
    % Update dual variable
    gU = gU + gXr - gY;
    
    % Objective function and convergence measures
    if opt.AuxVarObj,
        gJdf = sum(vec(abs(gD*gY - gS).^2))/2;
        gJl1 = sum(abs(vec(bsxfun(@times, gL1Weight, gY))));
    else
        gJdf = sum(vec(abs(gD*gX - gS).^2))/2;
        gJl1 = sum(abs(vec(bsxfun(@times, gL1Weight, gX))));
    end
    gJfn = gJdf + glambda*gJl1;
    
    gnX = norm(gX(:)); gnY = norm(gY(:)); gnU = norm(gU(:));
    if opt.StdResiduals,
        % See pp. 19-20 of boyd-2010-distributed
        gr = norm(vec(gX - gY));
        gs = norm(vec(grho*(gYprv - gY)));
        gepri = sqrt(gNx)*gAbsStopTol+max(gnX,gnY)*gRelStopTol;
        gedua = sqrt(gNx)*gAbsStopTol+grho*gnU*gRelStopTol;
    else
        % See wohlberg-2015-adaptive
        gr = norm(vec(gX - gY))/max(gnX,gnY);
        gs = norm(vec(gYprv - gY))/gnU;
        gepri = sqrt(gNx)*gAbsStopTol/max(gnX,gnY)+gRelStopTol;
        gedua = sqrt(gNx)*gAbsStopTol/(grho*gnU)+gRelStopTol;
    end
    
    % Record and display iteration details
    Jfn = gather(gJfn);
    Jdf = gather(gJdf);
    Jl1 = gather(gJl1);
    r = gather(gr);
    s = gather(gs);
    epri = gather(gepri);
    edua = gather(gedua);
    rho = gather(grho);
    tk = toc(tstart);
    optinf.itstat = [optinf.itstat; [k Jfn Jdf Jl1 r s epri edua rho tk]];
    if opt.Verbose,
        if opt.AutoRho,
            disp(sprintf(sfms, k, Jfn, Jdf, Jl1, r, s, rho));
        else
            disp(sprintf(sfms, k, Jfn, Jdf, Jl1, r, s));
        end
    end
    
    % See wohlberg-2015-adaptive and pp. 20-21 of boyd-2010-distributed
    if opt.AutoRho,
        if k ~= 1 && mod(k, opt.AutoRhoPeriod) == 0,
            if opt.AutoRhoScaling,
                rhomlt = sqrt(r/(s*opt.RhoRsdlTarget));
                if rhomlt < 1, rhomlt = 1/rhomlt; end
                if rhomlt > opt.RhoScaling, rhomlt = opt.RhoScaling; end
            else
                rhomlt = opt.RhoScaling;
            end
            rsf = 1;
            if r > opt.RhoRsdlTarget*opt.RhoRsdlRatio*s, rsf = rhomlt; end
            if s > (opt.RhoRsdlRatio/opt.RhoRsdlTarget)*r, rsf = 1/rhomlt; end
            grsf = gpuArray(rsf);
            grho = grsf*grho;
            gU = gU/grsf;
            if rsf ~= 1,
                [gluL, gluU] = factorise(gD, grho);
            end
        end
    end
    
    gYprv = gY;
    k = k + 1;
    
end

% Record run time and working variables
X = gather(gX);
Y = gather(gY);
U = gather(gU);
lambda = gather(glambda);
rho = gather(grho);
optinf.runtime = toc(tstart);
optinf.X = X;
optinf.Y = Y;
optinf.U = U;
optinf.lambda = lambda;
optinf.rho = rho;

% End status display for verbose operation
if opt.Verbose && opt.MaxMainIter > 0,
    disp(char('-' * ones(1,nsep)));
end

return


function u = vec(v)

u = v(:);

return


function u = shrink(v, lambda)

if isscalar(lambda),
    u = sign(v).*max(0, abs(v) - lambda);
else
    u = sign(v).*max(0, bsxfun(@minus, abs(v), lambda));
end

return


function [L,U] = factorise(A, c)

[N,M] = size(A);
% If N < M it is cheaper to factorise A*A' + cI and then use the
% matrix inversion lemma to compute the inverse of A'*A + cI
if N >= M,
    [L,U] = lu(A'*A + c*eye(M,M));
else
    [L,U] = lu(A*A' + c*eye(N,N));
end

return


function x = linsolve(A, c, L, U, b)

[N,M] = size(A);
if N >= M,
    x = U \ (L \ b);
else
    x = (b - A'*(U \ (L \ (A*b))))/c;
end

return


function opt = defaultopts(opt)

if ~isfield(opt,'Verbose'),
    opt.Verbose = 0;
end
if ~isfield(opt,'MaxMainIter'),
    opt.MaxMainIter = 1000;
end
if ~isfield(opt,'AbsStopTol'),
    opt.AbsStopTol = 0;
end
if ~isfield(opt,'RelStopTol'),
    opt.RelStopTol = 1e-4;
end
if ~isfield(opt,'L1Weight'),
    opt.L1Weight = 1;
end
if ~isfield(opt,'Y0'),
    opt.Y0 = [];
end
if ~isfield(opt,'U0'),
    opt.U0 = [];
end
if ~isfield(opt,'rho'),
    opt.rho = [];
end
if ~isfield(opt,'AutoRho'),
    opt.AutoRho = 1;
end
if ~isfield(opt,'AutoRhoPeriod'),
    opt.AutoRhoPeriod = 10;
end
if ~isfield(opt,'RhoRsdlRatio'),
    opt.RhoRsdlRatio = 1.2;
end
if ~isfield(opt,'RhoScaling'),
    opt.RhoScaling = 100;
end
if ~isfield(opt,'AutoRhoScaling'),
    opt.AutoRhoScaling = 1;
end
if ~isfield(opt,'RhoRsdlTarget'),
    opt.RhoRsdlTarget = 1;
end
if ~isfield(opt,'StdResiduals'),
    opt.StdResiduals = 0;
end
if ~isfield(opt,'RelaxParam'),
    opt.RelaxParam = 1.8;
end
if ~isfield(opt,'AuxVarObj'),
    opt.AuxVarObj = 1;
end

return
