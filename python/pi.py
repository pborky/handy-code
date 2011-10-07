from numpy import power,array,matrix
from numpyl.ma import masked_array
from numpy.random import uniform
from  matplotlib.pyplot import plt

def pi(n = 1000, internal = False, fig = None):
    '''Stochastic estimation of number pi based on Monte-Carlo method. '''
    n = int(n)
    radius = 1.0
    if fig is not None: ax = fig.add_subplot(111)
    try:
        r = uniform(low = -radius, high = radius, size= (n,2))
        inside = power(radius,2) >= power(r,2).sum(1)
        nk = inside.sum()
        if fig is not None:
            x = masked_array(r[:,0:1], mask=inside)
            y = masked_array(r[:,1:2], mask=inside)
            fig.hold(True)
            ax.plot(x.compressed().copy(), y.compressed().copy(),'.b')
            x.mask = ~x.mask
            y.mask = ~y.mask
            ax.plot(x.compressed(), y.compressed(),'.r')
    except MemoryError: # divide and conquer
        print '** reducing sample count to %d' % int(n/10)
        (n, nk) = array([ pi(n = n / 10, internal = True, fig = fig) for i in range(10) ]).sum(0)
    
    if internal:
        return (n, nk)
    
    if fig is not None: fig.show()
    
    p = 4.0 * nk / n
    print 'nk = %d, n = %d, pi = 4 nk / n = %f' % (nk, n, p)
    return p

if __name__=='__main__':
    pi(fig=plt.figure())
