#!/bin/bash

# ------------------------------------------------------------------------
# Build instructions for 64-bit libvoikko and voikko-fi 4.x on macOS
#
# Also build and copy steps for osxspell.
#
# directory structure
#   - libs
# 		- pkgconfig
# 		- voikko-fi
# 		- libvoikko (needs: voikko-fi)
#   -(osxspell)
#
# The script copies voikko-fi and libvoikko -files to osxspell

build_clean() {
	pushd $MYLIBS/pkg-config*
	make clean
	popd

	pushd $MYLIBS/voikko-fi*
	make clean
	popd

	pushd $MYLIBS/libvoikko*
	make distclean
	popd
}


build_pkgconfig() {
	pushd $MYLIBS/pkg-config*
	./configure --prefix=$PREFIX CPPFLAGS="$CXXFLAGS" CFLAGS="-I$PREFIX/include -L$PREFIX/lib -isysroot $TARGET_ARCH" --enable-static --disable-dependency-tracking --with-internal-glib || exit 1
	make CFLAGS="$CFLAGS -I$PREFIX/include -L$PREFIX/lib -isysroot $TARGET_ARCH" || exit 1
	make install
	popd
}

build_voikkofi() {
	pushd $MYLIBS/corevoikko/voikko-fi*
	make clean
	make vvfst || exit 1
	make vvfst-install DESTDIR=$PREFIX/lib/voikko || exit 1
	popd
}

build_libvoikko() {
	pushd $MYLIBS/corevoikko/libvoikko*
	make distclean
	./configure --disable-hfst --prefix=$PREFIX CXXFLAGS="$CXXFLAGS" CPPFLAGS="-I$PREFIX/include" CFLAGS="$CFLAGS -I$PREFIX/include -L$PREFIX/lib -isysroot $TARGET_ARCH" LDFLAGS="$LDFLAGS" --enable-static --disable-dependency-tracking --with-dictionary-path=$PREFIX/lib/voikko || exit 1
	make install CFLAGS="-I$PREFIX/include -L$PREFIX/lib -isysroot $TARGET_ARCH" \
		LINK="$GCC -framework CoreFoundation -framework Cocoa $LINKFLAGS" \
		LDFLAGS="-framework CoreFoundation -framework Cocoa" || exit 1
	popd
}

build_libvoikko_osxspell() {
	pushd $MYLIBS/corevoikko/libvoikko*
	make distclean
	./configure --disable-hfst --prefix=$PREFIX CC="$GCC" CXXFLAGS="$CXXFLAGS" CPPFLAGS="-I$PREFIX/include" CFLAGS="$CFLAGS -I$PREFIX/include -L$PREFIX/lib -isysroot $TARGET_ARCH" LDFLAGS="$LDFLAGS -Wl,-install_name,@executable_path/../Resources/voikko/libvoikko.1.$BITS.dylib" --enable-static --disable-dependency-tracking --with-dictionary-path=$PREFIX/lib/voikko || exit 1
	make install CFLAGS="-I$PREFIX/include -L$PREFIX/lib -isysroot $TARGET_ARCH" \
		LINK="$GCC -framework CoreFoundation -framework Cocoa $LINKFLAGS" \
		LDFLAGS="-framework CoreFoundation -framework Cocoa -Wl,-install_name,@executable_path/../Resources/voikko/libvoikko.1.$BITS.dylib" || exit 1
	popd
}

copy_libs_osxspell() {
	cp -vr $PREFIX/lib/voikko/* $(pwd)/$OSXSPELLDIR/Resources/voikko
	cp -v $PREFIX/lib/libvoikko.1.dylib \
	$(pwd)/$OSXSPELLDIR/Resources/voikko/libvoikko.1.$BITS.dylib
}

if [ "$#" != "2" ]; then
	echo "Usage: <x86_64> <libvoikko, libvoikko-laaja, mozvoikko, osxspell or ooo>"
fi

if [ "$#" = "2" ]; then
	export GCC=gcc
	export MYLIBS=libs
	export OSXSPELLDIR=.

	export SDK_VERSION="/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX13.sdk"
	export DEPLOYMENT_TARGET="11.0"
	export CFLAGS=" -Qunused-arguments"
	export CXXFLAGS=" -Qunused-arguments"
	export PREFIX=~/.voikko

	if [ $1 = "x86_64" ]; then
		export TARGET_ARCH="$SDK_VERSION -arch x86_64 -m64 -mmacosx-version-min=$DEPLOYMENT_TARGET"
		export MACOSX_DEPLOYMENT_TARGET="$DEPLOYMENT_TARGET"
		export LDFLAGS=" -arch x86_64"
		export CXXFLAGS="$CXXFLAGS -arch x86_64"
		export LINKFLAGS=" -m64 -arch x86_64"
		export BITS="x86_64"
	elif [ $1 = "arm64" ]; then
		export TARGET_ARCH="$SDK_VERSION -arch arm64 -m64 -mmacosx-version-min=$DEPLOYMENT_TARGET"
		export MACOSX_DEPLOYMENT_TARGET="$DEPLOYMENT_TARGET"
		export LDFLAGS=" -arch arm64"
		export CXXFLAGS="$CXXFLAGS -arch arm64"
		export LINKFLAGS=" -m64 -arch arm64"
		export BITS="arm64"
	else
		echo "no bits given"
		exit -1
	fi

	export PATH=$PREFIX/bin:$PATH
	export PKG_CONFIG_PATH=$PREFIX/lib/pkgconfig

	if [ $2 = "libvoikko" ]; then
		build_pkgconfig || exit 1
		build_libvoikko || exit 1
		build_voikkofi || exit 1
	elif [ $2 = "osxspell" ]; then
		build_pkgconfig || exit 1
		build_libvoikko_osxspell || exit 1
		build_voikkofi || exit 1
		copy_libs_osxspell || exit 1
	else
		$2
	fi
fi
