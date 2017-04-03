function plot_anomalous_pix(img1,mask1,title1,img2,mask2,title2)
figure,
subplot(1,2,1),imshow(img1.*mask1),title(title1);
subplot(1,2,2),imshow(img2.*mask2),title(title2);
end
