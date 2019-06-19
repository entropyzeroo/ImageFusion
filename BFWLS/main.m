% 

clear
clc
addpath ./im
addpath ./func
t1 = Tiff('0000_rgb.tiff','r');
t2 = Tiff('0000_nir.tiff','r');
imgRGB = read(t1);
imgNIR = read(t2);
% trans to YUV color space
imgYUV = myrgb2yuv(imgRGB);


imgNIR_Double = double(imgNIR);

%% step1
Yb_WLS = wlsFilter(imgNIR_Double,0.125,1.2); 
Yb_BF = fastBilateralFilter(imgNIR_Double);

Yd_WLS = imgNIR_Double - Yb_WLS;
Yd_BF = imgNIR_Double - Yb_BF;

Yb_WLS_C = wlsFilter(imgYUV(:,:,1),0.125,1.2);
% detail fusion
Yd = 0.5*(Yd_WLS + Yd_BF);
%% step2
% base fusion
Y = Yb_WLS_C + Yd;


imgYUV(:,:,1) = Y;

% trans to RGB
OUT = myyuv2rgb(imgYUV);

figure
imshow([imgRGB uint8(OUT)]);

