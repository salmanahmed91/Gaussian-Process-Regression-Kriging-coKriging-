function gprKrig = initKrig(gprKrig,X,Xtest,Y,Ytest,lbX,ubX,RcorrType)

    gprKrig.X         = X;
    gprKrig.Xtest     = Xtest;
    gprKrig.Y         = Y;
    gprKrig.Ytest     = Ytest;
    gprKrig.lbX       = lbX;
    gprKrig.ubX       = ubX;
        
    gprKrig.RcorrType = RcorrType;
end