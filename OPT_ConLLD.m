function [gpr_mdl_SUR, gpr_mdl_ERROR] = OPT_ConLLD(YC_E,gpr_mdl_SUR,gpr_mdl_2D,nvars,lb,ub,MaxIt,nPop,intCon)

x1e       = gpr_mdl_SUR.X;
YE_E      = gpr_mdl_SUR.Y;
x1eTest   = gpr_mdl_SUR.Xtest;
YE_ETest  = gpr_mdl_SUR.Ytest;
RcorrType = gpr_mdl_SUR.RcorrType;

fun = @(thetaE_Pe_rho)ConLLD(thetaE_Pe_rho,x1e,YE_E,YC_E,RcorrType);

gaoptions = optimoptions('ga','Display','iter','PopulationSize',nPop,...
                      'MaxGenerations',MaxIt,...
                      'PlotFcn',{@gaplotbestf @gaplotbestindiv});
%%Optimize
%[thetaE_Pe_rhoOPT, fval] = ga(fun,nvars,[],[],[],[],lb,ub,[],[],gaoptions)
[thetaE_Pe_rhoOPT, fval] = gaYarpiz(fun,nvars,lb,ub,MaxIt,nPop,intCon);


nth = length(thetaE_Pe_rhoOPT);
rhoOPT    = thetaE_Pe_rhoOPT(nth);

[muE, sigma2E, Re_EE] = muSigmaR(thetaE_Pe_rhoOPT(1:end-1),x1e,YE_E-rhoOPT.*YC_E,RcorrType);


thetaC_POPT = gpr_mdl_2D.theta_P;
x1c       = gpr_mdl_2D.X;
YC_C      = gpr_mdl_2D.Y;
muC       = gpr_mdl_2D.muC;
sigma2C   = gpr_mdl_2D.sigma2C;
Rc_CC     = gpr_mdl_2D.Rc_CC;

[Rc_CE] = Rcorr(thetaC_POPT,x1c,x1e,RcorrType);
[Rc_EC] = Rcorr(thetaC_POPT,x1e,x1c,RcorrType);
[Rc_EE] = Rcorr(thetaC_POPT,x1e,x1e,RcorrType);

gpr_mdl_SUR.theta_P = thetaE_Pe_rhoOPT(1:end-1);
gpr_mdl_SUR.rho  =  rhoOPT;
gpr_mdl_SUR.muE = muE;
gpr_mdl_SUR.sigma2E = sigma2E;


gpr_mdl_SUR.Re_EE = Re_EE;
gpr_mdl_SUR.Rc_CE = Rc_CE;
gpr_mdl_SUR.Rc_EC = Rc_EC;
gpr_mdl_SUR.Rc_EE = Rc_EE;


gpr_mdl_ERROR = gpr_mdl_Krig;
gpr_mdl_ERROR.theta_P = thetaE_Pe_rhoOPT(1:end-1);
gpr_mdl_ERROR.X   =  x1e;
gpr_mdl_ERROR.Y   =  YE_E-rhoOPT.*YC_E; 
gpr_mdl_ERROR.Xtest = x1eTest;
gpr_mdl_ERROR.Ytest = YE_ETest;
gpr_mdl_ERROR.muC = muE;
gpr_mdl_ERROR.sigma2C = sigma2E;
gpr_mdl_ERROR.Rc_CC     = Re_EE;
gpr_mdl_ERROR.RcorrType = RcorrType;
