function [ path ] = path_monkeymonkey( subject )
%PATH_MONKEYMONKEY Summary of this function goes here
%   Detailed explanation goes here

% example : /home/giacomo/Research/2015_10_IBM_AnomalyDetection_Huntington/
%            sample_surfaces_longitudinal/
%            sample_2-visit_3-TON.long.sample_2_template/surf/

visit = num2str(subject.visit);
sample = num2str(subject.patient);
path = ['/home/giacomo/Research/2015_10_IBM_AnomalyDetection_Huntington/'...
        'sample_surfaces_longitudinal/'...
        'sample_',sample,...
        '-visit_',visit,...
        '-TON.long.sample_',sample,...
        '_template/'];
end

