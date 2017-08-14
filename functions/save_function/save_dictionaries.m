function save_dictionaries( data , regions , curv_type , patient_id , hemi , psz ,no_noisy, random_number)
%SAVE_DICTIONARIES 


%% check for input error
if ~(strcmp(hemi,'lh') || strcmp(hemi,'rh'))
    error('Hemisphere "%s" does not exist.', hemi);
end

if ~(strcmp(curv_type,'curvature') || strcmp(curv_type,'thickness') || ...
     strcmp(curv_type,'volume') || strcmp(curv_type,'area') || ... 
     strcmp(curv_type,'areapial') || strcmp(curv_type,'curvpial') ||...
     strcmp(curv_type,'areamid'))
    error('Curvature "%s" does not exist.', curv_type);
end


%% create folder
path = ['images_result/',curv_type,'/patient_',num2str(patient_id),...
                '/dictionaries/',hemi,'/'];

mkdir(path)

%% save images
for ii=1:length(regions)
    [img,~] = show_dictionary(data{1,parc2pos(regions{ii})},0,no_noisy,random_number);
    name = [regions{ii},'_',hemi,'_',num2str(psz)];
    imwrite((img-min(img(:))) ./ (max(img(:)-min(img(:)))),[path,name,'.png']);
end


end

