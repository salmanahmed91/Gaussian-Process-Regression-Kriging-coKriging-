function R = Rcorr_GAUSS2(theta_P,X1,X2)
%% This functaion calculates the correlation between the 
% points X1 and X2 based on the distance function
%   nth = length(theta_P);
%  theta = theta_P(1:nth/2);
%  P     = theta_P((nth)/2 + 1:nth);

theta = theta_P;

%% testing section only
%theta = theta_P(1,1);
%T1 = theta_P(1,3);
%T2 = theta_P(1,4);
%P  = theta_P(1,2);
%P = 2;
%%


k =length(theta);
nX1 = size(X1,1);
nX2 = size(X2,1);


R = zeros(nX1,nX2);
D = zeros(nX1,nX2);


%% Calculating the correlation matrix R
for i = 1:nX1
    for j = 1:nX2
        for h = 1:k
        %D(i,j) = D(i,j) + theta(h).* abs( X1(i,h) - X2(j,h) ).^(P(h));
        D(i,j) = D(i,j) + theta(h).* abs( X1(i,h) - X2(j,h) ).^(2);
        end
        R(i,j) = exp(  -D(i,j)) ;
    end
end


