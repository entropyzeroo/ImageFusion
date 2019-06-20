function out = SSR(im, sigma)
%Single Scale Retinex
%分通道处理
%   sigma 高斯模糊尺度

if ~exist('sigma', 'var')
    sigma = 80;
end


hsize = floor(sigma*6+1);
out = zeros(size(im));

k = fspecial('gaussian', hsize, sigma);
G = imfilter(im, k, 'replicate');

for i=1:size(im, 3)
    L = G(:,:,i);
    R = log(im(:,:,i)+1)-log(L+1);

%     R = exp(R);
    Max = max(R(:));
    Min = min(R(:));
    out(:,:,i) = (R-Min)/(Max-Min);
end

end

