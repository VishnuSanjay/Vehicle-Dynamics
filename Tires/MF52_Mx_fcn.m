function MX = MF52_Mx_fcn(C,X);

global FZ0 R0

global  PCY1 PDY1 PDY2 PDY3 ...
        PEY1 PEY2 PEY3 PEY4  ... 
        PKY1 PKY2 PKY3 ... 
        PHY1 PHY2 PHY3 ... 
        PVY1 PVY2 PVY3 PVY4;
        
global LFZO LCX LMUX LEX LKX  LHX LVX LCY LMUY LEY LKY LHY LVY ...
       LGAY LTR LRES LGAZ LXAL LYKA LVYKA LS LSGKP  LSGAL LGYR A_final
   
ALPHA  =  X(:,1)*pi/180;
FZ     =  abs(X(:,2));
GAMMA  =  X(:,3)*pi/180;

GAMMAY = GAMMA .* LGAY; %31 (%48 lgay=lg
FZ0PR  = FZ0  .*  LFZO; %15,  NEED LFZO NOT LFZ0 TO MATCH TIRE PROP FILE
DFZ    = (FZ-FZ0PR) ./ FZ0PR; %14,  (%30)

QSX1    = C(1);
QSX2    = C(2);
QSX3    = C(3);

FY = MF52_Fy_fcn(A_final,X);

MX = FZ.*R0.*(QSX1-QSX2.*GAMMA+QSX3.*FY./FZ0).*LMUX;      %84  SWIFT DOES NOT IMPLEMENT MX
