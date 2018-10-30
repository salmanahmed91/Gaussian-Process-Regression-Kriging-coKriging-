classdef gpr_mdl_Krig < handle
    properties
    theta_P     = [];
    X         = [];
    Xtest     = [];
    Y         = [];
    Ytest     = [];
    muC       = [];
    sigma2C   = [];
    Rc_CC     = [];
    lbX       = [];
    ubX       = [];
    RcorrType = [];
    end
    
    methods
        function [YC_xNew, RMSE_YC_xNew] = Eval(obj,xNew)
            [YC_xNew, RMSE_YC_xNew] = KrigEval(xNew, obj); 
        end
        
        function crossValidate(obj)
            x1cTest = obj.Xtest;
            YC_CTest   = obj.Ytest;
            
            [YC_xNew, RMSE_YC_xNew] = obj.Eval(x1cTest); 
            figure(199)
            plot(YC_xNew,YC_CTest...
            ,'o','linewidth',2),xlabel('Prediction'),ylabel('Actual'),shg,grid on
            figure(201)
            plot(RMSE_YC_xNew,...
            'o','linewidth',2),xlabel('test points'),ylabel('Standard Error ($\sigma$)'),grid on,

            SCVR = ([YC_CTest] - YC_xNew )./RMSE_YC_xNew;
            figure(203)
            plot(YC_xNew,SCVR...
            ,'o','linewidth',2),xlabel('Prediction'),ylabel('Standard residual [$\sigma$]'),grid on,
        end
        
        
        
        function paramEffects(obj,rsb,csb,effectType,predictorStr,numXnew)
                lb_X = obj.lbX;
                ub_X = obj.ubX;
                fix_X = (ub_X + lb_X)./2;
                nX = length(lb_X);
                                                   
                for k = 1:nX
                    sweepx = [lb_X(k):(ub_X(k)-lb_X(k))/1000:ub_X(k)]' ;
                    if(nX == 1)
                        xNewFixPrt = [sweepx];
                    else
                        if (nX  > 1)
                        xNewFixPrt = [repmat(fix_X(1:k-1),length(sweepx),1) sweepx repmat(fix_X(k+1:nX),length(sweepx),1)];
                        end
                    end
                    
                    switch effectType
                        case 'LIN'
                            xNew = xNewFixPrt;
                        case 'RAND'
                            xNew =  [x1c ; lb_X + (ub_X-lb_X).*rand(numXnew,nX)];
                    end
                    
                    [YC_xNew, RMSE_YC_xNew] = obj.Eval(xNew);
                    
                    figure(1999)
                     plot(RMSE_YC_xNew,...
                     'o','linewidth',2),xlabel('test points'),ylabel('Standard Error ($\sigma$)'),grid on,
                    
                    figure(1989)
                    subplot(rsb,csb,k),plot(xNew(:,k),YC_xNew,'linewidth',2),hold all;
                    %subplot(1,1,k),plot(x1c,YC(x1c),'o','linewidth',2);hold all;
                    %subplot(1,1,k),plot([x1cTest;x1eTest],YC([x1cTest;x1eTest]),'x','linewidth',4);hold all;
                    subplot(rsb,csb,k),plot(xNew(:,k),YC_xNew + 2.*RMSE_YC_xNew,'--','linewidth',2),hold all;
                    subplot(rsb,csb,k),plot(xNew(:,k),YC_xNew - 2.*RMSE_YC_xNew,'--','linewidth',2),hold all;
                    xlabel(strcat('$',predictorStr(k),'$')),ylabel('Response'),shg,grid on,
               end
                legend('show'),legend('GP yc','GP yc+$2\sigma$','GP yc-$2\sigma$','northeastoutside');
           
        end
    end
    
end




