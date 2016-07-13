#
# http://qiita.com/pottava/items/452bf80e334bc1fee69a
# docker pull centos:6.8
# docker run -it centos:6.8 /bin/bash
# <install>
#  install component on container( write commands on this file)
#  $eixt
# docker commit  [CONTAINERNAME] vagrant/nginx
# docker run -it vagrant/nginx /bin/bash
#  goto <install>
# docker rm $(docker ps -aq)
# docker rm $(docker ps -f status=exited -q)
#
# <build>
# docker build -t my-nodejs .
# <use>
# docker run -it my-nodejs /bin/bash

FROM node:5-slim

RUN set -x && \
    apt-get -yq update && \
    apt-get -yq install git net-tools sudo bzip2

RUN set -x && \
    npm install -g bower@1.7.9 grunt-cli@1.2.0 gulp@3.9.1 yo@1.8.4 && \
    npm install -g generator-angular-fullstack@3.7.6

# create working user
RUN adduser --disabled-password --gecos "yeoman" yo && \
    echo "yo ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

ENV HOME /home/yo
RUN mkdir /src && chown yo:yo /src
WORKDIR /src

USER yo

CMD /bin/bash
