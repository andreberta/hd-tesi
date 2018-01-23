function [v_curv] = load_mgh_file(path,curv_type,hemi,fwhm,raw)
%%
%LOAD_MGH_FILE Load curvature values from an mgh file, obtained using
%mri_preproc
%
%INPUTS:
%   path: the path in which the data of the patient is stored
%
%   curv_type: the type of curvature you want to read (hickness, are, volume)
%
%   hemi: the hemisphere you are considering (lh or rh)
%   fwhm: the size of the kernel used during mri_preproc
%
%   raw: 0 or 1. If 0 the curvature values extracted are not rescaled to be
%   in the [0,1] interval
%
%OUTPUT:
%   v_curv: the curvature values extracted
%
%Some notes:
%   *.mgh files are volume files, therefore you MRIread() function is used
%   to read the data

%%
% check input
if ~(strcmp(hemi,'lh') || strcmp(hemi,'rh'))
    error('Hemi: %s does not exists',hemi);
end

if ~any(strcmp(curvature_value(),curv_type))
    error('Curvature name: %s does not exists',curv_type);
end

%load mgh file
path_complete_crv = [pwd,'/',path,'surf/',hemi,'.',curv_type,'.',...
    'fwhm',num2str(fwhm),'.fsaverage.mgh'];
res = MRIread(path_complete_crv);
v_curv = res.vol(:);

%process data
if ~raw
    area = ( strcmp(curv_type,'area')    || ...
            strcmp(curv_type,'area.pial')||...
            strcmp(curv_type,'area.mid')); 
    v_curv = remove_curv_outliers(v_curv,area);
    v_curv = change_range(v_curv);
end


end

