close all
clear all;
% close all
global FZ0 R0 

global PCY1 PDY1 PDY2 PDY3 ...
    PEY1 PEY2 PEY3 PEY4  ...
    PKY1 PKY2 PKY3 ...
    PHY1 PHY2 PHY3 ...
    PVY1 PVY2 PVY3 PVY4;

global LFZO LCX LMUX LEX LKX  LHX LVX LCY LMUY LEY LKY LHY LVY ...
    LGAY LTR LRES LGAZ LXAL LYKA LVYKA LS LSGKP LSGAL LGYR
% 
% [name path] = uigetfile;
% load(name);
[FileName,PathName] = uigetfile(['E:\Mine\Tires\TTC_GUI''\*.mat'],'Select a tire file:');
input_filename = [PathName FileName];
load(input_filename)

inx = find(abs(P-(12*6.89))<6);
SA = SA(inx);
IA = IA(inx);
SL = SL(inx);
FY = FY(inx);
FX = FX(inx);
FZ = FZ(inx);
MZ = MZ(inx);
MX = MX(inx);
P = P(inx);
ET = ET(inx);
V = V(inx);
SL = SL(inx);
FX = FX(inx);


m=1:length(SA);     % point counter
sp=csaps(m,SA); % fit a generic spline to locate zeros.

z=fnzeros(sp);      % location of zero crossings
z=round(z(1,:));   % no dups and integer indices

figure  % Just checkin'
plot(m,SA,'r')
hold on
% plot(z,zeros(length(z)),'ko')
xlim([0 3200])

z([1:2:length(z)])=[];  % drop kick the shutdown points;
plot(z,zeros(length(z)),'bo')
line([0 m(end)], [0 0],'color','k')
xlabel('Point Count')
ylabel('Slip Angle')
legend('Test Data','Computed Slip Points of Interest'),legend Boxoff
clear fmdata
q=0;

for n=1:(length(z)-1) % for some reason there are some repeat runs here. Skip them
    
    sa=SA(z(n):z(n+1));
    fz=FZ(z(n):z(n+1));
    fy=FY(z(n):z(n+1));
    mz=MZ(z(n):z(n+1));
    mx=MX(z(n):z(n+1));
    rl=RL(z(n):z(n+1));
    ia=IA(z(n):z(n+1));

% fy= mean(fz)*ones(length(fz),1).*fy./fz;
% mz= mean(fz)*ones(length(fz),1).*mz./fz;
% mx= mean(fz)*ones(length(fz),1).*mx./fz;
% fz= mean(fz).*ones(length(fz),1);

    [tmp,imn]=min(sa);
    [tmp,imx]=max(sa);
    p=1:length(sa);
    rng=imx-50:imx+50;
    pp=polyfit(p(rng),mz(rng)',3);
    mzf=polyval(pp,p(rng));

    ind=find(abs(mzf-mz(rng)') > 7);
    mz(rng(ind))=mzf(ind);

    rng=imn-50:imn+50;
    pp=polyfit(p(rng),mz(rng)',3);
    mzf=polyval(pp,p(rng));

    ind=find(abs(mzf-mz(rng)') > 7);
    mz(rng(ind))=mzf(ind);
    
    sp_fy=csaps(sa,fy,.1);
    sp_mz=csaps(sa,mz,.99);
    sp_mx=csaps(sa,mx,.99);
    sp_rl=csaps(sa,rl,.99);
    
    for sl=floor(min(sa)):1:ceil(max(sa));
        q=q+1;
        fmdata(q,1)=sl;
        fmdata(q,2)=round(mean(ia));
        fmdata(q,3)=mean(fz);
        fmdata(q,4)=fnval(sp_fy,sl);
        fmdata(q,5)=fnval(sp_mz,sl);
        fmdata(q,6)=fnval(sp_mx,sl);
    end
end

fmdata  = sortrows(fmdata,[2,1,3]);

incls   = unique(round(fmdata(:,2)))'
nincls  = length(incls)

slips   =  unique(round(fmdata(:,1)))'
nslips  = length(slips)

t.SA= fmdata(:,1);
t.IA= fmdata(:,2);
t.FZ= fmdata(:,3);
t.FY= fmdata(:,4);
t.MZ= fmdata(:,5);
t.MX= fmdata(:,6);
%--------------------------------------------------------------------------
% Now patch in MF5.2 fitter:  

FZ0=  mean(abs(t.FZ)); % = FNOMIN = 'nominal wheel load'
R0  = .240;

INPUT = [t.SA,t.FZ,t.IA]; % slip, vert, incl
options =optimset('MaxFunEvals',50000,'MaxIter',50000,'Display','final','TolX',1e-7,'TolFun',1e-7);
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

% [LATERAL_COEFFICIENTS]
PCY1 =  -0.0088;
PDY1 = -435.744;
PDY2 = -8.181;
PDY3 = 7.7211;
PEY1 = 1.0626;
PEY2 = -.0613;
PEY3 = 0.0214;
PEY4 = -0.2166;
PKY1 = -53.2126;
PKY2 = 2.1268;
PKY3 = 2.1448;
PHY1 = 0.0039;
PHY2 =  0.0021;
PHY3 = -.1602;
PVY1 = -0.0146;
PVY2 = -0.003;
PVY3 = -3.3543;
PVY4 = -1.1311;
% load Afinal.mat
clear AA RESNORM
A_str ={'PCY1' 'PDY1' 'PDY2' 'PDY3' 'PEY1' 'PEY2' 'PEY3' 'PEY4' 'PKY1' 'PKY2' 'PKY3' 'PHY1' 'PHY2' 'PHY3' 'PVY1' 'PVY2' 'PVY3' 'PVY4'};
A_old =[PCY1 PDY1 PDY2 PDY3 PEY1 PEY2 PEY3 PEY4 PKY1 PKY2 PKY3 PHY1 PHY2 PHY3 PVY1 PVY2 PVY3 PVY4];
% A_old = A_final;


fig1=figure ('MenuBar','none','Name',['Pacejka_97  fy Fitting Results'],'Position',[2 2 1600 1180],'NumberTitle','off');
for k=1:60
    [A,RESNORM(k),RESIDUAL,EXITFLAG] = lsqcurvefit('MF52_Fy_fcn',A_old,INPUT,t.FY,[],[],options);
        AA(:,k)=A; 
        for n=1:18
        subplot(3,6,n)
        bar([AA(n,:)],'group')
        title(['A(' num2str(n) ')' ' =' A_str{n}],'FontSize',8)
        subplot(3,6,18)
        plot(1:k,RESNORM)
    end

    for n=1:18  % update A coefficients to newest values
        disp(['A_old(' num2str(n) ') = ' num2str(A_old(n)) ';    ' 'A(' num2str(n) ') = ' num2str(A(n)) ';'])
        eval(['A_old(' num2str(n) ') = ' num2str(A(n)) ' -1*eps*rand;']) % bootstrap
    end
%     set(fig1,'Name',[filename '     Free Rolling Lateral Force      Iteration: ' num2str(k)  '         RESNORM: ' num2str(RESNORM(k)) ])
    drawnow
end
A_final = A;


QBZ1 = 10;
QBZ2 = -2;
QBZ3 = -1;
QBZ4 = -1;
QBZ5 = -1;
QBZ9 = 20;
QBZ10 = -2;
QCZ1 = 1.18;
QDZ1 = -.1;
QDZ2 = -.01;
QDZ3 = 10;
QDZ4 = -100;
QDZ6 = .01;
QDZ7 = -.0002;
QDZ8 = .1;
QDZ9 = -.1;
QEZ1 = -1.6;
QEZ2 = -0.36;
QEZ3 = -1;
QEZ4 = 0.17433;
QEZ5 = -0.9;
QHZ1 = 0.005;
QHZ2 = -0.0019;
QHZ3 = 0.005;
QHZ4 = -.08;

clear BB
B_str ={'QBZ1' 'QBZ2' 'QBZ3' 'QBZ4' 'QBZ5' 'QBZ9' 'QBZ10' 'QCZ1' 'QDZ1' 'QDZ2' 'QDZ3' 'QDZ4' 'QDZ6' 'QDZ7' 'QDZ8' 'QDZ9' 'QEZ1' 'QEZ2' 'QEZ3' 'QEZ4' 'QEZ5' 'QHZ1' 'QHZ2' 'QHZ3' 'QHZ4'};
B_old =[QBZ1 QBZ2 QBZ3 QBZ4 QBZ5 QBZ9 QBZ10 QCZ1 QDZ1 QDZ2 QDZ3 QDZ4 QDZ6 QDZ7 QDZ8 QDZ9 QEZ1 QEZ2 QEZ3 QEZ4 QEZ5 QHZ1 QHZ2 QHZ3 QHZ4];
fig2=figure ('MenuBar','none','Name',['Pacejka_97  Mz Fitting Results'],'Position',[2 2 1600 1180],'NumberTitle','off');

INPUT(:,3) = abs(INPUT(:,3));

for k=1:40
   [B,RESNORM1(k),RESIDUAL,EXITFLAG] = lsqcurvefit('MF52_Mz_fcn',B_old,INPUT,t.MZ,[],[],options);
    BB(:,k) = B; 
    for n=1:25 
        subplot(5,5,n)
        bar([BB(n,:)],'group')
        title(['B(' num2str(n) ')' ' =' B_str{n}],'FontSize',8)
        subplot(5,5,25)
        plot(1:k,RESNORM1)
    end
%     set(fig2,'Name',[filename '     Free Rolling Aligning Moment      Iteration: ' num2str(k)  '         RESNORM: ' num2str(RESNORM(k)) ])
    drawnow;
    for n=1:25  % update A coefficients to newest values
        disp(['B_old(' num2str(n) ') = ' num2str(B_old(n)) ';    ' 'B(' num2str(n) ') = ' num2str(B(n)) ';'])
        eval(['B_old(' num2str(n) ') = ' num2str(B(n)) ' -1*eps*rand;']) % bootstrap
    end
end
% % pacefy=MF52_Fy_fcn(A_old,[SA FZ IA]);
% % figure;plot3(SA,FZ,FY)
% % hold on
% % plot3(SA,FZ,pacefy,'.')
% % figure;plot3(SA,IA,FY)
% % hold on
% % plot3(SA,IA,pacefy,'.')
