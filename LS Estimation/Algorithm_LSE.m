%% Algorithm_LSE.m Explanation:

% A function that takes two inputs and returns three outputs

% Inputs:
% - iter : Number of Iterations for Generating Data
% - rows : Number of Data Points Used for Estimating x

% Note than x is called here as (z) to avoid some confusions when running
% the code

% Outputs:
% Az = b ; (x is replaced by z)
% Outputs are A matrix, z vector, and b vector.

%% Code Implementation

function [z,b,A] = Algorithm_LSE(iter, rows)


% Generating Data Phase:
x = zeros(iter,1);
y = zeros(iter,1);
s = zeros(2, iter);

x(1) = 2;
y(1) = 1;
s(:,1) = [x(1) ; y(1)];

f = 0.5;
g = 1;
h = 2;

u = zeros(iter, 1); 
u = randi([0,1], [iter,1]);
% for i = 1:iter
%     if i == 1
%         %u(i) = 1;
%     else
%         %u(i) = 0;
%     end
% end

d = zeros(iter, 1);

for i = 2:iter 
    x(i) = f*x(i-1) + g*u(i);
    y(i) = h*x(i);
    s(:, i) = [x(i) ; y(i)];
end

for i = 1:iter
    d(i) = y(i);
end

% Solving  b = Az


% for i=1:iter-1
%     b(i,1) = y(i+1);
% end
% 
% for i=1:iter-1
%     A(i, 1) = y(i);
%     A(i, 2) = u(i+1);
% end

for i=1:rows
    b(i,1) = y(i+1);
end

for i=1:rows
    A(i,1) = y(i);
    A(i,2) = u(i+1);
end

z = A\b;
end
