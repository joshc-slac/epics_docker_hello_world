# base image set to track what most of our production machines seem to be running
FROM registry.access.redhat.com/ubi7/ubi

ENV container docker

#Build SLAC EPICS Base
###############################################################################################
RUN yum -y install git gcc make gcc-c++ ncurses-devel wget

RUN wget http://mirror.centos.org/centos/7/os/x86_64/Packages/readline-devel-6.2-11.el7.x86_64.rpm && rpm -i readline-devel-6.2-11.el7.x86_64.rpm

RUN mkdir $HOME/EPICS && cd $HOME/EPICS && git clone https://github.com/slac-epics/epics-base
RUN cd $HOME/EPICS/epics-base && EPICS_BASE=${HOME}/EPICS/epics-base EPICS_HOST_ARCH=$(${EPICS_BASE}/startup/EpicsHostArch) make

# configuring environment for epics ##TODO: there's probably a cleaner way...
RUN echo "export EPICS_BASE=${HOME}/EPICS/epics-base" >> $HOME/.bashrc 
RUN source $HOME/.bashrc && echo "export EPICS_HOST_ARCH=$(${EPICS_BASE}/startup/EpicsHostArch)" >> $HOME/.bashrc
RUN source $HOME/.bashrc && echo "export PATH=${EPICS_BASE}/bin/${EPICS_HOST_ARCH}:${PATH}" >> $HOME/.bashrc
###############################################################################################


# Configure SLAC Directory & Process Management Environment
###############################################################################################
ENV IOC_COMMON=/reg/d/iocCommon
ENV T_A=rhel7-x86_64
ENV PYPS_SITE_TOP=/reg/g/pcds/pyps
ENV IOC_DATA=/reg/d/iocData
ENV HUTCH=wtf
ENV HUTCH_HOSTNAME=ctl-$HUTCH-cam-03
ENV PSPKG_ROOT=/reg/g/pcds/pkg_mgr

#ioc.sh
RUN mkdir -p /usr/lib/systemd/scripts
COPY fs/ioc.sh /usr/lib/systemd/scripts
RUN chmod +x /usr/lib/systemd/scripts/ioc.sh

#startup.cmd
RUN mkdir -p $IOC_COMMON/rhel7-x86_64/common
COPY fs/startup.cmd $IOC_COMMON/rhel7-x86_64/common/

# build filepaths and populate files invoked by startup.cmd
RUN mkdir -p /reg/g/pcds/pyps/config/ #location for common_dirs.sh
COPY fs/common_dirs.sh fs/hosts.special /reg/g/pcds/pyps/config/
RUN mkdir -p $IOC_COMMON/$T_A/common/ #location for kernel-modules.cmd
COPY fs/kernel-modules.cmd fs/kernel-module-dirs.cmd $IOC_COMMON/$T_A/common/
RUN mkdir -p $PYPS_SITE_TOP/apps/ioc/latest/ #location for initIOC
RUN cd $PYPS_SITE_TOP/apps/ioc/ && git clone https://github.com/pcdshub/IocManager.git latest
# this is unfortunate but a legacy of the existing architecture.
RUN cd $PYPS_SITE_TOP/apps/ && ln -s ioc iocmanager
###############################################################################################

# Start Spinning Hutch Up 
###############################################################################################
#NOTE(josh): hostname is specified during call to docker run in Makefile
RUN yum install -y hostname pciutils
RUN mkdir -p /reg/g/pcds/pkg_mgr/etc
COPY fs/etc /reg/g/pcds/pkg_mgr/etc

#somewhat silly symlink mechanism to control prod iocmanager releases per hutch. Here we point to latest, could be a "version" to
RUN mkdir -p $PYPS_SITE_TOP/config/$HUTCH/ && cd $PYPS_SITE_TOP/config/$HUTCH/ && ln -s $PYPS_SITE_TOP/apps/iocmanager/latest iocmanager

# this sucks hard but we're trying to reach parity with this existing system, in the future use any other pkg_mgr than one rolled from scratch plz!
RUN mkdir -p $PSPKG_ROOT/release/controls-basic-0.0.1/x86_64-rhel7-gcc48-opt
COPY fs/pkg_mgr $PSPKG_ROOT/release/controls-basic-0.0.1/x86_64-rhel7-gcc48-opt

# tragic mechanism for globally tracking 'os' per machine hostname, this is messy and problematicl initIOC.hutch:14 needs this file to exist
RUN mkdir -p /reg/g/pcds/pyps/config/.host/ && cd /reg/g/pcds/pyps/config/.host/ && touch $HUTCH_HOSTNAME 

# another tough relic: this one sets up "environment" for soft IOCs to run. kill this with fire as well.
RUN mkdir -p /reg/d/iocCommon/All
COPY fs/hutch_env_scripts/ /reg/d/iocCommon/All   
##############################################################################################
