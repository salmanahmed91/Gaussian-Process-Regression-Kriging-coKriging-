function [J,distinct_d] = jd(X,p)
%computers the distances between all pairs of points in a sampling 
%plan X using p norm, sorts in ascending order and removes
% multiple occurances

%  Inputs:
%     X - sampling plan
%     p - distance norm
%     
%  Outputs:
%     J - the number of pairs separated by distance di
%     distinct_d - list of distinct distance values
%    

%number of sample points
n = size(X,1);

%Compute the distances between all pairs
d = zeros(n*(n-1)/2,1);

for i = 1:n-1
    for j = i+1:n
        %Distance metric: p-norm
        d((i-1)*n-(i-1)*i/2+j-i,1) = norm(X(i,:)-X(j,:),p);
    end
end

%Remove multiple occurances
distinct_d = unique(d);

%generte multiplicity array
J = zeros(size(distinct_d));
for i=1:length(distinct_d)
    J(i) = sum(ismember(d,distinct_d(i)));
end
end