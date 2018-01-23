
temp = zeros(size(res));
temp2 = temp;
for ii=1:size(res,1)
    if ii==7 || ii==10, continue; end
    for jj=1:size(res,2)
        [h,p] = kstest((res{ii,jj}-mean(res{ii,jj}))/std(res{ii,jj}));
        temp(ii,jj) = h;
        temp2(ii,jj) = p;
        
    end
end
