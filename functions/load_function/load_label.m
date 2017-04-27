function [l] = load_label(path)
%LOAD_LABEL read a label file and return the information in it

l = [];
% open it as an ascii file
fid = fopen(path, 'r') ;
if(fid == -1)
  fprintf('ERROR: could not open %s\n',path);
  return;
end

fgets(fid) ;
if(fid == -1)
  fprintf('ERROR: could not open %s\n',path);
  return;
end

line = fgets(fid) ;
nv = sscanf(line, '%d') ;
l = fscanf(fid, '%d %f %f %f %f\n') ;
l = reshape(l, 5, nv) ;
l = l' ;

fclose(fid) ;

