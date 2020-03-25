import numpy as np
from control.matlab import *
import csaps

def bandwidth(mag,freq):
	"""
	Takes magnitude output from lsim, converts to db 
	and returns the first instance of frequency array at which 
	the magnitude drops by 3db from the first entry of the array
	"""
	
	mag = 20 * np.log10(mag)
	mag0 = mag[0]
	mag1 = mag0-3

	arr = np.linspace(0,20,200)
	spl = csaps.CubicSmoothingSpline(freq,mag)
	ynew = spl(arr)
	
	inx = (np.argmax(ynew-mag1<0))
	#print(mag1,mag,freq,inx)
	return arr[inx]

def bandwidth_tf(tf):
	"""
	Does the same as the above function, but with the transfer function as the input
	"""
	mag,phase,w = bode(tf, Plot=False)
	mag = np.squeeze(mag)
	w = np.squeeze(w)
	return bandwidth(mag,w)
