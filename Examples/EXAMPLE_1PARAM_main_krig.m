clc;
clear all;
close all;

%% Load the data
load('lC121_RESP_2D');
load('lC121');
nResp = 2;

minParam = [13];
maxParam = [15];
xAll = normalizeX(lC121,minParam,maxParam);
yAll = lC121_RESP_2D(:,nResp);
[nCase, nParam] = size(xAll);


nTest   = 4;
nSmpl = nCase - nTest;
if (not(exist('index.mat')))
        [index.indTest, index.indSmpl] = smplSel(xAll,nTest);
        save index.mat index;
end
load('index.mat');
indTest = index.indTest;
indSmpl = index.indSmpl;

xSmpl     = xAll(indSmpl,:);
xTest     = xAll(indTest,:);
ySmpl     = yAll(indSmpl,:);
yTest     = yAll(indTest,:);

gpr_krig = fit_krig(xSmpl,ySmpl,xTest,yTest,11,5000,100);

%% Plotting the paramter trends
rsb = 1; % the index for subplot. rsb :rows, csb:colums
csb = 1;
effectType = 'LIN' ; % other can be 'RAND'
predictorStr = {'l_{C1}'};
nXnew = 500;
gpr_krig.paramEffects(rsb,csb,effectType,predictorStr,nXnew)