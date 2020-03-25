import numpy as np
from control.matlab import *
from control_self import *
import matplotlib.pyplot as plt

## Inputs for the simulation and unit conversion:
m = 1600 ## mass of the vehicle, in kgs
kdash = 0 ## k' = k/(a*b) - 1
wb = 2.747 ## wheelbase in metres
a = wb * 600 / m ## distance from CG to front axle in m
b = wb * 1000 / m ## distance from CG to rear axle in m
mf = m * b / (a+b) ## mass on front axle, kg
mr = m * a / (a+b)
IZZ = (kdash+1) * m * a * b ## yaw moment of inertia of the vehicle, in kg m^2
u = 100 / 3.6 ## vehicle forward velocity in m/s
SR = 16 ## degrees of steer wheel angle per degree of wheel angle. Assumed constant

DR = np.linspace(2,4,3)
l1 = np.shape(DR)[0]
K = np.linspace(1,6,6) ## understeer DF-DR in deg/g
l2 = np.shape(K)[0]

### Steer function 
t = np.linspace(0,1.5,16)
tmid = 1.5 ## point about which the step function is symmetric
hw = 1 ## half width of steer function duration
pwr = 147 ## steer velocity in deg/sec
swamp= 20 ## degrees of steering wheel angle
steerdeg= (-2/np.pi*np.arctan(np.abs((t-tmid)/hw)**pwr)+1)*swamp ##  in degrees
steer = steerdeg / 57.3


CR = np.zeros((l1,1))
yawv_p2ss = np.zeros((l2,l1))
TAU_AY = np.zeros((l2,l1))

for j in range(l1):
    CR[j] =  57.3 * mr * 9.81 / DR[j] ## Same as above, for rear tires
    
    DF = np.zeros((l2,1))
    CF = np.zeros((l2,1))	
    
    for i in range(l2):
        ## Front tire cornering stiffness, input in N/deg, gets converted to N/rad
        DF[i] = K[i] + DR[j]
        CF[i] =  57.3 * mf * 9.81 / DF[i]

        ### Note: CF(i) and CR(j) can also be considered as effective front and rear
        ### cornering compliances, according to the paper by Bundorf and Leffert
        D1 = m * u * IZZ;
        D2 = (IZZ * (CF[i]+CR[j])) + (m * (a**2 * CF[i] + b**2 * CR[j]))
        D3 = ((a+b)**2 * CF[i] * CR[j] / u) + (m * u * (b * CR[j] - a * CF[i]))
        denom = np.array([D1,np.float(D2), np.float(D3)])

        ### Yaw velocity numerator
        N1 = a * m * u * CF[i]
        N2 = (a+b) * CF[i] * CR[j]
        yawn = np.array([np.float(N1), np.float(N2)])
        yawan = np.array([np.float(N1), np.float(N2), 0])
        
        ### Sideslip angle numerator
        N3 = IZZ * CF[i]
        N4 = (CF[i] * CR[j] * (b**2 + a * b) / u) - a * m * u * CF[i]
        betan = np.array([np.float(N3), np.float(N4)])
        dbetan = np.array([np.float(N3), np.float(N4), 0])
        
        ### Lateral acceleration numerator
        N5 = u * IZZ * CF[i]
        N6 = CF[i] * CR[j] * (b**2 + a * b)
        N7 = (a+b) * CF[i] * CR[j] * u
        ayn = np.array([np.float(N5), np.float(N6), np.float(N7)])
        
        ### transfer functions
        yawvtxy = tf(yawn, denom) ## yaw velocity to steer
        betatxy = tf(betan, denom) ## sideslip by steer
        sstxy = tf(ayn, denom) ## lateral acceleration by steer
        betagtxy = tf(betan, ayn) ## sideslip by lateral acceleration
        yawatxy = tf(yawan, denom) ## yaw acceleration to steer
        dbetatxy = tf(dbetan, denom) ## sideslip velocity by steer
        
        yaw_bw=bandwidth_tf(yawvtxy) 
        beta_bw=bandwidth_tf(betatxy)
        ay_bw=bandwidth_tf(sstxy)
        

        R_BW = yaw_bw/(2*np.pi) ## in Hertz
        TAU_R = 2/yaw_bw ## in seconds
        
        B_BW = beta_bw/(2*np.pi) ## in Hertz
        TAU_B = 2/beta_bw ## in seconds
        
        AY_BW = ay_bw/(2*np.pi) ## in Hertz
        TAU_AY[i,j] = 2/ay_bw  ## in seconds
        
        wn=damp(yawvtxy, doprint=False)[0] ##natural freq
        z = damp(yawvtxy, doprint=False)[1] ## damping ratio, twice
        WN = wn[0] / (2*np.pi) ##first natural frequency in Hertz
        ZETA = z[0] ## damping ratio
        
        r = lsim(yawvtxy,steer / SR ,t) ##  yaw response wrt wheel angle
        r = r[0]
        yawv_p2ss[i,j] = (np.max(r)/r[-1]) ## yaw velocity peak to steady state ratio

print(yawv_p2ss, TAU_AY)

## Carpet plot time
fig, ax = plt.subplots()
for i in range(l2):
    ax.plot(TAU_AY[i,:], yawv_p2ss[i,:],'b')
    curr_k = "K = {}".format(K[i])
    ax.text(TAU_AY[i,-1]*1.001,yawv_p2ss[i,-1]*1.001,curr_k)

for i in range(l1):
    ax.plot(TAU_AY[:,i], yawv_p2ss[:,i],'go')
    curr_dr = "DR = {}".format(DR[i])
    ax.text(TAU_AY[0,i],yawv_p2ss[0,i]*0.985,curr_dr)

ax.set_xlabel('Lateral acceleration response time(seconds)')
ax.set_ylabel('Yaw velocity peak to steady state ratio (%)')
plt.show()
