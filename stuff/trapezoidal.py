
# coding: utf-8

# ## Chapter 5
# # INTEGRALS AND DERIVATIVES

# In[65]:

from numpy import pi,linspace, sin
from bottleneck import nansum
from time import clock


# ### Trapezoidal Rule

# In[61]:

class trpzsum:
    
    divs = None
    
    def __init__(self,divisions=100):
        self.divs=divisions
        
    def wloop(self,func,a,b):
        divs=self.divs
        f = func
        sum = -(f(b)-f(a))/2.0
        for x in linspace(a,b):
            sum += f(x)
        return sum*(b-a)/divs
    
    def wlistmap(self,func,a,b):
        divs = self.divs
        f = func
        sum = -(f(b)-f(a))/2.0 + nansum(list(map(f,linspace(a,b,divs))))
        return sum*(b-a)/divs
    
    def wlistcompr(self,func,a,b):
        divs = self.divs
        f = func
        sum = -(f(b)-f(a))/2.0 + nansum([f(x) for x in linspace(a,b,divs)])
        return sum*(b-a)/divs
        


# In[62]:

integ = trpzsum(500)
wloop = integ.wloop
wlistmap = integ.wlistmap
wlistcompr = integ.wlistcompr
rng = range(2000)
tic = 0

tic = time()
for i in rng:
    wloop(lambda x: sin(x),0,pi)
print("with loop, walltime:", time()-tic)

tic = clock()
for i in rng:
    wlistmap(lambda x: sin(x),0,pi)
print("with list+map, walltime:", clock()-tic)

tic = clock()
for i in rng:
    wlistcompr(lambda x: sin(x),0,pi)
print("with map+comprehension, walltime:", clock()-tic)


# In[63]:

def timing(ndivs,ntimes):
    tic = clock()
    for k in range(ntimes):
        sum = 0
        for x in linspace(0,pi,ndivs):
            sum += sin(x)
        sum *= pi/ndivs
    print("with loop, walltime: ", clock()-tic)

    tic = clock()
    for k in range(ntimes):
        sum = nansum([sin(x) for x in linspace(0,pi,ndivs)])*pi/ndivs
    print("with map+comprehension, walltime: ", clock()-tic)

timing(500,2000)


# In[ ]:



