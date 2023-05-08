clc; clear; clf; close all;

%% LearningAlgorithmCode.m Explanation:

% Is the m file name suggest. This is a code that I wrote to implement the 
% learning algorithm explained in the research paper. The code includes two
% phases. A phase of simulating data, and then a phase of estimating the 
% system parameters f,g,h.

%% Generating Data Phase:

% To Control Random Number Generator
rng(10)

iter = 100;

x = zeros(iter,1);
y = zeros(iter,1);
s = zeros(2, iter);

x(1) = 2;
y(1) = 1;
s(:,1) = [x(1) ; y(1)];

f_exact = 0.5;
g_exact = 1;
h_exact = 2;

% Using u as a random response instead of the commented impulse response

u = zeros(iter, 1); 
u = randi([0,1], [1,iter]);

% for i = 1:iter
%     if i == 1
%         %u(i) = 1;
%     else
%         %u(i) = 0;
%     end
% end

d = zeros(iter, 1);

for i = 2:iter 
    x(i) = f_exact*x(i-1) + g_exact*u(i);
    y(i) = h_exact*x(i);
    s(:, i) = [x(i) ; y(i)];
end

for i = 1:iter
    d(i) = y(i);
end

%% Estimating the System Parameters: 
% Note: I used the explicit scheme.

n = 0.1; % learning rate 
f = zeros(iter, 1);
g = zeros(iter, 1);
h = zeros(iter, 1);
f(1) = 0.3;
g(1) = 0.7;
h(1) = 1;


e = zeros(iter, 1);
yhat = zeros(iter, 1);
yhat(1) = 1;


for i = 2:iter % # of iterations 
    f(i) = f(i-1) + n*e(i-1)*yhat(i-1); % yhat(i-1) = I*s(:, i-1)
    g(i) = g(i-1) + n*e(i-1)*h(i-1)*u(i);
    h(i) = h(i-1) + n*e(i-1)*(yhat(i-1)/h(i-1));
    yhat(i) = f(i)*yhat(i-1) + h(i)*g(i)*u(i);
    e(i) = d(i) - yhat(i);
end

%% Plotting and Calculating Errors

Error_f = zeros(iter, 1);
Error_g = zeros(iter, 1);
Error_h = zeros(iter, 1);

for i = 1:iter
    Error_f(i) = ((abs(f(i) - f_exact))/f_exact)*100;
    Error_g(i) = ((abs(g(i) - g_exact))/g_exact)*100;
    Error_h(i) = ((abs(h(i) - h_exact))/h_exact)*100;
end

Error = [Error_f, Error_g, Error_h];

figure('Name', 'Estimates of f,g,h')
% Figure 1 (Estimates of f,g,h for 100 Iterations)

subplot(3,1,1)
plot([1:100]', f)
yline(0.5, '--r', 'f')
axis([-inf inf 0 2.5])
xlabel('Number of Iterations')
ylabel('f Value')
title('Estimates of f for 100 Iterations')

subplot(3,1,2)
plot([1:100]', g)
yline(1, '--r', 'g')
axis([-inf inf 0 2.5])
xlabel('Number of Iterations')
ylabel('g Value')
title('Estimates of g for 100 Iterations')

subplot(3,1,3)
plot([1:100]', h)
yline(2, '--r', 'h')
axis([-inf inf 0 2.5])
xlabel('Number of Iterations')
ylabel('h Value')
title('Estimates of h for 100 Iterations')

table([1:100]', f, Error_f, g, Error_g, h, Error_h, 'VariableNames', ...
    {'iteration', 'f est.', 'f Error%', 'g est.', 'g Error%', 'h est.', ...
    'h Error%'})

% To export .eps figure 
print -depsc fghestimatesLA 
