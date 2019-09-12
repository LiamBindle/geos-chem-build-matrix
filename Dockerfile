FROM gcc:6

MAINTAINER Liam Bindle <liam.bindle@gmail.com>

WORKDIR /download

ENV CC=gcc \
    CXX=g++ \
    FC=gfortran \
    CPPFLAGS="-I/usr/local/include" \
    LDFLAGS="-L/usr/local/lib" \
    LD_LIBRARY_PATH=/usr/local/lib \
    ZLIB_VERSION=1.2.11 \
    HDF5_VERSION=1.10.5 \
    NetCDF_C_VERSION=4.7.1 \
    NetCDF_Fortran_VERSION=4.4.5 \
    CMake_VERSION=3.15.3

RUN apt-get update
RUN apt-get -yq install bzip2 

# Install zlib
RUN curl -L -o zlib.tar.gz https://www.zlib.net/zlib-${ZLIB_VERSION}.tar.gz \
&&  tar -xvf zlib.tar.gz --strip-components 1 \
&&  ./configure --prefix=/usr/local \
&&  make -j3 \
&&  make install \
&&  rm -rf * 

# Install HDF5
RUN curl -L -o hdf5.tar.bz2 http://www.hdfgroup.org/ftp/HDF5/current/src/hdf5-${HDF5_VERSION}.tar.bz2 \
&&  tar -xjvf hdf5.tar.bz2 --strip-components 1 \
&&  ./configure --prefix=/usr/local --with-zlib=/usr/local --enable-hl \
&&  make -j3 \
&&  make install \
&&  rm -rf *

# Install NetCDF
RUN curl -L -o netcdf-c.tar.gz ftp://ftp.unidata.ucar.edu/pub/netcdf/netcdf-c-${NetCDF_C_VERSION}.tar.gz \
&&  tar -xzvf netcdf-c.tar.gz --strip-components 1 \
&&  ./configure --prefix=/usr/local \
&&  make -j3 \
&&  make check \
&&  make install \
&&  rm -rf *

# Install NetCDF-Fortran
RUN curl -L -o netcdf-fortran.tar.gz ftp://ftp.unidata.ucar.edu/pub/netcdf/netcdf-fortran-${NetCDF_Fortran_VERSION}.tar.gz \
&&  tar -xzvf netcdf-fortran.tar.gz --strip-components 1 \
&&  ./configure --prefix=/usr/local \
&&  make -j3 \
&&  make check \
&&  make install \
&&  rm -rf *

# Download CMake
RUN curl -L -o cmake.tar.gz https://github.com/Kitware/CMake/releases/download/v${CMake_VERSION}/cmake-${CMake_VERSION}-Linux-x86_64.tar.gz \
&& mkdir /opt/cmake-${CMake_VERSION} \
&& tar -xzvf cmake.tar.gz --strip-components 1 -C /opt/cmake-${CMake_VERSION} \
&& rm -rf *

ENV PATH=$PATH:/opt/cmake-${CMake_VERSION}/bin
