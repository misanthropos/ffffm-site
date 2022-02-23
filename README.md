# Freifunk Frankfurt Firmware
Wenn du einen release bauen willst, checke den entsprechenden Git Tag oder Branch aus und baue die Firmware.
Für genaue Details siehe [Firmware bauen](#firmware-bauen)
```bash
git checkout '[branch oder tag name]'
```

## Branches
* `stable`
  * Die aktuelle Stabile Firmware.

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
  * Kann als Experimental released werden.

## Router aktualisieren
Um einen Router auf einen anderen Branch umzustellen:
```bash
uci set autoupdater.settings.branch='[branch name]'
uci commit autoupdater # Optional, wen nicht gesetzt wird der Router beim nächsten release des alten branches mit aktualisiert
autoupdater
```

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

### build.sh
* `build`
  Baut die Firmware für eine auswahl an Targets welche mit `SELECTED_TARGETS` gesetzt werden.
  `GLUON_VERBOSE=1` aktiviert debug ausgaben.
* `build_all`
  Baut alle möglichen Targets.
  `GLUON_VERBOSE=1` aktiviert debug logs.
* `manifest`
  Generiert ein `.manifest` file für den vorherigen build.
* `sign [key or keyfile] [manifest path]`
  Signiert gegebene Manifest mit dem angegebenen Key.
* `update`
  Aktualisiert das Gluon repo und dessen Abhängigkeiten.

## Config-Mode per SSH
Um einen Router per SSH in den Config-Mode zu setzen 
```bash
uci set gluon-setup-mode.@setup_mode[0].enabled='1'
uci commit gluon-setup-mode
reboot
```

### CI
Die GitLab CI wird verwendet, um Images automatisiert zu bauen. Der Build kann durch folgende Umgebungsvariablen gesteuert werden:

| Variable          | Funktion                                                    |
|-------------------|-------------------------------------------------------------|
| `FIRMWARE_SERVER` | Firmware Server, bspw. `user@host:/srv/firmware/`           |
| `GLUON_VERBOSE`   | Wenn nicht leer werden mehr debug informationen ausgegeben. |
| `SIGNING_KEY`     | Key oder Key Datei zum signieren der Firmware.              |
| `SSH_PRIVATE_KEY` | SSH Key zum Upload der Images auf den Firmware Server.      |
| `TARGETS`         | Liste um die anzahl der zu bauenden Targets einzuschränken. |
| `UPLOAD`          | Upload feature branch as experimental.                      |

### Firmware Server Struktur
```
$FIRMWARE_SERVER
├── archive
│   └── [branch]
│       └── gluon-[site]-[version]
│           ├── debug
│           │   ├── Kernel debug definitions
│           │   └── [...]
│           ├── images
│           │   ├── factory
│           │   │   ├── Factory router images
│           │   │   └── [...]
│           │   ├── other
│           │   │   ├── Other router images
│           │   │   └── [...]
│           │   └── sysupgrade
│           │       ├── Sysupgrade router images
│           │       ├── [branch].manifest
│           │       └── [...]
│           └── packages
│               └── gluon-[site]-[version]
│                   └── [architektur]
│                       └── [subarchitektur]
│                           ├── [...].ipk
│                           ├── Packages
│                           ├── Packages.gz
│                           ├── Packages.manifest
│                           └── Packages.sig
├── images
│   └── [branch] -> symlink auf ../archive/[branch]/gluon-[site]-[version]/images/
└── modules
    └── gluon-[site]-[version] -> symlink auf ../archive/experimental/gluon-[site]-[version]/packages/gluon-[site]-[version]/
```
