FROM fedora

RUN dnf -y update && \
    dnf -y install wget curl bash-completion && \
    dnf -y autoremove 

WORKDIR /tmp

RUN wget -O mongodb.rpm https://downloads.mongodb.com/compass/mongodb-mongosh-shared-openssl3-2.5.1.x86_64.rpm && \
    dnf -y install ./mongodb.rpm

