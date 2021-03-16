﻿# VoikkoSpellService - Spell-checking service for Mac OS X

VoikkoSpellService is an open source spell-checking service for Mac OS X.

VoikkoSpellService utilises the Voikko project's libvoikko and suomi-malaga libraries for spell- and grammar checking. Those are included in the binary package.

## Supported Mac OS X versions:

- Mac OS X 10.11 (El Capitan)
- or newer

The component includes binary for 64-bit targets. 

Voikko projects homepage is at: http://voikko.puimula.org/

## Installation with Homebrew

Open Terminal and first install Homebrew and Cask.

1. Install (Homebrew)[https://brew.sh/]: `$ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"”`
1. Install voikkospellservice: `$ brew cask install voikkospellservice`
1. Voikko Spellchecking should be now available.

## Installation from dmg package

1. Remove old installation of VoikkoSpellService or Soikko and then log out and in.
2. Copy the *VoikkoSpellService.app* to user's *~/Library/Services*. If there is no such directory then create it.
3. Log out and in.
4. After login go to Services folder and start VoikkoSpellService with Ctrl clicking and selecting Open. This is done because the component isn't from App Store and can't work with Sandboxing.
5. Voikko Spellchecking should be now available.

## Building:

1. open *VoikkoSpellService.xcodeproj* in Xcode. 
2. Copy *voikko* and *voikko-fi* libraries to *osxspell/Resources/voikko*
3. Fix necessary paths to libvoikko and build
4. Install by copying build results, VoikkoSpellService.app, under *~/Library/Services*

Done;

## License:

GPL v3
See COPYING

## Authors:

2010 - 2021 Marko Wallin <marko.wallin@iki.fi>
* Continuing the development
2006 – 2010 Harri Pitkänen <hatapitk@iki.fi>
* The original code for the VoikkoSpellService component
