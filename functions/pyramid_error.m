function [ error ] = pyramid_error( subj)
%PYRAMID_ERROR Summary of this function goes here
%   Detailed explanation goes here

error = sum(abs(subj.v_curv - ...
                    subj.pyramimid.F(subj.vertices(:,5),subj.vertices(:,6))));


end

