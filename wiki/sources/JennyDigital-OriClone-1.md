---
type: source
source_url: https://github.com/JennyDigital/OriClone-1
tags: [oric-clone, eagle-cad, pcb-design, oric-1, dual-rom, hardware, keyboard-pcb, via-6522, ay-3-8912]
related: [OldWer-Metaphoric, Board-Folk-Oric-Remix]
product: oriclone-1
detail_level: standard
created: 2026-05-17
updated: 2026-05-17
---

OriClone-1 is an open-hardware Eagle CAD clone of the Tangerine Oric-1 computer, designed by JennyDigital and shared publicly on GitHub. It predates and directly influenced [[OldWer-Metaphoric]], whose memory subsystem is explicitly derived from this project. The repo provides the full Eagle schematic and board layout for a two-PCB system (main computer board plus a matching tactile keyboard PCB with three revisions), a set of custom Eagle component libraries for Oric-specific ICs, a prebuilt 32 KB dual-ROM binary combining Oric-1 v1.0 and Atmos v1.1, and PDF fabrication documents. It is a key link in the genealogy of modern Oric clone hardware.

_All claims below are sourced from ../../raw/github/JennyDigital-OriClone-1.md unless otherwise noted._

## What it does

OriClone-1 provides the full design files to build a new Oric-1 compatible computer from scratch using modern PCB fabrication services. The project includes the complete Eagle schematic, board layout, Gerber output files for both the main board and keyboard PCB, and all the custom Eagle libraries needed to work with the project. It also ships a ready-to-program 32 KB dual-ROM binary so builders can flash a single EEPROM that contains both the Oric-1 and Atmos ROMs in separate banks.

## Key features

- **Eagle CAD main board** — `OriClone-1.sch` (1.1 MB full schematic) and `OriClone-1.brd` (451 KB layout), with Gerber files for direct PCB fabrication
- **Tactile keyboard PCB** — Three design revisions (v1.1, v1.3b, v1.3c), each with its own PDF documentation and Gerbers, giving builders a matching custom keyboard rather than relying on an original Oric keyboard
- **Dual-ROM binary** — `OricDualROM.bin` (32 KB): two 16 KB ROM images combined in one EEPROM-flashable file, enabling a single chip to hold both Oric-1 v1.0 and Atmos v1.1 with bank selection
- **Custom Eagle libraries** — Six `.lbr` files covering the core Oric chipset: `Mos6502.lbr` (CPU), `ORIC_Parts.lbr` (ULA, VIA, and other Oric-specific parts), `ay-3-8912.lbr` (PSG sound chip), `EEPROMs.lbr` (ROM replacement), `Lumberg-0105-DIN.lbr` (cassette/sound/RGB connectors), and `Liontech Logos.lbr` (branding)
- **IC pinout reference** — `OriClone-1-IC-Pinouts.pdf` (54 KB) documenting pin assignments for all ICs used in the build

## Architecture

The project uses Eagle CAD (not KiCAD, which distinguishes it from the later [[OldWer-Metaphoric]] and [[Board-Folk-Oric-Remix]] projects). The main board schematic at 1.1 MB is substantially detailed, covering the 6502A CPU, ULA (Oric's custom chip), 6522 VIA (for I/O and sound), AY-3-8912 PSG (sound), RAM, ROM, and peripheral interfaces. A separate keyboard PCB connects to the main board, mirroring the two-PCB split architecture also used in Metaphoric. The dual-ROM scheme uses an EEPROM with bank selection via an address line tied to ground or +5V — the same bank-switching technique Metaphoric inherited and adapted.

One documented hardware caveat: the W65C22S variant of the 6522 VIA is incompatible with the Oric cassette interface for unknown reasons; builders must use the Rockwell 6522 variant or substitute tape loading with an Erebus storage adapter or disk interface.

## Installation

1. Obtain the Eagle schematic (`project/OriClone-1/OriClone-1.sch`) and board file (`project/OriClone-1/OriClone-1.brd`) — requires Autodesk Eagle (now Fusion 360 Electronics)
2. Install the custom libraries from `lbr/` into Eagle's library path before opening the project
3. Use the Gerber files in `project/OriClone-1/Gerbers/` for PCB fabrication
4. Optionally build the keyboard PCB: choose a revision from `project/Oric Tactile KB/` (v1.3c is the latest) and use its corresponding Gerbers
5. Flash `OricDualROM.bin` to a suitable EEPROM (e.g. 27C256 or compatible) to supply both Oric-1 and Atmos ROMs from one chip
6. Populate the board with original or compatible ICs — **use Rockwell 6522 VIA, not W65C22S**, for functional cassette port

## Example usage

The typical build path is: fabricate main board PCBs using the provided Gerbers, solder through-hole components, flash the dual-ROM EEPROM, and connect an Oric-compatible keyboard (the supplied keyboard PCB or an original Oric keyboard). The `OriClone-1-IC-Pinouts.pdf` serves as a component-placement and wiring reference during assembly.

## Maintenance status

- 7 stars on GitHub; last commit April 2024
- No releases tagged; no license declared (all-rights-reserved by default)
- Active as of 2024; project predates and feeds into the Metaphoric clone ([[OldWer-Metaphoric]]) which is more actively maintained and has adopted KiCAD
- No open issues or pull requests visible
