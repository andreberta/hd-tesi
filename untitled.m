
s_reshaped = reshape(S,15,15,100000);

s_noise = zeros(1,100000);

for ii=1:100000
    s_noise(ii) = estimate_noise(s_reshaped(:,:,ii));
end

figure;
for ii=1:100000
    imagesc(s_reshaped(:,:,ii)),title(num2str(s_noise(ii))),colormap(gray),pause;
end

