function [negLogLik, mu, sigma2, R] = ConLLD(thetaE_Pe_rho,Xe,Ye,Yc,varargin)

nth = length(thetaE_Pe_rho);
rho    = thetaE_Pe_rho(nth);
theta_P = thetaE_Pe_rho(1:end-1);
ne = size(Xe,1);

%% Calculating the mean and variance
d = Ye - rho.*Yc ;

%% Calculating the correlation matrix R
[mu, sigma2, R,L,p] = muSigmaR(theta_P,Xe,d,varargin{:});

%% Calculate the log_lik function
if (p > 0)
    negLogLik = 1e4;
else
   %logDetR = log(det(R));
    logDetR = 2*sum(log(abs(diag(L))));
    negLogLik = -( -ne/2*log(sigma2) - 1/2 * logDetR) ;
    
    if(negLogLik == -Inf)
        negLogLik = -1e-12;
    end
end





end