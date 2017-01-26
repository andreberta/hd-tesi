function [ v_curv_parc_region , vertex_per_parc_region ] = load_annotation_file( subject , annot )
%LOAD_ANNOTATION_FILE Summary of this function goes here
%   Detailed explanation goes here

annot_file = { 'rh.BA.annot'                'rh.bert_ref.aparc.a2009s.annot'  'lh.overlap.annot'...		    
               'h.bert_ref.aparc.annot'     'lh.aparc.a2009s.annot'           'lh.aparc.annot'...		    
               'lh.aparc.DKTatlas40.annot'  'rh.overlap.annot'                'rh.aparc.a2009s.annot'...	 
               'lh.BA.annot'		        'rh.aparc.annot'                  'lh.BA.thresh.annot'...		     
               'rh.aparc.DKTatlas40.annot'  'lh.bert_ref.aparc.a2009s.annot'  'lh.bert_ref.aparc.annot'...
              };

path_complete_annot = [subject.path,'label/',annot_file{annot}];
[vertices_annot, label_annot, colortable_annot] = read_annotation(path_complete_annot);
vertices_annot = vertices_annot + 1;

unique_parc_region = unique(label_annot);
vertex_per_parc_region = cell(length(unique_parc_region),1);
v_curv_parc_region = zeros(length(vertices_annot),1);

for ii=1:length(unique_parc_region)
    curr_parc_region = unique_parc_region(ii);
    selected = vertices_annot(label_annot == curr_parc_region);
    vertex_per_parc_region{ii} = selected;
    
    v_curv_parc_region(selected) = ii;
end


end

