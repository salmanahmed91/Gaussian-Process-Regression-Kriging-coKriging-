function [maxEI_, xMaxEI] = maxProdEI(yMin,yMax,mdl_coKrig)


%% -----------------Optimization EI function--------------------------
nvars =  size(mdl_coKrig.X,2) ;
A = [];
b = [];
Aeq = [];
beq = [];
nPop = 5000;
MaxIt = 20;
intCon = [];

lb = [mdl_coKrig.lbX];      % Lower Bound of Variables
ub = [mdl_coKrig.ubX]; 

fun = @(x)-(EI(yMin,x,mdl_coKrig,'min')).*EI(yMax,x,mdl_coKrig,'max');
%%Optimize
[xMaxEI, maxEI_] = gaYarpiz(fun,nvars,lb,ub,MaxIt,nPop,intCon);

end
