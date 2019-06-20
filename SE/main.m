clc
clear
close all
addpath im
addpath func

tic
rgb = im2double(imread('rgb.jpg'));
nir = im2double(imread('nir.jpg'));

[rgb_x, rgb_y] = gradient(rgb);
[nir_x, nir_y] = gradient(nir);

hx = cat(3, rgb_x, nir_x);
hy = cat(3, rgb_y, nir_y);

[gx, gy] = se(rgb_x, rgb_y, hx, hy);
out = reintegration(rgb, gx, gy);

imshow([rgb nir (out-min(out(:)))/(max(out(:))-min(out(:)))])
% imshow([rgb out])
toc