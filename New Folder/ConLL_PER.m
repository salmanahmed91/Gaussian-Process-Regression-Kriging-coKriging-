function [fval, mu, sigma, R] = ConLL_PER(theta_P_T,X,Y)

nth = length(theta_P_T);
theta = theta_P_T(1:nth/3);
P   = theta_P_T((nth)/3+1:(nth)/3 + nth/3);
T   = theta_P_T((nth)/3 + nth/3 + 1 : nth);

k = length(theta);
n = size(X,1);

R = zeros(n,n);
D = zeros(n,n);

%% Calculating the correlation matrix R
% for i = 1:n
%     for j = 1:n
%         for h = 1:k
%         D(i,j) = D(i,j) + theta(h).* abs( X(i,h) - X(j,h) ).^P(h);
%         end
%         R(i,j) = exp(-D(i,j));
%     end
% end

R = Rcorr_PER(theta,P,T,X,X);

%% Calculating the mean and variance


mu = (ones(n,1)'*(R\Y))/(ones(n,1)'*(R\ones(n,1)));

sigma = (Y-ones(n,1)*mu)'*(R\(Y-ones(n,1)*mu))/n;

%% Calculate the log_lik function
logRdet = log(det(R));
if (logRdet < -743.7469)
    logRdet = -743.7469;
else
    logRdet = logRdet;
end

fval = -( -n/2*log(sigma) - 1/2 * logRdet) ;





end