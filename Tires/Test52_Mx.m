close all
clear all;

load Afinal_8_new;

global FZ0 R0 

global PCY1 PDY1 PDY2 PDY3 ...
    PEY1 PEY2 PEY3 PEY4  ...
    PKY1 PKY2 PKY3 ...
    PHY1 PHY2 PHY3 ...
    PVY1 PVY2 PVY3 PVY4;

global LFZO LCX LMUX LEX LKX  LHX LVX LCY LMUY LEY LKY LHY LVY ...
    LGAY LTR LRES LGAZ LXAL LYKA LVYKA LS LSGKP LSGAL LGYR A_final
% 
% [name path] = uigetfile;
% load(name);
[FileName,PathName] = uigetfile(['E:\Mine\Tires\TTC_GUI''\*.mat'],'Select a tire file:');
input_filename = [PathName FileName];
load(input_filename)

inx = find((abs(P-(12*6.89))<6));
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

incls   = unique(round(fmdata(:,2)))';
nincls  = length(incls);

slips   =  unique(round(fmdata(:,1)))';
nslips  = length(slips);

t.SA= fmdata(:,1);
t.IA= fmdata(:,2);
t.FZ= fmdata(:,3);
t.FY= fmdata(:,4);
t.MZ= fmdata(:,5);
t.MX= fmdata(:,6);
%--------------------------------------------------------------------------
% Now patch in MF5.2 fitter:  

FZ0=  abs(mean(t.FZ)); % = FNOMIN = 'nominal wheel load'
R0  = 0.240;

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

% [Overturning moment]
QSX1                     = 0.02                 ;%typarr(  86)
QSX2                     = 5                   ;%typarr(  87)
QSX3                     = 0.2                  ;%typarr(  88)
C_old =[QSX1 QSX2 QSX3];

clear CC RESNORM
C_str ={'QSX1'  'QSX2' 'QSX3'};
C_old =[QSX1 QSX2 QSX3];
% A_old = A_final;


fig1=figure ('MenuBar','none','Name',['Pacejka_97  fy Fitting Results'],'Position',[2 2 1600 1180],'NumberTitle','off');
for k=1:50
    [C,RESNORM(k),RESIDUAL,EXITFLAG] = lsqcurvefit('MF52_Mx_fcn',C_old,INPUT,t.MX,[],[],options);
        CC(:,k)=C; 
        for n=1:3
        subplot(3,1,n)
        bar([CC(n,:)],'group')
        title(['C(' num2str(n) ')' ' =' C_str{n}],'FontSize',8)
        subplot(3,1,3)
        plot(1:k,RESNORM)
    end

    for n=1:3  % update A coefficients to newest values
        disp(['C_old(' num2str(n) ') = ' num2str(C_old(n)) ';    ' 'C(' num2str(n) ') = ' num2str(C(n)) ';'])
        eval(['C_old(' num2str(n) ') = ' num2str(C(n)) ' -1*eps*rand;']) % bootstrap
    end

end
C_final = C;