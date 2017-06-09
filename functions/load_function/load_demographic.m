function [patient_ids,visit_distr] = load_demographic(path_file)
%read the file
M = readtable(path_file);


%take patient_ids
patient_ids = table2cell(M(:,2));

%load visits
patient_first_visit = table2array(M(:,6));
patient_last_visit = table2array(M(:,7));

%define number of visit
visit_number = patient_last_visit - patient_first_visit + 1;

visit_distr = cell(1,length(visit_number));

for ii=1:length(visit_number)
    visit_distr{ii}.dict_learn = patient_first_visit(ii);
    if visit_number(ii) < 4
        visit_distr{ii}.density_estimation = patient_first_visit(ii);
        visit_distr{ii}.visit_tested = patient_first_visit(ii)+1:patient_last_visit(ii);
    else
        visit_distr{ii}.density_estimation = patient_first_visit(ii)+1;
        visit_distr{ii}.visit_tested = patient_first_visit(ii)+2:patient_last_visit(ii);
    end
end

end

% for ii=1:length(B)
%     B{ii}
% end