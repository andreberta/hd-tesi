function [v_curv] = load_mgh_file(path,curv_type,hemi,fwhm,raw)
%LOAD_MGH_FILE 

%example lh.curv_type.fwhm.fsaverage.mgh
%fwhm = 0,5,10,15,20,25

fwhm = num2str(fwhm);

path_complete_crv = [path,'surf/',hemi,'.',curv_type,'.','fwhm',fwhm,'.fsaverage.mgh'];
res = MRIread(path_complete_crv);
v_curv = res.vol(:);
%process data
if ~raw
    area =  strcmp(curv_type,'area') || strcmp(curv_type,'area.pial'); 
    v_curv = remove_curv_outliers(v_curv,area);
    v_curv = change_range(v_curv);
end


end

