function stat = select_stat(stat,region,hemi,parameter)

pos = parc2pos(region);

if strcmp(hemi,'lh')
    mask = parameter.lh{pos}.parc_shrink == pos;
else  
    mask = parameter.rh{pos}.parc_shrink == pos;
    
end

psz = parameter.psz;
step = parameter.step;


[M,N] = size(mask);

MM = length(1:step:(M-psz+1));
NN = length(1:step:(N-psz+1));

small_stat = reshape(stat,MM,NN);
stat = zeros(M-psz+1,N-psz+1);
for ii=1:step
    vi = 1:step:(M-psz+1);
    vi = vi + ii - 1;
    wi = 1:MM;
    if (vi(end) > M-psz+1)
        vi(end) = [];
        wi(end) = [];
    end
    for jj=1:step
        vj = 1:step:(N-psz+1);
        vj = vj + jj - 1;
        wj = 1:NN;
        if (vj(end) > N-psz+1)
            vj(end) = [];
            wj(end) = [];
        end
        stat(vi,vj) = small_stat(wi,wj);
    end
end

up_ = round(psz/2);
down_ = up_ - 1;

stat = stat(mask(up_:end-down_,up_:end-down_));


end


