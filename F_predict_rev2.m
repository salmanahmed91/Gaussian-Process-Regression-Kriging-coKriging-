function [ Ynew , Xnew] = F_predict_rev2( Xi,Yi,beta )
%F_PREDICT Summary of this function goes here
%   Detailed explanation goes here

Xnew = zeros(length(Xi)*length(Yi),2);
Ynew = zeros(length(Xi),length(Yi));

k = 1;
for i = 1:length(Xi);
    for j = 1:length(Yi)
        Xnew(k,:) = [Xi(i) Yi(j)];
        k = k +1;
    end
end




X1 = [ones(size(Xnew,1),1) Xnew];
XX = [Xnew(:,1).*Xnew(:,2)];
X2 = [Xnew(:,1).^2 Xnew(:,2).^2];

X = [X1 XX X2];

Y = X*beta;

k = 1;
for i = 1:length(Xi);
    for j = 1:length(Yi)
        Ynew(i,j) = Y(k,1);
        k = k +1;
    end
end


end

