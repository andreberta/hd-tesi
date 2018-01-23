%% initialization
HD_patient = {'R003833008','R035507376','R04540108X','R061498291',...
    'R064906976','R105432869','R121532712','R135289971',...
    'R139656824','R171064892','R178341801','R217548576',...
    'R245726018','R247388241','R252012422','R259227210',...
    'R269043034','R275695571','R298174257','R304648773'};

control_patient = {'R015150415','R029890379','R043875068','R06335342X',...
    'R113409507','R154597824','R157808098','R159147998'};

load('parameter.mat');


curv_type = 'thickness';
rosas = 1;


%% get values as
parameter.save_path = @save_kde2d;
[as_2D_contr_lh,as_2D_contr_rh] = get_as_values(control_patient,curv_type,parameter,5,rosas);
[as_2D_HD_lh,as_2D_HD_rh] = get_as_values(HD_patient,curv_type,parameter,2,rosas);

parameter.save_path = @save_kde3d;
[as_3D_contr_lh,as_3D_contr_rh] = get_as_values(control_patient,curv_type,parameter,5,rosas);
[as_3D_HD_lh,as_3D_HD_rh] = get_as_values(HD_patient,curv_type,parameter,2,rosas);

%% get values curv patch-wise
point = 0;
[curv_contr_lh,curv_contr_rh] = get_curv_values(control_patient,curv_type,parameter,7,rosas,point);
[curv_HD_lh,curv_HD_rh] = get_curv_values(HD_patient,curv_type,parameter,4,rosas,point);

%% get values curv point-wise
point = 1;
[p_curv_contr_lh,p_curv_contr_rh] = get_curv_values(control_patient,curv_type,parameter,7,rosas,point);
[p_curv_HD_lh,p_curv_HD_rh] = get_curv_values(HD_patient,curv_type,parameter,4,rosas,point);

%% show results - Initialize
p2show = 4:7;

%x_labels
as_control_x_labels = {'v3','v4','v5','v6','v7'};
as_HD_x_labels = {'v3','v4'};

curv_control_x_labels = {'v1','v2','v3','v4','v5','v6','v7'};
curv_HD_x_labels = {'v1','v2','v3','v4'};

%y_label
as_y_label = 'Anomaly Score Value';
curv_y_label = 'Mean Thickness Value';

%% show results - control

saveas(gcf,'curv_control_lh.eps','epsc')
close all;

title_ = '';
%2D control AS
title_ = 'AS-Control-LH-2D';
show_ls_res(as_2D_contr_lh,p2show,as_control_x_labels,as_y_label,title_)


title_ = 'AS-Control-RH-2D';
show_ls_res(as_2D_contr_rh,p2show,as_control_x_labels,as_y_label,title_)

%3D control AS
title_ = 'AS-Control-LH-3D';
show_ls_res(as_3D_contr_lh,p2show,as_control_x_labels,as_y_label,title_)
title_ = 'AS-Control-RH-3D';
show_ls_res(as_3D_contr_rh,p2show,as_control_x_labels,as_y_label,title_)

%Control CURV patch
title_ = 'CURV-Control-LH';
show_ls_res(curv_contr_lh,p2show,curv_control_x_labels,curv_y_label,title_)
title_ = 'CURV-Control-RH';
show_ls_res(curv_contr_rh,p2show,curv_control_x_labels,curv_y_label,title_)

%Control CURV point
title_ = 'CURV-POINT-Control-LH';
show_ls_res(p_curv_contr_lh,p2show,curv_control_x_labels,curv_y_label,title_)
title_ = 'CURV-POINT-Control-RH';
show_ls_res(p_curv_contr_rh,p2show,curv_control_x_labels,curv_y_label,title_)


%% show results - HD patient
%2D control AS
title_ = 'AS-HD-LH-2D';
show_ls_res(as_2D_HD_lh,p2show,as_control_x_labels,as_y_label,title_)
title_ = 'AS-HD-RH-2D';
show_ls_res(as_2D_HD_rh,p2show,as_control_x_labels,as_y_label,title_)

%3D control AS
title_ = 'AS-HD-LH-3D';
show_ls_res(as_3D_HD_lh,p2show,as_control_x_labels,as_y_label,title_)
title_ = 'AS-Control-RH-3D';
show_ls_res(as_3D_HD_rh,p2show,as_control_x_labels,as_y_label,title_)

%Control CURV patch
title_ = 'CURV-HD-LH';
show_ls_res(curv_HD_lh,p2show,curv_control_x_labels,curv_y_label,title_)
title_ = 'CURV-HD-RH';
show_ls_res(curv_HD_rh,p2show,curv_control_x_labels,curv_y_label,title_)

%Control CURV point
title_ = 'CURV-POINT-HD-LH';
show_ls_res(p_curv_HD_lh,p2show,curv_control_x_labels,curv_y_label,title_)
title_ = 'CURV-POINT-HD-RH';
show_ls_res(p_curv_HD_rh,p2show,curv_control_x_labels,curv_y_label,title_)

