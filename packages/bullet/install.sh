#! /bin/sh

. ../../common.sh

cp ../cross_toolchain.txt .

if test "x$4" = "xx86_64-w64-mingw32" ; then
    proc="AMD64"
    machine=-m64
else
    proc="X86"
    machine=-m32
fi

sed -i -e "s|@host@|$4|g;s|@proc@|$proc|g" cross_toolchain.txt

rm -rf builddir && mkdir builddir && cd builddir

cmake \
    -DCMAKE_TOOLCHAIN_FILE=../cross_toolchain.txt \
    -DCMAKE_INSTALL_PREFIX=$prefix_unix \
    -DCMAKE_VERBOSE_MAKEFILE:BOOL=$verbcmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_C_FLAGS="-O2 -pipe $machine -march=$1 -D__USE_MINGW_ANSI_STDIO=0" \
    -DCMAKE_CXX_FLAGS="-O2 -pipe $machine -march=$1 -D__USE_MINGW_ANSI_STDIO=0" \
    -DCMAKE_EXE_LINKER_FLAGS="-s" \
    -DCMAKE_SHARED_LINKER_FLAGS="-s $machine" \
    -DTARGET_SUPPORTS_SHARED_LIBS=TRUE \
    -DBUILD_SHARED_LIBS:BOOL=ON \
    -DINSTALL_LIBS:BOOL=ON \
    -DINSTALL_EXTRA_LIBS:BOOL=ON \
    -DBUILD_UNIT_TESTS:BOOL=OFF \
    -DBUILD_BULLET2_DEMOS:BOOL=OFF \
    -DBUILD_OPENGL3_DEMOS:BOOL=OFF \
    -DBUILD_EXTRAS:BOOL=OFF \
    -DUSE_GLUT:BOOL=OFF \
    -DBUILD_BULLET3:BOOL=OFF \
    -DBUILD_PYBULLET:BOOL=OFF \
    -DBUILD_EXTRAS:BOOL=OFF \
    -LAH \
    -G "Unix Makefiles" \
    .. > ../../config.log 2>&1

make -j $jobopt install > ../../make.log 2>&1
