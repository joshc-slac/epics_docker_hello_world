#!/bin/sh
#
# To be run as a program, not sourced. Check exit status.
#
STARTUP=unknown
if [    -d "$EPICS_BASE/startup" ]; then
    STARTUP=$EPICS_BASE/startup
elif [  -d "$EPICS_BASE_RELEASE/startup" ]; then
    STARTUP=$EPICS_BASE_RELEASE/startup
elif [  -d "$EPICS_BASE_TOP/current/startup" ]; then
    STARTUP=$EPICS_BASE_TOP/current/startup
elif [  -d "/reg/g/pcds/package/epics/3.14/base/R3.14.12-0.4.0/startup" ]; then
    STARTUP=/reg/g/pcds/package/epics/3.14/base/R3.14.12-0.4.0/startup
elif [  -d "/afs/slac/g/lcls/epics/base/R3.14.12.4-1.2/startup" ]; then
    STARTUP=/afs/slac/g/lcls/epics/base/R3.14.12.4-1.2/startup
elif [  -d "/afs/slac/g/pcds/epics/base/R3.14.12-0.4.0/startup" ]; then
    STARTUP=/afs/slac/g/pcds/epics/base/R3.14.12-0.4.0/startup
fi
if [ -x "$STARTUP/EpicsHostArch" ]; then
	$STARTUP/EpicsHostArch
	exit 0
fi

exit 1
