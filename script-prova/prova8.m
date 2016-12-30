%% file location

path = [getenv('SUBJECTS_DIR'),'/bert/surf/'];
surf = {'lh.inflated','rh.inflated','lh.inflated.nofix','rh.inflated.nofix'...
    ,'lh.orig','rh.orig','lh.orig.nofix','rh.orig.nofix',...
    'lh.pial','rh.pial','lh.qsphere.nofix','rh.qsphere.nofix',...
    'lh.smoothwm','rh.smoothwm','lh.sphere','rh.sphere',...
    'lh.sphere.reg','rh.sphere.reg','lh.white','rh.white'};

curv = {'lh.area','lh.sulc','rh.smoothwm.K2.crv',...
'lh.thickness','rh.inflated.H','rh.smoothwm.K.crv','lh.area.pial',...
'lh.volume','rh.inflated.K','lh.avg_curv','lh.smoothwm','rh.smoothwm.S.crv',...
'lh.curv','lh.smoothwm.BE.crv','rh.jacobian_white',...
'lh.curv.pial','lh.smoothwm.C.crv','rh.sphere.reg','lh.defect_borders',...
'lh.smoothwm.FI.crv','rh.area','rh.sulc','lh.defect_chull',...
'lh.smoothwm.H.crv','rh.thickness','lh.defect_labels',...
'lh.smoothwm.K1.crv','rh.area.pial','rh.volume',...
'lh.smoothwm.K2.crv','rh.avg_curv','rh.smoothwm','lh.inflated.H',...
'lh.smoothwm.K.crv','rh.curv','rh.smoothwm.BE.crv','lh.inflated.K',...
'rh.curv.pial','rh.smoothwm.C.crv','lh.smoothwm.S.crv',...
'rh.defect_borders','rh.smoothwm.FI.crv','lh.jacobian_white',...
'rh.defect_chull','rh.smoothwm.H.crv',...
'rh.defect_labels','rh.smoothwm.K1.crv'};

%% read surf and process data
%load surf and curv
path_complete_crv = strcat(path,curv{13});
path_complete_srf = strcat(path,surf{15});
[vertices, faces] = freesurfer_read_surf(path_complete_srf);
[v_curv, ~] = read_curv(path_complete_crv);


%add to surf spherical coordinate system
[rows,col] = size(vertices);
vertices_spherical = zeros(rows, col*2);

vertices_spherical(:,1:3) = vertices;
%in col 4 there is the radius
vertices_spherical(:,4) = (vertices_spherical(:,1).^2 + vertices_spherical(:,2).^2 ...
             + vertices_spherical(:,3).^2).^(1/2);
%in col 5 the inclination (theta) --> [0,pi]
vertices_spherical(:,5) = acos(vertices_spherical(:,3) ./ vertices_spherical(:,4));
%in col 6 the azimuth (phi) --> [-pi/2,pi/2]
vertices_spherical(:,6) = atan(vertices_spherical(:,2) ./ vertices_spherical(:,1));
%round number of digits of vols 5 and 6 to 4 digits
% vertices_spherical(:,5) = round(vertices_spherical(:,5).*10000)/10000;
% vertices_spherical(:,6) = round(vertices_spherical(:,6).*10000)/10000;
%% Patch extraction


%first method: define a small interval over inclination and azimuth and
%select all the point in the interval
%Inclination: se va oltre pi riparte da 0 e viceversa se va sotto 0 riparti
%da pi in giu
%Azimuth: stesso ragionamento
%Un problema può essere che il numero di vertici è diverso per ogni patch

sdf = vertices_spherical(1,:);
wind = 0.10;
selected = [];
for ii=1:length(vertices_spherical)
    current = vertices_spherical(ii,:);
    
    if current(5)<=sdf(5)+wind && current(5)>=sdf(5)-wind  || ...     %in-bound case
            sdf(5)-wind<0 && current(5)>=pi-wind+sdf(5) || ...                %out-bound
            sdf(5)+wind>pi && current(5)<=wind+sdf(5)-pi
        if current(6)<=sdf(6)+wind && current(6)>=sdf(6)-wind || ... %in-bound case
                sdf(6)-wind<-pi/2 && current(6)>=pi/2-wind+(pi/2+sdf(6))|| ... %out-bound
                sdf(6)+wind>pi/2 && current(6)<=-pi/2+wind-(pi/2-sdf(6))
            
            selected = [selected ; current];        %add it to selected verteces
            
        end
    end
    
end

            
%second method: combine firdt and second, select a small region near the
%vertex, then select the k-nearest neighborhood from that region, the
%result is the same but it should be faster

sdf = vertices_spherical(1,:);
wind = 0.10;
selected = [];
for ii=1:length(vertices_spherical)
    current = vertices_spherical(ii,:);
    
    if current(5)<=sdf(5)+wind && current(5)>=sdf(5)-wind  || ...     %in-bound case
            sdf(5)-wind<0 && current(5)>=pi-wind+sdf(5) || ...                %out-bound
            sdf(5)+wind>pi && current(5)<=wind+sdf(5)-pi
        if current(6)<=sdf(6)+wind && current(6)>=sdf(6)-wind || ... %in-bound case
                sdf(6)-wind<-pi/2 && current(6)>=pi/2-wind+(pi/2+sdf(6))|| ... %out-bound
                sdf(6)+wind>pi/2 && current(6)<=-pi/2+wind-(pi/2-sdf(6))
            
            selected = [selected ; current];        %add it to selected verteces
            
        end
    end
    
end

IDX = knnsearch(selected(:,5:6),sdf(:,5:6),'K',5);


