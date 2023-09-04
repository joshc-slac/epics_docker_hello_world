FROM registry.access.redhat.com/ubi7/ubi

RUN yum -y install git gcc make gcc-c++


RUN mkdir $HOME/EPICS \
&& cd $HOME/EPICS \
&& git clone https://github.com/epics-base/epics-base.git \
&& cd epics-base \
&& make

RUN bash
