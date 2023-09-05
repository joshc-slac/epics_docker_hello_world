# base image set to track what most of our production machines seem to be running
FROM registry.access.redhat.com/ubi7/ubi

# needed to build epics-base
RUN yum -y install git gcc make gcc-c++

RUN mkdir $HOME/EPICS \
&& cd $HOME/EPICS \
&& git clone https://github.com/epics-base/epics-base.git \ 
&& cd epics-base \
&& make # TODO: change this to the slac-epics base: https://github.com/slac-epics/epics-base which is currently not building

# configuring environment for epics ##TODO: there's probably a cleaner way...
RUN echo "export EPICS_BASE=${HOME}/EPICS/epics-base" >> $HOME/.bashrc && source $HOME/.bashrc \
&& echo "export EPICS_HOST_ARCH=$(${EPICS_BASE}/startup/EpicsHostArch)" >> $HOME/.bashrc && source $HOME/.bashrc\
&& echo "export PATH=${EPICS_BASE}/bin/${EPICS_HOST_ARCH}:${PATH}" >> $HOME/.bashrc && source $HOME/.bashrc 
