%% general
clc
clear
close all


addpath('functions');

%% load patient data
bert_lh_curv.path = 'data/bert/';
bert_rh_curv.path = 'data/bert/';
bert_lh_jw.path = 'data/bert/';
bert_rh_jw.path = 'data/bert/';
bert_lh_vol.path = 'data/bert/';
bert_rh_vol.path = 'data/bert/';
buck04.path = 'data/004/';
bert_lh_thick.path = 'data/bert/';
bert_rh_thick.path = 'data/bert/';


[bert_lh_curv] = load_patient_data_(bert_lh_curv,10,8,5,'lh');
[bert_rh_curv] = load_patient_data_(bert_rh_curv,10,8,5,'rh');

[bert_lh_jw] = load_patient_data_(bert_lh_jw,10,23,5,'lh');
[bert_rh_jw] = load_patient_data_(bert_rh_jw,10,23,5,'rh');


[buck04]  = load_patient_data_(buck04,10,8,5,'lh');
[bert_lh_vol] = load_patient_data_(bert_lh_vol,10,5,5,'lh');
[bert_rh_vol] = load_patient_data_(bert_rh_vol,10,5,5,'rh');
[bert_lh_thick] = load_patient_data_(bert_lh_thick,10,3,5,'lh');
[bert_rh_thick] = load_patient_data_(bert_rh_thick,10,3,5,'rh');

%% scatterplotSphere
% scatteplotsphere( bert_lh_curv,'bert-lh.sphere.reg-lh.curv');
% scatteplotsphere( bert_rh_curv,'bert-rh.sphere.reg-rh.curv');

scatteplotsphere( bert_lh_jw,'bert-lh.sphere.reg-lh.jw');
scatteplotsphere( bert_rh_jw,'bert-rh.sphere.reg-rh.jw');

% scatteplotsphere( buck04,'buck04-lh.sphere.reg-lh.curv');
% scatteplotsphere( bert_lh_vol,'bert-lh.sphere.reg-lh.vol');
% scatteplotsphere( bert_rh_vol,'bert-rh.sphere.reg-lh.vol');
% scatteplotsphere( bert_lh_thick,'bert-lh.sphere.reg-lh.thickness');
% scatteplotsphere( bert_lh_thick,'bert-rh.sphere.reg-lh.thickness');
% scatteplotsphere( bert_rh_thick,'bert-lh.sphere.reg-rh.thickness');

%% interp
[bert_lh_curv] = surf_to_pyramid( bert_lh_curv );
[bert_rh_curv] = surf_to_pyramid( bert_rh_curv);
[buck04] = surf_to_pyramid( buck04);
[bert_lh_vol] = surf_to_pyramid(bert_lh_vol);
[bert_rh_vol] = surf_to_pyramid(bert_rh_vol);
[bert_lh_thick] = surf_to_pyramid(bert_lh_thick);
[bert_rh_thick] = surf_to_pyramid(bert_rh_thick);

%% print 
pyramid_to_png(bert_lh_curv,'bert_lh_curv');
pyramid_to_png(bert_rh_curv,'bert_rh_curv');
pyramid_to_png(buck04,'buck04');
pyramid_to_png(bert_lh_vol,'bert_lh_vol');
pyramid_to_png(bert_rh_vol,'bert_rh_vol');
pyramid_to_png(bert_lh_thick,'bert_lh_thick');
pyramid_to_png(bert_rh_thick,'bert_rh_thick');