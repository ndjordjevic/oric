# Board-Folk/Oric-Remix

## Metadata
- Stars: 3
- Primary language: HTML
- Default branch: main
- Latest release: (none)
- License: (none specified — README places schematics/PCB layouts in the public domain for study and historical preservation)
- Homepage: (none)
- Fetched: 2026-05-17
- Final URL: https://github.com/Board-Folk/Oric-Remix

## Description
Oric Remix

## README
# Oric Remix

An updated Oric-1 / Oric Atmos board

This repository contains the Bill-of-Materials (BOM), Gerbers and Kicad files for an updated Tangerine Oric motherboard found in the Oric-1 and Oric Atmos computers. The board is compatible for system ROM, in software and in form factor with the original board. Improvements include integration of service manual modifications, updated RAM and ROM layout and composite video, with the added intention to make it easier to build. It does not replace any of the core chips including the ULA which is still required.

There was an issue with v1.1 board causing the /ROMDIS signal not disabling the internal ROM. Simon Luce discovered this in testing and devised a fix that is now incorporated into v1.2. This has now been tested with the Loci expansion which now starts correctly.

## Revisions
* Version 1.1 Initial Public Release
* Version 1.2 fix for external expansions (/ROMDIS fix)

Project now in Kicad 9.

### Version 1.1 Modifications from Original
* LM7805 voltage regulator
* 27C512 ROM with 4 bank selector
* Additional AY-3-8910 socket
* Integrated tape mods (inc service manual)
* Replacement /ROMDIS logic
* AD724 composite & stereo sound output
* Speaker volume control
* 4464 RAM
* Additional system reset button
* Commodore 1531 tape interface (optional - original remains on the board)

### Version 1.2
* /ROMDIS fix

## Modification Notes

### LM7805
The original Oric boards regulated the negative power rail using a 7905 voltage regulator, keeping the positive rail common across the board and to the power supply. This has been replaced with a 7805 regulator making the ground common instead, making it easier to replace the regulator with something modern. Note this may cause issues sharing a power adapter with other expansions that regulate on the negative rail; if so use separate power adapters.

### ROM replacement and /ROMDIS updated
For EPROMs and the bank selector, /ROMDIS was updated (the logic allowing external expansions to disable the system ROM). This uses IC11 which can no longer be omitted. Fixed in v1.2. A 27C512 EEPROM can be used in chunks of 16KB selectable with the DIP switch — concatenate 4 16KB ROM images into a 64KB file and select each 16KB bank with the switches as binary.

### AY-3-8910 socket
The AY-3-8910 can be fitted instead of the AY-3-8912 sound chip. No difference in function; good ones can be found more cheaply.

### Integrated Tape Mods
Two tape mods are included on the board: one from the service manual (page 71, modification 8 — R11 and C19 "Improved Cassette Loading"), one from an assembled original (R101 and C101). The second mod should not be fitted for boards assembled with the 1531 tape interface.

### AD724 Composite Output
The original PROM-based composite generation for the RF modulator was poor. Replaced with an AD724 and a 3.5mm TRRS output jack which also includes stereo audio out, in the same channel configuration as an Amstrad CPC464/6128. Sleeve is ground; needs an OMTP wired cable.

### Speaker Volume Control
The original Oric was too loud. This adjusts the volume. There's a header for connection of an external potentiometer instead.

### System Reset Button
An additional push button has been added, with alternative pin header LK6 for external connection. This is a separate CPU reset; the original pulls down /NMI.

### Commodore 1531 Tape Port
Tape support isn't great on the Oric. There was space on the board, so a Commodore 1531 tape interface was added (optional — BOM listed separately). The original tape connection and relay are still there with the original 7 pin DIN on the back. Both can be fitted so long as R101 and C101 aren't fitted.

## Keyboard
A keyboard replica modified for MX or compatible keyswitches is planned. A prototype PS/2 interface has been completed and works (not usable with an original case but makes a functional system). The board also has provision for USB, with code not yet completed.

## BOM
The README contains a full Main BOM and a separate Commodore 1531 Port BOM. Key ICs (Main BOM): IC1 LM7805 voltage regulator, IC2 LM386, IC3 LM358, IC4 AY-3-8912 / IC10 AY-3-8910 (one or the other, not both), IC5 6502A CPU, IC6 6522A VIA, IC7 HCS10017, IC8/IC20 74LS257, IC9 27C128-27C512 ROM, IC11 74LS00 (Clock and /ROMDIS — now a requirement), IC21 74LS04, IC22 74LS365, IC23 AD724JR, IC30/IC31 4464 RAM. Crystals: XT1 12MHz, XT2 4.43MHz. SW2 is the optional 2-position DIP4 ROM bank selector. The 1531 Port BOM adds transistors (BC547, BC337, TIP29), a 7.5V zener, and a 7-pin mini-DIN socket SK5.

## Version v1.1 /ROMDIS Fix
Version 1.1 boards can be modified to incorporate the fix: cut the track to the south side of IC11 pin 1 on the rear; cut the track between pins 4 and 5 of IC11 on the rear; scrape solder mask off the thin track north of pin 5 and re-tin; solder a thin bridge wire between the exposed track and pin 5 of IC11.

## Links
* Finedon Electronics - Short 7 pin DIN socket (ebay.co.uk/itm/185588182650)
* Mike Brown's Diagnostic ROM (oric.signal11.org.uk/html/diagrom.htm)

## Credits
Original replica PCB layout by Rob Taylor (@peepouk) with modifications by Ian Cudlip (@grandoldian). Original PCB, research, assistance and documentation from Chrissy (@chris_jh). Schematics recreated and modifications by Ian Cudlip with suggestions and testing from Chrissy. /ROMDIS fix by Simon Luce. Thanks to Lee "More Fun Making It" (@morefunmakingit), Marko Šolajić (@msolajic), Simon Luce and The Board Folk Team.

## Legal
As the product is a replica of a proprietary product, the author makes no claim of copyright to the schematics nor PCB layouts and releases these into the public domain, solely for study and historical preservation. PCBs may be produced from the designs at the user's own risk, for personal use or for sale/repair at a reasonable price. Provided "as-is" without warranty.

## Docs
(No docs/ directory. The changelog `Kicad/changelog.txt` records: v1.1 — fix volume pot, add VC1 PAL oscillator adjustment, C9 220nF AD724 decoupler, C3/C36 now 100uF Tant, C21 reset to 10uF, SW3/LK6 system reset switches; v1.2 — /ROMDIS fix by Simon Luce.)

## Top-level structure
- `.gitattributes`, `.gitignore` — repo config
- `Archive/` — older revision files: `Gerbers/`, `IssueAv1.1/`
- `BOM/` — `Oric-Remix-Issue_A_v1_2_ibom.html` (interactive HTML BOM; accounts for the HTML primary language)
- `Expansions/Oric-PS2USB/` — prototype PS/2 + USB keyboard interface expansion (`Arduino/` code, `Gerbers/`, `Kicad/`, `README.md`)
- `Gerbers/` — current manufacturing files: `Oric-Remix-Issue_A_v1_2.zip` and unpacked `Oric-Remix-Issue_A_v1_2/`
- `Kicad/` — main KiCAD 9 project: `Oric.kicad_pcb`, `Oric.kicad_pro`, `Oric.kicad_sch`, hierarchical sheets (`oric_cpuula.kicad_sch`, `oric_io.kicad_sch`, `oric_power.kicad_sch`, `oric_ram.kicad_sch`, `oric_rom.kicad_sch`, `oric_video.kicad_sch`), `Oric.pretty/` footprint library, `changelog.txt`
- `images/` — board renders and the /ROMDIS fix illustration
- `Readme.md` — full project description, modification notes and BOM
