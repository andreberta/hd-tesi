%% get aseg info 
% see also : function xyzlab = MRIseg2labelxyz(segmri,segid)

%load mri file
path_aparc_aseg = [getenv('SUBJECTS_DIR'),'/bert/mri/aparc+aseg.mgz'];
mri_aparc_aseg = MRIread(path_aparc_aseg,0);
temp = unique(mri_aparc_aseg.vol);

path_brain = [getenv('SUBJECTS_DIR'),'/bert/mri/brain.mgz'];
mri_brain = MRIread(path_brain,0);

segid = 2; %look at LUT 
mri_aparc_aseg_vol_mask = mri_aparc_aseg;
mri_aparc_aseg_vol_mask.vol...
    (mri_aparc_aseg_vol_mask.vol < segid) = 0;
mri_aparc_aseg_vol_mask.vol...
    (mri_aparc_aseg_vol_mask.vol > segid) = 0;
mri_aparc_aseg_vol_mask.vol...
    (mri_aparc_aseg_vol_mask.vol == segid) = 1;


dim=2;
figure;
for ii=1:mri_brain.volsize(dim)
    mriimg_S = MRIextractImage(mri_brain,ii,dim); %slice
    mriimg_mask = MRIextractImage(mri_aparc_aseg_vol_mask,ii,dim); %slice
    imshow(mriimg_S.vol .* mriimg_mask.vol/255),hold on
    drawnow;
end

