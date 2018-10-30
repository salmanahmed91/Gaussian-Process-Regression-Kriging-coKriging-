function [indXe, indXrem] = smplSel(X,numXe)

indXs = combnk(1:size(X,1),numXe);
%indXs = randi(size(X,1),size(X,1)*10000,numXe);
% indXs = zeros(size(X,1)*10000,numXe);
% for i = 1:size(indXs,1)
%     indXs(i,:) = randperm(size(X,1),numXe);
% end

minDs = zeros(size(indXs,1),1);
for s = 1:size(indXs,1)
    Xs = X(indXs(s,:),:);

n = size(Xs,1);
k = size(Xs,2);
SSUM = 0;
XCnumXe = size(combnk(Xs(:,1),2),1);
D.dist = zeros(XCnumXe,1);
D.i    = zeros(XCnumXe,1);
D.j    = zeros(XCnumXe,1);
l = 1;
for i = 1:n-1
    for j = i+1:n
     for h = 1:k
         SSUM = SSUM + (Xs(i,h)-Xs(j,h))^2;
     end
     D.dist(l,1) = sqrt(SSUM);
     D.i(l,1) = i;
     D.j(l,1) = j;
     
     if(l == 1)
        minDs(s,1) = D.dist(l,1);
     else
         if(D.dist(l,1) <= minDs(s,1))
            minDs(s,1) = D.dist(l,1);
         end
     end
     
     
     
     SSUM = 0;
 %    disp(['D = ', num2str(D.dist(l,1)'),' ',num2str(D.i(l,1)),' ',num2str(D.j(l,1))])
    l = l+1;
    end
end

%minDs(s,1) = min(D.dist);

end

%% Evaluate the max of min distance

[maxMinDist, maxMinInd] = max(minDs);
indXe = sort(indXs(maxMinInd,:),'ascend');
indXrem = setdiff(1:size(X,1),indXe);


