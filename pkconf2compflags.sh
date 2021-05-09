#!/bin/bash

CFLAGS=`pkg-config $1 --cflags`

for CFLAG in $CFLAGS
do
    echo $CFLAG >> $2/compile_flags.txt
done
