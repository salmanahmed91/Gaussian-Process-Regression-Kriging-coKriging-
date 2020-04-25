function [R] = Rcorr(theta_P,X1,X2,varargin)
%%varargin has the following form
% RcorrType = varargin(1)

if(isempty(varargin)) % For older codes and gpr_mdls

R = Rcorr_GAUSS(theta_P,X1,X2);
%R = Rcorr_GAUSS_PER(theta_P,X1,X2);
%R = Rcorr_GEK(theta_P,X1,X2);

else % for newer codes and models
    RcorrType = varargin{1};
    
    switch RcorrType
        case 1
        R = Rcorr_GAUSS(theta_P,X1,X2);
        case 2
        R = Rcorr_GAUSS_PER(theta_P,X1,X2);
        case 3
        R = Rcorr_GEK(theta_P,X1,X2);
        case 4
        R = Rcorr_GAUSS_SYM(theta_P,X1,X2);
        case 5
        R = Rcorr_PER(theta_P,X1,X2); 
        case 11
        R = Rcorr_GAUSS2(theta_P,X1,X2);
    end
end
    
end