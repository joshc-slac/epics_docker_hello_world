# This script can be sourced by your sh/bash shell startup, or later, in three ways
#
#	1. Use w/o  an argument to just define bash function env_add_pkg()
#		Example:
#			source $PSPKG_ROOT/etc/env_add_pkg.sh
#
#	2. Use with an argument to add that package/version to your environment
#		Example:
#			source $PSPKG_ROOT/etc/env_add_pkg.sh git-utils-0.3.0
#			source $PSPKG_ROOT/etc/env_add_pkg.sh ipython/0.13.1
#			source $PSPKG_ROOT/etc/env_add_pkg.sh hdfview/2.9
#		If you find yourself using this too much, you may get conflicts.
#		To resolve, build a release in $PSPKG_ROOT/source/releases w/ compatible package versions.
#
#	3. Once you've sourced the script at least once, use the convenient bash function env_add_pkg
#		Example:
#			source $PSPKG_ROOT/etc/env_add_pkg.sh git-utils-0.3.0
#			env_add_pkg ipython/0.13.1
#			env_add_pkg hdfview/2.9

if [ ."$PSPKG_ROOT" == . ]; then
	if [ -d /reg/g/pcds/pkg_mgr ]; then
    	PSPKG_ROOT='/reg/g/pcds/pkg_mgr'
	else
    	PSPKG_ROOT='/afs/slac/g/pcds/pkg_mgr'
	fi
fi
export PSPKG_ROOT

function env_add_pkg_usage()
{
	echo "
env_add_pkg prepends a specied pkg_mgr package or release to your
   env path variables: PATH, PYTHONPATH, LD_LIBRARY_PATH

Usage: env_add_pkg PKG_NAME/VERSION
   or  env_add_pkg RELEASE-VERSION

Examples:
env_add_pkg controls-0.0.7
env_add_pkg pyca/2.1.0
"
}

if [ "$ENV_ADD_PKG_DEFINED" != "1" ]; then
	ENV_ADD_PKG_FIRST_TIME=1
else
	ENV_ADD_PKG_FIRST_TIME=0
fi
function env_add_pkg()
{
	if [ $# -ne 1 ]; then
		env_add_pkg_usage
		return 1
	fi
	source $PSPKG_ROOT/etc/env_add_pkg.sh $1
}
export ENV_ADD_PKG_DEFINED=1

# Allow setting PSPKG_RELEASE via cmd line
if [ $# -eq 1 ]; then
	echo Setting PSPKG_RELEASE=$1
	export PSPKG_RELEASE=$1
fi

# PSPKG_RELEASE must be specified
if [ -z "$PSPKG_RELEASE" ]; then
	if [ "$ENV_ADD_PKG_FIRST_TIME" == 1 ]; then
		# Allow reading this script from .bash_profile to define env_add_pkg()
		return 0
	fi
	# Throw a usage msg for any additional usage w/o PSPKG_RELEASE
	env_add_pkg_usage
	return 1
fi

# Determine which architecture to use
export PSPKG_PROC=`${PSPKG_ROOT}/etc/pspkg_proc.sh`
export PSPKG_OS=`${PSPKG_ROOT}/etc/pspkg_os.sh`
export PSPKG_COMP=`${PSPKG_ROOT}/etc/pspkg_comp.sh`
export PSPKG_BUILD=`${PSPKG_ROOT}/etc/pspkg_build.sh`

export PSPKG_ARCH="${PSPKG_PROC}-${PSPKG_OS}-${PSPKG_COMP}-${PSPKG_BUILD}"
export PSPKG_RELDIR="${PSPKG_ROOT}/release/${PSPKG_RELEASE}/${PSPKG_ARCH}"

# Check for release/package directory
if [ ! -d $PSPKG_RELDIR ]; then
	echo PSPKG Error: Package $PSPKG_RELDIR not found!
	return 1
fi

echo Adding $PSPKG_RELEASE to your shell environment...
source $PSPKG_ROOT/etc/pathmunge.sh

# Doesn't look like this is needed as long as python and each of
# the packages dependents have already been added to your env
# # Add the release's python bin to the path
# pathmunge ${PSPKG_RELDIR}/python-bin

# Add the release/package to PATH
pathmunge ${PSPKG_RELDIR}/bin

# Add the release to LD_LIBRARY_PATH
ldpathmunge ${PSPKG_RELDIR}/lib
ldpathmunge ${PSPKG_RELDIR}/lib64
if [ X${EXTRA_LD_LIBS} != X ] ; then
    # LinuxRT sh clobbers LD_LIBRARY_PATH in every subshell!
    export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${EXTRA_LD_LIBS}"
fi

# Add the release to PYTHONPATH
if [ -d ${PSPKG_RELDIR}/python-site-packages ]; then
	pythonpathmunge ${PSPKG_RELDIR}/python-site-packages
fi
if [ -d ${PSPKG_RELDIR}/lib/*/site-packages ]; then
	pythonpathmunge ${PSPKG_RELDIR}/lib/*/site-packages
fi

