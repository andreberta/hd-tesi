function [noise_dict] = noise_dictonary(D,plot_)

[rows,cols] = size(D);

asd = reshape(D,rows.^(1/2),rows.^(1/2),cols);
noise_dict = zeros(1,rows);
if plot_
    figure;
end
for ii=1:rows
    current_image = asd(:,:,ii);
    noise_dict(ii) = estimate_noise(current_image);
    if plot_
        imagesc(current_image),
        title(num2str(ii)),colormap(gray),colorbar, pause;
    end
end

end