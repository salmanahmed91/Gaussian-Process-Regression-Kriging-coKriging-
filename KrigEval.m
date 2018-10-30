function [fSUR, sigma] = KrigEval(xNew,gpr_model)



thetaC_PcOPT = gpr_model.theta_P;
x1c       = gpr_model.X;
YC_C      = gpr_model.Y;
muC       = gpr_model.muC;
sigma2C   = gpr_model.sigma2C;
Rc_CC     = gpr_model.Rc_CC;
RcorrType = gpr_model.RcorrType;

%[muC, sigma2C, Rc_CC] = muSigmaR(thetaCOPT,Pc,x1c,YC_C);

Y = [YC_C]; 
n = size(x1c,1);
k = size(x1c,2);

fSUR    = zeros(size(xNew,1),1);
sigma = zeros(size(xNew,1),1);
%oneVCT = ones(size(YC_C,1),1);
oneVCT = [ones(n,1)];

for i = 1:size(xNew,1)

Rc_Ci = Rcorr(thetaC_PcOPT,x1c,xNew(i,:),RcorrType);


fSUR(i) = muC + Rc_Ci'*((Rc_CC)\(Y - oneVCT*muC));
sigma(i) = sqrt(sigma2C*(1.00000001 - Rc_Ci'*((Rc_CC)\Rc_Ci) +...
                ((1 -  Rc_Ci'*((Rc_CC)\Rc_Ci))^2)...
                /(oneVCT'*((Rc_CC)\oneVCT))));

end

end