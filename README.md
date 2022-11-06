﻿VoikkoSpellService - Spell-checking service for macOS
========================================================

VoikkoSpellService is an open source spell-checking service for macOS.

VoikkoSpellService utilises the Voikko project's libvoikko and voikko-fi libraries for spell- and grammar checking. Those are included in the binary package.

Supported macOS versions:
============================
- Mac OS X 10.8 (Mountain Lion)
- Mac OS X 10.9 (Mavericks)
- or newer

The component includes binary for 64-bit targets.

Voikko projects homepage is at: http://voikko.sourceforge.net/

Installation:
=============
1. Remove old installation of VoikkoSpellService or Soikko and then log out and in.
2. Copy the VoikkoSpellService.app to System's /Library/Services. If there is no such directory then create it. You need administrator rights for this.
3. Log out and in.
4. After login go to Services folder and start VoikkoSpellService with Ctrl clicking and selecting Open. This is done because the component isn't from App Store and can't work with Sandboxing.
5. Voikko Spellchecking should be now available.

Building:
===========================================================================
1. open VoikkoSpellService.xcodeproj in Xcode.
2. Copy voikko and suomi-malaga libraries to osxspell/Resources/voikko
3. Fix necessary paths to libvoikko and build
4. Install by copying build results, VoikkoSpellService.app, under ~/Library/Services

# Done;

License:
========
GPL v3
See COPYING

Authors:
========
2010 - 2022 Marko Wallin <marko.wallin@iki.fi>
* Continuing the development
2006 – 2010 Harri Pitkänen <hatapitk@iki.fi>
* The original code for the VoikkoSpellService component
