import numpy as np
from numpy import genfromtxt
import matplotlib.pyplot as plt
from scipy.optimize import curve_fit
from sr_func import *

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


swa_l = np.delete(swa_l,np.argwhere(np.isnan(sr_l)))
sr_l = np.delete(sr_l,np.argwhere(np.isnan(sr_l)))
       
swa_r = np.delete(swa_r,np.argwhere(np.isnan(sr_r)))
sr_r = np.delete(sr_r,np.argwhere(np.isnan(sr_r)))

#--------------------- right wheel --------------------------------------
sr_r_fit  = sr_r[np.argwhere(np.abs(swa_r) < 115)]
swa_r_fit = swa_r[np.argwhere(np.abs(swa_r) < 115)]

#options = optimset('MaxFunEvals',1000000,'MaxIter',1000000,'Display','final');

SR_R = np.array([np.mean(sr_r_fit), 0, 0, np.max(sr_r_fit), 0, 0, 270, 0])  
SR_R = curve_fit(sr_func,swa_r_fit,sr_r_fit, SR_R)

#-------------------- left wheel --------------------------------------
sr_l_fit  = sr_l[np.argwhere(np.abs(swa_l) < 115)]
swa_l_fit = swa_l[np.argwhere(np.abs(swa_l) < 115)]


SR_L = SR_R # go with a winner
SR_L[1]= -SR_L[1]  #flip sign of symmetry term
#SR_L = np.array([np.mean(sr_l_fit), 0, 0, np.max(sr_l_fit), 0, 0, 260, 0])  
SR_L = curve_fit(sr_func,swa_l_fit,sr_l_fit,SR_L) 

#------------------- average ------------------------------------------
sr_avg = (sr_l_fit+sr_r_fit)/2 
SR_AVG = (SR_L +SR_R)/2

SR_AVG = curve_fit(sr_func,swa_l_fit,sr_avg,SR_AVG) 

SR_NO_IS = SR_AVG
#--------------- Plot of fitted data ---------------------------
swaplot= np.linspace(-130,130,261)

#F1=figure('Position',[100 100 800 600],'Color',[1. 1. 1.],'MenuBar','none','NumberTitle','off');
#set(F1,'Name',['Steering Ratio Test Results   File: '])
fig, (ax1, ax2) = plt.subplots(2)
fig.suptitle('Steering ratio test results')

ax1.plot(swa_l,sr_l,'b')
ax1.plot(swa_r,sr_r,'r') 
##ax1.plot(swaplot,sr_func(SR_L,swaplot),'g')
##ax1.plot(swaplot,sr_func(SR_R,swaplot),'y')

ax1.set_xlim(-150,150)
ax1.swt_ylim(3,15)
ax1.set_xticks(-150,-120,-90,-60,-30,0,30,60,90,120,150)
#axis([-150 150 3 15])
#set(gca,'XTick',[-150:30:150]);

##vref([-360 0 360])
##title([PathName filename '   ' title4],'Interpreter','none')
ax1.legend('Raw CW Turns','Raw CCW Turns')


#ax2.plot(swa_l_fit,sr_l_fit,'bo','markersize',2)
ax2.plot(swaplot,sr_func(SR_L,swaplot),'b-')

#ax2.plot(swa_r_fit,sr_r_fit,'ro','markersize',2)
ax2.plot(swaplot,sr_func(SR_R,swaplot),'r-')

#ax2.plot(swa_l_fit,sr_avg,'mo','markersize',2)
ax2.plot(swaplot,sr_func(SR_AVG,swaplot),'k-')
ax2.set_xlim(-150, 150)
ax2.set_ylim(3, 15)

##vref([-360 -180 0 180 360]);
ax2.set_xticks(-150,-120,-90,-60,-30,0,30,60,90,120,150)

#text(-150,ax(4)+1.,{['Right:' num2str(SR_R,4)],['Left: ' num2str(SR_L,4)],['Avg. :' num2str(SR_AVG,4)]},'FontName','FixedWidth')
##supertitle(['Overall Steer Ratio Test Results: '])
ax2.legend('Fitted CW Turns','Fitted CCW Turns','Avg Fitted')


#F2=figure('Position',[100 100 800 600],'Color',[1. 1. 1.],'MenuBar','none','NumberTitle','off');
#set(F2,'Name',['Steering Ratio Test Results   File: '])

fig2,ax = plt.subplots()
ax.plot(SWANGL,RFWA)
ax.plot(SWANGL,LFWA)
plt.grid()
ax.set_xlabel('Steering Wheel Angle (deg)')
ax.set_ylabel('Road Wheel Angles (deg)')
##href(0)
##vref(0)
##sidetext('BillCobb    zzvyb6@yahoo.com')
ax.title('Like hell Im driving this again!')
