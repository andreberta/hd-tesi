function [ subject ] = load_patient_data_( subject , srf , crv , annot , hemi )
%LOAD_PATIENT_DATA_ load freesurfer data relative to a patient

%load surface
[subject.vertices,subject.faces] = load_surface_file(subject,srf,hemi);
%load curvature
[subject.v_curv, ~] = load_curvature_file(subject,crv,hemi);
%load annotation
[subject.curv_parc_region,subject.vertex_per_parc_region] = ...
                                    load_annotation_file(subject,annot,hemi);

end
