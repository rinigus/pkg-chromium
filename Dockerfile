FROM ubuntu:18.04

RUN \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && apt-get update -y

RUN apt-get install -y ca-certificates
RUN sed -i 's|http://archive.ubuntu.com/ubuntu/|https://mirrors.nic.funet.fi/ubuntu/|g' /etc/apt/sources.list
RUN apt-get update -y

RUN \
    apt-get install -y \
    build-essential \
    curl \
    git \
    lsb-base \
    lsb-release \
    python3 \
    python \
    sudo \
    nano

RUN \
    echo Etc/UTC > /etc/timezone

RUN \
    echo tzdata tzdata/Areas select Etc | debconf-set-selections

RUN \
    echo tzdata tzdata/Zones/Etc UTC | debconf-set-selections

RUN \
    echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections


# RUN \
#     curl -s https://chromium.googlesource.com/chromium/src/+/master/build/install-build-deps.sh?format=TEXT | base64 -d \
#     | perl -pe 's/apt-get install \$\{do_quietly-}/DEBIAN_FRONTEND=noninteractive apt-get install -y/' \
#     | bash -e -s - \
#     --no-prompt \
#     --no-chromeos-fonts \
#     --no-arm \
#     --no-syms \
#     --no-nacl \
#     --no-backwards-compatible

ADD ./install-build-deps.sh /

RUN bash /install-build-deps.sh \
    --no-prompt \
    --no-chromeos-fonts \
    --no-syms \
    --no-nacl \
    --no-backwards-compatible \
    --arm

# needed to build mojo
RUN \
    apt-get install -y default-jdk

# missing python3.6 modules
RUN apt-get install -y python3-pip

# Set the locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8

RUN useradd -rm -d /chromium -s /bin/bash -u 995 -G sudo builder

USER builder

WORKDIR /chromium

# install missing modules
RUN pip3 install --user dataclasses importlib-metadata

# clone utils
RUN git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git

ENV PATH=/chromium/depot_tools:$PATH
ENV EDITOR=nano
