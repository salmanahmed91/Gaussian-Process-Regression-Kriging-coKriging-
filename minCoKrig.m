function [fval, xOPT] = minCoKrig(gpr_mdl,MaxIt,nPop,intCon)

fun = @(x)gpr_mdl.cokrigEval(x);
lbX = gpr_mdl.lbX;
ubX = gpr_mdl.ubX;
nvars = size(lbX,2);
%%Optimize
[xOPT, fval] = gaYarpiz(fun,nvars,lbX,ubX,MaxIt,nPop,intCon);