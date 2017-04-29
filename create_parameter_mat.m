
%% initialization

parameter.lh = cell(length(parc_region_value()),1);
parameter.rh = cell(length(parc_region_value()),1);


%% precentral -lh
pos = parc2pos('precentral');
parameter.lh{pos}.x_rot = 1.7;
parameter.lh{pos}.y_rot = 1.7;
parameter.lh{pos}.z_rot = 0;


%% postcentral -lh
pos = parc2pos('postcentral');
parameter.lh{pos}.x_rot = 1.7;
parameter.lh{pos}.y_rot = 1.7;
parameter.lh{pos}.z_rot = 0;

%% inferiortemporal -rh
pos = parc2pos('inferiortemporal');
parameter.rh{pos}.x_rot = -1.4;
parameter.rh{pos}.y_rot = -1;
parameter.rh{pos}.z_rot = 0;


%% supramarginal -rh
pos = parc2pos('supramarginal');
parameter.rh{pos}.x_rot = 0;
parameter.rh{pos}.y_rot = 0;
parameter.rh{pos}.z_rot = 0;




%% save

save('parameter.mat','parameter');