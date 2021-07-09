function FY= MF52_Fy_combined_fcn(A,X)

global FZ0 LFZO LCX LMUX LEX LKX  LHX LVX LCY LMUY LEY LKY LHY LVY ...
       LGAY LTR LRES LGAZ LXAL LYKA LVYKA LS LSGKP  LSGAL LGYR KY A_final
   
   

ALPHA = X(:,1).*pi./180;
FZ = abs(X(:,2));
GAMMA = X(:,3).*(pi./180);
K = X(:,4);

GAMMAY = GAMMA.*LGAY;
FZ0PR = FZ0  .*  LFZO; %15,  NEED LFZO NOT LFZ0 TO MATCH TIRE PROP FILE
DFZ = (FZ-FZ0PR) ./ FZ0PR;

%%--CombinedSlip Coeff--%%
RBY1				= A(1);
RBY2				= A(2);
RBY3				= A(3);
RCY1				= A(4);
REY1				= A(5);
REY2				= A(6);
RHY1				= A(7);
RHY2				= A(8);
RVY1				= A(9);
RVY2				= A(10);
RVY3				= A(11);
RVY4				= A(12);
RVY5				= A(13);
RVY6				= A(14);
% PTY1				= A(15);
% PTY2				= A(16);


FY0 = MF52_Fy_fcn(A_final,X); %% get pure slip fy from other function after fitting pure slip data
SHYK=RHY1+(RHY2.*DFZ);
KS = K + SHYK;
BYK=RBY1.*cos(atan(RBY2.*(ALPHA-RBY3))).*LYKA;
CYK=RCY1;
EYK=REY1+(REY2.*DFZ);
DYK=(FY0)./(cos(CYK.*atan((BYK.*SHYK)-(EYK.*((BYK.*SHYK)-atan(BYK.*SHYK))))));
MUY=(A_final(2)+A_final(3).*DFZ).*(1-A_final(4).*GAMMAY.^2).*LMUY;
DVYK=MUY.*FZ.*(RVY1+(RVY2.*DFZ)+(RVY3.*GAMMA)).*cos(atan(RVY4.*ALPHA));
SVYK=DVYK.*sin(RVY5.*atan(RVY6.*K)).*LVYKA;

FY = DYK .* cos((CYK .* atan(BYK.*KS - EYK.*(BYK.*KS - atan(BYK.*KS))))) + SVYK;
end





