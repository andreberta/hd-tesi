% Here is created a struct containing all the parameter needed for the
% analysis


%% initialization
%handle function: a function that given the id of a patient and a visits,
%return the path
parameter.path = @path_data;

%curv type used during the analysis
parameter.curv_type = 'thickness';

%resolution of the image
parameter.resolution = 1600;

%number of atoms in the dictionary
parameter.dim_dict_mult = 0.5;

%patch size
parameter.psz = 31;

%lambda parameter used during sparse coding and dictionary learning steps 
parameter.lambda = 0.05;

%define percentage of training patch used to learn the dictionary
parameter.percentage = 0.7;

%skip step-1 patch during the patch extraction
parameter.step = 1;

%set this to 1 if you are running the algorithm under octave 
parameter.octave = 0;

%if set to 1 add also the average patch-wise valu to the patch indicator
parameter.mean = 1;

%handle function: a function used to get the path to whcih save the results
parameter.save_path = @save_kde3d;

%regions used during the analysis, in this way all the regions are added,
%however, since the rotation for unknown, UNKNOWN and corpus callosum are
%not defined, the algorithm will skip them
parameter.regions = parc_region_value();

% initialize cell array to store region-dependent info
parameter.lh = cell(length(parc_region_value()),1);
parameter.rh = cell(length(parc_region_value()),1);


%% lload and store vertex coordinates and parcellation values of fsaverage
fsaverage_path = 'data/fsaverage/';

surf_name = 'sphere.reg';
[vertices_lh,~] = load_surface_file(fsaverage_path,surf_name,'lh');
[vertices_rh,~] = load_surface_file(fsaverage_path,surf_name,'rh');

parc_type = 'aparc.annot';
[aparc_lh,~] = load_annotation_file(fsaverage_path,parc_type,'lh');
[aparc_rh,~] = load_annotation_file(fsaverage_path,parc_type,'rh');

parameter.vert_lh = vertices_lh;
parameter.vert_rh = vertices_rh;

parameter.parc_lh = aparc_lh;
parameter.parc_rh = aparc_rh;




%% LH
%Here are defined all the rotation for thr regions in the left hemisphere

hemi = 'lh';

%unknown
% region = 'unknown';
% pos = parc2pos(region);
% parameter.lh{pos}.x_rot = 0;
% parameter.lh{pos}.y_rot = -0.9;
% parameter.lh{pos}.z_rot = 0;
% parameter = parc_bounded( parameter , region , hemi );

%bankssts
region = 'bankssts';
pos = parc2pos(region);
parameter.lh{pos}.x_rot = -1;
parameter.lh{pos}.y_rot = -2;
parameter.lh{pos}.z_rot = 0;
parameter = parc_bounded( parameter , region , hemi );

%caudalanteriorcingulate
region = 'caudalanteriorcingulate';
pos = parc2pos(region);
parameter.lh{pos}.x_rot = 0;
parameter.lh{pos}.y_rot = 0;
parameter.lh{pos}.z_rot = 0;
parameter = parc_bounded( parameter , region , hemi );

%caudalmiddlefrontal
region = 'caudalmiddlefrontal';
pos = parc2pos(region);
parameter.lh{pos}.x_rot = -0.5;
parameter.lh{pos}.y_rot = 1.5;
parameter.lh{pos}.z_rot = 0;
parameter = parc_bounded( parameter , region , hemi );

%cuneus
region = 'cuneus';
pos = parc2pos(region);
parameter.lh{pos}.x_rot = 0;
parameter.lh{pos}.y_rot = -0.5;
parameter.lh{pos}.z_rot = 0.7;
parameter = parc_bounded( parameter , region , hemi );

%entorhinal
region = 'entorhinal';
pos = parc2pos(region);
parameter.lh{pos}.x_rot = 0;
parameter.lh{pos}.y_rot = -0.9;
parameter.lh{pos}.z_rot = 0;
parameter = parc_bounded( parameter , region , hemi );

%fusiform
region = 'fusiform';
pos = parc2pos(region);
parameter.lh{pos}.x_rot = -1.7;
parameter.lh{pos}.y_rot = -1.7;
parameter.lh{pos}.z_rot = 0;
parameter = parc_bounded( parameter , region , hemi );

%inferiortemporal
region = 'inferiortemporal';
pos = parc2pos(region);
parameter.lh{pos}.x_rot = -1.7;
parameter.lh{pos}.y_rot = -1.7;
parameter.lh{pos}.z_rot = 0;
parameter = parc_bounded( parameter , region , hemi );

%isthmuscingulate
region = 'isthmuscingulate';
pos = parc2pos(region);
parameter.lh{pos}.x_rot = 0;
parameter.lh{pos}.y_rot = 0;
parameter.lh{pos}.z_rot = 0;
parameter = parc_bounded( parameter , region , hemi );

%lateraloccipital
region = 'lateraloccipital';
pos = parc2pos(region);
parameter.lh{pos}.x_rot = 0;
parameter.lh{pos}.y_rot = -2;
parameter.lh{pos}.z_rot = 0;
parameter = parc_bounded( parameter , region , hemi );

%lateralorbitofrontal
region = 'lateralorbitofrontal';
pos = parc2pos(region);
parameter.lh{pos}.x_rot = 0;
parameter.lh{pos}.y_rot = -0.9;
parameter.lh{pos}.z_rot = 0;
parameter = parc_bounded( parameter , region , hemi );

%lingual
region = 'lingual';
pos = parc2pos(region);
parameter.lh{pos}.x_rot = 0;
parameter.lh{pos}.y_rot = -0.9;
parameter.lh{pos}.z_rot = 0;
parameter = parc_bounded( parameter , region , hemi );

%medialorbitofrontal
region = 'medialorbitofrontal';
pos = parc2pos(region);
parameter.lh{pos}.x_rot = 0;
parameter.lh{pos}.y_rot = 0;
parameter.lh{pos}.z_rot = 0;
parameter = parc_bounded( parameter , region , hemi );

%middletemporal
region = 'middletemporal';
pos = parc2pos(region);
parameter.lh{pos}.x_rot = -1;
parameter.lh{pos}.y_rot = -2;
parameter.lh{pos}.z_rot = 0;
parameter = parc_bounded( parameter , region , hemi );

%parahippocampal
region = 'parahippocampal';
pos = parc2pos(region);
parameter.lh{pos}.x_rot = 0;
parameter.lh{pos}.y_rot = -0.9;
parameter.lh{pos}.z_rot = 0;
parameter = parc_bounded( parameter , region , hemi );

%paracentral
region = 'paracentral';
pos = parc2pos(region);
parameter.lh{pos}.x_rot = 0;
parameter.lh{pos}.y_rot = 0.9;
parameter.lh{pos}.z_rot = 0;
parameter = parc_bounded( parameter , region , hemi );

%parsopercularis
region = 'parsopercularis';
pos = parc2pos(region);
parameter.lh{pos}.x_rot = 0;
parameter.lh{pos}.y_rot = 0;
parameter.lh{pos}.z_rot = -1.7;
parameter = parc_bounded( parameter , region , hemi );

%parsorbitalis
region = 'parsorbitalis';
pos = parc2pos(region);
parameter.lh{pos}.x_rot = 0;
parameter.lh{pos}.y_rot = 0;
parameter.lh{pos}.z_rot = -1.7;
parameter = parc_bounded( parameter , region , hemi );

%parstriangularis
region = 'parstriangularis';
pos = parc2pos(region);
parameter.lh{pos}.x_rot = 0;
parameter.lh{pos}.y_rot = 0;
parameter.lh{pos}.z_rot = -1.7;
parameter = parc_bounded( parameter , region , hemi );

%pericalcarine
region = 'pericalcarine';
pos = parc2pos(region);
parameter.lh{pos}.x_rot = 0;
parameter.lh{pos}.y_rot = -0.5;
parameter.lh{pos}.z_rot = 0.7;
parameter = parc_bounded( parameter , region , hemi );

% precentral
region = 'precentral';
pos = parc2pos(region);
parameter.lh{pos}.x_rot = 1.7;
parameter.lh{pos}.y_rot = 1.7;
parameter.lh{pos}.z_rot = 0;
parameter = parc_bounded( parameter , region , hemi );

%posteriorcingulate
region = 'posteriorcingulate';
pos = parc2pos(region);
parameter.lh{pos}.x_rot = 0;
parameter.lh{pos}.y_rot = 0;
parameter.lh{pos}.z_rot = 0;
parameter = parc_bounded( parameter , region , hemi );

% postcentral
region = 'postcentral';
pos = parc2pos(region);
parameter.lh{pos}.x_rot = 1.7;
parameter.lh{pos}.y_rot = 1.7;
parameter.lh{pos}.z_rot = 0;
parameter = parc_bounded( parameter , region , hemi );

%precuneus
region = 'precuneus';
pos = parc2pos(region);
parameter.lh{pos}.x_rot = 0;
parameter.lh{pos}.y_rot = 0;
parameter.lh{pos}.z_rot = 0;
parameter = parc_bounded( parameter , region , hemi );

%rostralanteriorcingulate
region = 'rostralanteriorcingulate';
pos = parc2pos(region);
parameter.lh{pos}.x_rot = 0;
parameter.lh{pos}.y_rot = 0;
parameter.lh{pos}.z_rot = 0;
parameter = parc_bounded( parameter , region , hemi );

%rostralmiddlefrontal
region = 'rostralmiddlefrontal';
pos = parc2pos(region);
parameter.lh{pos}.x_rot = 0;
parameter.lh{pos}.y_rot = 0;
parameter.lh{pos}.z_rot = -1.7;
parameter = parc_bounded( parameter , region , hemi );

%superiorfrontal
region = 'superiorfrontal';
pos = parc2pos(region);
parameter.lh{pos}.x_rot = 0;
parameter.lh{pos}.y_rot = 0.9;
parameter.lh{pos}.z_rot = 0;
parameter = parc_bounded( parameter , region , hemi );

%superiorparietal
region = 'superiorparietal';
pos = parc2pos(region);
parameter.lh{pos}.x_rot = 0;
parameter.lh{pos}.y_rot = 0.5;
parameter.lh{pos}.z_rot = 1.7;
parameter = parc_bounded( parameter , region , hemi );

%superiortemporal
region = 'superiortemporal';
pos = parc2pos(region);
parameter.lh{pos}.x_rot = 0;
parameter.lh{pos}.y_rot = -0.5;
parameter.lh{pos}.z_rot = -2.5;
parameter = parc_bounded( parameter , region , hemi );

%supramarginal
region = 'supramarginal';
pos = parc2pos(region);
parameter.lh{pos}.x_rot = 0;
parameter.lh{pos}.y_rot = 0.5;
parameter.lh{pos}.z_rot = 2.5;
parameter = parc_bounded( parameter , region , hemi );

%frontalpole
region = 'frontalpole';
pos = parc2pos(region);
parameter.lh{pos}.x_rot = 0;
parameter.lh{pos}.y_rot = 0;
parameter.lh{pos}.z_rot = 0;
parameter = parc_bounded( parameter , region , hemi );

%temporalpole
region = 'temporalpole';
pos = parc2pos(region);
parameter.lh{pos}.x_rot = 0;
parameter.lh{pos}.y_rot = -1;
parameter.lh{pos}.z_rot = -1.5;
parameter = parc_bounded( parameter , region , hemi );

%transversetemporal
region = 'transversetemporal';
pos = parc2pos(region);
parameter.lh{pos}.x_rot = 0;
parameter.lh{pos}.y_rot = 0;
parameter.lh{pos}.z_rot = -2.5;
parameter = parc_bounded( parameter , region , hemi );

%insula
region = 'insula';
pos = parc2pos(region);
parameter.lh{pos}.x_rot = 0;
parameter.lh{pos}.y_rot = 0;
parameter.lh{pos}.z_rot = -2;
parameter = parc_bounded( parameter , region , hemi );

%inferiorparietal
region = 'inferiorparietal';
pos = parc2pos(region);
parameter.lh{pos}.x_rot = 0;
parameter.lh{pos}.y_rot = 0;
parameter.lh{pos}.z_rot = 2;
parameter = parc_bounded( parameter , region , hemi );






%% RH

% here are defined all the rotation of the right hemisphere

hemi = 'rh';


% region = 'unknown';
% pos = parc2pos(region);
% parameter.rh{pos}.x_rot = 0;
% parameter.rh{pos}.y_rot = -0.7;
% parameter.rh{pos}.z_rot = -1.7;
% parameter = parc_bounded( parameter , region , hemi );

region = 'bankssts';
pos = parc2pos(region);
parameter.rh{pos}.x_rot = 0;
parameter.rh{pos}.y_rot = -0.5;
parameter.rh{pos}.z_rot = 0.5;
parameter = parc_bounded( parameter , region , hemi );                 
       
region = 'caudalanteriorcingulate';
pos = parc2pos(region);
parameter.rh{pos}.x_rot = 0;
parameter.rh{pos}.y_rot = 0.5;
parameter.rh{pos}.z_rot = -2.5;
parameter = parc_bounded( parameter , region , hemi ); 
 
region = 'caudalmiddlefrontal';
pos = parc2pos(region);
parameter.rh{pos}.x_rot = 0;
parameter.rh{pos}.y_rot = 1;
parameter.rh{pos}.z_rot = -0.7;
parameter = parc_bounded( parameter , region , hemi ); 
        
region = 'cuneus';
pos = parc2pos(region);
parameter.rh{pos}.x_rot = 0;
parameter.rh{pos}.y_rot = 0;
parameter.rh{pos}.z_rot = 2.5; 
parameter = parc_bounded( parameter , region , hemi );           
        
region = 'entorhinal';
pos = parc2pos(region);
parameter.rh{pos}.x_rot = 0;
parameter.rh{pos}.y_rot = -1;
parameter.rh{pos}.z_rot = -1.9;
parameter = parc_bounded( parameter , region , hemi );      
         
region = 'fusiform';
pos = parc2pos(region);
parameter.rh{pos}.x_rot = 0;
parameter.rh{pos}.y_rot = -1.5;
parameter.rh{pos}.z_rot = -2.5;
parameter = parc_bounded( parameter , region , hemi );                 
 
region = 'isthmuscingulate';
pos = parc2pos(region);
parameter.rh{pos}.x_rot = 0;
parameter.rh{pos}.y_rot = 0;
parameter.rh{pos}.z_rot = 2.9;
parameter = parc_bounded( parameter , region , hemi );  
        
region = 'lateraloccipital';
pos = parc2pos(region);
parameter.rh{pos}.x_rot = 0;
parameter.rh{pos}.y_rot = -0.5;
parameter.rh{pos}.z_rot = 1.7;
parameter = parc_bounded( parameter , region , hemi ); 
        
region = 'lateralorbitofrontal';
pos = parc2pos(region);
parameter.rh{pos}.x_rot = 0;
parameter.rh{pos}.y_rot = -0.4;
parameter.rh{pos}.z_rot = -1.5;
parameter = parc_bounded( parameter , region , hemi );  
    
region = 'lingual';
pos = parc2pos(region);
parameter.rh{pos}.x_rot = 0;
parameter.rh{pos}.y_rot = -0.7;
parameter.rh{pos}.z_rot = 2.7;
parameter = parc_bounded( parameter , region , hemi );                  

region = 'medialorbitofrontal';
pos = parc2pos(region);
parameter.rh{pos}.x_rot = 0;
parameter.rh{pos}.y_rot = -0.3;
parameter.rh{pos}.z_rot = -2;
parameter = parc_bounded( parameter , region , hemi );      
 
region = 'middletemporal';
pos = parc2pos(region);
parameter.rh{pos}.x_rot = -0.8;
parameter.rh{pos}.y_rot = -0.8;
parameter.rh{pos}.z_rot = 0;
parameter = parc_bounded( parameter , region , hemi );           

region = 'parahippocampal';
pos = parc2pos(region);
parameter.rh{pos}.x_rot = 0;
parameter.rh{pos}.y_rot = -1;
parameter.rh{pos}.z_rot = -2.7;
parameter = parc_bounded( parameter , region , hemi );          

region = 'paracentral';
pos = parc2pos(region);
parameter.rh{pos}.x_rot = 0;
parameter.rh{pos}.y_rot = 0.9;
parameter.rh{pos}.z_rot = 2.7;
parameter = parc_bounded( parameter , region , hemi );              
 
region = 'parsopercularis';
pos = parc2pos(region);
parameter.rh{pos}.x_rot = 0;
parameter.rh{pos}.y_rot = 0.4;
parameter.rh{pos}.z_rot = -0.6;
parameter = parc_bounded( parameter , region , hemi );          

region = 'parsorbitalis';
pos = parc2pos(region);
parameter.rh{pos}.x_rot = 0;
parameter.rh{pos}.y_rot = 0;
parameter.rh{pos}.z_rot = -1.4; 
parameter = parc_bounded( parameter , region , hemi );           

region = 'parstriangularis';
pos = parc2pos(region);
parameter.rh{pos}.x_rot = 0;
parameter.rh{pos}.y_rot = 0;
parameter.rh{pos}.z_rot = -1;
parameter = parc_bounded( parameter , region , hemi );         

region = 'pericalcarine';
pos = parc2pos(region);
parameter.rh{pos}.x_rot = 0;
parameter.rh{pos}.y_rot = -0.5;
parameter.rh{pos}.z_rot = 2.5;
parameter = parc_bounded( parameter , region , hemi );           

region = 'postcentral';
pos = parc2pos(region);
parameter.rh{pos}.x_rot = -0.5;
parameter.rh{pos}.y_rot = 0.9;
parameter.rh{pos}.z_rot = 0.7;
parameter = parc_bounded( parameter , region , hemi );              

region = 'posteriorcingulate';
pos = parc2pos(region);
parameter.rh{pos}.x_rot = 0;
parameter.rh{pos}.y_rot = 0.3;
parameter.rh{pos}.z_rot = -3;
parameter = parc_bounded( parameter , region , hemi );       
 
region = 'precentral';
pos = parc2pos(region);
parameter.rh{pos}.x_rot = 0;
parameter.rh{pos}.y_rot = 1;
parameter.rh{pos}.z_rot = 0;
parameter = parc_bounded( parameter , region , hemi );              

region = 'precuneus';
pos = parc2pos(region);
parameter.rh{pos}.x_rot = 0;
parameter.rh{pos}.y_rot = 0.5;
parameter.rh{pos}.z_rot = 2.5; 
parameter = parc_bounded( parameter , region , hemi );               

region = 'rostralanteriorcingulate';
pos = parc2pos(region);
parameter.rh{pos}.x_rot = 0;
parameter.rh{pos}.y_rot = 0;
parameter.rh{pos}.z_rot = -2.5;
parameter = parc_bounded( parameter , region , hemi ); 
 
region = 'rostralmiddlefrontal';
pos = parc2pos(region);
parameter.rh{pos}.x_rot = 0;
parameter.rh{pos}.y_rot = 0.5;
parameter.rh{pos}.z_rot = -1.5;  
parameter = parc_bounded( parameter , region , hemi );   
 
region = 'superiorfrontal';
pos = parc2pos(region);
parameter.rh{pos}.x_rot = 0;
parameter.rh{pos}.y_rot = 1;
parameter.rh{pos}.z_rot = -2; 
parameter = parc_bounded( parameter , region , hemi );         

region = 'superiorparietal';
pos = parc2pos(region);
parameter.rh{pos}.x_rot = 0;
parameter.rh{pos}.y_rot = 0.5;
parameter.rh{pos}.z_rot = 1.7; 
parameter = parc_bounded( parameter , region , hemi );        
 
region = 'superiortemporal';
pos = parc2pos(region);
parameter.rh{pos}.x_rot = -0.8;
parameter.rh{pos}.y_rot = -0.8;
parameter.rh{pos}.z_rot = -0.4;
parameter = parc_bounded( parameter , region , hemi );         
 
region = 'frontalpole';
pos = parc2pos(region);
parameter.rh{pos}.x_rot = 0;
parameter.rh{pos}.y_rot = 0;
parameter.rh{pos}.z_rot = -1.5;  
parameter = parc_bounded( parameter , region , hemi );            

region = 'temporalpole';
pos = parc2pos(region);
parameter.rh{pos}.x_rot = 0;
parameter.rh{pos}.y_rot = -1;
parameter.rh{pos}.z_rot = -1.5;
parameter = parc_bounded( parameter , region , hemi ); 
          
region = 'transversetemporal';
pos = parc2pos(region);
parameter.rh{pos}.x_rot = 0;
parameter.rh{pos}.y_rot = -0.5;
parameter.rh{pos}.z_rot = -0.2;
parameter = parc_bounded( parameter , region , hemi ); 
 
region = 'insula';
pos = parc2pos(region);
parameter.rh{pos}.x_rot = -0.7;
parameter.rh{pos}.y_rot = -0.8;
parameter.rh{pos}.z_rot = -0.6;
parameter = parc_bounded( parameter , region , hemi ); 
 
region = 'inferiorparietal';
pos = parc2pos(region);
parameter.rh{pos}.x_rot = 0;
parameter.rh{pos}.y_rot = 0;
parameter.rh{pos}.z_rot = 1.2;
parameter = parc_bounded( parameter , region , hemi ); 
 
region = 'inferiortemporal';
pos = parc2pos(region);
parameter.rh{pos}.x_rot = -1;
parameter.rh{pos}.y_rot = -1;
parameter.rh{pos}.z_rot = 1;
parameter = parc_bounded( parameter , region , hemi ); 

region = 'supramarginal';
pos = parc2pos(region);
parameter.rh{pos}.x_rot = 0;
parameter.rh{pos}.y_rot = 0;
parameter.rh{pos}.z_rot = 0;
parameter = parc_bounded( parameter , region , hemi ); 



%% save
%-V6, so it is possible to use it also in octave
save('parameter.mat','parameter','-V6');