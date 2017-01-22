function [ v_curv ] = remove_curv_outliers( v_curv )
%REMOVE_CURV_OUTLIERS Summary of this function goes here
%   Detailed explanation goes here

tmp = bsxfun(@gt,abs(bsxfun(@minus,v_curv,median(v_curv))), 3*std(v_curv));
max_no_outliers = max(v_curv(~tmp));
min_no_outliers = min(v_curv(~tmp));
v_curv(logical(tmp .* (v_curv > 0))) = max_no_outliers;
v_curv(logical(tmp .* (v_curv < 0))) = min_no_outliers;


end

