ARG GCC_VERSION 
FROM gcc:${GCC_VERSION}

MAINTAINER Liam Bindle <liam.bindle@gmail.com>

WORKDIR /download

ENV CC=gcc \
    CXX=g++ \
    FC=gfortran \
    CPPFLAGS="-I/usr/local/include" \
    LDFLAGS="-L/usr/local/lib" \
    LD_LIBRARY_PATH=/usr/local/lib

RUN apt-get update
RUN apt-get -yq install bzip2 

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

# Install NetCDF
ARG NetCDF_C_VERSION
RUN wget https://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-c-${NetCDF_C_VERSION}.zip \
&&  unzip netcdf-c-${NetCDF_C_VERSION}.zip \
&&  cd netcdf-c-${NetCDF_C_VERSION} \
&&  ./configure --prefix=/usr/local \
&&  make -j3 \
&&  make check \
&&  make install \
&&  cd .. && rm -rf netcdf-c-${NetCDF_C_VERSION}*

# Install NetCDF-Fortran
ARG NetCDF_Fortran_VERSION
RUN wget https://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-fortran-${NetCDF_Fortran_VERSION}.zip \
&&  unzip netcdf-fortran-${NetCDF_Fortran_VERSION}.zip \
&&  cd netcdf-fortran-${NetCDF_Fortran_VERSION} \
&&  ./configure --prefix=/usr/local \
&&  make -j3 \
&&  make check \
&&  make install \
&&  rm -rf *

# Download CMake
ENV CMake_VERSION=3.15.3
RUN curl -L -o cmake.tar.gz https://github.com/Kitware/CMake/releases/download/v${CMake_VERSION}/cmake-${CMake_VERSION}-Linux-x86_64.tar.gz \
&& mkdir /opt/cmake-${CMake_VERSION} \
&& tar -xzvf cmake.tar.gz --strip-components 1 -C /opt/cmake-${CMake_VERSION} \
&& rm -rf *

ENV PATH=$PATH:/opt/cmake-${CMake_VERSION}/bin
