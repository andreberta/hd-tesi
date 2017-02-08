function [ v_curv ] = remove_curv_outliers( v_curv )
%REMOVE_CURV_OUTLIERS Actualy are not removed but their value is changed
%TODO - find the beast way to deal with them

tmp = bsxfun(@gt,abs(bsxfun(@minus,v_curv,median(v_curv))), 4*std(v_curv));
max_no_outliers = max(v_curv(~tmp));
min_no_outliers = min(v_curv(~tmp));
v_curv(logical(tmp .* (v_curv > 0))) = max_no_outliers;
v_curv(logical(tmp .* (v_curv < 0))) = min_no_outliers;


end

