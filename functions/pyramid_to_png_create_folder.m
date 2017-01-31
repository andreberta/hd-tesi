function  pyramid_to_png_create_folder( subject )
%PYRAMID_TO_PNG_CREATE_FOLDER Convert every level of the pyramid into an image and store
%it

pyramid = subject.pyramimid.interpolated;
[~,cols] = size(pyramid);

path = ['images_result/patient_',num2str(subject.patient),...
            '/visit_',num2str(subject.visit),'/'];
mkdir(path)

for ii=1:cols
    A = pyramid{ii};
    imwrite(A,[path,num2str(ii),'.png']);
end
end