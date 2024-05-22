#!/bin/sh

set -e
apk update
apk add alpine-sdk openblas-static openblas-dev cmake fftw-dev librtlsdr-dev boost-static boost-dev ncurses-static ncurses-dev lapack lapack-dev
rm /usr/lib/libopenblas.so
rm /usr/lib/libfftw3.so
rm /usr/lib/librtlsdr.so

wget https://downloads.sourceforge.net/project/itpp/itpp/4.3.1/itpp-4.3.1.tar.gz
tar xf itpp-4.3.1.tar.gz
cd itpp-4.3.1/
sed -i '/cmake_minimum_required/ c CMAKE_MINIMUM_REQUIRED( VERSION 3.24.1 )' CMakeLists.txt
#rm cmake/Modules/FindLAPACK.cmake
#rm cmake/Modules/FindBLAS.cmake
mkdir build
cd build
cmake -DITPP_SHARED_LIB=off ..
make
make install
cp /usr/local/lib/libitpp_static.a /usr/local/lib/libitpp.a
cd ../..

git clone https://github.com/JiaoXianjun/LTE-Cell-Scanner
cd LTE-Cell-Scanner
sed -i '/CMAKE_MINIMUM_REQUIRED/ c CMAKE_MINIMUM_REQUIRED( VERSION 3.24.1 )' CMakeLists.txt
sed -i '/^SET (common_link_libs/ c SET (common_link_libs ${Boost_LIBRARIES} ${Boost_THREAD_LIBRARY} ${LAPACK_LIBRARIES} ${FFTW_LIBRARIES} ${CURSES_LIBRARIES} -l:libusb-1.0.a)' src/CMakeLists.txt
#sed -i '/^SET (common_link_libs/ c SET (common_link_libs ${Boost_LIBRARIES} ${Boost_THREAD_LIBRARY} ${LAPACK_LIBRARIES} ${FFTW_LIBRARIES} ${CURSES_LIBRARIES} -l:libusb-1.0.a -l:libgfortran.a -l:libquadmath.a)' src/CMakeLists.txt
sed -i '2iset(CMAKE_FIND_LIBRARY_SUFFIXES ".a")\
set(BUILD_SHARED_LIBS OFF)\
set(CMAKE_EXE_LINKER_FLAGS "-static")\
set(Boost_USE_STATIC_LIBS   ON)' CMakeLists.txt
sed -i '1itypedef unsigned int uint;' include/searcher.h src/searcher.cpp
mkdir build
cd build
cmake ..
make
make install
tar czf ../../LTE-Cell-Scanner.tar.gz -C /usr/local/bin CellSearch LTE-Tracker
