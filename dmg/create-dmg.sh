#! /bin/bash

#cp ../README.md src/
#cp ../README-fi.md src/

test -f VoikkoSpellService.dmg && rm VoikkoSpellService.dmg
./create-dmg \
  --volname "VoikkoSpellService" \
  --background "background-simple.png" \
  --window-pos 200 120 \
  --window-size 529 390 \
  --icon-size 100 \
	--icon "VoikkoSpellService.app" 130 190 \
	--hide-extension "VoikkoSpellService.app" \
	--services-drop-link 430 190 \
  "VoikkoSpellService.dmg" \
  "src/"

#	--add-file README-fi.md src/README-fi.md 150 260 \
#	--add-file README.md src/README.md 250 260 \
