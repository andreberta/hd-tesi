function plot_stat(dpr,regions,parcv2,parcv3,psz)
up_ = round(psz/2);
down_ = up_ - 1;
figure,
for ii=1:length(regions)
    pos = parc2pos(regions{ii});
    
    maskv2 = parcv2(up_:end-down_,up_:end-down_) == pos;
    maskv3 = parcv3(up_:end-down_,up_:end-down_) == pos;
    
    min_ = min([dpr{5,ii}(maskv3);dpr{7,ii}(maskv2)]);
    max_ = max([dpr{5,ii}(maskv3);dpr{7,ii}(maskv2)]);
    
    temp_v3 = dpr{5,ii};
    temp_v3(~maskv3) = mean(temp_v3(maskv3))/2;
    temp_v2 = dpr{7,ii};
    temp_v2(~maskv3) = mean(temp_v2(maskv2))/2;
    
    subplot(1,2,1),imshow(temp_v3,[min_,max_]),
    title(['v3-',regions{ii}]),colorbar,colormap(gray);
    
    subplot(1,2,2),imshow(temp_v2,[min_,max_]),
    title(['v2-',regions{ii}]),colorbar,colormap(gray);

    pause
end
close;
end

