clc
clear
close all
addpath ./func
addpath ./im


im1 = im2double(imread('1.jpg'));
im2 = im2double(imread('2.jpg'));

% imshow([im1 im2])
%% Get B,D
h1 = fspecial('average',[31,31]);
B1 = imfilter(im1, h1, 'replicate');
B2 = imfilter(im2, h1, 'replicate');

D1 = im1-B1;
D2 = im2-B2;
% imshow([B1 B2])


%% Saliency map
h2 = fspecial('laplacian');
H1 = imfilter(im1, h2, 'replicate');
H2 = imfilter(im2, h2, 'replicate');

H1 = abs(H1);
H2 = abs(H2);

h3 = fspecial('gaussian', [11,11], 5);
S1 = imfilter(H1, h3, 'replicate');
S2 = imfilter(H2, h3, 'replicate');

% imshow([H1 H2;S1 S2])

%%  Get Weight maps
P1 = saliency(S1, S2);
P2 = saliency(S2, S1);

% imshow([P1 P2])

%% Guide Filter
eps1 = 0.3^2;
eps2 = 0.05^2;
for i=1:3
    Wb1(:,:,i) = guidedfilter(im1(:,:,i) , P1(:,:,i) , 8, eps1);
    Wb2(:,:,i)  = guidedfilter(im2(:,:,i) , P2(:,:,i) , 8, eps1);

    Wd1(:,:,i)  = guidedfilter(im1(:,:,i) , P1(:,:,i) , 4, eps2);
    Wd2(:,:,i)  = guidedfilter(im2(:,:,i) , P2(:,:,i) , 4, eps2);
end

% imshow([Wb1 Wb2;Wd1 Wd2])
%% Weighted average
Wbmax = Wb1+Wb2;
Wdmax = Wd1+Wd2;
Wb1 = Wb1./Wbmax;
Wb2 = Wb2./Wbmax;
Wd1 = Wd1./Wdmax;
Wd2 = Wd2./Wdmax;


B = B1.*Wb1+B2.*Wb2;
D = D1.*Wd1+D2.*Wd2;
im = B+D;

imshow([im1 im2 im])




