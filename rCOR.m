function r = rCOR(theta,P,X,y,xnew);

k = size(theta,1);
n = size(X,1);

R = zeros(n,1);
D = zeros(n,n);

%% Calculating the correlation matrix R
for i = 1:n
    
        for h = 1:k
        D(i,1) = D(i,1) + theta(h).* abs( X(i,h) - xnew(1,h) ).^P(h);
        end
        R(i,1) = exp(-D(i,1));
    
end

r = R;

end