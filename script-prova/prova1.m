%% read file from MRI folder

%load mri file
path_mri = [getenv('SUBJECTS_DIR'),'/bert/mri/brain.mgz'];
mri= MRIread(path_mri,0);
%load surf file: left white matter
path_surf = [getenv('SUBJECTS_DIR'),'/bert/surf/lh.white'];
[v_vertices, v_faces] = read_surf(path_surf);

%convert from RAS to CRS surf file cordinates

%prepare data
v_vert_CRS = zeros(size(v_vertices));
Torig = mri.tkrvox2ras;	
for ii=1:length(v_vertices)
    tmp = Torig \[v_vertices(ii,:) , 1]';
    v_vert_CRS(ii,:) = round(tmp(1:3)');
end

%in the for loop : load the images then plot the point extracted from the 
%                  the surf file


figure;
for ii=1:mri.volsize(1)    
    dim=1;
    r = v_vert_CRS(v_vert_CRS(:,2) == ii,1:3);
    mriimg_R = MRIextractImage(mri,ii,dim); %row
    subplot(1,3,1,'replace');
    imshow(mriimg_R.vol'/255),hold on
    plot(r(:,1),r(:,3),'.y');
    
    dim=2;
    c = v_vert_CRS(v_vert_CRS(:,1) == ii,1:3);
    mriimg_C = MRIextractImage(mri,ii,dim); %col
    subplot(1,3,2,'replace');
    imshow(mriimg_C.vol/255),hold on
    plot(c(:,3),c(:,2),'.y');
    
    dim=3;
    s = v_vert_CRS(v_vert_CRS(:,dim) == ii,1:3);
    mriimg_S = MRIextractImage(mri,ii,dim); %slice
    subplot(1,3,3,'replace');
    imshow(mriimg_S.vol/255),hold on
    plot(s(:,1),s(:,2),'.y');
    drawnow;
end

