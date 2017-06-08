iptsetpref('ImshowBorder','tight');
hemi = 'lh';
path_fun = parameter.path;
resolution = parameter.resolution;
psz = parameter.psz;
up_ = round(psz/2);
down_ = up_ - 1;
step = 1;
max_theta = pi;
min_theta = 0;
max_phi = pi;
min_phi = -pi;
dif_theta = max_theta - min_theta;
dif_phi = max_phi - min_phi;
x = min_theta:dif_theta/(resolution/2):max_theta;
y = min_phi:dif_phi/resolution:max_phi;
[xq , yq] = meshgrid(x,y);

curr_visit = 1;
patient_id = 2;
curv_type = 'thickness';
regions = parc_region_value();

fsaverage_path = 'data/fsaverage/';
path_surf = [fsaverage_path,'surf/'];
[vertices,faces] = freesurfer_read_surf([path_surf,hemi,'.','sphere.reg']);
[aparc,~] = load_annotation_file(fsaverage_path,5,hemi);

%load curvature file
curr_path = path_fun(patient_id,curr_visit);
v_curv = load_mgh_file(curr_path,curv_type,hemi,0,0);

vert_polar = addSphericalCoord(vertices);

% F_curv = scatteredInterpolant(vert_polar(:,5),vert_polar(:,6),v_curv);
% F_aparc = scatteredInterpolant(vert_polar(:,5),vert_polar(:,6),aparc,'nearest');
% 
% img_norot = F_curv(xq,yq);
% aparc_norot = F_aparc(xq,yq);

%show img_norot
% figure,imagesc(img_norot),colormap(gray),axis off;

%show flattened representation
% scatter3(vert_polar(:,5),vert_polar(:,6),v_curv,3,v_curv),colormap(jet);
% surf(img_norot,'LineStyle','none'),colormap(jet)

%show sphere
% figure
% patch('vertices',             vertices,             ...
%     'faces',                faces(:,[1 3 2]),     ...
%     'facevertexcdata',      v_curv,                 ...
%     'edgecolor',            'none',                 ...
%     'facecolor',            'interp');
% axis equal;
% colormap(gray);




for ii=1:length(regions)
    pos = parc2pos(regions{ii});
    if strcmp(hemi,'lh')
        empty = isempty(parameter.lh{pos});
    else if strcmp(hemi,'rh')
            empty = isempty(parameter.rh{pos});
        else
            error('Hemi: %s does not exists',hemi);
        end
    end
    
    if ~empty
        if strcmp(hemi,'lh')
            mask = parameter.lh{pos}.parc_shrink == pos;
            bound.lower_bound = parameter.lh{pos}.lower_bound;
            bound.upper_bound = parameter.lh{pos}.upper_bound;
            bound.right_bound = parameter.lh{pos}.right_bound;
            bound.left_bound  = parameter.lh{pos}.left_bound;
        else if strcmp(hemi,'rh')
                mask = parameter.rh{pos}.parc_shrink == pos;
                bound.lower_bound = parameter.rh{pos}.lower_bound;
                bound.upper_bound = parameter.rh{pos}.upper_bound;
                bound.right_bound = parameter.rh{pos}.right_bound;
                bound.left_bound  = parameter.rh{pos}.left_bound;
            else
                error('Hemi: %s does not exists',hemi);
            end
        end
        
        
        
        %rotate
        vert_new = rotate_vert(parameter,regions{ii},hemi);
        %interpolate
        img = surf_to_pyramid_rect(vert_new,v_curv,resolution,0,1,bound);
        
        %extract patches
        S = im2colstep(img,[psz,psz],[step,step]);
        %select patches in the region
        S = S(:,mask(up_:end-down_,up_:end-down_));
        %remove mean
        S = bsxfun(@minus,S,mean(S,1));
        %remove black patches
        [S,~] = remove_zeronorm_patches(S);
        S = S(:,randperm(size(S,2)));
        
        
        
%         %show img rotated
%         figure,imshow(img.*mask);
%         %show img not rotated
%         temp = (img_norot.*(aparc_norot==pos))';
%         figure,imshow(temp);
%         %show sphere
%         figure
%         patch('vertices',             vertices,             ...
%             'faces',                faces(:,[1 3 2]),     ...
%             'facevertexcdata',      v_curv.*(aparc == pos),                 ...
%             'edgecolor',            'none',                 ...
%             'facecolor',            'interp');
%         axis equal;
%         colormap(gray);
        
        %show some patches
        number = 200;
        res = show_dictionary(S,0,0,number);
        min_res = min(res(:));
        max_res = max(res(:));
        subplot(1,2,1),imshow(res,[min_res,max_res]),title(['patch:',regions{ii}]);
        %show dictionary
        D = patient.sc_data.lh{1,pos};
        res = show_dictionary(D,0,1,number);
        min_res = min(res(:));
        max_res = max(res(:));
        subplot(1,2,2),imshow(res,[min_res,max_res]),title(['dictionary:',regions{ii}]);  
        pause
        %show density
        kde = patient.sc_data.lh{2,pos};
%         figure,surf(kde.X,kde.Y,kde.density,'LineStyle','none');
%         xlabel('reconstruction-error');
%         ylabel('sparsity')

        
        
    end
end