%% dict Function Explanation:

% Part of the dictionary implementation used by the KRLS algorithm. Based
% on the definition of the KRLS, we need to implement the idea of
% admitting points, that are not representable as a linear combination of 
% the other points, into the dictionary. Hence, in this case, state is a 
% column vector that may or may not be added to the dictionary, based on  
% whether its features are almost-linearly-dependent on the other points in 
% the dictionary or not.

% Implemeneted by following the following resource:
% (1) David Wingate Personal Page - Resources Page:
%                         http://web.mit.edu/~wingated/www/resources.html
% (2) dict.m Script available at David Wingate's Resources Page:
%                         http://web.mit.edu/~wingated/www/scripts/dict.m
% Links may not be accesible, however; they can be accessed through the 
% following links:
% (1) https://web.archive.org/web/20140228014003/http://web.mit.edu/~wingated/www/resources.html
% (2) https://web.archive.org/web/20121108225246/http://web.mit.edu/~wingated/www/scripts/dict.m

%% function dp = dict(dp, state)

% Inputs:
% dp -> Data structure represting the problem setup, returned from
% dict_init.m or subsequent calls to this function (dict.m)
% state -> A new data point

% Outputs:
% dp -> An updated data structure. 


function dp = dict(dp, state)
m = size(dp.Dict, 2); % Number of Enteries ; note that size(''',2) returns the columns number

ktt = feval(dp.kfunc, state, state, dp.kparam);
ktwid = feval(dp.kfunc, dp.Dict, state, dp.kparam);

at = dp.Kinv * ktwid;
dt = ktt - ktwid' * at;

dp.addedFlag = 0;

if (dt > dp.thresh) % if NOT almost-linearly-dependent, add to dictionary
    dp.Dict = [dp.Dict, state];
    dp.K = [dp.K, ktwid; ktwid', ktt];
    dp.Kinv = (1 / dt) * [dt * (dp.Kinv) + at * at', -at; -at', 1];
    dp.addedFlag = 1;
end

dp.at = at;
dp.dt = dt;
dp.ktwid = ktwid;
kp.ktt = ktt; 

return;
end
