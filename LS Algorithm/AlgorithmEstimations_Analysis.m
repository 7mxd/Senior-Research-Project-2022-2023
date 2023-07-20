clc; clear; clf;

% We have the following: 
                             f = 0.5;
                             g = 1;
                             h = 2;
% Where beta is f*g as follows:
                             Beta = g*h;

% We are going through 100 iteration to generate the data

% Therefore, to check the impact of data size, I will keep increasing the 
% number of rows to estimate f and B.

% I will test the following sizes
                           datasize = [25, 50, 75, 100];
                           
% Set seed to get fixed results: 
rng(1);

[z1,b1,A1] = Algorithm_LSE(101, 25);
ERR_PERC(1,1) = ((abs(z1(1) - f))/f)*100;
ERR_PERC(1,2) = ((abs(z1(2) - Beta))/Beta)*100;

[z2,b2,A2] = Algorithm_LSE(101, 50);
ERR_PERC(2,1) = ((abs(z2(1) - f))/f)*100;
ERR_PERC(2,2) = ((abs(z2(2) - Beta))/Beta)*100;

[z3,b3,A3] = Algorithm_LSE(101, 75);
ERR_PERC(3,1) = ((abs(z3(1) - f))/f)*100;
ERR_PERC(3,2) = ((abs(z3(2) - Beta))/Beta)*100;

[z4,b4,A4] = Algorithm_LSE(101, 100);
ERR_PERC(4,1) = ((abs(z4(1) - f))/f)*100;
ERR_PERC(4,2) = ((abs(z4(2) - Beta))/Beta)*100;

f_values = [z1(1), z2(1), z3(1), z4(1)];
beta_values = [z1(2), z2(2), z3(2), z4(2)];

table(datasize', f_values', ERR_PERC(:,1), beta_values', ERR_PERC(:,2), ...
    'VariableNames', {'Data Points', 'f value', 'f Error %', 'beta value', 'beta Error %'})


subplot(5,1,[1,2])
plot(datasize, ERR_PERC(:, 1), '-o')
xticks(datasize)
ytickformat('percentage')
axis([-inf inf -inf inf])
xlabel("Data Points")
ylabel("Error Perctenage")
for i=1:numel(datasize)
    text(datasize(i) + 1.2, ERR_PERC(i,1), [num2str(ERR_PERC(i,1), '%0.2f'),'%'])
end
title("Error Percentage Compared with Data Size for f", 'fontName', 'Times New Roman')

subplot(5,1,[4,5])
plot(datasize, ERR_PERC(:, 2), 'r-o')
xticks(datasize)
ytickformat('percentage')
axis([-inf inf -inf inf])
xlabel("Data Points")
ylabel("Error Perctenage")
for i=1:numel(datasize)
    text(datasize(i) + 1.2, ERR_PERC(i,2), [num2str(ERR_PERC(i,2), '%0.2f'),'%'])
end
title("Error Percentage Compared with Data Size for \beta",'fontName', 'Times New Roman')

% To export .eps figure
print -depsc LSEstimations