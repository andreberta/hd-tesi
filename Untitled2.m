%% read file from MRI follder

%load mri file
path_mri_healthy = [parameter.path(1,1),'mri/brain.mgz'];
mri_healthy= MRIread(path_mri_healthy,0);
figure,

dim=1;%AXIAL
ii = 100;
mriimg_R = MRIextractImage(mri_healthy,ii,dim);
subplot(1,3,1),imshow(mriimg_R.vol'/255),xlabel('axial view');

dim=2;%SAGITTAL
ii=138;
mriimg_C = MRIextractImage(mri_healthy,ii,dim);
subplot(1,3,2),imshow(mriimg_C.vol/255),xlabel('sagittal view');

dim=3;%CORONAL
ii=156;
mriimg_S = MRIextractImage(mri_healthy,ii,dim);
subplot(1,3,3),imshow(mriimg_S.vol/255),xlabel('coronal view');

%------------------------------------------------------------------

figure
path_mri_unhealthy = [parameter.path(3,4),'mri/brain.mgz'];
mri_unhealthy = MRIread(path_mri_unhealthy,0);

dim=1;%AXIAL
ii = 100;
mriimg_R = MRIextractImage(mri_unhealthy,ii,dim);
subplot(1,3,1),imshow(mriimg_R.vol'/255),xlabel('axial view');

dim=2;%SAGITTAL
ii=138;
mriimg_C = MRIextractImage(mri_unhealthy,ii,dim);
subplot(1,3,2),imshow(mriimg_C.vol/255),xlabel('sagittal view');

dim=3;%CORONAL
ii=156;
mriimg_S = MRIextractImage(mri_unhealthy,ii,dim);
subplot(1,3,3),imshow(mriimg_S.vol/255),xlabel('coronal view');

