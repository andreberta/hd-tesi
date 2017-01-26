function  pyramid_to_png( subject , patient_name )
%PYRAMID_TO_PNG Convert every level of the pyramid into an image and store
%it
pyramid_adjusted = subject.pyramimid.interpolated_adjusted;
[~,cols] = size(pyramid_adjusted);

for ii=1:cols
    A = pyramid_adjusted{ii};
    imwrite(A,['images_result/adjusted/',patient_name,'_',num2str(ii),'.png']);
end

pyramid = subject.pyramimid.interpolated;
[~,cols] = size(pyramid_adjusted);

for ii=1:cols
    A = pyramid{ii};
    imwrite(A,['images_result/not_adjusted/',patient_name,'_',num2str(ii),'.png']);
end
end

