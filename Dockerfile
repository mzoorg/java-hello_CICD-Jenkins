FROM ubuntu:18.04
ARG DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install -y \
    git \
    maven \
    default-jdk
RUN apt install -y apt-transport-https ca-certificates curl software-properties-common
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
RUN apt update
RUN apt install -y docker-ce
COPY deployer deployer/
COPY docker /etc/docker/
