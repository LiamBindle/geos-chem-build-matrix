#!/bin/bash

echo "NetCDF_VERSION:           ${NetCDF_VERSION}"
echo "NetCDF_C_VERSION:         ${NetCDF_C_VERSION}"
echo "NetCDF_Fortran_VERSION:   ${NetCDF_Fortran_VERSION}"

if [ -z "$NetCDF_VERSION" ]
then
    # Install NetCDF-C and NetCDF-Fortran
    wget https://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-c-${NetCDF_C_VERSION}.zip \
    &&  unzip netcdf-c-${NetCDF_C_VERSION}.zip \
    &&  cd netcdf-c-${NetCDF_C_VERSION} \
    &&  ./configure --prefix=/usr/local \
    &&  make -j3 \
    &&  make check \
    &&  make install \
    &&  cd .. && rm -rf netcdf-c-* \
    &&  wget https://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-fortran-${NetCDF_Fortran_VERSION}.zip \
    &&  unzip netcdf-fortran-${NetCDF_Fortran_VERSION}.zip \
    &&  cd netcdf-fortran-${NetCDF_Fortran_VERSION} \
    &&  ./configure --prefix=/usr/local \
    &&  make -j3 \
    &&  make check \
    &&  make install \
    &&  rm -rf netcdf-fortran-* \
    &&  exit 0
else
    # Install NetCDF
    wget ftp://ftp.unidata.ucar.edu/pub/netcdf/old/netcdf-${NetCDF_VERSION}.tar.gz \
    &&  tar -xvf netcdf-${NetCDF_VERSION}.tar.gz \
    &&  cd netcdf-${NetCDF_VERSION} \
    &&  ./configure --prefix=/usr/local \
    &&  make -j3 \
    &&  make check \
    &&  make install \
    &&  cd .. && rm -rf netcdf* \
    &&  exit 0
fi

exit 1