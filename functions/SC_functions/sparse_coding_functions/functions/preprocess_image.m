function mask = preprocess_image(img,psz,thresh)
% Preprocess the test image to select and remove the black patches
% 
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

if (~exist('psz','var') || isempty(psz))
    psz = 15;
end
if (~exist('thresh','var') || isempty(thresh))
    thresh = 0.15;
end

img_med = conv2(img,ones(psz)/psz^2,'same');
mask = img_med < thresh;