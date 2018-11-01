function [R] = Rcorr_PER(theta,P,T,X1,X2)
%% This functaion calculates the correlation between the 
% points X1 and X2 based on the distance function



k =length(theta);
nX1 = size(X1,1);
nX2 = size(X2,1);


R = zeros(nX1,nX2);
D = zeros(nX1,nX2);
PD  = zeros(nX1,nX2);

%% Calculating the correlation matrix R
for i = 1:nX1
    for j = 1:nX2
        for h = 1:k
        D(i,j) = D(i,j) + theta(h).* abs( X1(i,h) - X2(j,h) ).^P(h);
        PD(i,j) = PD(i,j) + 2.*sin(pi/T(h).*(X1(i,h)-X2(j,h))).^2 ;
        end
        R(i,j) = exp(-D(i,j) - PD(i,j))  ;
    end
end



end