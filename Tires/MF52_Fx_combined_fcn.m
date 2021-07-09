function FX= MF52_Fx_combined_fcn(A,X)

global FZ0 LFZO LCX LMUX LEX LKX  LHX LVX LCY LMUY LEY LKY LHY LVY ...
       LGAY LGAX LTR LRES LGAZ LXAL LYKA LVYKA LS LSGKP  LSGAL LGYR KY D_final
   
ALPHA = X(:,4).*pi./180;
FZ = abs(X(:,2));
GAMMA = X(:,3).*(pi./180);
KAPPA = X(:,1);

GAMMAX = GAMMA.*LGAX;
FZ0PR = FZ0  .*  LFZO; %15,  NEED LFZO NOT LFZ0 TO MATCH TIRE PROP FILE
DFZ = (FZ-FZ0PR) ./ FZ0PR;

%%--CombinedSlip Coeff--%%
RBX1				= A(1);
RBX2				= A(2);
RCX1				= A(3);
REX1				= A(4);
REX2				= A(5);
RHX1				= A(6);


FX0     = MF52_Fx_fcn(D_final,X);% get pure slip fx from other function after fitting pure long. data
SHXA    = RHX1;
EXA     = REX1 + REX2.*DFZ;
CXA     = RCX1;
BXA     = RBX1.*cos(atan(RBX2.*KAPPA)).*LXAL; 
DXA     = FX0./(cos(CXA.*atan(BXA.*SHXA - EXA.*(BXA.*SHXA - atan(BXA.*SHXA)))));
ALPHAS  = ALPHA + SHXA;
FX = DXA.*cos(CXA.*atan(BXA.*ALPHAS - EXA.*(BXA.*ALPHAS - atan(BXA.*ALPHAS))));
end





