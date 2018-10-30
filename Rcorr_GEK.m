function [R] = Rcorr_GEK(theta_P,X1,X2)
%% This functaion calculates the correlation between the 
% points X1 and X2 based on the distance function
% nth = length(theta_P);
% theta = theta_P(1:nth - (nth)/2);
% P   = theta_P((nth)/2 + 1:nth);

%% testing section only
theta = theta_P(1,1);
%T1 = theta_P(1,3);
%T2 = theta_P(1,4);
%P  = theta_P(1,2);
P = 2;
%%


k = size(X1,2);
nX1 = size(X1,1);
nX2 = size(X2,1);

%% Calculating the correlation matrix R
if(nX2 ~= 1)
R = zeros(nX1*(k+1),nX2*(k+1));
dR1k = zeros(1,k);
dRk1 = zeros(k,1);
ddRkk = zeros(k,k);
D = zeros(nX1*(k+1),nX2*(k+1));
PD  = zeros(nX1*(k+1),nX2*(k+1));

%% Calculating the correlation matrix R

for i = 1:nX1
    for j = 1:nX2
        for h = 1:k
        D(i,j) = D(i,j) + theta(h).* abs( X1(i,h) - X2(j,h) ).^P(h);
%        PD(i,j) = PD(i,j) + 2.*(sin(T1*pi/1.*(X1(i,h)-X2(j,h)))).^2;% + 2.*(sin(T2*pi/1.*(X1(i,h)-X2(j,h)))).^2;
        end
        R(i,j) = exp(  -D(i,j)) ;%.* exp(   - PD(i,j)  );
%         R(i,j) = exp(  -D(i,j)    - T2*PD(i,j)  );
        
        for h = 1:k
            dR1k(1,h) =    R(i,j).*( theta(h) * P(h) * ( X1(i,h)-  X2(j,h))^(P(h)-1));
            dRk1(h,1) =   -R(i,j).*( theta(h) * P(h) * ( X1(i,h)-  X2(j,h))^(P(h)-1));
        end
        
        for h = 1:k
            for l=1:k
                
                if(h==l)
                ddRkk(h,l) = R(i,j)*( -theta(h)*theta(l)*P(h)*P(l)*...
                                     ( X1(i,h) - X2(j,h) )^(P(h)-1)*...
                                   ( X1(i,l) - X2(j,l) )^(P(l)-1) ...
                                   + 2*theta(h));
                 
                else
                ddRkk(h,l) = - R(i,j)* theta(h)*theta(l)*P(h)*P(l)*...
                                     ( X1(i,h) - X2(j,h) )^(P(h)-1)*...
                                   ( X1(i,l) - X2(j,l) )^(P(l)-1);
                end
            end
        end
        
        R(i,j+nX2+(j-1)*(k-1):j+nX2+(j-1)*(k-1)+k-1) = dR1k;
        R(i+nX1+(i-1)*(k-1):i+nX1+(i-1)*(k-1)+k-1,j) = dRk1;
        R(i+nX1+(i-1)*(k-1):i+nX1+(i-1)*(k-1)+k-1,j+nX2+(j-1)*(k-1):j+nX2+(j-1)*(k-1)+k-1) = ddRkk;
        
        
    end
end


else
   
R = zeros(nX1*(k+1),1);
dRk1 = zeros(k,1);
D = zeros(nX1*(k+1),1);
PD  = zeros(nX1*(k+1),1);

%% Calculating the correlation matrix R
for i = 1:nX1
    for j = 1:nX2
        for h = 1:k
        D(i,j) = D(i,j) + theta(h).* abs( X1(i,h) - X2(j,h) ).^P(h);
%        PD(i,j) = PD(i,j) + 2.*(sin(T1*pi/1.*(X1(i,h)-X2(j,h)))).^2;% + 2.*(sin(T2*pi/1.*(X1(i,h)-X2(j,h)))).^2;
        end
        R(i,j) = exp(  -D(i,j)) ;%.* exp(   - PD(i,j)  );
%         R(i,j) = exp(  -D(i,j)    - T2*PD(i,j)  );
        
        for h = 1:k
            dRk1(h,1) =   -R(i,j).*( theta(h) * P(h) * ( X1(i,h)-  X2(j,h))^(P(h)-1));
        end
      
        R(i+nX1+(i-1)*(k-1):i+nX1+(i-1)*(k-1)+k-1,j) = dRk1;
        
    end
end
end

end