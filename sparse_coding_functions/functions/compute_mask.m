function mask = compute_mask(stat,gamma,mask_pre,psz)
% Function to compute the mask with the detection
% It implements the majority coting approach
% Revision history
% May 2016 - First Release
%
% References
% [1] Giacomo Boracchi, Diego Carrera, Brendt Wohlberg
%     Novelty Detection in Images by Sparse Representations
%     IEEE Symposium Series on Computational Intelligence (SSCI), 2014
%     doi:10.1109/INTELES.2014.7008985
% 
% [2] Diego Carrera, Fabio Manganini, Giacomo Boracchi, Ettore Lanzarone
%     Defect Detection in Nanostructures
%     http://bibliograzia.imati.cnr.it/sites/bibliograzia.vp1.it/files/16-03.pdf
%
% Author: Diego Carrera
% diego.carrera@polimi.it

cnt_map = conv2(ones(size(stat)),ones(psz),'full');
cnt_map = cnt_map-mask_pre;

map = double(stat>=gamma);
map = conv2(map,ones(psz),'full');
mask = (map > (cnt_map/2)) & ~mask_pre;
