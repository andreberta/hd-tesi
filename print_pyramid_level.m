function print_pyramid_level( patient , visit_number , curv_type , hemi)
%PRINT_PYRAMID_LEVEL Given a patient, a visit number,an hemisphere and a 
%curvature value, prints out the whole pyramid
%   Admissible value for curv_type are curv , thick , vol or area, in case
%   of different values an error is shown. Same thing happens in case of
%   wrong values for hemisphere

if strcmp(hemi,'lh')
    visit = patient.visit{visit_number}.lh;
else if strcmp(hemi,'rh')
        visit = patient.visit{visit_number}.rh;
    else
        error('Hemisphere "%s" does not exist.', hemi);
    end
end


if strcmp(curv_type,'curv')
    interpolated_value = visit.pyramid_curv.interpolated;
else if strcmp(curv_type,'thick')
        interpolated_value = visit.pyramid_thick.interpolated;
    else if strcmp(curv_type,'vol')
            interpolated_value = visit.pyramid_vol.interpolated;
        else if strcmp(curv_type,'area')
                interpolated_value = visit.pyramid_area.interpolated;
            else
                error('Curvature "%s" does not exist.', curv_type);
            end
        end
    end
end

for ii=1:length(interpolated_value)
    figure;
    imshow(interpolated_value{ii});
end


end

