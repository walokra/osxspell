VoikkoSpellService - oikoluku -järjestelmäkomponentti macOS:lle
==============================================================
VoikkoSpellService on ohjelmisto oikeinkirjoituksen ja kieliopin tarkistamiseen sekä tavutukseen. Tällä hetkellä tuettuja kieliä ovat: suomi.

VoikkoSpellService käyttää oikolukuun Voikko-projektin libvoikko ja voikko-fi -kirjastoja. Kyseiset kirjastot ovat paketin mukana.

Tuetut macOS versiot:
========================
- Mac OS X 10.8 (Mountain Lion)
- Mac OS X 10.9 (Mavericks)
- tai uudempi

Komponentti sisältää 64-bit binäärin.

Voikon kotisivut löytyvät osoitteesta: http://voikko.sourceforge.net/

Asennus:
========
1: Jos sinulla on ennestään Soikko tai Voikon vanhempi versio, poista ne ja kirjaudu sisään uudelleen.
2. Kopioi VoikkoSpellService.app se kansioon Macintosh HD -> Järjestelmä -> Kirjasto -> Services (/Library/Services). Jos kyseinen hakemisto puuttuu, luo se ensin. Tarvitset pääkäyttäjän oikeudet tähän.
3. Kirjaudu ulos.
4. Kirjaudu sisään.
5. Sisäänkirjautumisen jälkeen siirry Services-kansioon Finderin avulla ja käynnistä VoikkoSpellService Ctrl-klikkaamalla ja valitsemalla Avaa. Tällä kierretään Gatekeeperin suojamekanismi App Storen ulkopuolelta ladatuille sovelluksille, jotka eivät toimi Sandboxissa.
6. Oikoluvun pitäisi olla nyt käytettävissä.

Lisenssi:
=========
GPL v3
Ks. COPYING-tiedosto.

Tekijät:
========
2010 - 2022 Marko Wallin <marko.wallin@iki.fi>
* Komponentin jatkokehitys
2006 – 2010 Harri Pitkänen <hatapitk@iki.fi>
* Alkuperäisen VoikkoSpellService -komponentin kehittäjä.
