%% RLSE on-line processing
%  Implemeneted by following instructions given by (APPLIED NUMERICAL 
%  METHODS USING MATLAB), pages 76-79

%% Explanation:

% at_k1 represents the added data point of A matrix
% b_k1 represents the added data point of b vector
% K represents the gain matrix
% P represents the inverse matrix "[A_k' A_k]^-1"

%% Defining RLSE_Online Function:

function [x, K, P] = RLSE_Online(aT_k1, b_k1, x, P)
    K = P*aT_k1' / (aT_k1*P*aT_k1' + 1); % Equation (2.1.17) Page 78
    x = x + K * (b_k1 - aT_k1*x); % Equation (2.1.16) Page 78
    P = P - K*aT_k1*P; % Equation (2.1.18) Page 78
end