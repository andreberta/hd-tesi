function [ patches_vert ] = extract_patches( vert , patch_dim )

length_vert = length(vert);
patches_vert = zeros(length_vert, patch_dim);

fprintf('Extracting patches from surface... \n');
for ii=1:length_vert
    patch = extract_patch(vert, vert(ii,:), patch_dim);
    patches_vert(ii,:) = patch';
end
fprintf('DONE\n');

end

