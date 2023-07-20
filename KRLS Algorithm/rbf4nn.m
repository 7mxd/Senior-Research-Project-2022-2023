%% rbf4nn Function Explanation:

% Fast Gaussian kernel evaluation that uses spherical covariances without
% the normalization factor.

% The function computes a radial basis function (rbf) kernel matrix of the 
% inputs X and Y, using a uniform covariance matrix defined as (sigsq * I)

% Implemeneted by following the following resource:
% (1) David Wingate Personal Page - Resources Page:
%                         http://web.mit.edu/~wingated/www/resources.html
% (2) rbf4nn.m Script available at David Wingate's Resources Page:
%                         http://web.mit.edu/~wingated/www/scripts/rbf4nn.m
% Links may not be accesible, however; they can be accessed through the 
% following links:
% (1) https://web.archive.org/web/20140228014003/http://web.mit.edu/~wingated/www/resources.html
% (2) https://web.archive.org/web/20121114002549/http://web.mit.edu/~wingated/www/scripts/rbf4nn.m

%% function K = rbf4nn(X, Y, sig)

% Inputs:
% X -> a matrix that contains all samples as columns
% Y -> another matrix that contains all samples as columns
% sigsq -> sigma (squared) ; where sigma represents the kernal width

% Outputs:
% K_ij = exp(-1 / (2*sigsq) * (X_i' * Y_j)) 
% where K_ij is the Gaussian kernel function equation


function K = rbf4nn(X, Y, sigsq)
K = X' * Y;

Xsq = X .* X;
Xsum = sum(Xsq, 1);

Ysq = Y .* Y;
Ysum = sum(Ysq, 1);

K = K - Xsum' * ones(1, length(Ysum)) / 2;
K = K - ones(length(Xsum), 1) * Ysum / 2;
K = K ./ sigsq;
K = exp(K);
end

