# This should be sourced by your bash or bourne shell
# to remove any prior PSPKG_RELEASE from your env paths

if [ ."$PSPKG_ROOT" == . ]; then
    PSPKG_ROOT='/reg/g/pcds/pkg_mgr'
fi

IFS_ORIG="$IFS"

clean() {
    IFS=':'
    result=""
    for i in $1; do
	if echo $i | grep $PSPKG_ROOT > /dev/null; then
	    :
	elif [ "${result}:" == ":" ]; then
	    result="$i"
	else
	    result="${result}:$i"
	fi
    done
    IFS="${IFS_ORIG}"
    echo "$result"
}

export PATH=`clean "$PATH"`
export PYTHONPATH=`clean "$PYTHONPATH"`
export LD_LIBRARY_PATH=`clean "$LD_LIBRARY_PATH"`
