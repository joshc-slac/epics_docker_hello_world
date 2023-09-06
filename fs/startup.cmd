#!/bin/sh
# =============================================================
# Master startup script for all PCDS rhel7 IOC hosts
# This script is run as the BOOTFILE via
# /etc/rc.d/init.d/ioc
# Must be run as the "root" user.

# Set the target architecture
export T_A=rhel7-x86_64

# =============================================================
# Setup the common directory env variables
if [ -f /reg/g/pcds/pyps/config/common_dirs.sh ]; then
	source /reg/g/pcds/pyps/config/common_dirs.sh
else
	source /afs/slac/g/pcds/config/common_dirs.sh
fi

# Note(josh): does not exist on ctl-lfe-cam-02, skipping
if [ -f $IOC_COMMON/$T_A/facility/ioc_env.sh ]; then
	# =========================================
	# Setup environment for ioc users
	# =========================================
	if [ ! -e "/etc/profile.d" ]; then
		mkdir /etc/profile.d
	fi
	cp $IOC_COMMON/$T_A/facility/ioc_env.sh /etc/profile.d/
	chmod 0777 /etc/profile.d/ioc_env.sh 
fi

# Note(josh): does not exist on ctl-lfe-cam-02, skipping
# Turn on CORE Dumps, memory locking, and real time scheduling
#sysctl -w kernel.core_pattern=/tmp/%p.core
#ulimit -c unlimited
#ulimit -l unlimited
#ulimit -r unlimited

# =============================================================
# Load Kernel Modules 
# =============================================================
source $IOC_COMMON/$T_A/common/kernel-modules.cmd

# Some older versions of iocManager use PYPS_ROOT instead of PYPS_SITE_TOP
PYPS_ROOT=$PYPS_SITE_TOP

if ! ps -C procmgrd0 > /dev/null; then
	# Launch the iocManager
	$PYPS_SITE_TOP/apps/ioc/latest/initIOC
fi
