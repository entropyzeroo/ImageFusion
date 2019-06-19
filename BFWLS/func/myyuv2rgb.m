% function rgb  = myyuv2rgb(image)
% input params.
% image: input YUV image with YUV444 format, which value must be [0 255]
% output
% rgb: 3 channels color image, value [0 255], double
%


 
function rgb  = myyuv2rgb(image)
image = double(image);
Y = image(:,:,1);
U = image(:,:,2);
V = image(:,:,3);
 
R = Y + 1.402.*(V-128);
 
G = Y - 0.34414.*(U-128) - 0.71414.*(V-128);
 
B = Y + 1.772.*(U-128);
 
rgb(:,:,1) = R;
rgb(:,:,2) = G;
rgb(:,:,3) = B;
end