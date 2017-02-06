function [ patient ] = load_patient( patient_id , visit_number )
%LOAD_PATIENT Load all the information for a patient given the patient id
%and the number of his visits, return a struct containing all the
%information for every visit and save the results as images
%   Surface:    -?h.sphere.reg
%
%   Curvature:  -?h.curv
%               -?h.thickness
%               -?h.volume
%               -?h.area
%
%   Annotation: -?h.aparc
%% load patient data

patient.id = patient_id;
patient.visit = cell(1,visit_number);

disp('Start loading patient data...')


for ii=1:visit_number
    
    disp(['Visit number ',num2str(ii)]);
    
    visit_path = path_local(patient_id,ii);
    
    %load surf    
    disp('Loading surfaces')
    [visit.lh.vertices,~] = load_surface_file(visit_path,10,'lh');
    [visit.rh.vertices,~] = load_surface_file(visit_path,10,'rh');
    
    %curv
    disp('Loading curvature: curv')
    [visit.lh.curv, ~] = load_curvature_file(visit_path,8,'lh');
    [visit.rh.curv, ~] = load_curvature_file(visit_path,8,'rh');
    %thick    
    disp('Loading curvature: thickness')
    [visit.lh.thick, ~] = load_curvature_file(visit_path,3,'lh');
    [visit.rh.thick, ~] = load_curvature_file(visit_path,3,'rh');
    %vol    
    disp('Loading curvature: volume')
    [visit.lh.vol, ~] = load_curvature_file(visit_path,5,'lh');    
    [visit.rh.vol, ~] = load_curvature_file(visit_path,5,'rh');
    %area
    disp('Load curvature: area')
    [visit.lh.area, ~] = load_curvature_file(visit_path,1,'lh');    
    [visit.rh.area, ~] = load_curvature_file(visit_path,1,'rh');
    
    %load annotation 
    disp('Loading annotaions')
    [visit.lh.aparc, ~] = load_annotation_file(visit_path,5,'lh');
    [visit.rh.aparc, ~] = load_annotation_file(visit_path,5,'rh');
    
    patient.visit{ii} = visit;
    
end

%% interp curvature
disp('Interpolation...')
for ii=1:visit_number 
    
    disp(['Visit number ',num2str(ii)]);
    
    current_visit = patient.visit{ii};
    
    %volume interp
    %curv
    disp('Interpolating curvature: curv')
    current_visit.lh.pyramid_curv = surf_to_pyramid(current_visit.lh.vertices,current_visit.lh.curv);
    current_visit.rh.pyramid_curv = surf_to_pyramid(current_visit.rh.vertices,current_visit.rh.curv);    
    %thick
    disp('Interpolating curvature: thickness')
    current_visit.lh.pyramid_thick = surf_to_pyramid(current_visit.lh.vertices,current_visit.lh.thick);     
    current_visit.rh.pyramid_thick = surf_to_pyramid(current_visit.rh.vertices,current_visit.rh.thick);
    %vol
    disp('Interpolating curvature: volume')
    current_visit.lh.pyramid_vol = surf_to_pyramid(current_visit.lh.vertices,current_visit.lh.vol);
    current_visit.rh.pyramid_vol = surf_to_pyramid(current_visit.rh.vertices,current_visit.rh.vol);
    %area
    disp('Interpolating curvature: area')
    current_visit.lh.pyramid_area = surf_to_pyramid(current_visit.lh.vertices,current_visit.lh.area);
    current_visit.rh.pyramid_area = surf_to_pyramid(current_visit.rh.vertices,current_visit.rh.area);

   
    %aparc interp
    disp('Interpolating aparc')
    current_visit.lh.pyramid_aparc = surf_to_pyramid_aparc(current_visit.lh.vertices,current_visit.lh.aparc);
    current_visit.rh.pyramid_aparc = surf_to_pyramid_aparc(current_visit.rh.vertices,current_visit.rh.aparc);
    
    %vertex per pixel computation
    disp('Vertex per pixel density')
    current_visit.lh.vertex_per_pix = histcount_surface_density(current_visit.lh.vertices);
    current_visit.rh.vertex_per_pix = histcount_surface_density(current_visit.rh.vertices);
    
    patient.visit{ii} = current_visit;
end


%% print

disp('Saving interpolated result as images...')
for ii=1:visit_number
    
    disp(['Visit number ',num2str(ii)]);
    
    visit = patient.visit{ii};
    
    %surf
    pyramid_to_png_create_folder(visit.lh.pyramid_curv,patient_id,ii,'curvature','lh');    
    pyramid_to_png_create_folder(visit.rh.pyramid_curv,patient_id,ii,'curvature','rh');
    %thick
    pyramid_to_png_create_folder(visit.lh.pyramid_thick,patient_id,ii,'thickness','lh');
    pyramid_to_png_create_folder(visit.rh.pyramid_thick,patient_id,ii,'thickness','rh');
    %vol
    pyramid_to_png_create_folder(visit.lh.pyramid_vol,patient_id,ii,'volume','lh');
    pyramid_to_png_create_folder(visit.rh.pyramid_vol,patient_id,ii,'volume','rh');
    %area
    pyramid_to_png_create_folder(visit.lh.pyramid_area,patient_id,ii,'area','lh');
    pyramid_to_png_create_folder(visit.rh.pyramid_area,patient_id,ii,'area','rh');
end

disp('DONE.')


end

