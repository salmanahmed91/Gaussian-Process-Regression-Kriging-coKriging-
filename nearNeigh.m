function xNear = nearNeigh(x,X)

n = size(X,1);
dist = zeros(n,1);

for i = 1: n
    dist(i,1) = sum((x-X(i,:)).^2);
end

[minDist ,IndxNear]  = min(dist);
xNear = X(IndxNear,:);
end
    