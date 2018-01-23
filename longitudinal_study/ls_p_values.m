%% initialization
HD_patient = {'R003833008','R035507376','R04540108X','R061498291',...
    'R064906976','R105432869','R121532712','R135289971',...
    'R139656824','R171064892','R178341801','R217548576',...
    'R245726018','R247388241','R252012422','R259227210',...
    'R269043034','R275695571','R298174257','R304648773'};

control_patient = {'R015150415','R029890379','R043875068','R06335342X',...
    'R113409507','R154597824','R157808098','R159147998'};

load('parameter.mat');

% visit per thickness
visits_contr = 1:4;
visits_HD = 1:4;
%max visit number per as
max_visits = 2;

curv_type = 'thickness';
alpha = 5/100;

% control var
p_1D_V1_contr_lh = nan(length(control_patient),37);
p_1D_V1_contr_rh = nan(length(control_patient),37);
%
p_1D_V2_contr_lh = nan(length(control_patient),37);
p_1D_V2_contr_rh = nan(length(control_patient),37);

p_2D_contr_lh = nan(length(control_patient),37);
p_2D_contr_rh = nan(length(control_patient),37);

p_3D_contr_lh = nan(length(control_patient),37);
p_3D_contr_rh = nan(length(control_patient),37);

h_1D_V1_contr_lh = nan(length(control_patient),37);
h_1D_V1_contr_rh = nan(length(control_patient),37);

h_1D_V2_contr_lh = nan(length(control_patient),37);
h_1D_V2_contr_rh = nan(length(control_patient),37);

h_2D_contr_lh = nan(length(control_patient),37);
h_2D_contr_rh = nan(length(control_patient),37);

h_3D_contr_lh = nan(length(control_patient),37);
h_3D_contr_rh = nan(length(control_patient),37);

% HD var
p_1D_V1_HD_lh = nan(length(HD_patient),37);
p_1D_V1_HD_rh = nan(length(HD_patient),37);

p_1D_V2_HD_lh = nan(length(control_patient),37);
p_1D_V2_HD_rh = nan(length(control_patient),37);

p_2D_HD_lh = nan(length(HD_patient),37);
p_2D_HD_rh = nan(length(HD_patient),37);

p_3D_HD_lh = nan(length(HD_patient),37);
p_3D_HD_rh = nan(length(HD_patient),37);

h_1D_V1_HD_lh = nan(length(HD_patient),37);
h_1D_V1_HD_rh = nan(length(HD_patient),37);

h_1D_V2_HD_lh = nan(length(control_patient),37);
h_1D_V2_HD_rh = nan(length(control_patient),37);

h_2D_HD_lh = nan(length(HD_patient),37);
h_2D_HD_rh = nan(length(HD_patient),37);

h_3D_HD_lh = nan(length(HD_patient),37);
h_3D_HD_rh = nan(length(HD_patient),37);


%% Computation - Kruskal Control

for ii=1:length(control_patient)
    disp(control_patient{ii});
    
%     disp('1D_V1')
%     [h_1D_V1_contr_lh(ii,:),p_1D_V1_contr_lh(ii,:)] =...
%         ls_kruskall_curv(control_patient{ii},'lh',curv_type,parameter,visits_contr,alpha);
%     [h_1D_V1_contr_rh(ii,:),p_1D_V1_contr_rh(ii,:)] =...
%         ls_kruskall_curv(control_patient{ii},'rh',curv_type,parameter,visits_contr,alpha);
    
    disp('1D_V2')
    [h_1D_V2_contr_lh(ii,:),p_1D_V2_contr_lh(ii,:)] =...
        ls_kruskall_curv_pw(control_patient{ii},'lh',curv_type,parameter,visits_contr,alpha);
    [h_1D_V2_contr_rh(ii,:),p_1D_V2_contr_rh(ii,:)] =...
        ls_kruskall_curv_pw(control_patient{ii},'rh',curv_type,parameter,visits_contr,alpha);
    
    disp('2D')
    parameter.save_path = @save_kde2d;
    [h_2D_contr_lh(ii,:),p_2D_contr_lh(ii,:)] =...
        ls_kruskall(control_patient{ii},'lh',curv_type,parameter,alpha,max_visits);
    [h_2D_contr_rh(ii,:),p_2D_contr_rh(ii,:)] =...
        ls_kruskall(control_patient{ii},'rh',curv_type,parameter,alpha,max_visits);
    
    disp('3D')
    parameter.save_path = @save_kde3d;
    [h_3D_contr_lh(ii,:),p_3D_contr_lh(ii,:)] =...
        ls_kruskall(control_patient{ii},'lh',curv_type,parameter,alpha,max_visits);
    [h_3D_contr_rh(ii,:),p_3D_contr_rh(ii,:)] =...
        ls_kruskall(control_patient{ii},'rh',curv_type,parameter,alpha,max_visits);
end

%% Computation - Kruskal HD

for ii=1:length(HD_patient)
    disp(HD_patient{ii});
    
    disp('1D_V1')
    [h_1D_V1_HD_lh(ii,:),p_1D_V1_HD_lh(ii,:)] =...
        ls_kruskall_curv(HD_patient{ii},'lh',curv_type,parameter,visits_HD,alpha);
    [h_1D_V1_HD_rh(ii,:),p_1D_V1_HD_rh(ii,:)] =... 
        ls_kruskall_curv(HD_patient{ii},'rh',curv_type,parameter,visits_HD,alpha);
    
    disp('1D_V2')
    [h_1D_V2_HD_lh(ii,:),p_1D_V2_HD_lh(ii,:)] =...
        ls_kruskall_curv_pw(HD_patient{ii},'lh',curv_type,parameter,visits_HD,alpha);
    [h_1D_V2_HD_rh(ii,:),p_1D_V2_HD_rh(ii,:)] =...
        ls_kruskall_curv_pw(HD_patient{ii},'rh',curv_type,parameter,visits_HD,alpha);
    
    disp('2D')
    parameter.save_path = @save_kde2d;
    [h_2D_HD_lh(ii,:),p_2D_HD_lh(ii,:)] =...
        ls_kruskall(HD_patient{ii},'lh',curv_type,parameter,alpha,max_visits);
    [h_2D_HD_rh(ii,:),p_2D_HD_rh(ii,:)] =...
        ls_kruskall(HD_patient{ii},'rh',curv_type,parameter,alpha,max_visits);
    
    disp('3D')
    parameter.save_path = @save_kde3d;
    [h_3D_HD_lh(ii,:),p_3D_HD_lh(ii,:)] =...
        ls_kruskall(HD_patient{ii},'lh',curv_type,parameter,alpha,max_visits);
    [h_3D_HD_rh(ii,:),p_3D_HD_rh(ii,:)] =...
        ls_kruskall(HD_patient{ii},'rh',curv_type,parameter,alpha,max_visits);
end


%% Computation - Ranksum

for ii=1:length(HD_patient)
    disp(HD_patient{ii});
    
    disp('1D_V1')
    [rank_h_1D_V1_lh(:,ii),rank_h_1D_V1_rh(:,ii),rank_p_1D_V1_lh(:,ii),rank_p_1D_V1_rh(:,ii)] = ls_rank_curv(HD_patient{ii},curv_type,parameter,3:4);
    
    disp('1D_V2')
    [rank_h_1D_V2_lh(:,ii),rank_h_1D_V2_rh(:,ii),rank_p_1D_V2_lh(:,ii),rank_p_1D_V2_rh(:,ii)] = ls_rank_curv_pw(HD_patient{ii},curv_type,parameter,3:4);
    
    disp('2D')
    parameter.save_path = @save_kde2d;
    [rank_h_2D_lh(:,ii),rank_h_2D_rh(:,ii),rank_p_2D_lh(:,ii),rank_p_2D_rh(:,ii)] = ls_rank(HD_patient{ii},curv_type,parameter);
    
    disp('3D')
    parameter.save_path = @save_kde3d;
    [rank_h_3D_lh(:,ii),rank_h_3D_rh(:,ii),rank_p_3D_lh(:,ii),rank_p_3D_rh(:,ii)] = ls_rank(HD_patient{ii},curv_type,parameter);
end

%%
    %% show results -P-VALUE- Control

    disp('Control Kruskall-Wallis results')
    disp('h_1D_V1_contr_lh')
    disp(sum(p_1D_V1_contr_lh(~isnan(p_1D_V1_contr_lh)))/numel(p_1D_V1_contr_lh(~isnan(p_1D_V1_contr_lh))))
    disp('h_1D_V1_contr_rh')
    disp(sum(p_1D_V1_contr_rh(~isnan(p_1D_V1_contr_rh)))/numel(p_1D_V1_contr_rh(~isnan(p_1D_V1_contr_rh))))

    disp('h_1D_V2_contr_lh')
    disp(sum(p_1D_V2_contr_lh(~isnan(p_1D_V2_contr_lh)))/numel(p_1D_V2_contr_lh(~isnan(p_1D_V2_contr_lh))))
    disp('h_1D_V2_contr_lh')
    disp(sum(p_1D_V2_contr_lh(~isnan(p_1D_V2_contr_lh)))/numel(p_1D_V2_contr_lh(~isnan(p_1D_V2_contr_lh))))

    disp('h_2D_contr_lh')
    disp(sum(p_2D_contr_lh(~isnan(p_2D_contr_lh)))/numel(p_2D_contr_lh(~isnan(p_2D_contr_lh))))
    disp('h_2D_contr_rh')
    disp(sum(p_2D_contr_rh(~isnan(p_2D_contr_rh)))/numel(p_2D_contr_rh(~isnan(p_2D_contr_rh))))

    disp('h_3D_contr_lh')
    disp(sum(p_3D_contr_lh(~isnan(p_3D_contr_lh)))/numel(p_3D_contr_lh(~isnan(p_3D_contr_lh))))
    disp('h_3D_contr_rh')
    disp(sum(p_3D_contr_rh(~isnan(p_3D_contr_rh)))/numel(p_3D_contr_rh(~isnan(p_3D_contr_rh))))


    %% show results -P-VALUE- HD
    disp('HD Kruskall-Wallis results')
    disp('h_1D_V1_HD_lh')
    disp(sum(p_1D_V1_HD_lh(~isnan(p_1D_V1_HD_lh)))/numel(p_1D_V1_HD_lh(~isnan(p_1D_V1_HD_lh))))
    disp('h_1D_V1_HD_rh')
    disp(sum(p_1D_V1_HD_rh(~isnan(p_1D_V1_HD_rh)))/numel(p_1D_V1_HD_rh(~isnan(p_1D_V1_HD_rh))))

    disp('h_1D_V2_HD_lh')
    disp(sum(p_1D_V2_HD_lh(~isnan(p_1D_V2_HD_lh)))/numel(p_1D_V2_HD_lh(~isnan(p_1D_V2_HD_lh))))
    disp('h_1D_V2_HD_rh')
    disp(sum(p_1D_V2_HD_rh(~isnan(p_1D_V2_HD_rh)))/numel(p_1D_V2_HD_rh(~isnan(p_1D_V2_HD_rh))))

    disp('h_2D_HD_lh')
    disp(sum(p_2D_HD_lh(~isnan(p_2D_HD_lh)))/numel(p_2D_HD_lh(~isnan(p_2D_HD_lh))))
    disp('h_2D_HD_rh')
    disp(sum(p_2D_HD_rh(~isnan(p_2D_HD_rh)))/numel(p_2D_HD_rh(~isnan(p_2D_HD_rh))))

    disp('h_3D_HD_lh')
    disp(sum(p_3D_HD_lh(~isnan(p_3D_HD_lh)))/numel(p_3D_HD_lh(~isnan(p_3D_HD_lh))))
    disp('h_3D_HD_rh')
    disp(sum(p_3D_HD_rh(~isnan(p_3D_HD_rh)))/numel(p_3D_HD_rh(~isnan(p_3D_HD_rh))))


    %% show results ranksum -P-VALUE-
    disp('HD Ranksum results')
    disp('rank_h_1D_V1_lh')
    disp(sum(rank_p_1D_V1_lh(~isnan(rank_p_1D_V1_lh)))/numel(rank_p_1D_V1_lh(~isnan(rank_p_1D_V1_lh))))
    disp('rank_h_1D_V1_rh')
    disp(sum(rank_p_1D_V1_rh(~isnan(rank_p_1D_V1_rh)))/numel(rank_p_1D_V1_rh(~isnan(rank_h_1D_V1_rh))))

    disp('rank_h_1D_V2_lh')
    disp(sum(rank_p_1D_V2_lh(~isnan(rank_p_1D_V2_lh)))/numel(rank_p_1D_V2_lh(~isnan(rank_p_1D_V2_lh))))
    disp('rank_h_1D_V2_rh')
    disp(sum(rank_p_1D_V2_rh(~isnan(rank_p_1D_V2_rh)))/numel(rank_p_1D_V2_rh(~isnan(rank_h_1D_V2_rh))))

    disp('rank_h_2D_lh')
    disp(sum(rank_p_2D_lh(~isnan(rank_p_2D_lh)))/numel(rank_p_2D_lh(~isnan(rank_p_2D_lh))))
    disp('rank_h_2D_rh')
    disp(sum(rank_p_2D_rh(~isnan(rank_p_2D_rh)))/numel(rank_p_2D_rh(~isnan(rank_p_2D_rh))))

    disp('rank_h_3D_lh')
    disp(sum(rank_p_3D_lh(~isnan(rank_p_3D_lh)))/numel(rank_p_3D_lh(~isnan(rank_p_3D_lh))))
    disp('rank_h_3D_rh')
    disp(sum(rank_p_3D_rh(~isnan(rank_p_3D_rh)))/numel(rank_p_3D_rh(~isnan(rank_p_3D_rh))))

%%
    %% show results -TEST PASSED- Control
    disp('Control Kruskall-Wallis results')
    disp('h_1D_V1_contr_lh')
    disp(sum(h_1D_V1_contr_lh(~isnan(h_1D_V1_contr_lh)))/numel(h_1D_V1_contr_lh(~isnan(h_1D_V1_contr_lh))))
    disp('h_1D_V1_contr_rh')
    disp(sum(h_1D_V1_contr_rh(~isnan(h_1D_V1_contr_rh)))/numel(h_1D_V1_contr_rh(~isnan(h_1D_V1_contr_rh))))

    disp('h_1D_V2_contr_lh')
    disp(sum(h_1D_V2_contr_lh(~isnan(h_1D_V2_contr_lh)))/numel(h_1D_V2_contr_lh(~isnan(h_1D_V2_contr_lh))))
    disp('h_1D_V2_contr_lh')
    disp(sum(h_1D_V2_contr_lh(~isnan(h_1D_V2_contr_lh)))/numel(h_1D_V2_contr_lh(~isnan(h_1D_V2_contr_lh))))

    disp('h_2D_contr_lh')
    disp(sum(h_2D_contr_lh(~isnan(h_2D_contr_lh)))/numel(h_2D_contr_lh(~isnan(h_2D_contr_lh))))
    disp('h_2D_contr_rh')
    disp(sum(h_2D_contr_rh(~isnan(h_2D_contr_rh)))/numel(h_2D_contr_rh(~isnan(h_2D_contr_rh))))

    disp('h_3D_contr_lh')
    disp(sum(h_3D_contr_lh(~isnan(h_3D_contr_lh)))/numel(h_3D_contr_lh(~isnan(h_3D_contr_lh))))
    disp('h_3D_contr_rh')
    disp(sum(h_3D_contr_rh(~isnan(h_3D_contr_rh)))/numel(h_3D_contr_rh(~isnan(h_3D_contr_rh))))


    %% show results -TEST PASSED- HD
    disp('HD Kruskall-Wallis results')
    disp('h_1D_V1_HD_lh')
    disp(sum(h_1D_V1_HD_lh(~isnan(h_1D_V1_HD_lh)))/numel(h_1D_V1_HD_lh(~isnan(h_1D_V1_HD_lh))))
    disp('h_1D_V1_HD_rh')
    disp(sum(h_1D_V1_HD_rh(~isnan(h_1D_V1_HD_rh)))/numel(h_1D_V1_HD_rh(~isnan(h_1D_V1_HD_rh))))

    disp('h_1D_V2_HD_lh')
    disp(sum(h_1D_V2_HD_lh(~isnan(h_1D_V2_HD_lh)))/numel(h_1D_V2_HD_lh(~isnan(h_1D_V2_HD_lh))))
    disp('h_1D_V2_HD_rh')
    disp(sum(h_1D_V2_HD_rh(~isnan(h_1D_V2_HD_rh)))/numel(h_1D_V2_HD_rh(~isnan(h_1D_V2_HD_rh))))

    disp('h_2D_HD_lh')
    disp(sum(h_2D_HD_lh(~isnan(h_2D_HD_lh)))/numel(h_2D_HD_lh(~isnan(h_2D_HD_lh))))
    disp('h_2D_HD_rh')
    disp(sum(h_2D_HD_rh(~isnan(h_2D_HD_rh)))/numel(h_2D_HD_rh(~isnan(h_2D_HD_rh))))

    disp('h_3D_HD_lh')
    disp(sum(h_3D_HD_lh(~isnan(h_3D_HD_lh)))/numel(h_3D_HD_lh(~isnan(h_3D_HD_lh))))
    disp('h_3D_HD_rh')
    disp(sum(h_3D_HD_rh(~isnan(h_3D_HD_rh)))/numel(h_3D_HD_rh(~isnan(h_3D_HD_rh))))


    %% show results ranksum -TEST PASSED-
    disp('HD Ranksum results')
    disp('rank_h_1D_V1_lh')
    disp(sum(rank_h_1D_V1_lh(~isnan(rank_h_1D_V1_lh)))/numel(rank_h_1D_V1_lh(~isnan(rank_h_1D_V1_lh))))
    disp('rank_h_1D_V1_rh')
    disp(sum(rank_h_1D_V1_rh(~isnan(rank_h_1D_V1_rh)))/numel(rank_h_1D_V1_rh(~isnan(rank_h_1D_V1_rh))))

    disp('rank_h_1D_V2_lh')
    disp(sum(rank_h_1D_V2_lh(~isnan(rank_h_1D_V2_lh)))/numel(rank_h_1D_V2_lh(~isnan(rank_h_1D_V2_lh))))
    disp('rank_h_1D_V2_rh')
    disp(sum(rank_h_1D_V2_rh(~isnan(rank_h_1D_V2_rh)))/numel(rank_h_1D_V2_rh(~isnan(rank_h_1D_V2_rh))))

    disp('rank_h_2D_lh')
    disp(sum(rank_h_2D_lh(~isnan(rank_h_2D_lh)))/numel(rank_h_2D_lh(~isnan(rank_h_2D_lh))))
    disp('rank_h_2D_rh')
    disp(sum(rank_h_2D_rh(~isnan(rank_h_2D_rh)))/numel(rank_h_2D_rh(~isnan(rank_h_2D_rh))))

    disp('rank_h_3D_lh')
    disp(sum(rank_h_3D_lh(~isnan(rank_h_3D_lh)))/numel(rank_h_3D_lh(~isnan(rank_h_3D_lh))))
    disp('rank_h_3D_rh')
    disp(sum(rank_h_3D_rh(~isnan(rank_h_3D_rh)))/numel(rank_h_3D_rh(~isnan(rank_h_3D_rh))))




