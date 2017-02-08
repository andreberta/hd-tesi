function [ error ] = pyramid_error( subj)
%PYRAMID_ERROR Return the error of the interpolation
%TODO - if it is possible define an error for each level of the pyramid

error = sum(abs(subj.v_curv - ...
                    subj.pyramimid.F_curv(subj.vertices(:,5),subj.vertices(:,6))));


end

