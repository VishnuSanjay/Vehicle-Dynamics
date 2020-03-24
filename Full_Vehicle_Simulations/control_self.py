import numpy as np
def bandwidth(mag,freq):
	"""
	Takes magnitude output from lsim, converts to db 
	and returns the first instance of frequency array at which 
	the magnitude drops by 3db from the first entry of the array
	"""
	mag = 20 * np.log10(mag)
	mag0 = mag[0]
	mag1 = mag0-3
	l = np.shape(mag)[0]
	inx = (np.argmax(mag-mag1>0))
	return freq[inx]