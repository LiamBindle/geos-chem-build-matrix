ARG GCC_VERSION 
FROM gcc:${GCC_VERSION}

MAINTAINER Liam Bindle <liam.bindle@gmail.com>

ENV CC=gcc \
    CXX=g++ \
    FC=gfortran \
    CPPFLAGS="-I/usr/local/include" \
    LDFLAGS="-L/usr/local/lib" \
    LD_LIBRARY_PATH=/usr/local/lib

RUN apt-get update
RUN apt-get -yq install bzip2 zip

WORKDIR /download

# Install zlib
ARG ZLIB_VERSION 
RUN curl -L -o zlib.tar.gz https://www.zlib.net/zlib-${ZLIB_VERSION}.tar.gz \
&&  tar -xvf zlib.tar.gz --strip-components 1 \
&&  ./configure --prefix=/usr/local \
&&  make -j3 \
&&  make install \
&&  rm -rf * 

# Install HDF5
ARG HDF5_VERSION
RUN curl -L -o hdf5.tar.bz2 http://www.hdfgroup.org/ftp/HDF5/current/src/hdf5-${HDF5_VERSION}.tar.bz2 \
&&  tar -xjvf hdf5.tar.bz2 --strip-components 1 \
&&  ./configure --prefix=/usr/local --with-zlib=/usr/local --enable-hl \
&&  make -j3 \
&&  make install \
&&  rm -rf *

ARG NetCDF_C_VERSION
ARG NetCDF_Fortran_VERSION
ARG NetCDF_VERSION
ADD build_netcdf.sh /download/build_netcdf.sh
RUN chmod +x build_netcdf.sh && ./build_netcdf.sh

# Download CMake
ENV CMake_VERSION=3.15.3
RUN curl -L -o cmake.tar.gz https://github.com/Kitware/CMake/releases/download/v${CMake_VERSION}/cmake-${CMake_VERSION}-Linux-x86_64.tar.gz \
&& mkdir /opt/cmake-${CMake_VERSION} \
&& tar -xzvf cmake.tar.gz --strip-components 1 -C /opt/cmake-${CMake_VERSION} \
&& rm -rf *

ENV PATH=$PATH:/opt/cmake-${CMake_VERSION}/bin
WORKDIR /
