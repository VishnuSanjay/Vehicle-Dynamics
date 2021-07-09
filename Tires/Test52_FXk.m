close all
clear all
load Dfinal_8_new
global FZ0 R0 KY

% global PCY1 PDY1 PDY2 PDY3 ...
%     PEY1 PEY2 PEY3 PEY4  ...
%     PKY1 PKY2 PKY3 ...
%     PHY1 PHY2 PHY3 ...
%     PVY1 PVY2 PVY3 PVY4;

global LFZO LCX LMUX LEX LKX  LHX LVX LCY LMUY LEY LKY LHY LVY ...
    LGAY LGAX LTR LRES LGAZ LXAL LYKA LVYKA LS LSGKP LSGAL LGYR D_final

[FileName,PathName] = uigetfile(['E:\Mine\Tires\TTC_GUI''\*.mat'],'Select a tire file:');
input_filename = [PathName FileName];
load(input_filename)
pinterest = 12*6.89476;
% SAinterest = -6;
vinterest = 40;
x = (abs(P-pinterest)<5) .*  (abs(V-vinterest) <=3);% .* (abs(SA + 6) <=0.5) ;%+ (abs(SA + 3)<=0.5));
[inx iny] = find(x==1);
SA1 = SA(inx);
IA1 = IA(inx);
SL1 = SL(inx);
FY1 = FY(inx);
FX1 = FX(inx);
FZ1 = FZ(inx);
MZ1 = MZ(inx);
MX1 = MX(inx);
P1 = P(inx);
ET1 = ET(inx);
V1 = V(inx);
SL1 = SL(inx);
FX1 = FX(inx);
RL1 = RL(inx);


m=1:length(SL1);     % point counter
sp=csaps(m,SL1,.1); % fit a generic spline to locate zeros.

z=fnzeros(sp);      % location of zero crossings
z=round(z(1,:));   % no dups and integer indices

figure  % Just checkin'
plot(m,SL1,'r')
hold on
% plot(z,zeros(length(z)),'ko')
% xlim([0 3200])

z([2:2:length(z)])=[];  % drop kick the shutdown points;
plot(z,zeros(length(z)),'bo')
line([0 m(end)], [0 0],'color','k')
xlabel('Point Count')
ylabel('Slip Ratio')
legend('Test Data','Computed Slip Points of Interest'),legend Boxoff
clear fmdata

hold on
zeros = 1;
for n = 1:(length(z)-1)
    q = z(n);
    [M I] = max(SL1(z(n):z(n+1)));
    q = q+I;
    zeros(n+1) = q;
    plot(zeros(n+1),M,'o')
end

z = zeros;
q = 0;
for n = 1:(length(z)-1) % for some reason there are some repeat runs here. Skip them
    sa = SA1(z(n):z(n+1));
    fz = FZ1(z(n):z(n+1));
    fy = FY1(z(n):z(n+1));
    mz = MZ1(z(n):z(n+1));
    mx = MX1(z(n):z(n+1));
    rl = RL1(z(n):z(n+1));
    ia = IA1(z(n):z(n+1));
    fx = FX1(z(n):z(n+1));
    sl = SL1(z(n):z(n+1));

fy= mean(fz)*ones(length(fz),1).*fy./fz;
mz= mean(fz)*ones(length(fz),1).*mz./fz;
mx= mean(fz)*ones(length(fz),1).*mx./fz;
fz= mean(fz).*ones(length(fz),1);

%     [tmp,imn]=min(sa);
%     [tmp,imx]=max(sa);
%     p=1:length(sa);
%     rng=imx-50:imx+50;
%     pp=polyfit(p(rng),mz(rng)',3);
%     mzf=polyval(pp,p(rng));
% 
%     ind=find(abs(mzf-mz(rng)') > 7);
%     mz(rng(ind))=mzf(ind);
% 
%     rng=imn-50:imn+50;
%     pp=polyfit(p(rng),mz(rng)',3);
%     mzf=polyval(pp,p(rng));
% 
%     ind=find(abs(mzf-mz(rng)') > 7);
%     mz(rng(ind))=mzf(ind);
    
    sp_fyk = csaps(sl,fy,.9999);
    sp_fx=csaps(sl,fx,.9999);
    
    
    for temp=(min(sl)):0.01:(max(sl));
        q=q+1;
        fmdata(q,1)=temp;
        fmdata(q,2)=round(mean(ia));
        fmdata(q,3)=mean(fz);
        fmdata(q,4)=fnval(sp_fyk,temp);
        fmdata(q,5)=fnval(sp_fx,temp);
        fmdata(q,6)=mean(sa);
    end
end

fmdata  = sortrows(fmdata,[2,1,3]);

incls   = unique(round(fmdata(:,2)))';
nincls  = length(incls);

slips   =  unique(round(fmdata(:,1)))';
nslips  = length(slips);

t.SL= fmdata(:,1);
t.IA= fmdata(:,2);
t.FZ= fmdata(:,3);
t.FYK= fmdata(:,4);
t.FX= fmdata(:,5);
t.SA= fmdata(:,6);
%--------------------------------------------------------------------------
% Now patch in MF5.2 fitter:  

FZ0=  abs(mean(t.FZ)); % = FNOMIN = 'nominal wheel load'
R0  = 0.240;

INPUT = [t.SL,t.FZ,t.IA,t.SA]; % slip, vert, incl

LFZO                     = 0.100000E+01         ;%typarr(  31)
LCX                      = 0.100000E+01         ;%typarr(  32)
LMUX                     = 0.100000E+01         ;%typarr(  33)
LEX                      = 0.100000E+01         ;%typarr(  34)
LKX                      = 0.100000E+01         ;%typarr(  35)
LHX                      = 0.100000E+01         ;%typarr(  36)
LVX                      = 0.100000E+01         ;%typarr(  37)
LCY                      = 0.100000E+01         ;%typarr(  38)
LMUY                     = 0.100000E+01         ;%typarr(  39)
LEY                      = 0.100000E+01         ;%typarr(  40)
LKY                      = 0.100000E+01         ;%typarr(  41)
LHY                      = 0.100000E+01         ;%typarr(  42)
LVY                      = 0.100000E+01         ;%typarr(  43)
LGAY                     = 0.100000E+01         ;%typarr(  44)
LTR                      = 0.100000E+01         ;%typarr(  45)
LRES                     = 0.100000E+01         ;%typarr(  46)
LGAZ                     = 0.100000E+01         ;%typarr(  47)
LXAL                     = 0.100000E+01         ;%typarr(  48)
LYKA                     = 0.100000E+01         ;%typarr(  49)
LVYKA                    = 0.100000E+01         ;%typarr(  50)
LS                       = 0.100000E+01         ;%typarr(  51)
LSGKP                    = 0.100000E+01         ;%typarr(  52)
LSGAL                    = 0.100000E+01         ;%typarr(  53)
LGYR                     = 0.100000E+01         ;%typarr(  54)
LGAX                     = 0.100000E+01         ; % Scale factor of camber for Fx

RBX1				= +2.372E+001;
RBX2				= +2.597E+001;
RCX1				= +7.495E-001;
REX1				= -4.759E-001;
REX2				= +8.109E-001;
RHX1				= +0.000E+000;

clear AA RESNORM
A_str ={ 'RBX1' 'RBX2' 'RCX1' 'REX1' 'REX2' 'RHX1'};
A_old =[ RBX1 RBX2 RCX1 REX1 REX2 RHX1];
options =optimset('MaxFunEvals',50000,'MaxIter',50000,'Display','final','TolX',1e-8,'TolFun',1e-8);
figure
fig1=figure ('MenuBar','none','Name',['Pacejka_97  fy Fitting Results'],'Position',[2 2 1600 1180],'NumberTitle','off');
for k=1:40
    [A,RESNORM(k),RESIDUAL,EXITFLAG] = lsqcurvefit('MF52_Fx_combined_fcn',A_old,INPUT,t.FX,[],[],options);
        AA(:,k)=A; 
        for n=1:6
            subplot(3,6,n)
            bar([AA(n,:)],'group')
            title(['A(' num2str(n) ')' ' =' A_str{n}],'FontSize',8)
        end

    for n=1:6  % update A coefficients to newest values
        disp(['A_old(' num2str(n) ') = ' num2str(A_old(n)) ';    ' 'A(' num2str(n) ') = ' num2str(A(n)) ';'])
        eval(['A_old(' num2str(n) ') = ' num2str(A(n)) ' -1*eps*rand;']) % bootstrap
    end
%     set(fig1,'Name',[filename '     Free Rolling Lateral Force      Iteration: ' num2str(k)  '         RESNORM: ' num2str(RESNORM(k)) ])
    drawnow
    plot(k,RESNORM(k),'o');hold on;
end
