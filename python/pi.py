from numpy import power,array
from numpy.ma import masked_array
from numpy.random import uniform
from matplotlib.pyplot import plot,hold,show

def pi(n = 1000, internal = False, draw = False):
    '''Stochastic estimation of number "pi" based on Monte-Carlo method. '''
    n = int(n)
    radius = 1.0
    try:
        r = uniform(low = -radius, high = radius, size= (n,2))
        inside = power(radius,2) >= power(r,2).sum(1)
        nk = inside.sum() # number of hits inside the circle
        if draw:
            x = masked_array(r[:,0:1], mask=inside)
            y = masked_array(r[:,1:2], mask=inside)
            hold(True)
            plot(x.compressed(), y.compressed(),'.b')
            x = masked_array(r[:,0:1], mask=~inside)
            y = masked_array(r[:,1:2], mask=~inside)
            plot(x.compressed(), y.compressed(),'.r')
    except MemoryError: # divide and conquer
        print '** reducing sample count to %d' % int(n/100)
        (n, nk) = array([ pi(n = n / 1E2, internal = True ) for i in range(int(1E2)) ]).sum(0)
    
    if internal:
        return (n, nk)
    
    if draw: show()
    
    p = 4.0 * nk / n
    print 'nk = %d, n = %d, pi = 4 nk / n = %f' % (nk, n, p)
    return p

if __name__=='__main__':
    pi(n = 1E4, draw = True)
