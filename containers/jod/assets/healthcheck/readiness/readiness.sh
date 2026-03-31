#!/bin/sh

set -e;

D=/opt/app/healthcheck/readiness

cd $D

rm -rf teste.pdf
echo "Ready" > teste.txt

curl -s -F file=@teste.txt "http://127.0.0.1:8080/conversion?format=pdf" -o teste.pdf

exit 0