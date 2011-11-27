#!/usr/bin/python

import io
import os
import IPython.external.path as path
import sys
import md5
import pyexif

if len(sys.argv) < 2:
    print ''' 
Usage:
    duplicates.py <path> [remove|symlink]
'''
    exit(1)

print "Search path: %s" % str(sys.argv[1])

remove = False
link = False

if len(sys.argv) == 3:
    if sys.argv[2] == 'remove':
        remove = True
    elif sys.argv[2] == 'symlink':
        link = True


p = path.path(sys.argv[1])
d = {}
c = {}
dup = set()
for f in p.walk():
    if not f.isdir() and not f.islink():
        s = io.open(f, 'rb')
        try:
            h = md5.md5(s.read())
            h = h.hexdigest()
            #print '{}'.format(h)
            if h not in d:
                d[h] = []
            d[h].append(f)
            c[h] = len(d[h])
            if c[h] > 1:
                dup.add(h)
        finally:
            s.close()
for h in dup:
    print "\nhash %s" % str(h)
    o = d[h].pop(0)
    print "\tfile %s (origin)" % str(o)
    for f in d[h]:
        if remove:
            os.remove(f)
            print "\tfile %s (removed)" % str(f)
        elif link:
            os.remove(f)
            os.symlink(o,f)
            print "\tfile %s (linked)" % str(f)
        else:
            print "\tfile %s (duplicate)" % str(f)
