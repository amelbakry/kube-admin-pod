From registry.opensource.zalan.do/stups/ubuntu:16.04.3-8
MAINTAINER "Ahmed.Elbakry@zalando.de"

# Installing python tools and dev packages
RUN apt-get update \
    && apt-get install -q -y --no-install-recommends  python3-pip python3-setuptools python3-wheel gcc sudo \
    && apt-get clean \ 
    && rm -rf /var/lib/apt/lists/*

# Set python 3 as the default python version
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 1 \
    && update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 1
RUN pip3 install --upgrade pip requests setuptools pipenv boto3

# Installing Kubectl 
RUN sudo apt-get update && sudo apt-get install -y apt-transport-https \
    && curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - \
    &&  sudo touch /etc/apt/sources.list.d/kubernetes.list \
    && echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list \
    && sudo apt-get update \
    && sudo apt-get install -y kubectl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Installing Client Packages
RUN sudo apt-get update \
    && sudo apt-get install -y \
            apt-transport-https \
            redis-tools \
            mysql-client \
            postgresql-client \
            net-tools \
            awscli \
            tcpdump \
            traceroute \
            apt-transport-https \
            curl \
            gnupg \
            jq \
            && apt-get clean \
            && rm -rf /var/lib/apt/lists/*

COPY endpoints-discovery.sh /
