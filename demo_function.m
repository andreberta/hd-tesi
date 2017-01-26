%% general
clc
clear
close all


addpath('functions');

%% load patient data
bert_lh_curv.path = 'data/bert/';
bert_rh_curv.path = 'data/bert/';
bert_lh_vol.path = 'data/bert/';
bert_rh_vol.path = 'data/bert/';
bert_lh_thick.path = 'data/bert/';
buck04.path = 'data/004/';


[ bert_lh_curv ] = load_patient_data_( bert_lh_curv , 16 , 13 , 6 );
[ bert_rh_curv ] = load_patient_data_( bert_rh_curv , 17 , 34 , 11);
[ buck04 ] = load_patient_data_( buck04 , 16 , 13 , 6);

[ bert_lh_vol ] = load_patient_data_( bert_lh_vol , 16 , 8 , 6);
[ bert_rh_vol ] = load_patient_data_( bert_rh_vol , 17 , 28 , 11);
 
[bert_lh_thick] = load_patient_data_(bert_lh_thick,16,4);

%% scatterplotSphere
scatteplotsphere( bert_lh_curv,'bert-lh.sphere.reg-lh.curv');
scatteplotsphere( bert_rh_curv,'bert-rh.sphere.reg-rh.curv');
% scatteplotsphere( buck04,'buck04-lh.sphere.reg-lh.curv');
% scatteplotsphere( bert_lh_vol,'bert-lh.sphere.reg-lh.vol');
% scatteplotsphere( bert_rh_vol,'bert-rh.sphere.reg-lh.vol');
% scatteplotsphere( bert_lh_thick,'bert-lh.sphere.reg-lh.thickness');


%% interp
[bert_lh_curv] = surf_to_pyramid( bert_lh_curv );
[bert_rh_curv] = surf_to_pyramid( bert_rh_curv);
[buck04] = surf_to_pyramid( buck04);
[bert_lh_vol] = surf_to_pyramid(bert_lh_vol);
[bert_rh_vol] = surf_to_pyramid(bert_rh_vol);

error_bert_lh_curv = pyramid_error(bert_lh_curv);
error_bert_rh_curv = pyramid_error(bert_rh_curv);
error_buck04 = pyramid_error(buck04);
error_bert_lh_vol = pyramid_error(bert_lh_vol);
error_bert_rh_vol = pyramid_error(bert_rh_vol);

%% print 
pyramid_to_png(bert_lh_curv,'bert_lh_curv');
pyramid_to_png(bert_rh_curv,'bert_rh_curv');
pyramid_to_png(buck04,'buck04');
pyramid_to_png(bert_lh_vol,'bert_lh_vol');
pyramid_to_png(bert_rh_vol,'bert_rh_vol');