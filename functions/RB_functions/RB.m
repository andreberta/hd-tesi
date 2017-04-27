function [ patient ] = RB(patient,w_dim,p_dim,level)
%RB Compute ref-based for a patient, in particular compute it for every
%visits except the first one. 
%It compute :
% - y_hat(i,i): visit i reconstructed with itself
% - y_hat(i,1): visit i reconstructed with visit 1 (visit 1 is the refernce)
% Finally compute the patch-wise difference between the two.
%
%INPUT: 
%       -patient : a struct containing all the info for a patient (see load_patient.m)
%       -w_dim : window search radius
%       -p_dim : patch radius
%       -level : level of the pyramid you want to use [Better use the last one]
%
%OUTPUT:
%       -patient : the same input struct, which the new per-visit
%       information added

%% retrive information from input data
visit = patient.visit;
visit_number = length(visit);

%% compute noise
lh_noise = zeros(1,visit_number);
rh_noise = zeros(1,visit_number);

for ii=1:visit_number
    lh_noise(ii) = estimate_noise(extract_img_from_visit(visit,ii,'lh',level));
    rh_noise(ii) = estimate_noise(extract_img_from_visit(visit,ii,'rh',level));
end


%% compute
v1_lh = extract_img_from_visit(visit,1,'lh',level);
v1_rh = extract_img_from_visit(visit,1,'rh',level);

disp('Start ref based computation...');
for ii=2:visit_number
    
    disp([' Visit number ',num2str(ii)]);
    curr_lh = extract_img_from_visit(visit,ii,'lh',level);
    curr_rh = extract_img_from_visit(visit,ii,'rh',level);
    
    %lh
    % compute y_hat(i,i)
    [y_hat_ii,~]=fov_impl(curr_lh,curr_lh,w_dim,p_dim,lh_noise(ii),0,0);  
    % compute y_hat(i,1)
    [y_hat_i1,~]=fov_impl(v1_lh,curr_lh,w_dim,p_dim,mean([lh_noise(ii),lh_noise(1)]),0,0);
    % compute patch-wise difference
    pw_diff = patch_wise_difference(y_hat_ii,y_hat_i1,p_dim);
    visit = insert_pwdiff(visit,ii,'lh',pw_diff);
    
    %rh
    % compute y_hat(i,i)
    [y_hat_ii,~]=fov_impl(curr_rh,curr_rh,w_dim,p_dim,rh_noise(ii),0,0);  
    % compute y_hat(i,1)
    [y_hat_i1,~]=fov_impl(v1_rh,curr_rh,w_dim,p_dim,mean([rh_noise(ii),rh_noise(1)]),0,0);
    % compute patch-wise difference
    pw_diff = patch_wise_difference(y_hat_ii,y_hat_i1,p_dim);
    visit = insert_pwdiff(visit,ii,'rh',pw_diff);
    

end

patient.visit = visit;

%% other fun

function img = extract_img_from_visit(visit,number_visit,hemi,level)
if strcmp(hemi,'lh')
    img = visit{number_visit}.lh.pyramid_curv.interpolated{level};
else if strcmp(hemi,'rh')
        img = visit{number_visit}.rh.pyramid_curv.interpolated{level};
    end
end

end


function visit = insert_pwdiff(visit,number_visit,hemi,pw_diff)
    if strcmp(hemi,'lh')
        visit{number_visit}.lh.patchw_diff = pw_diff;
    else if strcmp(hemi,'rh')
            visit{number_visit}.rh.patchw_diff = pw_diff;
        end
    end
end


end

