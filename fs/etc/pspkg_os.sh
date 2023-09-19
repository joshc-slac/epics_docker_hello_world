#!/bin/sh
#
# To be run as a program, not sourced. Check exit status.
#
kernel=`uname -s` || exit 1
os=''
if [ "$kernel" = "Linux" -a -r /etc/redhat-release ] ; then
    rh=`cat /etc/redhat-release | tr ' ' _`
    case $rh in
	Red_Hat_Enterprise_Linux_*_release_5.*)   os=rhel5 ;;
	Red_Hat_Enterprise_Linux_*_release_6.*)   os=rhel6 ;;
	Red_Hat_Enterprise_Linux_*_release_7.*)   os=rhel7 ;;
	CentOS_release_5.*)                       os=rhel5 ;;
	CentOS_release_6.*)                       os=rhel6 ;;
	CentOS_release_7.*)                       os=rhel7 ;;
	CentOS_Linux_release_7.*)                 os=rhel7 ;;
	Scientific_Linux_*_release_5.*)           os=rhel5 ;;
	Scientific_Linux_*_release_6.*)           os=rhel6 ;;
	Scientific_Linux_*_release_7.*)           os=rhel7 ;;
    esac
elif [ "$kernel" = "Linux" -a -r /etc/SuSE-release ] ; then
    suse=`cat /etc/SuSE-release | grep VERSION | tr -d ' '`
    case $suse in
      VERSION=11) os=suse11 ;;
      VERSION=11.*) os=suse11 ;;
      VERSION=12) os=suse12 ;;
      VERSION=12.*) os=suse12 ;;
    esac
elif [ "$kernel" = "Linux" -a -r /etc/lsb-release ] ; then
    . /etc/lsb-release
    if [ "$DISTRIB_ID" = "Ubuntu" ] ; then
	os=`echo ubu${DISTRIB_RELEASE} | cut -d. -f1`
    elif [ "$DISTRIB_ID" = "LinuxMint" ] ; then
	os=`echo mint${DISTRIB_RELEASE} | cut -d. -f1`
    fi
elif [ "$kernel" = "Linux" -a -r /etc/os-release ] ; then
    . /etc/os-release
    if [ "$NAME" = "Angstrom" ] ; then
	os=`echo ang_${VERSION_ID} | cut -d. -f1`
    fi
elif [ "$kernel" = "Linux" -a `ls -l /bin/ls | awk '{print $NF;}'` = busybox ] ; then
#    os=linuxRT
    os=rhel6
elif [ "$kernel" = "SunOS" ] ; then
    case `uname -r` in
	5.8)  os="sol8" ;;
	5.9)  os="sol9" ;;
	5.10) os="sol10" ;;
    esac
fi

if [ ."$os" == . ]; then
    # XXX should also try inxi -S
    echo "Could not determine os for $kernel" 2>&1
    exit 1
fi

echo $os
