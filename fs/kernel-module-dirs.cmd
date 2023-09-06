if [ -z "$EPICS_SITE_TOP" ]; then
	EPICS_SITE_TOP=/reg/g/pcds/epics
fi
if [ -z "$PACKAGE_SITE_TOP" ]; then
	PACKAGE_SITE_TOP=/reg/g/pcds/package
fi

# Select default EDT driver if not overridden
if [ "$EDT_DRIVER" == "" ];
then
	if [ "$EDT_VER" == "" ];
	then
		#EDT_VER=R5.5.1.6
		EDT_VER=R5.5.8.2
	fi
	#EDT_DRIVER=$PACKAGE_SITE_TOP/EDTpdv/$EDT_VER/$T_A
	#EDT_DRIVER=$PACKAGE_SITE_TOP/EDTpdv/$EDT_VER
	EDT_DRIVER=$PACKAGE_SITE_TOP/EDTpdv/$EDT_VER/`uname -r`
fi
export EDT_DRIVER

# Select default ev2 driver if not overridden
if [ "$EV2_DRIVER" == "" ];
then
	if [ "$EV2_VER" == "" ];
	then
		EV2_VER=latest
	fi
	EV2_DRIVER=$EPICS_SITE_TOP/R3.14.12-0.4.0/modules/ev2_driver/$EV2_VER/
fi
export EV2_DRIVER

# Select default SLAC_AES_DRIVER if not overridden
if [ "$SLAC_AES_DRIVER" == "" ];
then
	if [ "$SLAC_AES_VER" == "" ];
	then
		#SLAC_AES_VER=latest
		SLAC_AES_VER=v5.15.2
	fi
	SLAC_AES_DRIVER=$PACKAGE_SITE_TOP/slaclab/aes-stream-drivers/$SLAC_AES_VER/install/`uname -r`/
fi
export SLAC_AES_DRIVER

# Select default TPR driver if not overridden
if [ "$TPR_DRIVER" == "" ];
then
	if [ "$TPR_VER" == "" ];
	then
		TPR_VER=latest
	fi
	TPR_DRIVER=$PACKAGE_SITE_TOP/slaclab/pcieTprDriver/$TPR_VER/
fi
export TPR_DRIVER
