clc
clear
close all
addpath func
addpath im

rgb = im2double(imread('rgb.jpg'));
nir = im2double(imread('nir.jpg'));

% 金字塔层数
nlev = 5;

% 分通道融合
for i=1:3
    rgb_pyr = LPD(rgb(:,:,i), nlev);
    nir_pyr = LPD(nir, nlev);
    % 顶层融合规则选择
%     out = (rgb_pyr{nlev}+nir_pyr{nlev})/2;
    out = rgb_pyr{nlev};
    % 下层融合规则
    for l = nlev-1 : -1 : 1
        out = nir_pyr{l} + rgb_pyr{l} + ...
        imresize(out,[size(nir_pyr{l},1) size(nir_pyr{l},2)],'bilinear');
    end
    O(:,:,i) = out;
end

imshow([rgb nir O])

