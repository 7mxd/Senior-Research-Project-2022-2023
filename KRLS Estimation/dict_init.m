%% dict_init Function Explanation:

% Dictionary Initializer ; Will be used later in "dict.m"

% Part of the dictionary implementation used by the KRLS algorithm. Based
% on the definition of the KRLS, we need to implement the idea of
% admitting points, that are not representable as a linear combination of 
% the other points, into the dictionary.

% Implemeneted by following the following resource:
% (1) David Wingate Personal Page - Resources Page:
%                         http://web.mit.edu/~wingated/www/resources.html
% (2) dict_init.m Script available at David Wingate's Resources Page:
%                         http://web.mit.edu/~wingated/www/scripts/dict_init.m
% Links may not be accesible, however; they can be accessed through the 
% following links:
% (1) https://web.archive.org/web/20140228014003/http://web.mit.edu/~wingated/www/resources.html
% (2) https://web.archive.org/web/20121116162347/http://web.mit.edu/~wingated/www/scripts/dict_init.m

%% function dp = dict_init(kfunc, kparam, thresh, state)

% Inputs:
% kfunc -> Handle to the kernel function, which is the "rbf4nn.m" function
%          in our case. This function should take three agruments: X, Y,
%          and some sort of parameter. It should return a matrix K, where K_ij is
%          kernel(X_i, Y_i, kparam). X and Y are matrices of the data 
%          points stored as columns.
% kparam -> The "kernel specific" parameter that will be passed to the
%           kernel function on every call.
% thresh -> the almost-linearly-independent threshold
% state -> the initial data point (column vector)

% Outputs:
% dp -> A dictionary data structure. Used to be called in "dict.m".


function dp = dict_init(kfunc, kparam, thresh, state)
dp.kfunc = kfunc;
dp.kparam = kparam;
dp.thresh = thresh;

dp.Dict = state;

dp.K = feval(kfunc, state, state, kparam); % evaluate the kernel function on the three other inputs 
dp.Kinv = 1 / dp.K; % inverted K

dp.addedFlag = 1; 

return;
end

