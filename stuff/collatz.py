from sys import argv

xmax = int(argv[1])

for x in range(3,xmax):
    while x > 2:
        if x%2 == 0:
            x = x//2
        else:
            x = 3*x+1
        #print(x)
        
