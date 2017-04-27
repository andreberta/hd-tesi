function res = reconstruct_image(patient,visit_number,hemi,parc,level,step,psz)
%RECONSTRUCT_IMAGE reconstruct the image using the result of sparse coding
%
% INPUT : 	-patient : patient struct to which apply sparse cosing (see load_patient.m)
%		-visit_number : the visit you want to consdider
%		-hemi : the hemisphere you want to consider
%		-parc : parcellation info
%		-level : level of the pyramid you want to consider
%		-step : is the step used in the sparse coding
%		-psz : is the patch size used in the dictionary learning phase




% input check

if ~isfield(patient,'sc_data')
	error('Sparse coding has not been applied to this patient')
end

%retrive data from input
if strcmp(hemi,'lh')

	img = patient.visit{visit_number}.lh.pyramid_curv.interpolated{level};
	dpr = patient.sc_data.lh;
	X = patient.visit{visit_number}.lh.X;

	else if strcmp(hemi,'rh')

		img = paient.visit{visit_number}.rh.pyramid_curv.interpolated{level};
		dpr = patient.sc_data.lh;
		X = patient.paient.visit{visit_number}.lh.X;
	end
end

up_ = round(psz/2);
down_ = up_ - 1;
x = up_:step:size(img,1)-down_;
y = up_:step:size(img,2)-down_;
[xq , yq] = meshgrid(x,y);
asd = [xq(:),yq(:)];



% initialaize variable
regions = parc_region_value();
res = zeros(size(img));



for ii=1:length(regions)
    
    if isempty(dpr{1,ii}) || strcmp(regions{ii},'UNKNOWN')
        continue
    end
    
    res_region = zeros(size(img));
    times = ones(size(img));
    
    pos = parc2pos(regions{ii});
    mask = parc == pos;
    se = strel('square',2*psz);
    mask_dilated = imdilate(mask,se);
    S = im2colstep(img.*mask_dilated,[psz,psz],[step,step]);
    [S,temp] = remove_zeronorm_patches(S);
    rec_patch = dpr{1,ii}*X{ii} + mean(S,1);
    
    selected = asd(temp,:);
    
    for jj=1:min(size(selected,1),size(rec_patch,2))
        reshaped_patch = reshape(rec_patch(:,jj),psz,psz);

        row = selected(jj,2);
        col = selected(jj,1);
        
        res_region(row-down_:row+down_,col-down_:col+down_) = ...
            res_region(row-down_:row+down_,col-down_:col+down_) + reshaped_patch;
        
        times(row-down_:row+down_,col-down_:col+down_) = ...
            times(row-down_:row+down_,col-down_:col+down_) + 1;
        
    end
    res_region = ((res_region ./ times) .* mask);
    res = res + res_region;
end

end

