function Xn = normalizeX(X,lbX,ubX)
Xn = zeros(size(X,1),size(X,2));
for i = 1:size(X,1)
Xn(i,:) = (X(i,:) - lbX)./(ubX-lbX);
end