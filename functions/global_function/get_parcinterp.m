function [ res ] = get_parcinterp( patient , visit_number , hemi ,level )
%GET_PARCINTERP 

if strcmp(hemi,'lh')
    visit = patient.visit{visit_number}.lh;
else if strcmp(hemi,'rh')
        visit = patient.visit{visit_number}.rh;
    else
        error('Hemisphere "%s" does not exist.', hemi);
    end
end

res = visit.pyramid_aparc.interpolated_aparc{level};


end

