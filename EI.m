function ei = EI(yminMax,x,mdl_coKrig,maxmin)


[yhat , RMSE] = mdl_coKrig.Eval(x);

if maxmin == 'min'
        u = yminMax - yhat ;
else
if maxmin == 'max'
        u = yhat - yminMax ;
end
end

A1 = u.* ( 1/2 + 1/2.*erf(1/sqrt(2).*u./RMSE));
A2 = RMSE.*1/sqrt(2*pi).*exp(-1/2.*u.^2./RMSE.^2);
ei = A1 + A2;

end