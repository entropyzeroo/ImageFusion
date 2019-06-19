function out = saliency(i1,i2)
%权重映射
%对于输入的两张RGB图,返回图1的三通道权重图
[w, h, d] = size(i1);
out = zeros(w, h, d);
for i=1:d
    maxmap = max(cat(3, i1(:,:,i), i2(:,:,i)), [], 3); %求显著值图
    temp = double(maxmap==i1(:,:,i)); % 求解权重图
    out(:,:,i) = temp;
end

