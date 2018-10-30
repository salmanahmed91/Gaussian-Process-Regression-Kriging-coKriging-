function gpr_mdl_2D = OPT_ConLL(gpr_mdl_2D,nvars,lb,ub,MaxIt,nPop,intCon)
%% Initialize the data from GPR model
x1c = gpr_mdl_2D.X;
YC_C = gpr_mdl_2D.Y;
RcorrType = gpr_mdl_2D.RcorrType;
%% -----------------Optimization of log-likehood for low fidelity--------------------------
fun = @(theta_Pc)ConLL(theta_Pc,x1c,YC_C,RcorrType);

A = [];
b = [];
Aeq = [];
beq = [];
%%Set the options
gaoptions = optimoptions('ga','Display','iter','PopulationSize',nPop,...
                      'MaxGenerations',MaxIt,...
                      'PlotFcn',@gaplotbestf);
%%Optimize
%[thetaC_PcOPT, fval] = ga(fun,nvars,A,b,Aeq,beq,lb,ub,[],[3],gaoptions)
[thetaC_PcOPT, fval] = gaYarpiz(fun,nvars,lb,ub,MaxIt,nPop,intCon);

[muC, sigma2C, Rc_CC] = muSigmaR(thetaC_PcOPT,x1c,YC_C,RcorrType);


gpr_mdl_2D.theta_P   = thetaC_PcOPT;
gpr_mdl_2D.muC       = muC;
gpr_mdl_2D.sigma2C   = sigma2C;
gpr_mdl_2D.Rc_CC     = Rc_CC;

end
