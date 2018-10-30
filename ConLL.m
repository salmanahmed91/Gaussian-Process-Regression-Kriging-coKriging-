function [negLogLik, mu, sigma2, R] = ConLL(theta_P,X,Y,varargin)

n = size(X,1);
k = size(X,2);
%% Calculating the correlation matrix R
[mu, sigma2, R,L,p] = muSigmaR(theta_P,X,Y,varargin{:});

%% Calculate the log_lik function
if (p > 0)
    negLogLik = 1e4;
else
   %logDetR = log(det(R));
    logDetR = 2*sum(log(abs(diag(L))));
    negLogLik = -( -n/2*log(sigma2) - 1/2 * logDetR) ;
end








end