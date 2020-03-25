def sr_func(SR,swa):
    #VHTRIMS Overall Steer Ratio fitting function
    #[RATIO] = sr_func(A0,A1,A2,B,C,D,F,G,swa)

    # sample data typical for full blown curve fit:
    #A0 = 15.57 Ratio Points
    #A1 = -0.4974 * 10**(-3)  # ASYMMETRY
    #A2 = -9.4283 * 10**(-6) #  BOW
    #B = -0.56 # LUMPINESS AMPLITUDE (Ratio Points)
    #C = -14.84 # LUMPINESS PHASE POSITION (Degrees SWA)
    #D = 2.70 # VARIABLE RATIO AMPLITUDE (Ratio Points)
    #F = 550.82 # VARIABLE RATIO RANGE (Degrees SWA)
    #G = 13.75 # VARIABLE RATIO ZERO OFFSET (Degrees SWA)

    A0 = SR[0]
    A1 = SR[1]
    A2 = SR[2]
    B = SR[3]
    C = SR[4]
    D = SR[5]
    F = SR[6]
    G = SR[7]

    #F[F==0] = np.finfo('d').max #realsteve could do the job, too.

    RATIO = A0 + A1/10**3*(swa) + A2/10**6*(swa)**2 + B*np.cos(2*(swa- C)/57.3) + D*np.exp(-(4*(swa-G)/F)**2) 
    return RATIO
