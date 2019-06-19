% 改进了原文算法融合后导致局部区域的模糊
clc
clear
close all
addpath ./im
addpath ./func

t1 = Tiff('0000_rgb.tiff','r');
t2 = Tiff('0000_nir.tiff','r');
rgb = double(read(t1)) / 255;
nir = double(read(t2)) / 255;


imgYUV = myrgb2yuv(rgb);

%% 
Yb_WLS = wlsFilter(nir,0.125,1.2); 
Yb_BF = fastBilateralFilter(nir);
Yd_WLS = nir - Yb_WLS;
Yd_BF = nir - Yb_BF;

Yb_WLS_C = wlsFilter(imgYUV(:,:,1),0.125,1.2);
Yd_WLS_C = imgYUV(:,:,1)-Yb_WLS_C;

Yb = 0.5*(Yb_WLS+Yb_BF);
Yd = 0.5*(Yd_WLS + Yd_BF);
%%
h2 = fspecial('laplacian', 0.2);
H1 = imfilter(imgYUV(:,:,1), h2, 'replicate');
H2 = imfilter(nir, h2, 'replicate');

H1 = abs(H1);
H2 = abs(H2);

h3 = fspecial('gaussian', [11,11], 5);
S1 = imfilter(H1, h3, 'replicate');
S2 = imfilter(H2, h3, 'replicate');

P1 = saliency(S1, S2);
P2 = saliency(S2, S1);

eps2 = 0.05^2;

Wd1  = guidedfilter(imgYUV(:,:,1) , P1 , 4, eps2);
Wd2  = guidedfilter(nir , P2 , 4, eps2);

Wdmax = Wd1+Wd2;
Wd1 = Wd1./Wdmax;
Wd2 = Wd2./Wdmax;

%%
Y = Yd+Yb_WLS_C;
imgYUV(:,:,1) = Y;
out1 = myyuv2rgb(imgYUV);
%%

B = Yb_WLS_C;
D = Yd_WLS_C.*P1+Yd.*P2;
im = B+D;
imgYUV(:,:,1) = im;
out2 = myyuv2rgb(imgYUV);
%原图 原文结果 优化结果
imshow([rgb out1 out2])





