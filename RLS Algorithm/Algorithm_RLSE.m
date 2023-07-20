%% Algorithm_RLSE Program Explanation:

% "Algorithm_RLSE.m" is a program that updates the parameter estimates 
% once a new data point is generated. It uses the "RLSE_Online" function 
% to compare the results of the on-line processing with the results
% obtained by the off-line processing (using A\b)

% Implemeneted by following instructions given by (APPLIED NUMERICAL 
% METHODS USING MATLAB), pages 76-79

%% Program Implementation:

rng(10);

clear; clc;

% Initializing Data:
iter = 101; % Number of Iterations
x = zeros(iter,1); % UPPERCASE X represents `x` in learning algorithm
y = zeros(iter,1); % UPPERCASE Y represents `y` in learning algorithm
x(1) = 2;
y(1) = 1;
u = randi([0,1], [iter, 1]); 
f = 0.5;
g = 1;
h = 2;

z_o = [0.5 2]'; % True Values of the Parameters (f, beta)
zsize = length(z_o);
z = zeros(zsize, 1);
P = 100*eye(zsize, zsize);

for k=1:(iter - 1) 
    x(k+1) = f*x(k) + g*u(k+1); 
    y(k+1) = h*x(k+1);
    
    A(k, :) = [y(k) u(k+1)];
    b(k, :) = y(k+1);
    [z,K,P] = RLSE_Online(A(k,:), b(k,:), z, P); % Updating z vector (f, beta) estimates
    online(:,k) = z;
    offline(:,k) = A\b;
end

table([1:100]', online(1,:)', online(2,:)', offline(1,:)', offline(2,:)', ...
    'VariableNames', {'k', 'f value on-line', 'beta value on-line', ...
    'f value off-line', 'beta value off-line'})