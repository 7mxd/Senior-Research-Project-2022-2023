clc; clear; clf; close all;

%% krls_santafe.m Explanation:

% This code is written to use the previous KRLS function and apply them to
% "The Santa Fe Time Series Competition Data Set A: Laser generated data".
% Based on 1000 data points of the laser time-series, KRLS will be used to
% predict the next 100 data points.

% Few Resources:
% (1) The Santa Fe Time Series Competition Data
%        http://www-psych.stanford.edu:80/~andreas/Time-Series/SantaFe.html
% (2) Github Gist - Santa-Fe Regression with MATLAB
%        https://gist.github.com/caub/9462102
% Link (1) may not be accesible, however; it can be accessed through the
% following link:
% (1) https://web.archive.org/web/20160427182805/http://www-psych.stanford.edu:80/~andreas/Time-Series/SantaFe.html

%% Load Data and Prepare Inputs

tic; % Time Started for NSME 

% Edit weboptions
options = weboptions;
options.Timeout = 60;

% Read Content from Webpage:
data = [webread('https://web.archive.org/web/20160427182805if_/http://www-psych.stanford.edu:80/~andreas/Time-Series/SantaFe/A.dat') ...
    webread('https://web.archive.org/web/20160427182805if_/http://www-psych.stanford.edu:80/~andreas/Time-Series/SantaFe/A.cont')];
y = textscan(data, '%f'); % Read Formatted Data (%f) from a text file (data)
y = y{1}(1:1100) / 256; % y{1} to access cell (access data)
figure('Name', 'Santa Fe Laset Time Series Data')
plot(y(1:1000))

% To export .eps figure
print -depsc KRLSTraining


%% Set an Auto-Regressive Matrix for the inputs
X = zeros(length(y), 40); % 1100 rows and 40 columms
for i = 1:size(X, 2) % 1:40
    X(:, i) = [NaN(i,1); y(1:end-i)]; % 'NaN' on the Upper Triangle of the Matrix
end 

%% Kernel Recursive Least Squares Regression

% Parameters:
%   Here we test them directly. Normally we must allocate room for 
%   cross-validation in order to find optimal parameters in a grid. Once
%   the best parameters are assessed, they an be evaluated on the 
%   training + validation sets

kernel_func = @rbf4nn; % Gaussian Kernel
kparam = 0.9; % Variance of the Gaussian
ald_thresh = 0.01; % almost-linearly-dependance threshold
n = 40; % Auto-Regressive Window Size

ltest = 100; % Test Set Size
Ytest = y(end - ltest + 1 : end); % Test Set
X_ = X(n + 1 : end - ltest, 1:n); % 960 x 40
Y_ = y(n + 1 : end - ltest); % 960 x 1

% We could try to train with missing values, starting at 2 instead of n+1
ltraining = size(X_, 1); % size of training data (960)
lvalidation = 0;

kp = krls_init(kernel_func, kparam, ald_thresh, X_(1,:)', Y_(1));

for i  = 2:ltraining 
    kp = krls(kp, X_(i,:)', Y_(i));
end

v = [Y_(ltraining) X_(ltraining, 1:n-1)];

prediction = zeros(ltest, 1);
for j = 1:ltest
    prediction(j) = krls_query(kp, v');
    v = [prediction(j) v(1:n-1)];
end

testNSME = goodnessOfFit(Ytest, prediction, 'NMSE');
disp("NSME = " + testNSME)

figure('Name', 'KRLS predicting 100 steps into the future with NMSE = 0.069428')
plot(1000 + (1:length(Ytest)), Ytest, 'b-')
hold on
plot(1000 + (1:length(Ytest)), prediction, 'r--')
hold off
legend('True Continuation', 'KRLS Prediction')

toc % Time Ended for NMSE

% To export .eps figure
print -depsc KRLSPrediction1

%% Reinforcement Training

% To improve the performance of a machine learning algorithm, a technique 
% called "Reinforcement Training" is used to iteratively add new training
% samples into the existing dataset and re-train the model on the
% "augmented" dataset.

tic % Time Started for Reinforcement Training

ireinforce = 10; % We will have 10 values of NMSE 
nmses = repmat(testNSME, 1, ireinforce); % Replicate the 'testNMSE' on 1 x 10 matrix
prediction = repmat(prediction, 1, ireinforce); % Replicate the 'prediction' on 1 x 10 matrix

for i = 2:ireinforce
    % Make new inputs by injecting the fitted values
    fitted = zeros(ltraining, 1); % fitted values are composed of 100 x 1 column vector
    for j = i:ltraining
        fitted(j) = krls_query(kp, X_(j, :)');
    end
    X_(2:end, 2:end) = X_(1:end-1, 1:end-1);
    X_(i:end, 1) = fitted(1:end-i+1);
    for j = i:ltraining
        kp = krls(kp,  X_(j, :)', Y_(j));
    end

    v = [Y_(ltraining) X_(ltraining, 1:n-1)];
    prediction = zeros(ltest, 1);
    for j = 1:ltest
        prediction(j) = krls_query(kp, v');
        v = [prediction(j) v(1:n-1)];
    end

    nmses(i) = goodnessOfFit(Ytest, prediction, 'NMSE');
    predictions(:, i) = prediction; % Prediction Vector that will contain prediction vectors for each iteration
end

% Plot Best Reinforcement

[minNMSE, iNMSE]  = min(nmses); % 'iNMSE' is the index of the minimum NMSE
disp("MIN NSME = " + minNMSE)

figure('Name', 'KRLS predicting 100 steps into the future with NMSE = 0.042877')
plot(1000 + (1:length(Ytest)), Ytest, 'b-')
hold on
plot(1000 + (1:length(Ytest)), predictions(:, iNMSE), 'r--') 
hold off
legend('True Continuation', 'KRLS Prediction')

toc % Time Ended for Reinforcement Training

% To export .eps figure
print -depsc KRLSPrediction2

% Restore weboptions 
options = weboptions;
options.Timeout = 5;

