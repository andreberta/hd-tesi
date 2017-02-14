function [ patient ] = load_patient( patient_id , visit_number , plot_)
%LOAD_PATIENT Load all the information for a patient given the patient id
%and the number of his visits, return a struct containing all the
%information for every visit and save the results as images
%   Surface:    -?h.sphere.reg
%
%   Curvature:  -?h.curv
%               -?h.thickness
%               -?h.volume
%               -?h.area
%               -?h.area.pial
%               -?h.area.mid
%               -?h.curv.pial
%
%   Annotation: -?h.aparc
%% load patient data

patient.id = patient_id;
patient.visit = cell(1,visit_number);

disp('Start loading patient data...')


for ii=1:visit_number
    
    disp([' Visit number ',num2str(ii)]);
    
    visit_path = path_local(patient_id,ii);
    
    %load surf    
    disp('  Loading surfaces')
    [visit.lh.vertices,~] = load_surface_file(visit_path,10,'lh');
    [visit.rh.vertices,~] = load_surface_file(visit_path,10,'rh');
    
    %curv
    disp('  Loading curvature: curv')
    [lh_curv, ~] = load_curvature_file(visit_path,8,'lh',0);
    [rh_curv, ~] = load_curvature_file(visit_path,8,'rh',0);
    disp('  Interpolating curvature: curv')
    visit.lh.pyramid_curv = surf_to_pyramid(visit.lh.vertices,lh_curv);
    visit.rh.pyramid_curv = surf_to_pyramid(visit.rh.vertices,rh_curv);    
        
    %thick    
    disp('  Loading curvature: thickness')
    [lh_thick, ~] = load_curvature_file(visit_path,3,'lh',0);
    [rh_thick, ~] = load_curvature_file(visit_path,3,'rh',0);
    disp('  Interpolating curvature: thickness')
    visit.lh.pyramid_thick = surf_to_pyramid(visit.lh.vertices,lh_thick);     
    visit.rh.pyramid_thick = surf_to_pyramid(visit.rh.vertices,rh_thick);
    
    
    %vol    
    disp('  Loading curvature: volume')
    [lh_vol, ~] = load_curvature_file(visit_path,5,'lh',0);    
    [rh_vol, ~] = load_curvature_file(visit_path,5,'rh',0);
    disp('  Interpolating curvature: volume')
    visit.lh.pyramid_vol = surf_to_pyramid(visit.lh.vertices,lh_vol);
    visit.rh.pyramid_vol = surf_to_pyramid(visit.rh.vertices,rh_vol);
    
    %area
    disp('  Load curvature: area')
    [lh_area, ~] = load_curvature_file(visit_path,1,'lh',0);    
    [rh_area, ~] = load_curvature_file(visit_path,1,'rh',0);
    disp('  Interpolating curvature: area')
    visit.lh.pyramid_area = surf_to_pyramid(visit.lh.vertices,lh_area);
    visit.rh.pyramid_area = surf_to_pyramid(visit.rh.vertices,rh_area);
   
    %area.pial
    disp('  Load curvature: area.pial')
    [lh_areapial, ~] = load_curvature_file(visit_path,4,'lh',0);    
    [rh_areapial, ~] = load_curvature_file(visit_path,4,'rh',0);
    disp('  Interpolating curvature: area.pial')
    visit.lh.pyramid_areapial = surf_to_pyramid(visit.lh.vertices,lh_areapial);
    visit.rh.pyramid_areapial = surf_to_pyramid(visit.rh.vertices,rh_areapial);
    
    %curv.pial
    disp('  Load curvature: curv.pial')
    [lh_curvpial, ~] = load_curvature_file(visit_path,10,'lh',0);    
    [rh_curvpial, ~] = load_curvature_file(visit_path,10,'rh',0);
    disp('  Interpolating curvature: curv.pial')
    visit.lh.pyramid_curvpial = surf_to_pyramid(visit.lh.vertices,lh_curvpial);
    visit.rh.pyramid_curvpial = surf_to_pyramid(visit.rh.vertices,rh_curvpial);
    
    %area.mid
    disp('  Load curvature: area.mid')
    [lh_areamid, ~] = load_curvature_file(visit_path,24,'lh',0);    
    [rh_areamid, ~] = load_curvature_file(visit_path,24,'rh',0);
    disp('  Interpolating curvature: area.mid')
    visit.lh.pyramid_areamid = surf_to_pyramid(visit.lh.vertices,lh_areamid);
    visit.rh.pyramid_areamid = surf_to_pyramid(visit.rh.vertices,rh_areamid);

    
    %load annotation 
    disp('  Loading annotaions')
    [lh_aparc,~,~] = load_annotation_file(visit_path,5,'lh');
    [rh_aparc,~,~] = load_annotation_file(visit_path,5,'rh');
    disp('  Interpolating aparc')
    visit.lh.pyramid_aparc = surf_to_pyramid_aparc(visit.lh.vertices,lh_aparc);
    visit.rh.pyramid_aparc = surf_to_pyramid_aparc(visit.rh.vertices,rh_aparc);
    
    %vertex per pixel computation
    disp('  Vertex per pixel density')
    visit.lh.vertex_per_pix = histcount_surface_density(visit.lh.vertices);
    visit.rh.vertex_per_pix = histcount_surface_density(visit.rh.vertices);
    
    
    patient.visit{ii} = visit;
    
end


%% print

if plot_
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
        %area.pial
        pyramid_to_png_create_folder(visit.lh.pyramid_areapial,patient_id,ii,'areapial','lh');
        pyramid_to_png_create_folder(visit.rh.pyramid_areapial,patient_id,ii,'areapial','rh');
        %curv.pial
        pyramid_to_png_create_folder(visit.lh.pyramid_curv,patient_id,ii,'curvpial','lh');
        pyramid_to_png_create_folder(visit.rh.pyramid_curvpial,patient_id,ii,'curvpial','rh');
        %area_mid
        pyramid_to_png_create_folder(visit.lh.pyramid_areamid,patient_id,ii,'areamid','lh');
        pyramid_to_png_create_folder(visit.rh.pyramid_areamid,patient_id,ii,'areamid','rh');
    end
end
disp('DONE.')


end

