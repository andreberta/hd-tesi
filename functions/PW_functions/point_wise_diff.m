function [ patient ] = point_wise_diff( patient , level )
%POINT_WISE_DIFF compute the pixel-wise difference between each visits 
% ,starting from the second, with the first one

%% retrive information
visit = patient.visit;
v1_lh = extract_img_from_visit(visit,1,'lh',level);
v1_rh = extract_img_from_visit(visit,1,'rh',level);

%% compute
for ii= 2:length(visit)
    
    curr_lh = extract_img_from_visit(visit,ii,'lh',level);
    curr_rh = extract_img_from_visit(visit,ii,'rh',level);
    
    visit{ii}.lh.pointw_diff = v1_lh - curr_lh;    
    visit{ii}.rh.pointw_diff = v1_rh - curr_rh;
end

patient.visit = visit;

end



%% other fun

function img = extract_img_from_visit(visit,number_visit,hemi,level)
if strcmp(hemi,'lh')
    img = visit{number_visit}.lh.pyramid_curv.interpolated{level};
else if strcmp(hemi,'rh')
        img = visit{number_visit}.rh.pyramid_curv.interpolated{level};
    end
end

end