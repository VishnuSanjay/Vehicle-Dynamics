import numpy as np

def Pacejka4_Model(P,X)
    # x1  = X[:,0]  #Slip
    # x2  = X[:,1]  #Fz
    D   = (P[0] + P[1]/1000*X[:,1])*X[:,1]  ## peak value (normalized)
    fy  = D*np.sin(P[3]*np.arctan(P[2]* X[:,0]))
    
    return fy
~                                                                               
~                                                                               
~                                                                               
~                                       
