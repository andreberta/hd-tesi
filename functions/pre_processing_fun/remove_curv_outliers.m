function [v_curv] = remove_curv_outliers(v_curv,area)
%%
%REMOVE_CURV_OUTLIERS Deal with outliers in curvature.
%   Find outliers in v_curv and set them to the max, ot the min, value in
%   v_curv, without considering the outliers
%   In case of area curvature value, remove negative value, which may be
%   cause by an error in the FreeSurfer Process
%
%INPUT:
%   v_curv: curvature value to be processed
%   
%   area: it should be 1 if the values in v_curv are area curvature value
%
%OUTPUT:
%   v_curv: curvature value without ouliers

%% Remove outliers
too_distant = bsxfun(@gt,abs(bsxfun(@minus,v_curv,median(v_curv))), 4*std(v_curv));
max_no_outliers = max(v_curv(~too_distant));
min_no_outliers = min(v_curv(~too_distant));
v_curv(logical(too_distant .* (v_curv > 0))) = max_no_outliers;
v_curv(logical(too_distant .* (v_curv < 0))) = min_no_outliers;

%% Deal with area curvature values
if  area
    area_neg = v_curv < 0;
    min_no_neg = min(v_curv(~area_neg));
    v_curv(area_neg) = min_no_neg;
end


end

