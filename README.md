# Freifunk Frankfurt Firmware
Wenn du einen release bauen willst, checke den entsprechenden Git Tag oder Branch aus und baue die Firmware.
Für genaue Details siehe [Firmware bauen](#firmware-bauen)
```bash
git checkout '[branch oder tag name]'
```

## Branches
* `stable`
  * Die aktuelle Stabile Firmware

* `rc`
  * Eine Release Candidate-Firmware ist eine fast fertige Stable-Firmware.
    Die Änderungen sind bereits auf den `stable` Branch gemergt, jedoch noch nicht getaggt.
    Eine RC-Firmware erhältst du, wenn du den `stable` Branch auscheckst und baust.

* `next`
  * Eine Next-Firmware enthält Änderungen, die "Work in Progress" auf dem `next` Branch sind, und ist tendenziell instabil.
    Sie entsteht aus jedem Build, der auf dem `next` Branch basiert.

* `experimental`
  * Experimental-Firmware sind alle anderen.
    Eine Experimental-Firmware wird nicht offiziell angeboten, und kann beispielsweise für Versuche verwendet werden.
    Beispielsweise wird aus dem `experimental` Branch gegen Gluon Master gebaut.

* `feature-*`
  * Tests für kommende Features, sehr experimentell und ändert sich oft.

## Firmware bauen
Vorbereitung
```bash
git clone https://github.com/freifunk-gluon/gluon
git clone https://chaos.expert/FFFFM/site.git gluon/site
cd gluon/site
./build.sh update
```

Bauen aller targets
```bash
./build.sh build_all
```

Bauen einer Auswahl an Targets
```bash
SELECTED_TARGETS=x86-64 ./site/build.sh build
``` 
