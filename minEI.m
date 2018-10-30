function [maxEI_, xMaxEI] = minEI(yMax,mdl_coKrig)


%% -----------------Optimization EI function--------------------------
nvars =  size(mdl_coKrig.X,2) ;
A = [];
b = [];
Aeq = [];
beq = [];
nPop = 50;
MaxIt = 20;
intCon = [];

lb = [mdl_coKrig.lbX];      % Lower Bound of Variables
ub = [mdl_coKrig.ubX]; 

fun = @(x)EI(yMax,x,mdl_coKrig);
%%Optimize
[xMaxEI, maxEI_] = gaYarpiz(fun,nvars,lb,ub,MaxIt,nPop,intCon);

end
