#!env bash


pathpurge()
{
	PATH=`echo $PATH | sed -e "s%^$1$%%"`
	PATH=`echo $PATH | sed -e "s%^\(.*\):$1$%\1%"`
	PATH=`echo $PATH | sed -e "s%^\(.*\):$1:\(.*\)$%\1:\2%"`
	PATH=`echo $PATH | sed -e "s%^$1:\(.*\)$%\1%"`
}

pathmunge ()
{
	if [ "$1" == "" ] ; then
		echo Usage: pathmunge dirname
		return
	fi
#	if [ ! -d $1 ] ; then
#		echo Error: $1 is not a directory
#		echo Usage: pathmunge dirname
#		return
#	fi
	if [ "$PATH" == "" ] ; then
		export PATH=$1
		return
	fi
	pathpurge $1
	export PATH=$1:$PATH
}

edmpathpurge()
{
	EDMDATAFILES=`echo $EDMDATAFILES | sed -e "s%^$1$%%"`
	EDMDATAFILES=`echo $EDMDATAFILES | sed -e "s%^\(.*\):$1$%\1%"`
	EDMDATAFILES=`echo $EDMDATAFILES | sed -e "s%^\(.*\):$1:\(.*\)$%\1:\2%"`
	EDMDATAFILES=`echo $EDMDATAFILES | sed -e "s%^$1:\(.*\)$%\1%"`
}

edmpathmunge ()
{
	if [ "$1" == "" ] ; then
		echo Usage: edmpathmunge dirname
		return
	fi
#	if [ ! -d $1 ] ; then
#		echo Error: $1 is not a directory
#		echo Usage: edmpathmunge dirname
#		return
#	fi
	if [ "$EDMDATAFILES" == "" -o "$EDMDATAFILES" == "$1" ] ; then
		export EDMDATAFILES=$1
		return
	fi
	edmpathpurge $1
	export EDMDATAFILES=$1:$EDMDATAFILES
}

ldpathpurge()
{
	LD_LIBRARY_PATH=`echo $LD_LIBRARY_PATH | sed -e "s%^$1$%%"`
	LD_LIBRARY_PATH=`echo $LD_LIBRARY_PATH | sed -e "s%^\(.*\):$1$%\1%"`
	LD_LIBRARY_PATH=`echo $LD_LIBRARY_PATH | sed -e "s%^\(.*\):$1:\(.*\)$%\1:\2%"`
	LD_LIBRARY_PATH=`echo $LD_LIBRARY_PATH | sed -e "s%^$1:\(.*\)$%\1%"`
}

ldpathmunge ()
{
	if [ "$1" == "" ] ; then
		echo Usage: ldpathmunge dirname
		return
	fi
#	if [ ! -d $1 ] ; then
#		echo Error: $1 is not a directory
#		echo Usage: ldpathmunge dirname
#		return
#	fi
	if [ "$LD_LIBRARY_PATH" == "" -o "$LD_LIBRARY_PATH" == "$1" ] ; then
		export LD_LIBRARY_PATH=$1
		return
	fi
	ldpathpurge $1
	export LD_LIBRARY_PATH=$1:$LD_LIBRARY_PATH
}

pythonpathpurge()
{
	PYTHONPATH=`echo $PYTHONPATH | sed -e "s%^$1$%%"`
	PYTHONPATH=`echo $PYTHONPATH | sed -e "s%^\(.*\):$1$%\1%"`
	PYTHONPATH=`echo $PYTHONPATH | sed -e "s%^\(.*\):$1:\(.*\)$%\1:\2%"`
	PYTHONPATH=`echo $PYTHONPATH | sed -e "s%^$1:\(.*\)$%\1%"`
}

pythonpathmunge ()
{
	if [ "$1" == "" ] ; then
		echo Usage: pythonpathmunge dirname
		return
	fi
#	if [ ! -d $1 ] ; then
#		echo Error: $1 is not a directory
#		echo Usage: pythonpathmunge dirname
#		return
#	fi
	if [ "$PYTHONPATH" == "" -o "$PYTHONPATH" == "$1" ] ; then
		export PYTHONPATH=$1
		return
	fi
	pythonpathpurge $1
	export PYTHONPATH=$1:$PYTHONPATH
}

