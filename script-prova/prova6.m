%% labels

%load all the labels extracted from lh.BA.annot
[l1] = read_label('bert','lh.BA1');
[l2] = read_label('bert','lh.BA2');
[l3] = read_label('bert','lh.BA3a');
[l4] = read_label('bert','lh.BA3b');
[l5] = read_label('bert','lh.BA4a');
[l6] = read_label('bert','lh.BA4p');
[l7] = read_label('bert','lh.BA6');
[l8] = read_label('bert','lh.BA44');
[l9] = read_label('bert','lh.BA45');
[l10] = read_label('bert','lh.V1');
[l11] = read_label('bert','lh.V2');
[l12] = read_label('bert','lh.MT');
[l13] = read_label('bert','lh.perirhinal');
l = combine_labels(l1,l2); 
l = combine_labels(l,l3);
l = combine_labels(l,l4);
l = combine_labels(l,l5);
l = combine_labels(l,l6);
l = combine_labels(l,l7);
l = combine_labels(l,l8);
l = combine_labels(l,l9);
l = combine_labels(l,l10);
l = combine_labels(l,l11);
l = combine_labels(l,l12);
l = combine_labels(l,l13);

l_f = [l1;l2;l3;l4;l5;l6;l7;l8;l9;l10;l11;l12;l13];

%fs_read_label