import numpy as np
from numpy import genfromtxt
data = genfromtxt('data.csv', delimiter=',')

SWANGL = data[:,2]
RFWA = data[:,3]
LFWA = data[:,4]

inx = np.argwhere(np.abs(np.diff(SWANGL)) < 2.5)

SWANGL = np.delete(SWANGL, inx)
RFWA = np.delete(RFWA,inx)
LFWA = np.delete(LFWA,inx)

swa_l = SWANGL
swa_r = SWANGL

rwa = RFWA
lwa = LFWA

swa_ld = np.gradient(swa_l)
swa_rd = np.gradient(swa_r)

rwad = np.gradient(rwa)
lwad = np.gradient(lwa)


sr_l = (swa_ld/lwad)
sr_r = (swa_rd/rwad)


swa_l(find(isnan(sr_l)))=[];
sr_l(find(isnan(sr_l)))=[];
       
swa_r(find(isnan(sr_r)))=[];
sr_r(find(isnan(sr_r)))=[];

%--------------------- right wheel --------------------------------------
sr_r_fit  = sr_r (find(abs(swa_r) < 115));
swa_r_fit = swa_r(find(abs(swa_r) < 115));

options = optimset('MaxFunEvals',1000000,'MaxIter',1000000,'Display','final');

SR_R = [mean(sr_r_fit) 0 0 max(sr_r_fit) 0 0 270 0]  
[SR_R,x1,y1] = lsqcurvefit('sr_func',SR_R,swa_r_fit,sr_r_fit,[],[],options)

%-------------------- left wheel --------------------------------------
sr_l_fit  = sr_l (find(abs(swa_l) < 115));
swa_l_fit = swa_l(find(abs(swa_l) < 115));


SR_L = SR_R;    % go with a winner
SR_L(2)= -SR_L(2);  %flip sign of symetry term
%SR_L = [mean(sr_l_fit) 0 0 max(sr_l_fit) 0 0 260 0]  
[SR_L,x2,y2] = lsqcurvefit('sr_func',SR_L,swa_l_fit,sr_l_fit,[],[],options) 


sr_avg=(sr_l_fit+sr_r_fit)/2;
SR_AVG=(SR_L +SR_R)/2;

[SR_AVG,x3,y3] = lsqcurvefit('sr_func',SR_AVG,swa_l_fit,sr_avg,[],[],options) 

SR_NO_IS=SR_AVG
%--------------- Plot of fitted data ---------------------------
swaplot=-130:1:130;

F1=figure('Position',[100 100 800 600],'Color',[1. 1. 1.],'MenuBar','none','NumberTitle','off');
set(F1,'Name',['Steering Ratio Test Results   File: '])

subplot(2,1,1)
plot(swa_l,sr_l,'b'),hold on
plot(swa_r,sr_r,'r') 
%%plot(swaplot,sr_func(SR_L,swaplot),'g')
%%plot(swaplot,sr_func(SR_R,swaplot),'y')

axis([-150 150 3 15])
set(gca,'XTick',[-150:30:150]);

%%vref([-360 0 360])
%%title([PathName filename '   ' title4],'Interpreter','none')
legend('Raw CW Turns','Raw CCW Turns')

subplot(2,1,2)
%plot(swa_l_fit,sr_l_fit,'bo','markersize',2)
hold on
plot(swaplot,sr_func(SR_L,swaplot),'b-')

%plot(swa_r_fit,sr_r_fit,'ro','markersize',2)
hold on
plot(swaplot,sr_func(SR_R,swaplot),'r-')

%plot(swa_l_fit,sr_avg,'mo','markersize',2)
hold on
plot(swaplot,sr_func(SR_AVG,swaplot),'k-')
xlim([-150 150])
ylim([3 15])

%%vref([-360 -180 0 180 360]);
set(gca,'XTick',[-360:30:360]);

ax=axis;
text(-150,ax(4)+1.,{['Right:' num2str(SR_R,4)],['Left: ' num2str(SR_L,4)],['Avg. :' num2str(SR_AVG,4)]},'FontName','FixedWidth')
%%supertitle(['Overall Steer Ratio Test Results: '])
legend('Fitted CW Turns','Fitted CCW Turns','Avg Fitted')


F2=figure('Position',[100 100 800 600],'Color',[1. 1. 1.],'MenuBar','none','NumberTitle','off');
set(F2,'Name',['Steering Ratio Test Results   File: '])

plot(SWANGL,RFWA,SWANGL,LFWA)
grid
xlabel('Steering Wheel Angle (deg)')
ylabel('Road Wheel Angles (deg)')
%%href(0)
%%vref(0)
%%sidetext('BillCobb    zzvyb6@yahoo.com')
title('Like hell Im driving this again!')
