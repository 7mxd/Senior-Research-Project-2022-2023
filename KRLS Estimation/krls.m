%% krls Function Explanation:

% Main Kernel Recursive Least Squares (KRLS) Function. 
% It will be repeatedly called with new data points.
% Part of the Kernel Recursive Least Squares (KRLS) Implementation.

% Implemeneted by following the following resource:
% (1) David Wingate Personal Page - Resources Page:
%                         http://web.mit.edu/~wingated/www/resources.html
% (2) krls_init.m Script available at David Wingate's Resources Page:
%                         http://web.mit.edu/~wingated/www/scripts/krls.m
% Links may not be accesible, however; they can be accessed through the 
% following links:
% (1) https://web.archive.org/web/20140228014003/http://web.mit.edu/~wingated/www/resources.html
% (2) https://web.archive.org/web/20121108224525/http://web.mit.edu/~wingated/www/scripts/krls.m

%% function kp = krls(kp, state, target)

% Inputs:
% kp -> the data structure returned from "krls_init.m" or subsequent calls 
%       to this function (krls.m)
% state -> the next state vector (data point) (column vector)
% target -> the target value (scalar)

% Outputs:
% kp -> A data structure that includes everything needed for subsequent
%       KRLS calls (in krls.m)


function kp = krls(kp, state, target)
m = size(kp.dp.Dict, 2); % Number of Enteries ; note that size(''',2) returns the columns number

kp.dp = dict(kp.dp, state);

at = kp.dp.at;
dt = kp.dp.dt;
ktwid = kp.dp.ktwid;
Kinv = kp.dp.Kinv;

if(kp.dp.addedFlag) 
    kp.P = [kp.P, zeros(m, 1); zeros(1, m), 1];
    inno = (target - ktwid' * kp.Alpha) / dt;
    kp.Alpha = [kp.Alpha - at * inno; inno];
    kp.addedFlag = 1;
else 
    tmp = kp.P * at;
    qt = tmp / (1 + at' * tmp);
    kp.P = kp.P - qt * tmp';
    kp.Alpha = kp.Alpha + Kinv * qt * (target - ktwid' * kp.Alpha);
    kp.addedFlag = 0;
end

return;
end

