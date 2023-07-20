%% krls_query Function Explanation:

% Query the Resulting Estimator
% Gives the value of the regression function at a given state

% Part of the Kernel Recursive Least Squares (KRLS) Implementation.

% Implemeneted by following the following resource:
% (1) David Wingate Personal Page - Resources Page:
%                         http://web.mit.edu/~wingated/www/resources.html
% (2) krls_init.m Script available at David Wingate's Resources Page:
%                         http://web.mit.edu/~wingated/www/scripts/krls_query.m
% Links may not be accesible, however; they can be accessed through the 
% following links:
% (1) https://web.archive.org/web/20140228014003/http://web.mit.edu/~wingated/www/resources.html
% (2) https://web.archive.org/web/20121108224401/http://web.mit.edu/~wingated/www/scripts/krls_query.m

%% function val = krls_query(kp, state)

% Inputs:
% kp -> the data structure returned from "krls_init.m" or subsequent calls 
%       to the "krls.m" function
% state -> the vector you want to query

% Outputs:
% val -> the value of regression function at state


function val = krls_query(kp, state)
kernvals = feval(kp.kfunc, state, kp.dp.Dict, kp.kparam);

val = kernvals * kp.Alpha;

return;
end

