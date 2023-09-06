#!/bin/sh
#
# To be run as a program, not sourced. Check exit status.
#
gcc_location=`which gcc 2>/dev/null`
if [ ."$gcc_location" == . ]; then
# This is a cheat.  No compiler == linuxRT.  Unless rhel7.
    OS=`${PSPKG_ROOT}/etc/pspkg_os.sh`
    if [ $OS == rhel7 ]; then
	echo gcc48
    else
        echo gcc44
    fi
else
    #echo gcc`gcc --version | grep '^gcc (.*' | awk '{print $3}' | sed -e 's,\.,,' -e 's,\..*,,'`

    # 1. Get version information
    # 2. Keep just first line. Examples:
    #    gcc (SUSE Linux) 4.3.4 [gcc-4_3-branch revision 152973]
    #    gcc (GCC) 4.4.7 20120313 (Red Hat 4.4.7-3)
    # 3. Discard parenthetical information between "gcc" and version number
    # 4. Remove first dot
    # 5. Remove everything after second dot

    # The first sed in this one is too greedy... the (.*) ends up matching
    #
    #     "(GCC) 4.4.7 20120313 (Red Hat 4.4.7-3)"
    #
    # instead of
    #
    #     "(GCC)"
    #
    # as is intended.
    #echo gcc`gcc --version | head -1 | sed 's,(.*),,' | awk '{print $2}' | sed -e 's,\.,,' -e 's,\..*,,'`

    echo gcc`gcc --version | head -1 | sed 's,([^)]*),,' | awk '{print $2}' | sed -e 's,\.,,' -e 's,\..*,,'`
fi
