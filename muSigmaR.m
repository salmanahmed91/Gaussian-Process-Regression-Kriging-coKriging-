function [mu, sigma2, R,L, p] = muSigmaR(theta_P,X,Y,varargin)

n = size(X,1);

%% Calculating the correlation matrix R
R = Rcorr(theta_P,X,X,varargin{:}); 
[L,p] = chol(R);

%% Calculating the mean and variance

if(p>0)
    mu = nan;
    sigma2 = nan;
else
    %replace R\ by L\(L'
mu = (ones(n,1)'*(L\(L'\Y)))/(ones(n,1)'*(L\(L'\ones(n,1))));

sigma2 = (Y-ones(n,1)*mu)'*(L\(L'\(Y-ones(n,1)*mu)))/n;

if(sigma2 <= 0)
    sigma2 = 1e-12;
end

end

end