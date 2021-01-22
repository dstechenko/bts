#!/bin/bash
# Copyright (C) Dmytro Stechenko
# License: http://www.gnu.org/licenses/gpl.html

# Required:
# build-essential bison flex libgmp3-dev libmpc-dev libmpfr-dev texinfo

# Optional:
# libcloog-isl-dev libisl-dev

set -euxo pipefail

export TARGET="i686-elf"

TOOLS_DIR=$(dirname  "$0")
TOOLS_DIR=$(realpath "$TOOLS_DIR")

BINUTILS_VER="2.35"
     GCC_VER="9.3.0"

BINUTILS_URL="https://ftp.gnu.org/gnu/binutils/binutils-$BINUTILS_VER.tar.gz"
     GCC_URL="http://mirrors.concertpass.com/gcc/releases/gcc-$GCC_VER/gcc-$GCC_VER.tar.gz"

DOWNLOAD_DIR=$(mktemp -d)

wget -O "$DOWNLOAD_DIR/binutils-$BINUTILS_VER.tar.gz" "$BINUTILS_URL"
wget -O "$DOWNLOAD_DIR/gcc-$GCC_VER.tar.gz"           "$GCC_URL"

tar -xvzf "$DOWNLOAD_DIR/binutils-$BINUTILS_VER.tar.gz" -C "$DOWNLOAD_DIR"
tar -xvzf "$DOWNLOAD_DIR/gcc-$GCC_VER.tar.gz"           -C "$DOWNLOAD_DIR"

export PREFIX="$TOOLS_DIR/cross"
export   PATH="$PREFIX/bin:$PATH"

rm    -rf "$PREFIX"
mkdir -p  "$PREFIX"

cd    "$DOWNLOAD_DIR"
mkdir "binutils-build"
cd    "binutils-build"

"$DOWNLOAD_DIR/binutils-$BINUTILS_VER/configure" --target="$TARGET" --prefix="$PREFIX" --with-sysroot --disable-nls --disable-Werror
make
make install

cd    "$DOWNLOAD_DIR"
mkdir "gcc-build"
cd    "gcc-build"

"$DOWNLOAD_DIR/gcc-$GCC_VER/configure" --target="$TARGET" --prefix="$PREFIX" --disable-nls --enable-languages=c,c++ --without-headers
make all-gcc
make all-target-libgcc
make install-gcc
make install-target-libgcc

cd $(dirname "$TOOLS_DIR")

rm -rf "$DOWNLOAD_DIR"
