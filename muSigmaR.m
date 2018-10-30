function [mu, sigma, R,L, p] = muSigmaR(theta_P,X,Y,varargin)

n = size(X,1);

%% Calculating the correlation matrix R
R = Rcorr(theta_P,X,X,varargin{:}); 
[L,p] = chol(R);

%% Calculating the mean and variance

if(p>0)
    mu = nan;
    sigma = nan;
else
    %replace R\ by L\(L'
mu = (ones(n,1)'*(L\(L'\Y)))/(ones(n,1)'*(L\(L'\ones(n,1))));

sigma = (Y-ones(n,1)*mu)'*(L\(L'\(Y-ones(n,1)*mu)))/n;

if sigma <= 0
    sigma = 1e-5;
end

end

end