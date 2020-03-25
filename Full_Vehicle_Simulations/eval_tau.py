import numpy as np
from control.matlab import *
from control_self import *

def eval_tau(CF_list, params)
    global m kdash wb mf mr a b IZZ u TAU_AY steering_sens yawv_p2ss
    DR = params[0]
    CR = params[1]


    n = np.shape(CF_list)[0] ##always 3, never mind
    TAU_AY_LIST = np.zeros((n,1))

    for i in range(n):
        CF = CF_list[i]
        DE1 = m * u * IZZ
        DE2 = (IZZ * (CF+CR)) + (m * (a**2 * CF + b**2 * CR))
        DE3 = ((a+b)**2 * CF * CR / u) + (m * u * (b * CR - a * CF))
    
        N5 = u * IZZ * CF;
        N6 = CF * CR * (b**2 + a * b);
        N7 = (a+b) * CF * CR * u;
    
        denom = np.array([DE1 DE2 DE3])
        ayn = np.array([N5 N6 N7])
        sstxy = tf(ayn, denom) ## lateral acceleration by steer
        ay_bw = bandwidth_tf(sstxy);
        TAU_AY_list[i] = 2/ay_bw ## in seconds

    return TAU_AY_list	


