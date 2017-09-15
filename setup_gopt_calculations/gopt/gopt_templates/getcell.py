#!/bin/bash
# returns the optimal cell for calculation with necessary vacuum in XYZ
# default vacuum added: 6 Ang

import numpy as np
import os 

vacuum = 8

for f in os.listdir('.'):
    if f.endswith(".xyz"):
        xyzfilename = f
#xyzfilename = "zzz.xyz"
#print(xyzfilename)
rawdata = np.genfromtxt(xyzfilename,skip_header=2) 

#print(rawdata)
X = rawdata[:,1]
Y = rawdata[:,2]
Z = rawdata[:,3]

#print("Cell Size:")
xangs = np.around(np.max(X) - np.min(X) + vacuum, 2)
yangs = np.around(np.max(Y) - np.min(Y) + vacuum, 2)
zangs = np.around(np.max(Z) - np.min(Z) + vacuum, 2)

print(xangs, yangs, zangs)


#print("Rounded up:")
rxangs = np.ceil(np.max(X) - np.min(X) + vacuum)
ryangs = np.ceil(np.max(Y) - np.min(Y) + vacuum)
rzangs = np.ceil(np.max(Z) - np.min(Z) + vacuum)

#print(rxangs, ryangs, rzangs)


