#!/bin/sh
#
# To be run as a program, not sourced. Check exit status.
#
if [ ."$PSPKG_BUILD" == . ]; then
    echo opt
elif [ "$PSPKG_BUILD" == 'dbg' ]; then
    echo "$PSPKG_BUILD"
elif [ "$PSPKG_BUILD" == 'opt' ]; then
    echo "$PSPKG_BUILD"
else
    echo "Invalid PSPKG_BUILD '$PSPKG_BUILD'" 2>&1
    exit 1
fi
exit 0
