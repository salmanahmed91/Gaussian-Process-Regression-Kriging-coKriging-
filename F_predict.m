function [ Y ] = F_predict( Xnew,beta )
%F_PREDICT Summary of this function goes here
%   Detailed explanation goes here

X1 = [ones(size(Xnew,1),1) Xnew];
XX = [Xnew(:,1).*Xnew(:,2) Xnew(:,1).*Xnew(:,3) Xnew(:,1).*Xnew(:,4) Xnew(:,1).*Xnew(:,5) Xnew(:,1).*Xnew(:,6) Xnew(:,1).*Xnew(:,7) Xnew(:,2).*Xnew(:,3) Xnew(:,2).*Xnew(:,4) Xnew(:,2).*Xnew(:,5) Xnew(:,2).*Xnew(:,6) Xnew(:,2).*Xnew(:,7) Xnew(:,3).*Xnew(:,4) Xnew(:,3).*Xnew(:,5) Xnew(:,3).*Xnew(:,6) Xnew(:,3).*Xnew(:,7) Xnew(:,4).*Xnew(:,5) Xnew(:,4).*Xnew(:,6) Xnew(:,4).*Xnew(:,7) Xnew(:,5).*Xnew(:,6) Xnew(:,5).*Xnew(:,7) Xnew(:,6).*Xnew(:,7) ];
X2 = [Xnew(:,1).^2 Xnew(:,2).^2 Xnew(:,3).^2 Xnew(:,4).^2 Xnew(:,5).^2 Xnew(:,6).^2 Xnew(:,7).^2];

X = [X1 XX X2];

Y = X*beta;
end

