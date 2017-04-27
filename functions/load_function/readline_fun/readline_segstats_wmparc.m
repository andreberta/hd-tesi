function [ stats ] = readline_segstats_wmparc( tline )
%READ_SEGSTATS Receive a line of a seg/wmparc stats file, read it and extract
%data
%  Return the following field:
%   Index SegId NVoxels Volume SegName normMean normStdDev normMin normMax normRange

stats{1}   = sscanf(tline,'%d',1);
stats{2} = sscanf(tline,'%*d %d',1);
stats{3}  = sscanf(tline,'%*d %*d %d',1);
stats{4}    = sscanf(tline,'%*d %*d %*d %f',1);
%stats  = sscanf(tline,'%*d %*d %*d %*f %s',1);
stats{5}  = sscanfitem(tline,5);
stats{6}  = sscanf(tline,'%*d %*d %*d %*f %*s %f',1);
stats{7}= sscanf(tline,'%*d %*d %*d %*f %*s %*f %f',1);
stats{8} = sscanf(tline,'%*d %*d %*d %*f %*s %*f %*f %f',1);
stats{9} = sscanf(tline,'%*d %*d %*d %*f %*s %*f %*f %*f %f',1);
stats{10} = sscanf(tline,'%*d %*d %*d %*f %*s %*f %*f %*f %*f %f',1);




end

