import numpy as np

def enf_fcn(X,nf):
	''' 
	Takes in the ENF coefficients and the Aligning moment values to return the steer
	complaince in degrees 
	'''
	enfb = X[1]
	enfc = X[2]
	return enf = np.sign(nf) * enfb * enfc / 100 * np.log(np.absolute(nf) / enfc + 1)