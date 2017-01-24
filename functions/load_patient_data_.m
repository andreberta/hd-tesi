function [ subject ] = load_patient_data_( subject , srf , crv )
%LOAD_PATIENT_DATA_ Summary of this function goes here
%   Detailed explanation goes here

[subject.vertices, subject.faces] = load_surface_file(subject,srf);
[subject.v_curv, ~] = load_curvature_file(subject,crv);

subject.vertices = addSphericalCoord( subject.vertices );

subject.v_curv = remove_curv_outliers(subject.v_curv);

subject.v_curv = change_range(subject.v_curv);
end

