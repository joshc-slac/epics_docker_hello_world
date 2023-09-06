#!/bin/sh
#
# To be run as a program, not sourced. Check exit status.
#
x=`uname -i`
if [ $x == unknown ]; then
    x=`uname -m`
fi
echo $x

