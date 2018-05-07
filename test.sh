#!/bin/sh

URL=$1
SUCCESS='### SUCCESS: Files Are Identical! ###'
FAIL='### WARNING: Files Are Different! ###'

curl -r 0-4194303 $URL -o curled.dat

./Chunky -urlString $URL
./Chunky -urlString $URL -output specified.dat -chunkSize 1048576 -nChunks 4
./Chunky -urlString $URL -output single.dat -chunkSize 4194304 -nChunks 1

cmp --silent curled.dat data.dat && echo $SUCCESS || echo $FAIL
cmp --silent curled.dat specified.dat && echo $SUCCESS || echo $FAIL
cmp --silent curled.dat single.dat && echo $SUCCESS || echo $FAIL

rm curled.dat
rm data.dat
rm specified.dat
rm single.dat