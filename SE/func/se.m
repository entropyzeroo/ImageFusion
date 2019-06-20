function [gx,gy] = se(rx, ry, hx, hy)
%SE
[m, n, ~] = size(rx);
gx = zeros(size(rx));
gy = gx;

rx2 = sum(rx.^2, 3);
ry2 = sum(ry.^2, 3);
rxy = sum(rx.*ry, 3);

hx2 = sum(hx.^2, 3);
hy2 = sum(hy.^2, 3);
hxy = sum(hx.*hy, 3);

for i=1:m
    for j=1:n
        st1 = [rx2(i,j) rxy(i, j);rxy(i, j) ry2(i, j)];
        st2 = [hx2(i,j) hxy(i, j);hxy(i, j) hy2(i, j)];
        sq1 = st1^0.5;
        sq2 = st2^0.5;
        temp = sq1*sq2';
        [u, ~, v] = svd(temp);
        o = u*v;
        a = real(pinv(sq1)*o*sq2');
        x = rx(i, j, :);
        y = ry(i, j, :);
        xy = [x(:) y(:)];
        xy = xy*a;
        gx(i,j,:) = xy(:,1);
        gy(i,j,:) = xy(:,2);
    end
end

end

