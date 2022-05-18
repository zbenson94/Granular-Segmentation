function IMS_filt = bpassfilt(IMS,rbp)



k       = ceil(2*rbp);
filt    = ones(k,k);
filt    = filt / sum(filt(:));

bkg = imfilter(IMS(:,:,1),filt);
tmp = IMS(:,:,1) - bkg;
tmp(tmp<0) = 0;
tmp        = tmp(k:size(tmp,1)-k,k:size(tmp,2)-k);
IMS_filt = zeros([size(tmp),size(IMS,3)]);
IMS_filt(:,:,1) = tmp;

for i = 2:size(IMS,3)
    bkg = imfilter(IMS(:,:,i),filt,0);
    tmp = IMS(:,:,i) - bkg;
    tmp(tmp<0) = 0;
    tmp        = tmp(k:size(tmp,1)-k,k:size(tmp,2)-k);
    IMS_filt(:,:,i) = tmp;
end

end