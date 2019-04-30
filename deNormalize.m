function Xn = deNormalize(X,lbX,ubX)

Xn = X.*(ubX-lbX) + lbX ;