%% Algorithm_RLSE Analysis:

clear; clc; clf; close all; 

rng(1);

% Note that we have the following parameters:
                                   %f = 0.5;
                                    Beta = 2;
                                    
% and I will test the following numbers of data points;
                              k_data = [26, 51, 76, 101];

%% Program Implementation:

% Initializing Data:
iter = 101; % Number of Iterations
x = zeros(iter,1); % `x` in learning algorithm
y = zeros(iter,1); % `y` in learning algorithm
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
    
    ERR_PERC(k,1) = ((abs(online(1,k) - f))/f)*100;
    ERR_PERC(k,2) = ((abs(online(2,k) - Beta))/Beta)*100;
end

%% Table & Plots:

table1 = table([2:101]', online(1,:)', ERR_PERC(:,1), online(2,:)', ERR_PERC(:,2), ...
    'VariableNames', {'k', 'f value', 'f Error %', 'beta value', 'beta Error %'})

figure('Name', 'Estimates of f and beta for different k values')
% Figure 1 (Estimates of f and beta for different data points)
subplot(2,1,1)
plot([2:101]', online(1,:)')
yline(0.5, '--r', 'f')
xlim([2 101])
xticks([2:11:102])
ylim([0 2.5])
xlabel('k value')
ylabel('f value')
title('f estimates of x_{k} s.t. k\in[2, 101]','fontName', 'Times New Roman')

subplot(2,1,2)
plot([2:101]', online(2,:))
yline(2, '--r', '\beta')
xlim([2 101])
xticks([2:11:102])
ylim([1.5 inf])
xlabel('k value')
ylabel('\beta value')
title('\beta estimates of x_{k} s.t. k\in[2, 101]','fontName', 'Times New Roman')

% To export .eps figure
print -depsc RLSEstimations1

figure('Name', "Error Percentage Compared with k values for f and beta")
% Figure 2 (Error Percentage Compared with Data Size for f and beta)
ERR = [ERR_PERC(25,:)', ERR_PERC(50,:)', ERR_PERC(75,:)', ERR_PERC(100,:)'];
subplot(5,1,[1,2])
plot(k_data, ERR(1, :), '-o')
xticks(k_data)
ytickformat('percentage')
axis([-inf inf -inf inf])
xlabel("k value")
ylabel("Error Perctenage")
for i=1:numel(k_data)
    text(k_data(i) + 1.2, ERR(1,i), [num2str(ERR(1,i), '%0.2f'),'%'])
end
title("Error Percentage for f Estimates at Different k values of x_{k}",'fontName', 'Times New Roman')

subplot(5,1,[4,5])
plot(k_data, ERR(2, :), 'r-o')
xticks(k_data)
ytickformat('percentage')
axis([-inf inf -inf inf])
xlabel("k value")
ylabel("Error Perctenage")
for i=1:numel(k_data)
    text(k_data(i) + 1.2, ERR(2,i), [num2str(ERR(2,i), '%0.2f'),'%'])
end
title("Error Percentage for \beta Estimates at Different k values of x_{k}",'fontName', 'Times New Roman')

% To export .eps figure
print -depsc RLSEstimations2