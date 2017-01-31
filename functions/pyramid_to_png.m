function  pyramid_to_png( subject , patient_name )
%PYRAMID_TO_PNG Convert every level of the pyramid into an image and store
%it

pyramid = subject.pyramid.interpolated;
[~,cols] = size(pyramid);

for ii=1:cols
    A = pyramid{ii};
    imwrite(A,['images_result/',patient_name,'_',num2str(ii),'.png']);
end
end

