#! /usr/bin/python

from math import sqrt, log
from sys import argv

L = int(argv[1])
m = 0

for i in range(1,L):
    for j in range(1,L):
        for k in range(1,L):
            if (i+j+k)%2==0:
                m +=  1/sqrt(i**2+j**2+k**2)
            else:
                m -=  1/sqrt(i**2+j**2+k**2)
m = 8*m - 6*log(2)

print("The Madelung constant for NaCl is ",m)
