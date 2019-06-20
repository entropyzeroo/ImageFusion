% 用于测试重建原图的效果
clc
clear
close all
addpath ./im
addpath ./func

rgb = im2double(imread('rgb.jpg'));
nir = im2double(imread('nir.jpg'));

[rgb_x, rgb_y] = gradient(rgb);
[nir_x, nir_y] = gradient(nir);
x = (rgb_x+nir_x)/2;
y = (rgb_y+nir_y)/2;
out = reintegration(rgb, x, y);

imshow([rgb nir out])