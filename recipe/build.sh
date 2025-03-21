#!/bin/bash
# Stop on any error
set -e

# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/gnuconfig/config.* .

BUILD_DIR=build
BUILD_TYPE=RelWithDebInfo

BUILD_TESTING=OFF
BUILD_SHARED_LIBS=ON
RTE_ENABLE_SP=OFF
KERNEL_MODE=default
FAILURE_THRESHOLD='7.e-4'

# Ensure the directories exist
mkdir -p "${BUILD_DIR}"
mkdir -p $PREFIX/lib
mkdir -p $PREFIX/include

# Note: $CMAKE_ARGS is automatically provided by conda-forge. 
# It sets default paths and platform-independent CMake arguments.
cmake -S . -B ${BUILD_DIR} \
      ${CMAKE_ARGS} \
      -DCMAKE_Fortran_COMPILER=$FC \
      -DRTE_ENABLE_SP=$RTE_ENABLE_SP \
      -DKERNEL_MODE=$KERNEL_MODE \
      -DBUILD_TESTING=$BUILD_TESTING \
      -DFAILURE_THRESHOLD=$FAILURE_THRESHOLD \
      -DBUILD_SHARED_LIBS=$BUILD_SHARED_LIBS \
      -DCMAKE_INSTALL_PREFIX=$PREFIX \
      -DCMAKE_BUILD_TYPE=$BUILD_TYPE \
      -G Ninja

# Compile
cmake --build ${BUILD_DIR} --target install -- -v

# Run tests
ctest --output-on-failure --test-dir ${BUILD_DIR} -V
