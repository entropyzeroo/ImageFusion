clc
clear


I = im2double(imread('im.png'));
rgb = I(:,1:500,:);
nir = I(:,501:1000,:);

% rgb = im2double(imread('s11.png'));
% nir = im2double(imread('s12.png'));
% nir = cat(3, nir,nir,nir);

w = size(rgb, 2);

Ycbcr = rgb2ycbcr([rgb nir]);
Y = Ycbcr(:,:,1);

base = fastBilateralFilter(Y);
detail = Y-base;

YF = base(:,1:w,:)+detail(:,w+1:2*w,:);
cbcr = Ycbcr(:,1:w,:);
cbcr(:,:,1) = YF;

out = ycbcr2rgb(cbcr);

imshow([rgb nir out])
imwrite([rgb zeros(529,10,3) nir zeros(529,10,3) out],'res.png')
