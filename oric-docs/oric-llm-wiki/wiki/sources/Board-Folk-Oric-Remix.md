---
type: source
source_url: https://github.com/Board-Folk/Oric-Remix
tags: [oric-replica, kicad-pcb, motherboard, romdis-fix, ad724-composite, commodore-1531, ps2-usb-keyboard, rom-bank-selector]
related: [OldWer-Metaphoric, oric.free.fr, JennyDigital-OriClone-1]
product: oric-remix
detail_level: standard
created: 2026-05-17
updated: 2026-05-17
---

Oric Remix is an updated replica of the Tangerine Oric-1 / Oric Atmos motherboard, published by The Board Folk as KiCAD 9 design files, gerbers and bills of materials. Unlike a full clone, it stays compatible with the original board in system ROM, software and form factor — it still requires the original core chips, including the ULA — while folding in service-manual modifications, modern RAM/ROM, improved composite video and an easier build. It matters to this wiki as a preservation-grade, drop-in motherboard replacement for original Oric machines.

_All claims below are sourced from ../../raw/github/Board-Folk-Oric-Remix.md unless otherwise noted._

## What it does

Oric Remix is a remanufacturable Oric-1/Atmos motherboard. You fabricate the PCB and populate it with a mix of new parts and the original core chips (6502A CPU, 6522A VIA, AY sound chip and the ULA, which the board does not replace). The result is ROM-, software- and form-factor-compatible with a genuine Oric board, intended as a repair or rebuild path for the original machines.

## Installation

The repository provides everything needed for fabrication and assembly: a KiCAD 9 project in `Kicad/` (top sheet `Oric.kicad_pcb` plus hierarchical schematics for CPU/ULA, I/O, power, RAM, ROM and video), ready-to-manufacture gerbers in `Gerbers/` (`Oric-Remix-Issue_A_v1_2.zip`), an interactive HTML BOM in `BOM/`, and the README's full Main BOM and separate Commodore 1531 Port BOM. Older v1.1 files are retained under `Archive/`. The current revision is Issue A v1.2; always build v1.2, as v1.1 has a /ROMDIS defect (see Maintenance status).

## Key features

- LM7805 positive-rail voltage regulator, replacing the original's negative-rail 7905 so ground is common and the regulator is easier to substitute.
- 27C128–27C512 ROM support with a 4-bank DIP-switch selector (concatenate four 16KB images into a 64KB EPROM).
- Replacement /ROMDIS logic (IC11, 74LS00) so external expansions can correctly disable the system ROM — fixed in v1.2 and verified with the Loci expansion.
- A second socket for the cheaper AY-3-8910 sound chip as an alternative to the AY-3-8912.
- AD724-based composite video plus stereo audio on a 3.5mm TRRS jack (OMTP wiring, Amstrad CPC channel layout), replacing the original PROM-based RF composite generation.
- Integrated tape modifications (service-manual "Improved Cassette Loading" plus a mod from an original board), speaker volume control, an additional system reset button, 4464 RAM, and an optional on-board Commodore 1531 tape interface.

## Architecture

The board keeps the original Oric architecture and chip set — it is a replica, not a clone — so the ULA and the 6502A/6522A/AY core remain mandatory. The KiCAD 9 design is organised into hierarchical schematic sheets matching the Oric's functional blocks (CPU/ULA, I/O, power, RAM, ROM, video). The notable architectural change is the power rail: moving from negative-rail (7905) to positive-rail (7805) regulation makes ground common, which can conflict with expansions that still regulate on the negative rail — separate power adapters are advised in that case. IC11 is now a hard requirement because it carries both clock and the corrected /ROMDIS logic.

## Example usage

A built Oric Remix board drops into an Oric repair or rebuild, displaying over the AD724 composite/TRRS output and loading software from the original 7-pin DIN tape port or the optional Commodore 1531 interface. The DIP switch SW2 selects one of four 16KB ROM banks. Keyboard options are still evolving: an MX-keyswitch keyboard replica is planned, and a prototype PS/2 keyboard interface (with provision for USB) is included as the `Expansions/Oric-PS2USB` expansion, with Arduino firmware and its own KiCAD project.

## Maintenance status

A small project (3 stars, 2 forks) by The Board Folk team, actively maintained — last updated May 2026 and migrated to KiCAD 9. Two public revisions exist: v1.1 (initial release) and v1.2, which fixes a /ROMDIS defect where the signal failed to disable the internal ROM. v1.1 boards can be field-modified with the documented track-cut-and-bridge-wire procedure. No formal license is declared, but the README places the schematics and PCB layouts in the public domain for study and historical preservation, permitting personal or commercial fabrication at the builder's own risk. Credits: PCB layout by Rob Taylor (@peepouk), modifications and schematic recreation by Ian Cudlip (@grandoldian), research and documentation by Chrissy (@chris_jh), /ROMDIS fix by Simon Luce.
