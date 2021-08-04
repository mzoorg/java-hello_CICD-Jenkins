FROM ubuntu:18.04
ARG DEBIAN_FRONTEND=noninteractive
ARG ssh_prv_key
ARG ssh_pub_key

RUN apt update && apt install -y \
    git \
    maven \
    default-jdk \
    openssh-server

RUN apt install -y apt-transport-https ca-certificates curl software-properties-common
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
RUN apt update
RUN apt install -y docker-ce

# Mkdir .ssh
RUN mkdir -p /root/.ssh && \
    touch /root/.ssh/known_hosts && \
    chmod -R 0777 /root/.ssh

# Add the keys and set permissions
RUN echo "$ssh_prv_key" > /root/.ssh/id_rsa && \
    echo "$ssh_pub_key" > /root/.ssh/id_rsa.pub && \
    chmod 600 /root/.ssh/id_rsa && \
    chmod 600 /root/.ssh/id_rsa.pub

COPY deployer deployer/
COPY docker /etc/docker/
