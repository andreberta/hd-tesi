%% do something with LUT

path = '/home/andreberta/Scrivania/freesurfer/subjects/bert/label/';

%[code, name, rgbv] = read_fscolorlut();



path_complete = strcat(path,'lh.bert_ref.aparc.annot');
[vertices_annot, label_annot, colortable_annot] = read_annotation(path_complete);
% unique value in surf 133299      133401      134838      135016