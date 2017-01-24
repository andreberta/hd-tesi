function  pyramid_to_png( subject , patient_name )
%PYRAMID_TO_PNG Summary of this function goes here
%   Detailed explanation goes here

pyramid = subject.pyramimid.interpolated_adjusted;
[~,cols] = size(pyramid);

for ii=1:cols
    A = pyramid{ii};
    imwrite(A,['images_result/',patient_name,'_',num2str(ii),'.png']);
end

end

