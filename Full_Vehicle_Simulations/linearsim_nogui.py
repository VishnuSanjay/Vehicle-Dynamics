import numpy as np
from control.matlab import *
import matplotlib.pyplot as plt
from control_self import *

## Inputs for the simulation and unit conversion:
m = 1600 ## mass of the vehicle, in kgs
kdash = 0.072 ##k' = k/(a*b) - 1
wb = 2.747 ##wheelbase in metres
a = wb * 600 / m ##distance from CG to front axle in m
b = wb * 1000 / m ##distance from CG to rear axle in m
mf = m * b / (a+b) ##mass on front axle, kg
mr = m * a / (a+b) 
DF = 6 ##front corenering compliance in deg/g
DR = 3 
IZZ = (kdash+1) * m * a * b ## yaw moment of inertia of the vehicle, in kg m^2
CF =  57.3 * mf * 9.81 / DF ## Front tire cornering stiffness, input in N/deg, gets converted to N/rad
CR =  57.3 * mr * 9.81 / DR ## Same as above, for rear tires
u = 100 / 3.6 ## vehicle forward velocity in m/s
SR = 16 ##degrees of steer wheel angle per degree of wheel angle. Assumed constant


### Note: CF and CR can also be considered as effective front and rear
### cornering compliances, according to the paper by Bundorf and Leffert


## Computation area
D1 = m * u * IZZ
D2 = (IZZ * (CF+CR)) + (m * (a**2 * CF + b**2 * CR))
D3 = ((a+b)**2 * CF * CR / u) + (m * u * (b * CR - a * CF))
denom = np.array([D1,D2,D3])

### Yaw velocity numerator
N1 = a * m * u * CF
N2 = (a+b) * CF * CR
yawn = np.array([N1,N2])
yawan = np.array([N1,N2,0])

### Sideslip angle numerator
N3 = IZZ * CF
N4 = (CF * CR * (b**2 + a * b) / u) - a * m * u * CF
betan = np.array([N3,N4])
dbetan = np.array([N3,N4,0])

### Lateral acceleration numerator
N5 = u * IZZ * CF
N6 = CF * CR * (b**2 + a * b)
N7 = (a+b) * CF * CR * u
ayn = np.array([N5,N6,N7])

### transfer functions
yawvtxy = tf(yawn, denom) ##yaw velocity to steer 
betatxy = tf(betan, denom) ##sideslip by steer
sstxy = tf(ayn, denom) ##lateral acceleration by steer
betagtxy = tf(betan, ayn) ##sideslip by lateral acceleration
yawatxy = tf(yawan, denom) ##yaw acceleration to steer
dbetatxy = tf(dbetan, denom) ##sideslip velocity by steer

### Steer function 
t=np.linspace(0,2,21)
tmid = 1.5 ##point about which the step function is symmetric
hw=1 ##half width of steer function duration
pwr=31.8 ##steer velocity in deg/sec
swamp= 20 ##degrees of steering wheel angle
steerdeg=(-2/np.pi*np.arctan(np.abs((t-tmid)/hw)**pwr)+1)*swamp ##in degrees

steer = steerdeg / 57.3

## Responses and plots
r = lsim(yawvtxy,steer / SR ,t) ##yaw response wrt wheel angle
beta = lsim(betatxy, steer / SR, t) ##beta response wrt wheel angle
ay = lsim(sstxy, steer / SR ,t)
rd = lsim(yawatxy, steer / SR , t) ##yaw acceleration response wrt wheel angle
betad = lsim(dbetatxy, steer / SR, t)
r = r[0]
beta = beta[0]
ay = ay[0]
rd = rd[0]
betad = betad[0]

mag,phase,w = bode(yawvtxy, Plot=False)
mag           = np.squeeze(mag)
w             = np.squeeze(w)
mag1,phase1,w1 = bode(betagtxy, Plot=False)
mag1           = np.squeeze(mag1)
w1             = np.squeeze(w1)
mag2,phase2,w2 = bode(sstxy, Plot=False)
mag2           = np.squeeze(mag2)
w2             = np.squeeze(w2)
mag3,phase3,w3 = bode(yawatxy, Plot=False)
mag3           = np.squeeze(mag3)
w3            = np.squeeze(w3)


## Outputs
### steady state gains
yawvss = N2 / D3 ##steady state yaw velocity gain rad/s/rad of WA
betass = N4 / D3 ##steady state sideslip angle gain rad/rad of WA
ayss = N7 / D3 ##steady state lateral acceleration gain ms^-2/rad
ss = betass / ayss ##steady state sideslip gain rad/ms^-2

ayssg = ayss / 9.807 / 57.3 ##steady state lateral acceleration gain g's/deg
steeringsens = ayssg * 100 / SR ##steering sensitivity. g's per 100 deg

yaw_bw = bandwidth(mag,w) 
beta_bw = bandwidth(mag1,w1) 
ay_bw = bandwidth(mag2,w2)

R_BW = yaw_bw/(2*np.pi) ##in Hertz
TAU_R = 2/yaw_bw ##in seconds

B_BW = beta_bw/(2*np.pi)##in Hertz
TAU_B = 2/beta_bw ##in seconds

AY_BW = ay_bw/(2*np.pi) ##in Hertz
TAU_AY = 2/ay_bw ##in seconds
print(TAU_AY)
wn=damp(yawvtxy)[0]
z=damp(yawvtxy)[1]
WN = wn[0] / (2*np.pi) ##first natural frequency in Hertz
ZETA = z[0] ##damping ratio

yawv_p2ss= ((np.max(r)/r[-1])-1)*100 ##yaw velocity peak to steady state ratio
###ayssg is steering sensitivity in terms of g's per 1 deg wheel angle
###ayss is steering sensitivity in terms of ms^-2 per radian wheel angle


fig1, ((ax1, ax2), (ax3, ax4)) = plt.subplots(2, 2)

fig1.suptitle('Frequency Domain Plots')
ax1.plot(w/2/np.pi,mag*100/SR,'b-')
ax1.set_xlim((0,4))
ax1.grid()
ax1.set_ylabel('Yaw velocity Gain (deg / sec / 100 deg SWA)')
ax1.legend('Theory')

ax2.plot(w1/2/np.pi,mag1 * 57.3 * 9.807,'b-')
ax2.set_xlim((0,4))
ax2.grid()
ax2.set_ylabel('Sideslip Gain')
ax2.legend('Theory')

ax3.plot(w2/2/np.pi,mag2* 100/ 57.3 /SR /9.807,'b-')
ax3.set_xlim((0,4))
ax3.grid()
ax3.set_ylabel('Lateral acceleration Gain (gs per 100 deg SWA)')
ax3.legend('Theory')

ax4.plot(w/2/np.pi,mag3*100/SR,'b-')
ax4.set_xlim((0,4))
ax4.grid()
ax4.set_ylabel('Yaw acceleratoin (deg / sec^2 / 100 deg SWA)')
ax4.legend('Theory')
fig1.show()

### Time plots

fig2, ((ax1, ax2), (ax3, ax4)) = plt.subplots(2, 2)

fig2.suptitle('Time Domain Plots')
ax1.plot(t, r * 180 / np.pi, 'k')
ax1.grid()
ax1.set_xlabel('Time (s)') 
ax1.set_ylabel('Yaw velocity (deg/sec)')

ax2.plot(t,beta * 180 / np.pi , 'r')
ax2.grid()
ax2.set_xlabel('Time (s)') 
ax2.set_ylabel('Sideslip angle (deg)')

ax3.plot(t,ay / 9.807 , 'b')
ax3.grid()
ax3.set_xlabel('Time (s)') 
ax3.set_ylabel('Lateral acceleration (g)')

ax4.plot(t ,steerdeg, 'y')
ax4.grid()
ax4.set_xlabel('Time (s)') 
ax4.set_ylabel('Steer (deg)')
plt.show()

