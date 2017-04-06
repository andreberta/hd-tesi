function [ patient ] = load_patient( patient_id , visit_number , data_path, ...
                                    curv_type, fwhm , resolutions , opt )
%LOAD_PATIENT For all the visit of a patient, load the cortical surfaces
%information, extract an image from them and store it
%
%
%   Load sphere.reg surface, transform it from XYZ coordinates to polar
%   coordinates, the results is a 2D surface. Add curvature information to
%   that surface, the result is interpolated at different resolutions to
%   obtain a pyramid.
% INPUT:
%       -patient_id
%       -visit number
%       -data_path : function handle, for a function that receive
%        patient_id ,the visit number and return the folder in which the data
%        stored
%       -curv_type : type of curvature you want to load (thickness, area , area.mid , ...)
%       -resolutions: value at which the surfaces are interpolated
%       - save_path -> function handle, specify in which folder save the
%         results, as data_path in input needs patient_id and visit_number
%       -opt : - vertex_per_pixel_ -> 1 if has to compute vertex per
%                pixel
% OUTPUT:
%       -patient: a struct containing all the info loaded in the process

%% load patient data

if nargin == 6
    opt.vertex_per_pixel_ = 0;
else if nargin > 7
        error('Invalid number of input parameter.');
    end
end

opt = check_opt(opt);

patient.id = patient_id;
patient.curv_type = curv_type;
patient.visit = cell(1,visit_number);

disp('Start loading patient data...')

%load surf
fsaverage_path = 'data/fsaverage/'; 
[vertices_lh,~] = load_surface_file(fsaverage_path,10,'lh');
[vertices_rh,~] = load_surface_file(fsaverage_path,10,'rh');

for ii=1:visit_number
    
    disp([' Visit number ',num2str(ii)]);
    visit_path = data_path(patient_id,ii);

    %load mgh file as a curv file
    [lh_curv] = load_mgh_file(visit_path,curv_type,'lh',fwhm,0);
    [rh_curv] = load_mgh_file(visit_path,curv_type,'rh',fwhm,0);
    
    %interpolate data
    visit.lh.pyramid_curv = surf_to_pyramid(vertices_lh,lh_curv,resolutions);
    visit.rh.pyramid_curv = surf_to_pyramid(vertices_rh,rh_curv,resolutions);

    %vertex per pixel computation
    if opt.vertex_per_pixel_
        visit.lh.vertex_per_pix = histcount_surface_density(visit.lh.vertices);
        visit.rh.vertex_per_pix = histcount_surface_density(visit.rh.vertices);
    end
    
    patient.visit{ii} = visit;
end


end



%% functions


function opt = check_opt(opt)
if ~isfield(opt,'vertex_per_pixel_')
    opt.vertex_per_pixel_ = 0;
end

end







