# VoikkoSpellService - oikoluku -järjestelmäkomponentti macOS:lle

VoikkoSpellService on ohjelmisto oikeinkirjoituksen ja kieliopin tarkistamiseen sekä tavutukseen. Tällä hetkellä tuettuja kieliä ovat: suomi.

VoikkoSpellService käyttää oikolukuun Voikko-projektin libvoikko ja voikko-fi -kirjastoja. Kyseiset kirjastot ovat paketin mukana.

## Tuetut macOS versiot

- macOS 12.0 (Monterey)
- tai uudempi

Komponentti sisältää 64-bit binäärin (arm64 ja x86_64).

Voikon kotisivut löytyvät osoitteesta: http://voikko.puimula.org/

## Asennus käyttäen Homebrewia

Avaa Terminal (pääte) ja kirjoita alla olevat komennot:

1. Asenna (Homebrew)[https://brew.sh/]: `$ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"”`
1. Asenna voikkospellservice: `$ brew install voikkospellservice`
1. Oikoluvun pitäisi olla nyt käytettävissä.

## Asennus paketista

1: Jos sinulla on ennestään Soikko tai Voikon vanhempi versio, poista ne ja kirjaudu sisään uudelleen.
1. Kopioi VoikkoSpellService.app se kansioon Macintosh HD -> Järjestelmä -> Kirjasto -> Services (/Library/Services). Jos kyseinen hakemisto puuttuu, luo se ensin. Tarvitset pääkäyttäjän oikeudet tähän.
2. Kirjaudu ulos.
3. Kirjaudu sisään.
4. Sisäänkirjautumisen jälkeen siirry Services-kansioon Finderin avulla ja käynnistä VoikkoSpellService Ctrl-klikkaamalla ja valitsemalla Avaa. Tällä kierretään Gatekeeperin suojamekanismi App Storen ulkopuolelta ladatuille sovelluksille, jotka eivät toimi Sandboxissa.
5. Oikoluvun pitäisi olla nyt käytettävissä.

## Lisenssi:

GPL v3
Ks. COPYING-tiedosto.

## Tekijät:

2010 - 2022 Marko Wallin <marko.wallin@iki.fi>
* Komponentin jatkokehitys
2006 – 2010 Harri Pitkänen <hatapitk@iki.fi>
* Alkuperäisen VoikkoSpellService -komponentin kehittäjä.
