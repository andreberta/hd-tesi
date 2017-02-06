function print_dictionary(D)

[rows,cols] = size(D);

asd = reshape(D,rows.^(1/2),rows.^(1/2),cols);
figure;
for ii=1:rows
    imagesc(asd(:,:,ii)),
    title(num2str(ii)),colormap(gray),colorbar, pause;
end
end