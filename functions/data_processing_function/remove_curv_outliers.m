function [ v_curv ] = remove_curv_outliers( v_curv , area )
%REMOVE_CURV_OUTLIERS Deal with outliers in curvature.
%   If s value is too distant from the mean is changed, if the curvature is
%   an area curvature value deal with negative value

too_distant = bsxfun(@gt,abs(bsxfun(@minus,v_curv,median(v_curv))), 4*std(v_curv));
max_no_outliers = max(v_curv(~too_distant));
min_no_outliers = min(v_curv(~too_distant));
v_curv(logical(too_distant .* (v_curv > 0))) = max_no_outliers;
v_curv(logical(too_distant .* (v_curv < 0))) = min_no_outliers;

%if the curvature file is area or area.mid or area.pial remove negative
%value, there should be an error in the reconstruction procedure
if  area
    area_neg = v_curv < 0;
    min_no_neg = min(v_curv(~area_neg));
    v_curv(area_neg) = min_no_neg;
end


end

