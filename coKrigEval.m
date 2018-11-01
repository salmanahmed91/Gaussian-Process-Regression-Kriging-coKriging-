function [fSUR, sigma] = coKrigEval(xNew,gpr_model_HF)

gpr_model_LF = gpr_model_HF.gpr_mdl_2D;


thetaC_PcOPT = gpr_model_LF.theta_P;
x1c       = gpr_model_LF.X;
YC_C      = gpr_model_LF.Y;

thetaE_PeOPT = gpr_model_HF.theta_P;
rhoOPT    = gpr_model_HF.rho;
x1e       = gpr_model_HF.X;
YE_E      = gpr_model_HF.Y;
RcorrType = gpr_model_HF.RcorrType;

%[YC_E, RMSE_YC_E] = gpr_model_LF.krigEval(x1e); 

muC      = gpr_model_LF.muC;
sigma2C   = gpr_model_LF.sigma2C;
Rc_CC   = gpr_model_LF.Rc_CC;

muE    = gpr_model_HF.muE;
sigma2E = gpr_model_HF.sigma2E;

Re_EE  = gpr_model_HF.Re_EE;
Rc_CE  = gpr_model_HF.Rc_CE;
Rc_EC  = gpr_model_HF.Rc_EC;
Rc_EE  = gpr_model_HF.Rc_EE;

%[muC, sigmaC, Rc_CC] = muSigmaR(thetaCOPT,Pc,x1c,YC_C);
%[muE, sigmaE, Re_EE] = muSigmaR(thetaEOPT,Pe,x1e,YE_E-rhoOPT.*YC_E);

%[Rc_CE] = Rcorr(thetaCOPT,Pc,x1c,x1e);
%[Rc_EC] = Rcorr(thetaCOPT,Pc,x1e,x1c);
%[Rc_EE] = Rcorr(thetaCOPT,Pc,x1e,x1e);

C = [sigma2C*Rc_CC           rhoOPT*sigma2C*Rc_CE ;
     rhoOPT*sigma2C*Rc_EC    rhoOPT^2*sigma2C*Rc_EE + sigma2E*Re_EE];

Y = [YC_C;YE_E]; 
oneVCT = ones(size(Y,1),1);
muFINAL = (oneVCT'*(C\Y))/(oneVCT'*(C\oneVCT));

fSUR    = zeros(size(xNew,1),1);
sigma = zeros(size(xNew,1),1);


for i = 1:size(xNew,1)

Rc_Ci = Rcorr(thetaC_PcOPT,x1c,xNew(i,:),RcorrType);
Rc_Ei = Rcorr(thetaC_PcOPT,x1e,xNew(i,:),RcorrType);
Re_Ei = Rcorr(thetaE_PeOPT,x1e,xNew(i,:),RcorrType);

c = [rhoOPT*sigma2C*Rc_Ci ; 
     rhoOPT^2*sigma2C*Rc_Ei  +  sigma2E*Re_Ei];

%  c = [rhoOPT*sigma2C*Rc_Ci ; 
%       (rhoOPT^2*sigma2C  +  sigma2E).*Re_Ei];

fSUR(i) = muFINAL + c'*(C\(Y - oneVCT*muFINAL));

sigma2 = rhoOPT^2*sigma2C + sigma2E - c'*(C\c) ;%(1 - oneVCT'*(C\c))/(oneVCT'*(C\oneVCT));
if(sigma2 < -0.1)
    sigma2 = 0;
end
sigma(i) = sqrt(sigma2);
if (imag(sigma(i)) < -1e-3)
    sigma(i) = real(sigma(i));
end
if (~isreal(sigma(i)))
    sigma(i) = real(sigma(i));
end


end

end