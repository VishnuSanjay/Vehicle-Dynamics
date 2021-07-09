function MZ =MF52_Mz_fcn(B,X);

global FZ0 R0

global PCY1 PDY1 PDY2 PDY3 ...
       PEY1 PEY2 PEY3 PEY4  ... 
       PKY1 PKY2 PKY3 ... 
       PHY1 PHY2 PHY3 ... 
       PVY1 PVY2 PVY3 PVY4;

global LFZO LCX LMUX LEX LKX  LHX LVX LCY LMUY LEY LKY LHY LVY ...
       LGAY LTR LRES LGAZ LXAL LYKA LVYKA LS LSGKP  LSGAL LGYR  

ALPHA  =  X(:,1)*pi/180;
FZ     =  abs(X(:,2));
GAMMA  =  X(:,3)*pi/180;

GAMMAY = GAMMA .* LGAY; %31 (%48 lgay=lg
GAMMAZ = GAMMA .* LGAZ; %47 (%63 lgaz = lg
FZ0PR  = FZ0  .*  LFZO; %15,  NEED LFZO NOT LFZ0 TO MATCH TIRE PROP FILE
DFZ    = (FZ-FZ0PR) ./ FZ0PR; %14,  (%30)

QBZ1    = B(1 );
QBZ2    = B(2 );
QBZ3    = B(3 );
QBZ4    = B(4 );
QBZ5    = B(5 );
QBZ9    = B(6 );
QBZ10   = B(7 );
QCZ1    = B(8 );
QDZ1    = B(9 );
QDZ2    = B(10);
QDZ3    = B(11);
QDZ4    = B(12);
QDZ6    = B(13);
QDZ7    = B(14);
QDZ8    = B(15);
QDZ9    = B(16);
QEZ1    = B(17);
QEZ2    = B(18);
QEZ3    = B(19);
QEZ4    = B(20);
QEZ5    = B(21);
QHZ1    = B(22);
QHZ2    = B(23);
QHZ3    = B(24);
QHZ4    = B(25);

%C
%C -- ALIGNING TORQUE (PURE SIDE SLIP)
%C
SHY     = (PHY1+PHY2 .* DFZ) .* LHY + PHY3 .* GAMMAY; %38,  (%55)
SVY     = FZ .* ((PVY1+PVY2 .* DFZ) .* LVY+(PVY3+PVY4 .* DFZ) .* GAMMAY) .* LMUY; %39 (%56)
ALPHAY  = ALPHA+SHY;  %30 (%47)

SHT    = QHZ1+QHZ2 .* DFZ+(QHZ3+QHZ4 .* DFZ) .* GAMMAZ; %52 ( %68)
ALPHAT = ALPHA+SHT;  %43 (%59)
KY      = PKY1 .* FZ0 .* sin(2.0 .* atan(FZ ./ (PKY2 .* FZ0 .* LFZO))) .* (1.0-PKY3 .* abs(GAMMAY)) .* LFZO .* LKY; %36 (%53)
% NOTE: PER SVEN, "EQUATION 45 IS WRONG DOCUMENTATION,
% THERE IT SHOULD BE SHF INSTEAD OF SHR"
SHF    = SHY+SVY ./ KY; %46 (%62)
ALPHAR = ALPHA+SHF; %45 (%61)

BT = (QBZ1+QBZ2 .* DFZ+QBZ3 .* DFZ.^2) .* (1.0+QBZ4 .* GAMMAZ+QBZ5 .* abs(GAMMAZ)) .* LKY ./ LMUY; %48 (%64)
CT = QCZ1; %49 (%65)
DT = FZ .* (QDZ1+QDZ2 .* DFZ) .* (1.0+QDZ3 .* GAMMAZ+QDZ4 .* GAMMAZ.^2) .* (R0 ./ FZ0) .* LTR; %50 (%66)
% NOTE: EQUATION FOR ET HAS CHANGED FROM PAC97 EQUATION; 2/PI TERM IS NEW.
ET = (QEZ1+QEZ2 .* DFZ+QEZ3 .* DFZ.^2) .* (1.0+(QEZ4+QEZ5 .* GAMMAZ) .* (2/pi) .* atan(BT .* CT .* ALPHAT)); %51 (%67)
CY      = PCY1 .* LCY;  %32 (%49)
MUY     = (PDY1+PDY2 .* DFZ) .* (1.0-PDY3 .* GAMMAY.^2) .* LMUY; %34 (%51)

DY      = MUY .* FZ; %33 (%50)
BY      = KY ./ (CY .* DY);  %37 (%54)
BR = QBZ9 .* LKY ./ LMUY+QBZ10 .* BY .* CY;  %53 (%69)
% NOTE: LRES MULTIPLIES EVERYTHING IN ORIG EQN; BELOW MATCHES DOCUMENTATION
DR = FZ .* ((QDZ6+QDZ7 .* DFZ) .* LRES+(QDZ8+QDZ9 .* DFZ) .* GAMMAZ) .* R0 .* LMUY; %54 (%70 LRES=LMR)
TRAIL = DT .* cos(CT .* atan(BT .* ALPHAT-ET .* (BT .* ALPHAT-atan(BT .* ALPHAT)))) .* cos(ALPHA); %42 (%58)
MZR = DR .* cos(atan(BR .* ALPHAR)) .* cos(ALPHA); %44 (%60)
EY      = (PEY1+PEY2 .* DFZ) .* (1.0-(PEY3+PEY4 .* GAMMAY) .* sign(ALPHAY)) .* LEY; %35 (%52)
% NOTE: LVY MULTIPLIES ONLY PVY1&2 IN DOCUMENTATION; ORIG VERSION MULT ALL TERMS
SVY     = FZ .* ((PVY1+PVY2 .* DFZ) .* LVY+(PVY3+PVY4 .* DFZ) .* GAMMAY) .* LMUY; %39 (%56)
FY0     = DY .* sin(CY .* atan(BY .* ALPHAY-EY .* (BY .* ALPHAY-atan(BY .* ALPHAY))))+SVY; %29 (%46)
MZ0= -TRAIL .* FY0 + MZR;  %41 (%57)
MZ = MZ0; %40

