#!/bin/bash
while true; do
nc nat.brmlab.cz 80 <<-EOF
POST /brmd/alphasign-set HTTP/1.1
Host: nat.brmlab.cz
Connection: keep-alive
Content-Length: 73
Cache-Control: max-age=0
Origin: http://nat.brmlab.cz
User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/535.7 (KHTML, like Gecko) Chrome/16.0.912.63 Safari/535.7
Content-Type: application/x-www-form-urlencoded
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
Referer: http://nat.brmlab.cz/brmd/alphasign
Accept-Encoding: gzip,deflate,sdch

mode=flash&text=%3Cgreen%3E-%3DMUSHROOM%3D-%3C%2Fgreen%3E&beep=0&s=update
EOF
sleep 5
done
