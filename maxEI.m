function [maxEI_, xMaxEI] = maxEI(yminMax,mdl,maxmin)


%% -----------------Optimization EI function--------------------------
nvars =  size(mdl.X,2) ;
A = [];
b = [];
Aeq = [];
beq = [];
nPop = 50;
MaxIt = 20;
intCon = [];

lb = [mdl.lbX];      % Lower Bound of Variables
ub = [mdl.ubX]; 

fun = @(x)-EI(yminMax,x,mdl,maxmin);
%%Optimize
[xMaxEI, maxEI_] = gaYarpiz(fun,nvars,lb,ub,MaxIt,nPop,intCon);

end
