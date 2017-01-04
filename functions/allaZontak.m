function [ vert_res, anomaly ] = allaZontak( vert_1, vert_2, patch_dim, wimdow_dim, sigma )
% First attempt of reproduce the Zontak method on two surface. 
%Input
% vert_1: vertices list 1 comparable to the src (from new MRI)
% vert_2: vertices list 2 comparable to the ref (from old MRI)
% patch_dim: dimension of the patch which is equal to the number of vertex
%            extracted around a vertex
% wimdow_dim: dimension of the window which is equal to the number of vertex
%            extracted around a vertex
% sigma: noise?? 

%Output
% vert_res: [surf,curv] where curv is the recomputed one
% anomaly: is the result of the patch-wise difference between vert_res and
% vert1

%% prepare data
eps = sigma * sigma;

vert_res = vert_1;

length_vert_1 = length(vert_1);
length_vert_2 = length(vert_2);

patches_vert_1 = zeros(length_vert_1, patch_dim);
patches_vert_2 = zeros(length_vert_2, patch_dim);
anomaly = zeros(length_vert_1, 1);

%% extract patches for both the vertex lists
fprintf('Extracting patch from first surface... \n');
for ii=1:length_vert_1
    patch = extract_patch(vert_1, vert_1(ii,:), patch_dim);
    patches_vert_1(ii,:) = patch';
end
fprintf('DONE\n');
fprintf('Extracting patch from second surface...\n');
for ii=1:length_vert_2
    patch = extract_patch(vert_2, vert_2(ii,:), patch_dim);
    patches_vert_2(ii,:) = patch';
end
fprintf('DONE\n');

%% compute weight
fprintf('Computing weight and reconstracting curvature...\n');
kk=0;
for ii=1:length_vert_1
    %extract vertices from vert_2 in the search window
    [ IDX,~ ] = extract_searchwindow(vert_2, vert_1(ii,:), wimdow_dim);
    %select patches of vertices in the search window
    selected_patches = patches_vert_2(IDX,:);
    
    patch_vert_1 = patches_vert_1(ii,:);
    average_vert=0;
    sweight = 0;
    for jj=1:length(selected_patches)
        %compute weight
        patch_vert_2 = patches_vert_2(jj,:);
        d = sum(sum((patch_vert_1-patch_vert_2).*(patch_vert_1-patch_vert_2)));
        w=exp(-d/eps); 
        
        %sum all the weight
        sweight = sweight + w;
        %compute the value of the output without normalization
        average_vert = average_vert + w*vert_2(jj,7);
    end
    vert_res(ii,7) = average_vert/sweight;
    kk = kk + 1;
    if kk == 100
        kk = 0;
        ii
    end
end
fprintf('DONE\n');

%% compute difference
fprintf('Computing difference...\n');
for ii=1:length_vert_1
    patch_vert_res = extract_patch(vert_res, vert_res(ii,:), patch_dim);
    patch_vert_1 = patches_vert_1(ii,:);
    anomaly(ii) = norm(patch_vert_res - patch_vert_1);
end
fprintf('DONE\n');
end

