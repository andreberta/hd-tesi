function stat2file(stat_lh,stat_rh,path_patient,file_name)
%STAT2FILE 

dlmwrite([path_patient,file_name,'_lh.txt'],stat_lh,'delimiter','\t');
dlmwrite([path_patient,file_name,'_rh.txt'],stat_rh,'delimiter','\t');

end

