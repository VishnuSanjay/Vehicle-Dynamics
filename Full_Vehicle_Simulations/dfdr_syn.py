import numpy as np
from control.matlab import *

def dfdr_syn(Y):
    global m kdash wb mf mr a b IZZ u TAU_AY steering_sens yawv_p2ss X y
    DF = Y[0]
    DR = Y[1]
    CF =  57.3 * mf * 9.81 / DF## Front tire cornering stiffness, input in N/deg, gets converted to N/rad
    CR =  57.3 * mr * 9.81 / DR## Same as above, for rear tires


    DE1 = m * u * IZZ
    DE2 = (IZZ * (CF+CR)) + (m * (a**2 * CF + b**2 * CR))
    DE3 = ((a+b)**2 * CF * CR / u) + (m * u * (b * CR - a * CF))

    N1 = a * m * u * CF
    N2 = (a+b) * CF * CR
    yawn = np.array([np.float(N1) np.float(N2)])

    N5 = u * IZZ * CF;
    N6 = CF * CR * (b**2 + a * b);
    N7 = (a+b) * CF * CR * u;

    denom = np.array([np.float(DE1), np.float(DE2), np.float(DE3)])
    ayn = np.array([np.float(N5), np.float(N6), np.float(N7)])
    yawvtxy = tf(yawn, denom) ##yaw velocity to steer 
    sstxy = tf(ayn, denom) ## lateral acceleration by steer
    ay_bw = bandwidth_tf(sstxy)
    TAU_AY_val = 2/ay_bw   ##in seconds

    r,t = step(yawvtxy)
    r = r[0]	
    yawv_p2ss_val= (np.max[r]/r[end])
    X = np.array([TAU_AY_val, yawv_p2ss_val])
    y = Y
    error = X - [TAU_AY yawv_p2ss]
    return error 	
