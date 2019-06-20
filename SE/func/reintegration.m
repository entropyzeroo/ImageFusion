function out = reintegration(im, gx, gy)
%从梯度重建图像

[m, n, ~] = size(im);
R = im(:,:,1);G = im(:,:,2);B = im(:,:,3);
R2 = R.^2;G2 = G.^2;B2=B.^2;
RG = R.*G;RB = R.*B;GB = G.*B;
P = cat(3, R, G, B, R2, G2, B2, RG, RB, GB);
[Px, Py] = gradient(P);
Pxy = reshape([Px;Py], 2*m*n, 9);
Jxy = [gx;gy];
J1 = Jxy(:,:,1);J2 = Jxy(:,:,2);J3= Jxy(:,:,3);
z1 = pinv((Pxy'*Pxy))*Pxy'*J1(:);
z2 = pinv((Pxy'*Pxy))*Pxy'*J2(:);
z3 = pinv((Pxy'*Pxy))*Pxy'*J3(:);
PP = reshape(P, m*n, 9);
out(:,:,1) = reshape(PP*z1, m, n);
out(:,:,2) = reshape(PP*z2, m, n);
out(:,:,3) = reshape(PP*z3, m, n);
end

