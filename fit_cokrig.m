function gpr_cokrig = fit_cokrig(gpr_krig,xeSmpl,yeSmpl,xeTest,yeTest,RcorrType,nPop,MaxIt)
YE_E = yeSmpl;
XE = xeSmpl;
 
[neCase ,nParam] = size(XE);


%% ------------------ initializing parameters----------------------
gpr_mdl    = gpr_mdl_coKrig;
gpr_mdl_rep = gpr_mdl;

lbX = zeros(1,nParam);
ubX = ones(1,nParam);

% Define the correlation function
% 1 : Gaussian
% 11: Gaussian squared
% 2 : Gaussian x Periodic
% 3 : GEK
% 4 : Gaussian symmertic
% 5 : Periodic

ntheta = nParam;
if RcorrType == 1
    nP = nParam;
else
    nP = 0;
end
intCon = [];

%Limits for hyperparamsfor cokrig mdl
%%Always set the bounds first at large values to see the trend, and then reduce it
lbTheta_P_rho = [1e-5.*ones(1,ntheta) 1.01.*ones(1,nP)   -10] ; % Lower Bound of theta 
ubTheta_P_rho = [1e3*ones(1,ntheta)    1.999.*ones(1,nP) 10]   ; % Upper bounds of theta


%% Script to assign data and response
YE_E = yeSmpl;
XE = xeSmpl;
YC_E = gpr_krig.Eval(XE);
XETest = xeTest;
YE_ETest = yeTest;





if (size(x1c,2)==1)
    figure(987),hold all;
    plot(gpr_krig.X,gpr_krig.Y,'-o','linewidth',2);
    plot(XE,YE_E,'-x','linewidth',2);
    plot(XE,YC_E,'-^','linewidth',2);
    grid on, box on,xlabel('Position along x-axis (x) [$\tau_P$]'),ylabel('Detent [N]'),
    legend('show'),lgnd = legend('2D model (LF)','3D model (HF)','sample YC_E');
end
    
gpr_mdl_rep   =  initCoKrig(gpr_mdl_rep,XE,XETest,YE_E,YE_ETest,lbX,ubX,gpr_krig,RcorrType);

%% -----------------Optimization of log-likehood for d = ye - rho*yc--------------------------
nvars =  ntheta + nP + 1;
A = [];
b = [];
Aeq = [];
beq = [];
nPop = nPop;
MaxIt = MaxIt;

lb = [lbTheta_P_rho];      % Lower Bound of hyperparameters
ub = [ubTheta_P_rho];  % Upper bound of hyper-parameters

[gpr_cokrig, gpr_mdl_ERROR]= OPT_ConLLD(YC_E,gpr_mdl_rep,gpr_krig,nvars,lb,ub,MaxIt,nPop,intCon);







