clc;
clear all;
close all;



%% Script to generate data and response
%fn = @(x1,x2) [1 + (x1 + x2 + 1).^2.*(19 - 14*x1 + 3*x1.^2 - 14*x2 + 6*x1.*x2 + 3*x2.^2)]...
%                .*[30 + (2*x1-3*x2).^2.*(18-32*x1+12*x1.^2+48*x2-36*x1.*x2+27*x2.^2)];

YE_fn = @(x) (6.*x-2).^2.*sin(12.*x-4);
YC_fn = @(x) 0.5.*YE_fn(x)+10.*(x-0.5)-5;
XC = [0 0:0.1:1 1]'; % Define x values where the function is sampled prior.
XE = [0 0 0.4 0.6 1 1]';%We added additional 0 and 1 to use them as test value to work with code.
%if you use LHS to generate random values of X, don't bother adding the
%extra 0 and 1. 
RESP_YC = YC_fn(XC); % Calculate the response vector at known sample points. 
RESP_YE = YE_fn(XE);% Replace this part with data from your FEM or heavy simulation

%% Insering my own data (You can comment this part and run the code)
% load('Data\lP31_FTX_det_3D');
% load('Data\lP31_FTX_det_2D');
% nC = 7;
% x = [0:1/32:1-1/32]';
% indXC = [1 1:1:32 32]';
% indXE = [1 1:1:32 32]';
% 
% XC = (indXC-1)/32;
% XE = (indXE-1)/32;
% 
% RESP_YC = lP31_FTX_det_2D(indXC,nC);
% RESP_YE = lP31_FTX_det_3D(indXE,nC);

%%  
% Define the correlation function
% 1 : Gaussian
% 11: Gaussian squared
% 2 : Gaussian x Periodic
% 3 : GEK
% 4 : Gaussian symmertic
% 5 : Periodic
RcorrType = 11;
nPop = 1000;
MaxIt = 50;

minParam = [0]; %Define your lower and upper limits
maxParam = [1];
xcAll = normalizeX(XC,minParam,maxParam);
xeAll = normalizeX(XE,minParam,maxParam);
ycAll = RESP_YC;
yeAll = RESP_YE;
[ncCase, nParam] = size(xcAll);
[neCase, nParam] = size(xeAll);

ncTest   = 2;% Choose how many samples you want to use for validation. These
neTest   = 2;%will not be used in surrogate contruction.
ncSmpl = ncCase - ncTest;
neSmpl = neCase - neTest;
if (not(exist('index.mat'))) %if you change the samples, you need to delete the index.mat before running this code
        [index.indcTest, index.indcSmpl] = smplSel(xcAll,ncTest);
        [index.indeTest, index.indeSmpl] = smplSel(xeAll,neTest);
        save index.mat index;
end
load('index.mat');
indcTest = index.indcTest;
indcSmpl = index.indcSmpl;
indeTest = index.indeTest;
indeSmpl = index.indeSmpl;

xcSmpl     = xcAll(indcSmpl,:); %LF samples for surrogate construction
xcTest     = xcAll(indcTest,:); %LF test samples for cross validation
ycSmpl     = ycAll(indcSmpl,:); %LF response for surrogate construction
ycTest     = ycAll(indcTest,:); %LF response for cross validation

xeSmpl     = xeAll(indeSmpl,:); %HF samples for surrogate construction
xeTest     = xeAll(indeTest,:); %HF test samples for cross validation
yeSmpl     = yeAll(indeSmpl,:); %HF response for surrogate construction
yeTest     = yeAll(indeTest,:); %HF response for cross validation

%Up intil here, all the samples were arranged. 
%% fit_krig(X,y,xTest,yTest,RcorrType,nPop,MaxIt)
gpr_krig = fit_krig(xcSmpl,ycSmpl,xcTest,ycTest,RcorrType,nPop,MaxIt);
gpr_krigYE = fit_krig(xeSmpl,yeSmpl,xeTest,yeTest,RcorrType,nPop,MaxIt);
%% Plotting the paramter trends
rsb = 1; % the index for subplot. rsb :rows, csb:colums
csb = 1;
effectType = 'LIN' ; % other can be 'RAND'
predictorStr = {'x'};
nXnew = 500;
gpr_krig.paramEffects(rsb,csb,effectType,predictorStr,nXnew)
gpr_krigYE.paramEffects(rsb,csb,effectType,predictorStr,nXnew)


%% cokriging predictor calculation
gpr_cokrig = fit_cokrig(gpr_krig,xeSmpl,yeSmpl,xeTest,yeTest,RcorrType,5000,MaxIt);
%Plotting the paramter trends
rsb = 1; % the index for subplot. rsb :rows, csb:colums
csb = 1;
effectType = 'LIN' ; % other can be 'RAND'
predictorStr = {'x'};
nXnew = 500;
gpr_cokrig.paramEffects(rsb,csb,effectType,predictorStr,nXnew)



save('gpr_krigYE.mat','gpr_krigYE')
save('gpr_krig.mat','gpr_krig')