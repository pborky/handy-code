#!/usr/bin/python
import pycurl as c
import re
import urllib
import sys

if len(sys.argv) < 2:
    print "Usage:"
    print "crawl.py <url> <ext1|ext2...>"
    exit()

url=sys.argv[1]
ext=sys.argv[2]

class Test:
    def __init__(self):
        self.contents = ''
    def body_callback(self, buf):
        self.contents += buf

t = Test()
a = c.Curl()
a.setopt(c.URL, url)
a.setopt(a.WRITEFUNCTION, t.body_callback)
a.perform()
a.close()
for u in re.findall(r'<a\s+href="([^"]+(?:%s))"' % ext, t.contents, flags = re.S):
    try: 
        fn = re.search(r'.*/(.*)', u).group(1)
        print '%s -> %s' % (u, fn)
        urllib.urlretrieve(u, filename=fn)
    except AttributeError: pass    
