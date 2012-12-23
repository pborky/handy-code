from operator import *
from math import *
from functools import partial

def com(*fncs):
    """ function composition 
        f1,f2,f3,... -> f1 o f2 o f3 o ... 
    """
    return lambda *args: reduce(
        id,
        reduce(
            lambda acc,fnc:(fnc(*acc),), 
            reversed(fncs), 
            args)
    )

def flip(f):
    """ flip function arguments 
            f(a1,a2,a3,...,an) -> f(an,...,a2,a1) 
        square:
            sqr = partial(flip(pow),2)
    """
    return lambda *a: f(*reversed(a))

def minkowski(center, point, n):
    """ minkowski metric demostration """
    rpow = flip(pow)
    pow_to_n = partial(rpow,n)
    pow_to_1n = partial(rpow,1./n)
    return pow_to_n(reduce(add, map(com(pow_to_1n,sub),center,point)))
