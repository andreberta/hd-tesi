function show_patient_images( patient )
%SHOW_PATIENT_IMAGES Show the last level of the pyramid

visit = patient.visit;
level = length(visit{1}.lh.pyramid_curv.interpolated);

figure
for ii= 1:length(visit)
    subplot(1,2,1),imshow(extract_img_from_visit(visit,ii,'lh',level)),
    title(['visit-',num2str(ii),'-hemi-lh'])
    subplot(1,2,2),imshow(extract_img_from_visit(visit,ii,'rh',level)),
    title(['visit-',num2str(ii),'-hemi-rh'])
    pause
end

close
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