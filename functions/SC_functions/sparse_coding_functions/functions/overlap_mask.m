function [img_over] = overlap_mask(img,mask)
% overlap an image with a mask of boolean values and create a colored image
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


img_temp = img;


imsz = size(img);
img_over = zeros([imsz 3]);

img_temp(mask) = 1;
img_over(:,:,1) = img_temp;

img_temp = img;
img_temp(mask) = 0;
img_over(:,:,2) = img_temp;

img_temp = img;
img_temp(mask) = 0;
img_over(:,:,3) = img_temp;





