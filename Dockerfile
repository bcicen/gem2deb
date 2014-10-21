FROM ubuntu:trusty

MAINTAINER Bradley Cicenas <bradley.cicenas@gmail.com>

ADD run.sh /

RUN chmod +x /run.sh && \
    apt-get -yqq update && \
    apt-get -yq install ruby ruby-bundler gem2deb git && \
    apt-get clean

VOLUME /data

CMD /bin/bash /run.sh
