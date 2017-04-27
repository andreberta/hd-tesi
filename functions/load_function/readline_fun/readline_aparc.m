function [ stats ] = readline_aparc( tline )
%LREADLINE_APARC Receive a line of an aparc stats file, read it and extract
%data
%  Return a struct containing the following field:
%   ParcName NumVert SurfArea GrayVol ThickAvg ThickStd MeanCurv GausCurv FoldInd CurvInd


stats{1}  = sscanfitem(tline,1);
stats{2}  = sscanf(tline,'%*s %d',1);
stats{3}  = sscanf(tline,'%*s %*d %f',1);
stats{4}  = sscanf(tline,'%*s %*d %*f %f',1);
stats{5}  = sscanf(tline,'%*s %*d %*f %*f %f',1);
stats{6}  = sscanf(tline,'%*s %*d %*f %*f %*f %f',1);
stats{7}  = sscanf(tline,'%*s %*d %*f %*f %*f %*f %f',1);
stats{8}  = sscanf(tline,'%*s %*d %*f %*f %*f %*f %*f %f',1);
stats{9}  = sscanf(tline,'%*s %*d %*f %*f %*f %*f %*f %*f %f',1);
stats{10}  = sscanf(tline,'%*s %*d %*f %*f %*f %*f %*f %*f %*f %f',1);

end

