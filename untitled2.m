visit_1_path = path_local(1,1);

visit_2_path = path_local(1,2);

path_complete_annot = [visit_1_path,'label/','lh','.','aparc.annot'];
[vertices_annot_1, label_annot_1, asd_1] = read_annotation(path_complete_annot,0);
vertices_annot_1 = vertices_annot_1 + 1;

path_complete_annot = [visit_1_path,'label/','lh','.','aparc.annot'];
[vertices_annot_2, label_annot_2, asd_2] = read_annotation(path_complete_annot,0);
vertices_annot_2 = vertices_annot_2 + 1;

%%TODO 
% -controlla l' ordine dei valori in label_annot 1 e 2. 
%  magari controlla per tutte le visite
% -fai in modo che i valori di v_curv_parc_region in load_annot_file.m siano
%  coerenti per tutti i pazienti e per tutte le visite
% -scrivi una funzione che dato il nome di una regione in aparc ritorni il
%  valore con cui è salvato in v_curv_aparc