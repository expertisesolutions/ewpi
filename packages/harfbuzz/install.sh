#! /bin/sh

set -e

# $1 : name
# $2 : tarname
# $3 : prefix
# $4 : host
# $5 : taropt
# $6 : jobopt

dir_name=`tar t$5 $2 | head -1 | cut -f1 -d"/"`
cd $dir_name
export PKG_CONFIG_DIR=
export PKG_CONFIG_LIBDIR=$3/lib/pkgconfig
export PKG_CONFIG_SYSROOOT_DIR=$3
export CPPFLAGS=-I$3/include
export LDFLAGS=-L$3/lib

./configure --prefix=$3 --host=$4 --disable-static --with-glib=no --disable-gtk-doc-html --disable-gtk-doc-pdf --with-cairo=no --with-fontconfig=no --with-freetype=yes --with-graphite2=yes --with-icu=no > ../config.log 2>&1

make -j $jobopt install > ../make.log 2>&1
