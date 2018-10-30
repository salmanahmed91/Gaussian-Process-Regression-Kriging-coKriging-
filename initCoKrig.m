function gprCoKrig = initCoKrig(gprCoKrig,X,Xtest,Y,Ytest,lbX,ubX,gprKrig,RcorrType)

    gprCoKrig.X         = X;
    gprCoKrig.Xtest     = Xtest;
    gprCoKrig.Y         = Y;
    gprCoKrig.Ytest     = Ytest;
    gprCoKrig.lbX       = lbX;
    gprCoKrig.ubX       = ubX;
    gprCoKrig.gpr_mdl_2D = gprKrig;
    
    gprCoKrig.RcorrType = RcorrType;
end