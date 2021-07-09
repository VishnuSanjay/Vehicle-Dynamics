function MZ=MF52_Mz_combined_fcn(A,X)

global FZ0 LFZO LCX LMUX LEX LKX  LHX LVX LCY LMUY LEY LKY LHY LVY ...
       LGAY LTR LRES LGAZ LXAL LYKA LVYKA LS LSGKP  LSGAL LGYR KY KX
   
   global A_final B_final D_final Ak_final Dk_final
   
   
RBY1				= Ak_final(1);
RBY2				= Ak_final(2);
RBY3				= Ak_final(3);
RCY1				= Ak_final(4);
REY1				= Ak_final(5);
REY2				= Ak_final(6);
RHY1				= Ak_final(7);
RHY2				= Ak_final(8);
RVY1				= Ak_final(9);
RVY2				= Ak_final(10);
RVY3				= Ak_final(11);
RVY4				= Ak_final(12);
RVY5				= Ak_final(13);
RVY6				= Ak_final(14);


PDY1    = A_final(2);
PDY2    = A_final(3);
PDY3    = A_final(4);

QBZ1    = B_final(1 );
QBZ2    = B_final(2 );
QBZ3    = B_final(3 );
QBZ4    = B_final(4 );
QBZ5    = B_final(5 );
QBZ9    = B_final(6 );
QBZ10   = B_final(7 );
QCZ1    = B_final(8 );
QDZ1    = B_final(9 );
QDZ2    = B_final(10);
QDZ3    = B_final(11);
QDZ4    = B_final(12);
QDZ6    = B_final(13);
QDZ7    = B_final(14);
QDZ8    = B_final(15);
QDZ9    = B_final(16);
QEZ1    = B_final(17);
QEZ2    = B_final(18);
QEZ3    = B_final(19);
QEZ4    = B_final(20);
QEZ5    = B_final(21);
QHZ1    = B_final(22);
QHZ2    = B_final(23);
QHZ3    = B_final(24);
QHZ4    = B_final(25);

SSZ1 = A(1);
SSZ2 = A(2);
SSZ3 = A(3);
SSZ4 = A(4);

ALPHA = X(:,1).*pi./180;
FZ = abs(X(:,2));
GAMMA = X(:,3).*(pi./180);
K = X(:,4);

GAMMAY=GAMMA.*LGAY;

dFZ=(FZ-FZ0.*LFZO)./(FZ0.*LFZO);

FY = MF52_Fy_fcn(A_final,X);

%%Pure Long Slip

FX = MF52_Fx_fcn(D_final,X);

%%Pure Align Moment
% 
GAMMAZ=GAMMA.*LGAZ;

CT=QCZ1;
PCY1    = A_final(1);
PDY1    = A_final(2);
PDY2    = A_final(3);
PDY3    = A_final(4);
PEY1    = A_final(5);
PEY2    = A_final(6);
PEY3    = A_final(7);
PEY4    = A_final(8);
PKY1    = A_final(9);
PKY2    = A_final(10);
PKY3    = A_final(11);
PHY1    = A_final(12);
PHY2    = A_final(13);
PHY3    = A_final(14);
PVY1    = A_final(15);
PVY2    = A_final(16);
PVY3    = A_final(17);
PVY4    = A_final(18);

%c
%c -- lateral force (pure side slip)
%c
SHY     = (PHY1+PHY2 .* dFZ) .* LHY + PHY3 .* GAMMAY; %38,  (%55)
ALPHAY  = ALPHA+SHY;  %30 (%47)
CY      = PCY1 .* LCY;  %32 (%49)
MUY     = (PDY1+PDY2 .* dFZ) .* (1.0-PDY3 .* GAMMAY.^2) .* LMUY; %34 (%51)
DY      = MUY .* FZ; %33 (%50)
KY      = PKY1 .* FZ0 .* sin(2.0 .* atan(FZ ./ (PKY2 .* FZ0 .* LFZO))) .* (1.0-PKY3 .* abs(GAMMAY)) .* LFZO .* LKY; %36 (%53)
BY      = KY ./ (CY .* DY);  %37 (%54)
% NOTE, PER SVEN @TNO: "SIGN(ALPHAY)"IS CORRECT AS IN DOCUMENTATION & BELOW; IT'S NOT SUPPOSED TO BE "SIGN(GAMMAY)"
EY      = (PEY1+PEY2 .* dFZ) .* (1.0-(PEY3+PEY4 .* GAMMAY) .* sign(ALPHAY)) .* LEY; %35 (%52)
% NOTE: LVY MULTIPLIES ONLY PVY1&2 IN DOCUMENTATION; ORIG VERSION MULT ALL TERMS
SVY     = FZ .* ((PVY1+PVY2 .* dFZ) .* LVY+(PVY3+PVY4 .* dFZ) .* GAMMAY) .* LMUY; %39 (%56)

BR=((QBZ9.*LKY)./LMUY)+(QBZ10.*BY.*CY);
BT=(QBZ1+(QBZ2.*dFZ)+(QBZ3.*dFZ.^2)).*(1+(QBZ4.*(GAMMAZ))+(QBZ5.*abs(GAMMAZ))).*(LKY./LMUY);
R0=0.22;
DT=FZ.*(QDZ1+(QDZ2.*dFZ)).*(1+(QDZ3.*GAMMAZ)+(QDZ4.*(GAMMAZ.^2))).*(R0./FZ0).*LTR;
DR=FZ.*(((QDZ6+(QDZ7.*dFZ)).*LRES)+((QDZ8+(QDZ9.*dFZ)).*GAMMAZ)).*R0.*LMUY;
SHT=QHZ1+(QHZ2.*dFZ)+((QHZ3+(QHZ4.*dFZ)).*GAMMAZ);

SHF=SHY+(SVY./KY);
ALPHAT=ALPHA+SHT;
ALPHAR=ALPHA+SHF;

ET=(QEZ1+(QEZ2.*dFZ)+(QEZ3.*dFZ.^2)).*(1+(QEZ4+(QEZ5.*GAMMAZ)).*(2./pi).*atan(BT.*CT.*ALPHAT));

ALPHATEQ = atan(sqrt((((tan(ALPHAT))).^2)+(((KX./KY).^2).*K.^2))).*(sign(ALPHAT));


t=(DT).*(cos(CT.*atan((BT.*ALPHATEQ)-(ET.*((BT.*ALPHATEQ)-(atan(BT.*ALPHATEQ))))))).*(cos(ALPHA));

MZR=DR.*cos(atan(BR.*ALPHAR)).*cos(ALPHA);

MUY=(PDY1+PDY2.*dFZ).*(1-PDY3.*GAMMAY.^2).*LMUY;
DVYK=MUY.*FZ.*(RVY1+(RVY2.*dFZ)+(RVY3.*GAMMA)).*cos(atan(RVY4.*ALPHA));
SVYK=DVYK.*sin(RVY5.*atan(RVY6.*K)).*LVYKA;

%%Lets begin 

FY1=FY-SVYK;
ALPHAREQ = atan(sqrt((((tan(ALPHAR))).^2)+(((KX./KY).^2).*K.^2))).*(sign(ALPHAR));
MZR = DR.*(cos(atan(BR.*ALPHAREQ))).*cos(ALPHA);
S = (SSZ1+(SSZ2.*(FY./FZ0))+((SSZ3+(SSZ4.*dFZ)).*GAMMA)).*(R0.*LS);

MZ = (-t.*FY1)+MZR+(S.*FX);

