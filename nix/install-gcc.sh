#!/bin/bash

GCC_VERSION="8.2.0"
BOOST_VERSION="1.68.0"

WORK_DIR="$HOME/Projects/@tmp"

current_version="$(g++ --version | head -n 1 | cut -c11-16)"

IFS='.' read -r -a old_ver  <<< "$GCC_VERSION"
IFS='.' read -r -a dwld_ver <<< "$current_version"


version_split=$(echo $current_version | tr "." "\n")



i=0
for ver in $version_split
do 
	if [ "$ver" -gt "" ]
done

exit 0

# GCC
INSTALL_DIR="/usr/local/gcc"
if [ -d "$INSTALL_DIR" ]; then
	echo "[WARNING] gcc already exists in $INSTALL_DIR. Remove old installation?"
	read -p ":: " yn

	case $yn in
		[Yy]* ) ;;
		[Nn]* ) exit;;
		* ) echo "[ERROR] wrong choice, please enter [y | n]"; exit;;
	esac

	rm -rf $INSTALL_DIR
fi

cd $WORK_DIR
mkdir "gcc-$GCC_VERSION"
cd "gcc-$GCC_VERSION"

wget "https://ftp.gnu.org/gnu/gcc/gcc-$GCC_VERSION/gcc-$GCC_VERSION.tar.gz"
tar -xf "gcc-$GCC_VERSION.tar.gz"

cd "gcc-$GCC_VERSION"
./contrib/download_prerequisites

cd ..
mkdir "gcc-build"
cd "gcc-build"

../gcc-${GCC_VERSION}/configure                      \
    --prefix=${INSTALLDIR}                           \
    --with-pkgversion="Aryan Gupta $GCC_VERSION"     \
    --enable-shared                                  \
    --enable-threads=posix                           \
    --enable-__cxa_atexit                            \
    --enable-clocale=gnu                             \
    --enable-languages=c,c++                         \
    --disable-multilib                               \
    --program-suffix=-${GCC_VERSION:0:1}             \
    --disable-werror

pwd
sudo make
sudo make install


# BOOST
INSTALL_DIR="/usr/local/boost"

if [ -d "$INSTALL_DIR" ]; then
	echo "[WARNING] boost already exists in $INSTALL_DIR. Remove old installation?"
	read -p ":: " yn

	case $yn in
		[Yy]* ) ;;
		[Nn]* ) exit;;
		* ) echo "[ERROR] wrong choice, please enter [y | n]"; exit;;
	esac

	rm -rf $INSTALL_DIR
fi

cd $WORK_DIR
mkdir "boost-$BOOST_VERSION"
cd "boost-$BOOST_VERSION"

UNDERSCORE_VERSION=${BOOST_VERSION//'.'/'_'}
wget "https://dl.bintray.com/boostorg/release/$BOOST_VERSION/source/boost_$UNDERSCORE_VERSION.tar.gz"
tar -xf "boost_$UNDERSCORE_VERSION.tar.gz"

cd "boost_$UNDERSCORE_VERSION"

sudo ./bootstrap.sh --prefix=$INSTALL_DIR
sudo ./b2 install link=static runtime-link=static threading=multi
