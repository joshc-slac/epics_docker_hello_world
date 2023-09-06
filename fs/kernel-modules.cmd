# =========================================
# Set environment variables for kernel drivers
# =========================================
export TZ=PST8PDT

if [ -z "$IOC_COMMON" ]; then
	export IOC_COMMON=/reg/d/iocCommon
fi
if [ -z "$T_A" ]; then
	export T_A=rhel7-x86_64
fi
# =========================================
# Find the packages and driver paths, allowing override
# of the default driver version or path via host specific file
# =========================================
if [ -f $IOC_COMMON/hosts/`hostname`/kernel-module-dirs.cmd ];
then
	source $IOC_COMMON/hosts/`hostname`/kernel-module-dirs.cmd
fi
source $IOC_COMMON/$T_A/common/kernel-module-dirs.cmd

# =================================================
# Install the kernel drivers for installed hardware
# =================================================
lspci_edt=`lspci -d 123d:* -n`
if [ "$lspci_edt" != "" ]; then
	if [ -d $EDT_DRIVER/ -a ! -e /dev/edt0 -a $UID -eq 0 ]; then
		echo Installing EDT driver: $EDT_DRIVER
		if [ ! -e /opt/EDTpdv/version -o "R$(cat /opt/EDTpdv/version)" != "${EDT_VER}" ]; then
			mkdir -p /opt/EDTpdv
			mount --bind $EDT_DRIVER /opt/EDTpdv
			mount --bind $PACKAGE_SITE_TOP/EDTpdv/${EDT_VER}/pdv /opt/pdv
		fi
		/opt/EDTpdv/edtinit.sh start
	else
		echo EDT driver dir not found: $EDT_DRIVER
	fi
else
	echo EDT framegrabber not found.
fi

# Check for MRF EVR boards w/ PLX 9030 bridge
lspci_mrf_evr=`lspci -d 10b5:9030 -n`
# Also check for SLAC EVR
lspci_slac_evr=`lspci -d 1a4a:2010 -n`
if [ "$lspci_mrf_evr" != "" -o "$lspci_slac_evr" != "" ]; then
	if [ -n "$EV2_DRIVER" -a -d $EV2_DRIVER/ ]; then
		echo Installing EVENT2 driver: $EV2_DRIVER
		$EV2_DRIVER/driver/evr_load_module
		if [ -e /dev/era0 ];
		then
			chmod a+rw /dev/er*
		else
			/sbin/rmmod evr_device
		fi
		if [ -e /dev/ega0 ];
		then
			chmod a+rw /dev/eg*
		else
			/sbin/rmmod pci_mrfevg
		fi
	else
		echo event2 driver dir not found: $EV2_DRIVER
	fi
else
	echo EVR not found.
fi

# Check for SLAC TPR board
lspci_slac_tpr=`lspci -d 1a4a:2011 -n`
if [ "$lspci_slac_tpr" != "" ]; then
	if [ -n "$TPR_DRIVER" -a -f $TPR_DRIVER/`uname -r`/tpr.ko ]; then
		echo Installing SLAC TPR driver: $TPR_DRIVER
		(cd $TPR_DRIVER/`uname -r`; $TPR_DRIVER/src/load_module.sh)
	else
		export TPR_DRIVER=${TPR_DRIVER:=TPR_DRIVER}
		echo SLAC TPR driver kernel object not found: $TPR_DRIVER/`uname -r`/tpr.ko
	fi
else
	echo SLAC TPR not found.
fi

lspci_perle=`lspci -d 155f:* -n`
if [ "$lspci_perle" != "" ]; then
	if [ -n $PERLE_SERIAL_DRIVER -a -d $PERLE_SERIAL_DRIVER/ ]; then
		echo Installing PERLE driver: $PERLE_SERIAL_DRIVER
		insmod $PERLE_SERIAL_DRIVER/perle-serial.ko
	else
		echo Perle Serial driver dir not found: $PERLE_SERIAL_DRIVER
	fi
else
	echo Perle device not found.
fi

#lspci_megaraid=`lspci -d 1000:005d -n`
#if [ "$lspci_megaraid" != "" ]; then
#	if [ -n $MEGARAID_DRIVER -a -d $MEGARAID_DRIVER/ ]; then
#		echo Installing MegaRaid driver: $MEGARAID_DRIVER
#		insmod $MEGARAID_DRIVER/megaraid_sas.ko
#
#		#megaRAID command line utility
#		ln -s $MEGARAID_DRIVER/storcli64 /usr/bin/storcli64
#	else
#		echo Megaraid driver dir not found: $MEGARAID_DRIVER
#	fi
#else
#	echo MegaRaid device not found.
#fi

lspci_SLAC_datadev=`lspci -d 1a4a:2030 -n`
if [ "$lspci_SLAC_datadev" != "" ]; then
	if [ -n "$SLAC_AES_DRIVER" -a -f $SLAC_AES_DRIVER/datadev.ko ]; then
		echo Installing SLAC datadev driver: $SLAC_AES_DRIVER
		rmmod datadev
		insmod $SLAC_AES_DRIVER/datadev.ko cfgSize=0x200000 cfgRxCount=256 cfgTxCount=16
		chmod 666 /dev/datadev*
	else
		echo SLAC AES driver not found: $SLAC_AES_DRIVER/datadev.ko
	fi
else
	echo SLAC datadev device not found.
fi

lspci_SLAC_pgp=`lspci -d 1a4a:2020 -n`
if [ "$lspci_SLAC_pgp" != "" ]; then
	if [ -n "$SLAC_AES_DRIVER" -a -f $SLAC_AES_DRIVER/pgpcard.ko ]; then
		echo Installing SLAC pgpcard driver: $SLAC_AES_DRIVER
		rmmod pgpcard
		rmmod pgpcardG3
		insmod $SLAC_AES_DRIVER/pgpcard.ko cfgRxCount=256 cfgTxCount=64
		chmod 666 /dev/pgpcard*
	else
		echo SLAC pgpcard driver not found: $SLAC_AES_DRIVER/pgpcard.ko
	fi
else
	echo SLAC pgpcard device not found.
fi

# Cleanup env so defaults won't stick during debugging
unset EDT_DRIVER;			unset EDT_VER
unset EV2_DRIVER;			unset EV2_VER;
unset TPR_DRIVER;			unset TPR_VER;
unset MEGARAID_DRIVER;		unset MEGARAID_VER
unset PERLE_SERIAL_DRIVER;	unset PERLE_VER

# END of kernel-modules.cmd =========================================
