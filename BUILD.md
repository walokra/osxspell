# Compiling libvoikko on macOS M1

Tested on macOS Monterey 12.6

## Depends on

- hfstospell, 0.5.3, Helsinki Finite-State Technology ospell (https://code.google.com/p/foma/)
- foma, 0.9.18, Finite-state compiler and C library
- pkg-config, 0.29.2, Manage compile and link flags for libraries
- python@3.10, 3.10.8, Interpreted, interactive, object-oriented programming language (http://pkg-config.freedesktop.org/wiki/)

Command Line Tools:

- run in Terminal: xcode-select --install

### Install dependencies from homebrew:

```
$ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
$ brew install autoconf automake libtool
$ brew install hfstospell foma pkg-config python@3.10
```

## Building Voikko from sources

Download libraries:

- voikko-fi 2.5 https://github.com/voikko/corevoikko/archive/refs/tags/rel-voikko-fi-2.5.tar.gz

Environment: Xcode 14.1

```
$ gcc -v
Apple clang version 14.0.0 (clang-1400.0.29.202)
Target: arm64-apple-darwin21.6.0
Thread model: posix
```

1. Set the environment: pkg-config, foma, hfstospell
1. Build and install voikko-fi
1. Build and install libvoikko

### Build voikko-fi and libvoikko for osxspell

**voikko-fi**

```
$ export PREFIX=~/.voikko
$ cd <PATH TO voikko-fi>
$ make clean
$ make vvfst
$ make vvfst-install DESTDIR=$PREFIX/lib/voikko
```

**libvoikko**

Note:

- Note When building from Git checkout you will need autoconf, automake and pkg-config to generate the configure script: `$ ./autogen.sh`
- On x86_64 headers contain pieces which are not accepted by GCC with livoikko's default settings we must remove "-Werror and -pedantic" -selectors from configure.ac.

```
$ cd <PATH TO libvoikko>
$ export PREFIX=~/.voikko
$ export BITS=arm64
$ make distclean
$ ./configure --disable-hfst --disable-silent-rules --disable-external-dicts --prefix=$PREFIX LDFLAGS=" -Wl,-install_name,@executable_path/../Resources/voikko/libvoikko.1.$BITS.dylib" --enable-static --disable-shared --with-dictionary-path=/Library/Spelling/voikko:/usr/lib/voikko
$ make install CFLAGS="-I$PREFIX/include -L$PREFIX/lib" LINK="gcc -framework CoreFoundation -framework Cocoa" LDFLAGS="-framework CoreFoundation -framework Cocoa -Wl,-install_name,@executable_path/../Resources/voikko/libvoikko.1.$BITS.dylib"
```

To see the search path for your dynamic lib use e.g.: `$ otool -L ~/.voikko/lib/libvoikko.1.dylib`

## Build osxspell

```
$ cd ~/osxspell
$ export OSXSPELLDIR=~/osxspell
$ export PREFIX=~/.voikko
$ export BITS=arm64
$ cp -vr $PREFIX/lib/voikko/* $OSXSPELLDIR/Resources/voikko
$ cp -vy $PREFIX/lib/libvoikko.1.dylib $OSXSPELLDIR/Resources/voikko/libvoikko.1.$BITS.dylib
```

Open Xcode procect to:

- Build
- Archive
