function  print_surf( patient , visit_number , curv_type , hemi , raw )
%PRINT_SURF Given a patient, a visit number, a curvature type and an
%hemisphere print a scatter plot of the surface of the patient
%   Admissible value for curv_type are curv , thick , vol , area , area.pial
%   curv.pial or area.mid, in case of different values an error is shown. 
%   Same thing happens in case of wrong values for hemisphere



if strcmp(hemi,'lh')
    visit = patient.visit{visit_number}.lh;
else if strcmp(hemi,'rh')
        visit = patient.visit{visit_number}.rh;
    else
        error('Hemisphere "%s" does not exist.', hemi);
    end
end

if strcmp(curv_type,'curv')
    F = visit.pyramid_curv.F_curv;
    curv_code = 8;
else if strcmp(curv_type,'thick')
        F = visit.pyramid_thick.F_curv;
        curv_code = 3;
    else if strcmp(curv_type,'vol')
            F = visit.pyramid_vol.F_curv;
            curv_code = 5;
        else if strcmp(curv_type,'area')
                F = visit.pyramid_area.F_curv;
                curv_code = 1;
            else if strcmp(curv_type,'area.pial')
                    F = visit.pyramid_areapial.F_curv;
                    curv_code = 4;
                else if strcmp(curv_type,'curv.pial')
                        F = visit.pyramid_curvpial.F_curv;
                        curv_code = 10;
                    else if strcmp(curv_type,'area.mid')
                            F = visit.pyramid_areamid.F_curv;
                            curv_code = 24;
                        else
                            error('Curvature "%s" does not exist.', curv_type);
                        end
                    end
                end
            end
        end
    end
end

title = ['P: ',num2str(patient.id),'.','V: ',num2str(visit_number),'.',...
            'Hemi: ',hemi,'.',curv_type];
        
if raw
    visit_path = path_local(patient.id,visit_number);
    [z, ~] = load_curvature_file(visit_path,curv_code,hemi,raw);
    title = [title,'.','Raw.'];
else
    z = F.Values;
end

scatteplotsphere([F.Points,z],title);



end

