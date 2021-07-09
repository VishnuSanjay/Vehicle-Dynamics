function FX = MF52_Fx_fcn(A,X);

global FZ0 LFZO LCX LMUX LEX LKX  LHX LVX LCY LMUY LEY LKY LHY LVY ...
       LGAY LGAX LTR LRES LGAZ LXAL LYKA LVYKA LS LSGKP  LSGAL LGYR KY 
         

KAPPA  =  X(:,1);
FZ     =  abs(X(:,2));
GAMMA  =  X(:,3)*pi/180;
% ALPHA = X(:,4).*pi./180;

% FZ0 = mean(FZ);
GAMMAX = GAMMA .* LGAX; %31 (%48 lgay=lg
FZ0PR  = FZ0  .*  LFZO; %15,  NEED LFZO NOT LFZ0 TO MATCH TIRE PROP FILE
DFZ    = (FZ-FZ0PR) ./ FZ0PR; %14,  (%30)

PCX1    = A(1);
PDX1    = A(2);
PDX2    = A(3);
PDX3    = A(4);
PEX1    = A(5);
PEX2    = A(6);
PEX3    = A(7);
PEX4    = A(8);
PKX1    = A(9);
PKX2    = A(10);
PKX3    = A(11);
PHX1    = A(12);
PHX2    = A(13);
PVX1    = A(14);
PVX2    = A(15);



%c
%c -- lateral force (pure side slip)
%c
SHX     = (PHX1 + PHX2 .* DFZ) .* LHX; %38,  (%55)
SVX     = FZ.*(PVX1 + PVX2 .* DFZ).* LVX .* LMUX;
KAPPAX  = KAPPA + SHX;
EX      = (PEX1 + PEX2.*DFZ + PEX3.*DFZ.*DFZ).*(1 - PEX4.*sign(KAPPAX)).*(LEX);
MUX     = (PDX1 + PDX2.*DFZ).*(1 - PDX3.*GAMMAX.*GAMMAX).*LMUX;
DX      = MUX.*FZ;
CX      = PCX1.*LCX;
KX      = FZ.*(PKX1 + PKX2.*DFZ).*exp(PKX3.*DFZ).*LKX;
BX      = KX./(CX.*DX);

FX0     = DX.*sin(CX.*atan(BX.*KAPPAX - EX.*(BX.*KAPPAX - atan(BX.*KAPPAX)))) + SVX;
FX      = FX0;

% ALPHAY  = ALPHA+SHY;  %30 (%47)
% CY      = PCY1 .* LCY;  %32 (%49)
% MUY     = (PDY1+PDY2 .* DFZ) .* (1.0-PDY3 .* GAMMAY.^2) .* LMUY; %34 (%51)
% DY      = MUY .* FZ; %33 (%50)
% KY      = PKY1 .* FZ0 .* sin(2.0 .* atan(FZ ./ (PKY2 .* FZ0 .* LFZO))) .* (1.0-PKY3 .* abs(GAMMAY)) .* LFZO .* LKY; %36 (%53)
% BY      = KY ./ (CY .* DY);  %37 (%54)
% % NOTE, PER SVEN @TNO: "SIGN(ALPHAY)"IS CORRECT AS IN DOCUMENTATION & BELOW; IT'S NOT SUPPOSED TO BE "SIGN(GAMMAY)"
% EY      = (PEY1+PEY2 .* DFZ) .* (1.0-(PEY3+PEY4 .* GAMMAY) .* sign(ALPHAY)) .* LEY; %35 (%52)
% % NOTE: LVY MULTIPLIES ONLY PVY1&2 IN DOCUMENTATION; ORIG VERSION MULT ALL TERMS
% SVY     = FZ .* ((PVY1+PVY2 .* DFZ) .* LVY+(PVY3+PVY4 .* DFZ) .* GAMMAY) .* LMUY; %39 (%56)
% FY0     = DY .* sin(CY .* atan(BY .* ALPHAY-EY .* (BY .* ALPHAY-atan(BY .* ALPHAY))))+SVY; %29 (%46)
% FY      = FY0; %28
