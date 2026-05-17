# JennyDigital/OriClone-1

## Metadata
- Stars: 7
- Primary language: (none — hardware/PCB design files)
- Default branch: master
- Latest release: (none)
- License: (none)
- Homepage: (none)
- Fetched: 2026-05-17
- Final URL: https://github.com/JennyDigital/OriClone-1

## Description
A New Oric!

## README

# OriClone-1
A New Oric!

The Oric-1 and Atmos line of computers are something I loved as a kid, and I thought it about time there was a new one in my collection.

So I'm working on it, and sharing with the world.  As always, have fun!

Please note that the W65C22S version of the VIA IC won't let the cassette port read tapes, I have no idea why yet.  In that case use the Rockwell version instead, or alternatively, use something like an Erebus or disk interface.

Kind regards,

JennyDigital.

## Top-level structure

```
OriClone-1-IC-Pinouts.pdf   (54 KB)  — IC pinout reference document for the clone build
OriClone-1.pdf              (68 KB)  — Main project overview/schematic document
OricDualROM.bin             (32 KB)  — Dual ROM binary (32KB = two 16KB banks: Oric-1 v1.0 + Atmos v1.1)
README.md                   (< 1 KB) — Brief project introduction
lbr/                                 — Eagle CAD component libraries (see below)
project/                             — Eagle PCB design files (see below)
```

### lbr/ — Eagle CAD component libraries

Custom Eagle libraries created for this project, covering Oric-specific ICs and connectors:

```
EEPROMs.lbr             — EEPROM package definitions (used for dual-ROM implementation)
Liontech Logos.lbr      — Branding/logo silk-screen elements
Lumberg-0105-DIN.lbr    — DIN connector footprints (cassette/sound/RGB ports)
Mos6502.lbr             — MOS 6502 CPU package
ORIC_Parts.lbr          — Oric-specific parts collection (ULA, VIA, PSG, etc.)
ay-3-8912.lbr           — General Instrument AY-3-8912 sound chip package
```

### project/ — PCB design files

Two sub-projects: the main computer board and a matching tactile keyboard PCB.

```
project/OriClone-1/
  OriClone-1.brd        (451 KB) — Eagle board layout file (main computer PCB)
  OriClone-1.sch        (1.1 MB) — Eagle schematic (full circuit diagram)
  OriClone-1.pro        (1 KB)   — Eagle project file
  eagle.epf             (28 KB)  — Eagle editor preferences/state
  Gerbers/                       — PCB fabrication output files (Gerber format)

project/Oric Tactile KB/
  Oric Tactile KB 1.1.pdf   (28 KB) — Keyboard PCB v1.1 design document
  Oric Tactile KB 1.3b.pdf  (28 KB) — Keyboard PCB v1.3b design document
  Oric Tactile KB 1.3c.pdf  (28 KB) — Keyboard PCB v1.3c design document
  1.1/                              — Gerbers and files for keyboard v1.1
  1.3b/                             — Gerbers and files for keyboard v1.3b
  1.3c/                             — Gerbers and files for keyboard v1.3c
  Gerbers/                          — Additional fabrication outputs
```
