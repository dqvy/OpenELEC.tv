################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
#
#  This Program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2, or (at your option)
#  any later version.
#
#  This Program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with OpenELEC.tv; see the file COPYING.  If not, write to
#  the Free Software Foundation, 51 Franklin Street, Suite 500, Boston, MA 02110, USA.
#  http://www.gnu.org/copyleft/gpl.html
################################################################################

PKG_NAME="llvm"
PKG_VERSION="3.0"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://llvm.org/"
PKG_URL="http://llvm.org/releases/$PKG_VERSION/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS=""
PKG_BUILD_DEPENDS="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="toolchain/lang"
PKG_SHORTDESC="llvm: Low Level Virtual Machine"
PKG_LONGDESC="Low-Level Virtual Machine (LLVM) is a compiler infrastructure designed for compile-time, link-time, run-time, and idle-time optimization of programs from arbitrary programming languages. It currently supports compilation of C, Objective-C, and C++ programs, using front-ends derived from GCC 4.0, GCC 4.2, and a custom new front-end, "clang". It supports x86, x86-64, ia64, PowerPC, and SPARC, with support for Alpha and ARM under development."

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

# package specific configure options
PKG_CONFIGURE_OPTS_HOST="--enable-polly \
                         --enable-optimized \
                         --disable-profiling \
                         --disable-assertions \
                         --disable-expensive-checks \
                         --disable-debug-runtime \
                         --disable-debug-symbols \
                         --enable-jit \
                         --disable-docs \
                         --disable-doxygen \
                         --enable-threads \
                         --enable-pthreads \
                         --enable-pic \
                         --enable-shared \
                         --enable-embed-stdcxx \
                         --enable-timestamps \
                         --disable-libffi \
                         --enable-ltdl-install"

PKG_CONFIGURE_OPTS_TARGET="--enable-polly \
                           --enable-optimized \
                           --disable-profiling \
                           --disable-assertions \
                           --disable-expensive-checks \
                           --disable-debug-runtime \
                           --disable-debug-symbols \
                           --enable-jit \
                           --disable-docs \
                           --disable-doxygen \
                           --enable-threads \
                           --enable-pthreads \
                           --enable-pic \
                           --enable-shared \
                           --enable-embed-stdcxx \
                           --enable-timestamps \
                           --disable-libffi \
                           --disable-ltdl-install"

if [ "$TARGET_ARCH" = i386 ]; then
  PKG_CONFIGURE_OPTS_HOST="$PKG_CONFIGURE_OPTS_HOST --enable-targets=x86"
  PKG_CONFIGURE_OPTS_TARGET="$PKG_CONFIGURE_OPTS_TARGET --enable-targets=x86"
elif [ "$TARGET_ARCH" = x86_64 ]; then
  PKG_CONFIGURE_OPTS_HOST="$PKG_CONFIGURE_OPTS_HOST --enable-targets=x86_64"
  PKG_CONFIGURE_OPTS_TARGET="$PKG_CONFIGURE_OPTS_TARGET --enable-targets=x86_64"
fi

PKG_MAKE_OPTS_TARGET="LLVM_TBLGEN=$ROOT/$TOOLCHAIN/bin/llvm-tblgen"
PKG_MAKEINSTALL_OPTS_TARGET="LLVM_TBLGEN=$ROOT/$TOOLCHAIN/bin/llvm-tblgen"

pre_build_target() {
  # LLVM needs to be build for HOST first
    $SCRIPTS/build llvm:host
}

pre_configure_host() {
  ( cd ../autoconf
    aclocal  --force --verbose -I m4
    autoconf --force --verbose -I m4 -o ../configure
  cd .. )
}

pre_configure_target() {
  # llvm fails to build with LTO support
    strip_lto
}

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin
  rm -rf $INSTALL/usr/lib/BugpointPasses.so
  rm -rf $INSTALL/usr/lib/LLVMHello.so
  rm -rf $INSTALL/usr/lib/libLTO.so
  rm -rf $INSTALL/usr/lib/libprofile_rt.so
}
