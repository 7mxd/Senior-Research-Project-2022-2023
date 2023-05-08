%% krls_init Function Explanation:

% Kernel Recursive Least Squares (KRLS) Initializer. 
% Part of the Kernel Recursive Least Squares (KRLS) Implementation.

% Implemeneted by following the following resource:
% (1) David Wingate Personal Page - Resources Page:
%                         http://web.mit.edu/~wingated/www/resources.html
% (2) krls_init.m Script available at David Wingate's Resources Page:
%                         http://web.mit.edu/~wingated/www/scripts/krls_init.m
% Links may not be accesible, however; they can be accessed through the 
% following links:
% (1) https://web.archive.org/web/20140228014003/http://web.mit.edu/~wingated/www/resources.html
% (2) https://web.archive.org/web/20121108224220/http://web.mit.edu/~wingated/www/scripts/krls_init.m

%% function kp = krls_init(kfunc, kparam, thresh, state, target)

% Inputs:
% kfunc -> Handle to the kernel function, which is the "rbf4nn.m" function
%          in our case. This function should take three agruments: X, Y,
%          and some sort of parameter (which is kernel specific ;
%          sigma squared). It should return a matrix K, where K_ij is
%          kernel(X_i, Y_i, kparam). X and Y are matrices of the data 
%          points stored as columns.
% kparam -> The "kernel specific" parameter that will be passed to the
%           kernel function on every call.
% thresh -> the almost-linearly-independent threshold
% state -> the initial data point (column vector)
% target -> the initial target (scalar)

% Outputs:
% kp -> A data structure that includes everything needed for subsequent
%       KRLS calls (in krls.m)


function kp = krls_init(kfunc, kparam, thresh, state, target)
kp.kfunc = kfunc;
kp.kparam = kparam;
kp.thresh = thresh;

kp.dp = dict_init(kfunc, kparam, thresh, state);

kp.P = 1;
kp.Alpha = target / kp.dp.K;

return;
end

