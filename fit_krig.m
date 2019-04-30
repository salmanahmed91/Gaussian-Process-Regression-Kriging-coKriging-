function gpr_mdl = fit_krig(X,y,xTest,yTest,RcorrType,nPop,MaxIt)

YC_C = y;
X1C = X;
[nCase ,nParam] = size(X);


%% ------------------ initializing parameters Checking----------------------
gpr_mdl    = gpr_mdl_Krig;
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

%Limits for hyperparamsfor krig mdl
%%Always set the bounds first at large values to see the trend, and then reduce it
lbTheta_P = [1e-5.*ones(1,ntheta) 1.01.*ones(1,nP)   ] ; % Lower Bound of theta 
ubTheta_P = [1e3*ones(1,ntheta)    1.999.*ones(1,nP) ]   ; % Upper bounds of theta


%% Script to assign data and response
x1c     = X;
x1cTest = xTest;
YC_C     = y; 
YC_CTest = yTest; 
gpr_mdl_rep   =  initKrig(gpr_mdl_rep,x1c,x1cTest,YC_C,YC_CTest,lbX,ubX,RcorrType);

%% -----------------Optimization of log-likehood for low fidelity--------------------------
nvars = ntheta +nP;
A = [];
b = [];
Aeq = [];
beq = [];
lb = [lbTheta_P];      % Lower Bound of Variables
ub = [ubTheta_P];      % Upper bounds

gpr_mdl_rep = OPT_ConLL(gpr_mdl_rep,nvars,lb,ub,MaxIt,nPop,intCon);


%% ----------------- Evaluation of low fidelity model---------------
gpr_mdl_rep.crossValidate;
