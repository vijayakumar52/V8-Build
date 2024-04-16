ARG sys_image=debian:10

FROM $sys_image

# default values
ARG vendor=debian
ARG target_os=linux
ARG target_cpu=x64

# Update depedency of V8

RUN apt-get -qq update && \
  DEBIAN_FRONTEND=noninteractive apt-get -qq install -y \
    lsb-release \
    sudo \
    apt-utils \
    git \
    python \
    lbzip2 \
    curl  \
    wget  \
    xz-utils \
    g++-8-arm-linux-gnueabihf \
    gcc-arm-linux-gnueabihf

RUN apt-get -y update && apt-get -y upgrade
RUN apt install -y pkg-config
RUN mkdir -p /v8build
WORKDIR /v8build

# DEPOT TOOLS install
#RUN git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
#ENV PATH /v8build/depot_tools:"$PATH"
#RUN echo $PATH

# Fetch V8 code
#RUN fetch v8
#WORKDIR /v8build/v8
#RUN git checkout 9.3.345.11
#WORKDIR /v8build

#ENV target_os ${target_os}
#RUN echo "target_os= ['${target_os}']" >> .gclient
#RUN gclient sync


RUN apt-get install -y procps

RUN git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git \
    && export PATH="/v8build/depot_tools:$PATH" \
    && echo $PATH \
    && fetch v8 \
    && cd /v8build/v8 \
    && cd /v8build \
    && echo "target_os= ['android']" >> .gclient \
    && gclient sync


ENV PATH /v8build/depot_tools:"$PATH"

WORKDIR /v8build/v8
COPY install-deps.sh .
RUN echo y | sh install-deps.sh

#RUN apt -y install libcrypt1
#RUN apt -y --fix-broken install


RUN cd /tmp
RUN apt -y download libcrypt1
RUN dpkg-deb -x libcrypt1_1%3a4.4.36-4_amd64.deb  .
RUN cp -av usr/lib/x86_64-linux-gnu/* /usr/lib/x86_64-linux-gnu/
RUN DEBIAN_FRONTEND=noninteractive apt -y --fix-broken install

RUN apt install -y ninja-build

RUN apt-get install -y build-essential checkinstall
RUN apt-get install -y libreadline-gplv2-dev libssl-dev \
    libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev libffi-dev zlib1g-dev
RUN wget https://www.python.org/ftp/python/3.8.12/Python-3.8.12.tgz
RUN tar xzf Python-3.8.12.tgz
RUN cd Python-3.8.12 && ./configure --enable-optimizations && make altinstall


RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.7 1
RUN update-alternatives --install /usr/bin/python3 python3 /usr/local/bin/python3.8 2

RUN update-alternatives --set python3 /usr/local/bin/python3.8

RUN apt install -y python-is-python3
RUN python --version

#RUN apt -y download libcrypt1 \
#    && dpkg-deb -x libcrypt1_1%3a4.4.36-2_amd64.deb . \
#    && cp -av lib/x86_64-linux-gnu/* /lib/x86_64-linux-gnu/ \
#    && apt -y --fix-broken install

RUN apt install -y gcc-multilib 

ENV target_cpu ${target_cpu}
ENV build_platform ${target_cpu}.release
ENV path_to_args ${target_os}-${target_cpu}/args.gn

RUN ./tools/dev/v8gen.py ${build_platform} -vv

RUN rm out.gn/${build_platform}/args.gn
COPY ./${path_to_args} out.gn/${build_platform}/args.gn
RUN ls -al out.gn/${build_platform}/
RUN cat out.gn/${build_platform}/args.gn
RUN touch out.gn/${build_platform}/args.gn

# Build the V8 monolithic static liblary
RUN ninja -C out.gn/${build_platform} -t clean
RUN ninja -C out.gn/${build_platform} v8_monolith
