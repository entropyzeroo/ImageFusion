function OUT = wlsFilter(IN, lambda, alpha, L)
%WLSFILTER Edge-preserving smoothing based on the weighted least squares(WLS)?
% ? optimization framework, as described in Farbman, Fattal, Lischinski, and
% ? Szeliski, "Edge-Preserving Decompositions for Multi-Scale Tone and Detail
% ? Manipulation", ACM Transactions on Graphics, 27(3), August 2008.
%
% ? Given an input image IN, we seek a new image OUT, which, on the one hand,
% ? is as close as possible to IN, and, at the same time, is as smooth as
% ? possible everywhere, except across significant gradients in L.
%
%
% ? Input arguments:
% ? ----------------
% ? ? IN ? ? ? ? ? ? ?Input image (2-D, double, N-by-M matrix).?
% ? ? ??
% ? ? lambda ? ? ? ? ?Balances between the data term and the smoothness
% ? ? ? ? ? ? ? ? ? ? term. Increasing lambda will produce smoother images.
% ? ? ? ? ? ? ? ? ? ? Default value is 1.0
% ? ? ??
% ? ? alpha ? ? ? ? ? Gives a degree of control over the affinities by non-
% ? ? ? ? ? ? ? ? ? ? lineary scaling the gradients. Increasing alpha will
% ? ? ? ? ? ? ? ? ? ? result in sharper preserved edges. Default value: 1.2
% ? ? ??
% ? ? L ? ? ? ? ? ? ? Source image for the affinity matrix. Same dimensions
% ? ? ? ? ? ? ? ? ? ? as the input image IN. Default: log(IN)
%?
%
% ? Example?
% ? -------
% ? ? RGB = imread('peppers.png');?
% ? ? I = double(rgb2gray(RGB));
% ? ? I = I./max(I(:));
% ? ? res = wlsFilter(I, 0.5);
% ? ? figure, imshow(I), figure, imshow(res)
% ? ? res = wlsFilter(I, 2, 2);
% ? ? figure, imshow(res)

if(~exist('L', 'var')) %参数不存在，选取的默认值
    L = log(IN+eps);
end

if(~exist('alpha', 'var'))
	alpha = 1.2;
end

if(~exist('lambda', 'var'))
	lambda = 1;
end

smallNum = 0.0001;

[r,c] = size(IN);
k = r*c;

% Compute affinities between adjacent pixels based on gradients of L

dy = diff(L, 1, 1); %对L矩阵的第一维度上做差分，也就是下面的行减去上面的行，得到(N-1)xM维的矩阵
dy = -lambda./(abs(dy).^alpha + smallNum);
dy = padarray(dy, [1 0], 'post');%在最后一行的后面补上一行0
dy = dy(:);%按列生成向量，就是Ay对角线上的元素构成的矩阵

dx = diff(L, 1, 2); %对L矩阵的第二维度做差分，也就是右边的列减去左边的列，得到Nx(M-1)的矩阵
dx = -lambda./(abs(dx).^alpha + smallNum);
dx = padarray(dx, [0 1], 'post');%在最后一列的后面添加一列0
dx = dx(:);%按列生成向量，对应上面Ax的对角线元素


% Construct a five-point spatially inhomogeneous Laplacian matrix
B(:,1) = dx;
B(:,2) = dy;
d = [-r,-1];
A = spdiags(B,d,k,k);%把dx放在-r对应的对角线上，把dy放在-1对应的对角线上

e = dx;
w = padarray(dx, r, 'pre'); w = w(1:end-r);
s = dy;
n = padarray(dy, 1, 'pre'); n = n(1:end-1);

D = 1-(e+w+s+n);
A = A + A' + spdiags(D, 0, k, k);%A只有五个对角线上有非0元素

% Solve
OUT = A\IN(:);
OUT = reshape(OUT, r, c);

