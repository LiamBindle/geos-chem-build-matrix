# Declare dependency versions
GCC_VERSION=6
ZLIB_VERSION=1.2.11
HDF5_VERSION=1.10.5
NetCDF_C_VERSION=4.7.1
NetCDF_Fortran_VERSION=4.4.5

# Run docker build
docker build . --build-arg GCC_VERSION=${GCC_VERSION} --build-arg ZLIB_VERSION=${ZLIB_VERSION} --build-arg HDF5_VERSION=${HDF5_VERSION} --build-arg NetCDF_C_VERSION=${NetCDF_C_VERSION} --build-arg NetCDF_Fortran_VERSION=${NetCDF_Fortran_VERSION} -t liambindle/gcc-netcdf-c-netcdf-fortran:${GCC_VERSION}-${NetCDF_C_VERSION}-${NetCDF_Fortran_VERSION}