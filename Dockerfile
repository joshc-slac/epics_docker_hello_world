# base image set to track what most of our production machines seem to be running
FROM registry.access.redhat.com/ubi7/ubi

# needed to build epics-base
RUN yum -y install git gcc make gcc-c++ ncurses-devel wget

RUN wget http://mirror.centos.org/centos/7/os/x86_64/Packages/readline-devel-6.2-11.el7.x86_64.rpm && rpm -i readline-devel-6.2-11.el7.x86_64.rpm

RUN mkdir $HOME/EPICS && cd $HOME/EPICS && git clone https://github.com/slac-epics/epics-base
RUN cd $HOME/EPICS/epics-base && EPICS_BASE=${HOME}/EPICS/epics-base EPICS_HOST_ARCH=$(${EPICS_BASE}/startup/EpicsHostArch) make

# configuring environment for epics ##TODO: there's probably a cleaner way...
RUN echo "export EPICS_BASE=${HOME}/EPICS/epics-base" >> $HOME/.bashrc 
RUN source $HOME/.bashrc && echo "export EPICS_HOST_ARCH=$(${EPICS_BASE}/startup/EpicsHostArch)" >> $HOME/.bashrc
RUN source $HOME/.bashrc && echo "export PATH=${EPICS_BASE}/bin/${EPICS_HOST_ARCH}:${PATH}" >> $HOME/.bashrc

# now for more SLAC stuff
# RUN cd $HOME && git clone https://github.com/pcdshub/shared-dotfiles.git dotfiles