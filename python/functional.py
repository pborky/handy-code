
from operator import *
from math import *
from functools import partial

def com(*fncs):
    return lambda *args: reduce(
        id,
        reduce(
            lambda acc,fnc:(fnc(*acc),), 
            reversed(fncs), 
            args)
    )

def flip(f):
    return lambda *a: f(*reversed(a))

def dist(center, point):
  return sqrt(reduce(add, map(com(partial(flip(pow),2),sub),center,point)))
