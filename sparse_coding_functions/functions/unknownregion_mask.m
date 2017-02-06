function [ res ] = unknownregion_mask( patient , visit_no )
%UNKNOWNREGION_MASK Summary of this function goes here
%   Detailed explanation goes here

visit = patient.visit{visit_no};
aparc = visit.lh.pyramid_aparc.interpolated_aparc{end};
res = (aparc == 1);
end

