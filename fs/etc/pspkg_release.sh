#!/bin/sh
#
# To be run as a program, not sourced. Check exit status.
#
if [ ."$PSPKG_RELEASE" == . ]; then
    echo 'everything'
else
    echo "$PSPKG_RELEASE"
fi
exit 0
