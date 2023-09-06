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
#ioc.sh
RUN mkdir -p /usr/lib/systemd/scripts
COPY fs/ioc.sh /usr/lib/systemd/scripts
RUN chmod +x /usr/lib/systemd/scripts/ioc.sh

#startup.cmd
RUN mkdir -p $IOC_COMMON/rhel7-x86_64/common
COPY fs/startup.cmd $IOC_COMMON/rhel7-x86_64/common/

# build filepaths and populate files invoked by startup.cmd
RUN mkdir -p /reg/g/pcds/pyps/config/ #location for common_dirs.sh
COPY fs/common_dirs.sh /reg/g/pcds/pyps/config/
RUN mkdir -p $IOC_COMMON/$T_A/common/ #location for kernel-modules.cmd
COPY fs/kernel-modules.cmd fs/kernel-module-dirs.cmd $IOC_COMMON/$T_A/common/
RUN mkdir -p $PYPS_SITE_TOP/apps/ioc/latest/ #location for initIOC
RUN cd $PYPS_SITE_TOP/apps/ioc/ && git clone https://github.com/pcdshub/IocManager.git latest
###############################################################################################

# Start Spinning Hutch Up 
###############################################################################################
#NOTE(josh): hostname is specified during call to docker run in Makefile
RUN yum install -y hostname

###############################################################################################