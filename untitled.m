%% load images 
p1_v1_path = 'images_result/area/patient_1/visit_1/';
p1_v3_path = 'images_result/area/patient_1/visit_3/';

ref_lh = double(imread([p1_v1_path,'rh/5.png']));
src_lh = double(imread([p1_v3_path,'rh/5.png']));

hbm = vision.BlockMatcher('ReferenceFrameSource',...
        'Input port','BlockSize',[35 35]);
hbm.OutputValue = 'Horizontal and vertical components in complex form';
halphablend = vision.AlphaBlender;

motion = step(hbm,ref_lh,src_lh);

img12 = step(halphablend,src_lh,ref_lh);

figure;
[X Y] = meshgrid(1:35:size(ref_lh,2),1:35:size(src_lh,1));
imshow(img12/256);
hold on;
quiver(X(:),Y(:),real(motion(:)),imag(motion(:)),0);
hold off;