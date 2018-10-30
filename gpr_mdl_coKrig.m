classdef gpr_mdl_coKrig < handle
    properties
    theta_P     = [];
    rho       = [];
    X         = [];
    Xtest     = [];
    Y         = [];
    Ytest     = [];
    muE       = [];
    sigma2E   = [];
    Re_EE     = [];
    Rc_CE     = [];
    Rc_EC     = [];
    Rc_EE     = [];
    
    lbX       = [];
    ubX       = [];
    gpr_mdl_2D = gpr_mdl_Krig;
    RcorrType  = [];
    end
    
      
    methods
        function [YE_xNew, RMSE_YE_xNew] = Eval(obj,xNew)
            [YE_xNew, RMSE_YE_xNew] = coKrigEval(xNew,[obj]); 
        end
        
        function crossValidate(obj)
            x1eTest = obj.Xtest;
            YE_ETest   = obj.Ytest;
            
            [YE_xNew, RMSE_YE_xNew] = obj.Eval(x1eTest); 
            [YC_xNew, RMSE_YC_xNew] = obj.gpr_mdl_2D.Eval(x1eTest);
            figure(399)
            plot(YE_xNew,YE_ETest...
            ,'o','linewidth',2),xlabel('Prediction'),ylabel('Actual'),shg,grid on,hold all;
            plot(YC_xNew,YE_ETest...
            ,'x','linewidth',2),xlabel('Prediction'),ylabel('Actual'),shg,grid on,legend('show'),legend('GP ye','GP yc')
            figure(398)
            plot(RMSE_YE_xNew,...
            'o','linewidth',2),xlabel('test points'),ylabel('Standard Error ($\sigma$)'),grid on,

            SCVR = ([YE_ETest] - YE_xNew )./RMSE_YE_xNew;
            figure(397)
            plot(YE_xNew,SCVR...
            ,'o','linewidth',2),xlabel('Prediction'),ylabel('Standard residual [$\sigma$]'),grid on,
        end
        
               
        function paramEffects(obj,rsb,csb,effectType,predictorStr,numXnew)
                lb_X = obj.lbX;
                ub_X = obj.ubX;
                fix_X = (ub_X + lb_X)./2;
                nX = length(lb_X);
                titleStr = '';
                                                   
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
                            xNew =  [lb_X + (ub_X-lb_X).*rand(numXnew,nX)];
                    end
                    
                    [YE_xNew, RMSE_YE_xNew] = obj.Eval(xNew);
                    gpr_mdl_2D = obj.gpr_mdl_2D;
                    [YC_xNew, RMSE_YC_xNew] = gpr_mdl_2D.Eval(xNew);
                    
                    figure(394)
                     plot(RMSE_YE_xNew,...
                     'o','linewidth',2),xlabel('test points'),ylabel('Standard Error ($\sigma$)'),grid on,
                    
                    figure(395);hold all
                    subplot(rsb,csb,k),plot(xNew(:,k),YE_xNew,'linewidth',2),hold all;
                    subplot(rsb,csb,k),plot(xNew(:,k),YC_xNew,'linewidth',2),hold all;
                    %subplot(1,1,k),plot(x1c,YC(x1c),'o','linewidth',2);hold all;
                    %subplot(1,1,k),plot([x1cTest;x1eTest],YC([x1cTest;x1eTest]),'x','linewidth',4);hold all;
                    subplot(rsb,csb,k),plot(xNew(:,k),YE_xNew + 2.*RMSE_YE_xNew,'--','linewidth',2),hold all;
                    subplot(rsb,csb,k),plot(xNew(:,k),YE_xNew - 2.*RMSE_YE_xNew,'--','linewidth',2),hold all;
                    xlabel(strcat('$',predictorStr(k),'$')),ylabel('Response'),shg,grid on,
                    titleStr = [ titleStr (strcat('$',predictorStr(k),' = ',num2str(fix_X(k)),'$'))];
                end
                title(titleStr);
                
                legend('show'),legend('GP ye','GP yc','GP ye+$2\sigma$','GP ye-$2\sigma$','location','northeastoutside');
           
        end
    end
    
    
    
    
end




