%% apply defect detection to an image extracted from a volume in MRI

%test1
path_mri = [getenv('SUBJECTS_DIR'),'/bert/mri/brain.mgz'];
mri= MRIread(path_mri,0);

dim = 3;
index = 90;
mriimg = MRIextractImage(mri,index,dim);

original_image = mriimg.vol;


mask = zeros(size(original_image));
mask(114:117 ,109:114) = 1;
mask = conv2(mask, ones(4)/4^2, 'same');
modified_image = original_image .* (1-mask) + mask .* (original_image(114,148)+ 20);

src = modified_image + randn(size(modified_image)) * 0.2;
ref = original_image + randn(size(original_image)) * 0.2;

[output,anomaly]=NL_implV2(ref,src,8,4,0.2);
[y_hat,patch_hat]=fov_implV2(ref,src,8,4,0.2);



%test2
src1 = double(rgb2gray(imread('images/src1.jpg')));
ref1 = double(rgb2gray(imread('images/ref1.jpg')));

src1 = src1 + randn(size(src1)) * 0.2;
ref1 = ref1 + randn(size(ref1)) * 0.2;

src1 = src1(1:221,:);
ref1 = ref1(:,1:172);

[output1,anomaly1]=NL_implV2(ref1,src1,8,4,0.2);
[y_hat1,patch_hat1]=fov_implV2(ref1,src1,8,4,0.2);
