FROM nvcr.io/nvidia/cuda:12.9.1-cudnn-devel-ubuntu24.04

RUN gcc --version

RUN apt-get update && apt-get -y install sudo software-properties-common ninja-build wget libssl-dev

RUN cd /tmp &&  \
    wget https://github.com/Kitware/CMake/archive/refs/tags/v4.0.3.tar.gz &&  \
    tar -zxvf v4.0.3.tar.gz

RUN cd /tmp/CMake-4.0.3 &&  \
    ./bootstrap &&  \
    sudo gmake &&  \
    sudo gmake install
