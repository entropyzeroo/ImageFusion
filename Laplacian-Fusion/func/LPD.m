function pyr = LPD(I, nlev, sigma)
%Laplacian Pyramid Decomposition
%拉普拉斯金字塔分解
%   nlev  金字塔层数
%   sigma 高斯模糊程度

if size(I,3)==3
    I=rgb2gray(I);
end

if ~exist('nlev', 'var')
    nlev = 4;
end
 
if ~exist('sigma', 'var')
    sigma=0.4;
end

f = fspecial('gaussian', floor(sigma*6+1), sigma);
 
%构建拉普拉斯金字塔
pyr = cell(nlev,1);
J = I;
for l = 1:nlev-1   
    J_gauss = imfilter(J,f,'replicate');
    J_gauss_down = J_gauss(1:2:size(J_gauss,1)-1,1:2:size(J_gauss,2)-1); %downsample 
    J_gauss_high = imresize(J_gauss_down,[size(J_gauss,1) size(J_gauss,2)],'bilinear');
    pyr{l} = J-J_gauss_high;
    J=J_gauss_down;
end
pyr{nlev}=J_gauss_down; %最上一层即为高斯金字塔

end

