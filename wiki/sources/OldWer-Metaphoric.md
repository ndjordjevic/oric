---
type: source
source_url: https://github.com/OldWer/Metaphoric
tags: [oric-clone, kicad-pcb, hardware-replica, ay-3-8912, composite-video, scart-rgb, joystick-ports, eprom-rom]
related: [Board-Folk-Oric-Remix, oric.free.fr, JennyDigital-OriClone-1]
product: metaphoric
detail_level: standard
created: 2026-05-17
updated: 2026-05-17
---

Metaphoric is an open-hardware clone of the Tangerine Oric-1 / Oric Atmos home computer, distributed as KiCAD PCB projects (main board + keyboard) under a CC0-1.0 public-domain dedication. Its memory subsystem is based on the earlier OriClone-1 project, and it layers on modern conveniences — composite video, flexible power options, dual joystick ports and an automatic V-sync hack — while remaining a faithful Oric. It matters to this wiki as a buildable, fully documented route to owning a working Oric without an original machine.

_All claims below are sourced from ../../raw/github/OldWer-Metaphoric.md unless otherwise noted._

## What it does

Metaphoric reproduces an Oric-1/Atmos as a pair of modern PCBs you fabricate and assemble yourself. The main PCB carries the CPU, ULA, memory, sound, video and tape circuits; a separate keyboard PCB carries the keys plus extra switches, buttons and joystick ports. A ROM switch selects between Oric-1 and Oric Atmos firmware, so a single build covers both machines.

## Installation

The repository ships two KiCAD projects — `MetaphoricV2` (main PCB) and `MetaphoricKBV2` (keyboard PCB) — each with a bill of materials in `.csv`, `.xlsx` and `.pdf`, ready-to-manufacture gerbers (exported with recommended JLCPCB settings), and STL files for 3D-printed parts (a simple case, board-separating spacers, and a spacebar stabilizer holder). Pre-built dual Oric-1+Atmos ROM images live in `MetaphoricV2/ROM` as `DualROM27C512.bin` and `DualROM28C256.bin`. The main PCB fits the original Oric-1/Atmos case (the keyboard PCB does not); to use the original case, omit the TRRS socket J10 and the auxiliary connector J7, and solder the lower-row chips directly rather than socketing them. `RGB_Scart_Tape.pdf` documents building a SCART cable, the recommended display connection.

## Key features

- Composite video output on an RCA socket, plus a TRRS audio-video socket for "jack to 3×RCA" cables.
- Footprints for both the original AY-3-8912 and the cheaper 40-pin AY-3-8910 (or other clones) sound chips.
- Flexible power: a 7905 or 7805 regulator, or direct external +5V supply (center-positive); the negative-rail 7905 is needed only for original Oric accessories such as floppy drives.
- Two Atari-standard joystick ports on the keyboard PCB: one IJK "Stingy" port and one cursors+space port for non-IJK games; solder jumpers JP2/JP3 configure extra fire buttons (MSX/CPC/SMS style).
- Easily accessible RESET and NMI buttons, plus switches to select the Oric-1/Atmos ROM and to disable the IJK interface.
- An automatic hardware V-sync hack: a transistor connects video sync to tape-in while the tape relay is inactive, giving software a way to detect vertical sync (original Orics required an external cable for this).

## Architecture

The design is split across two boards joined back-to-back by pin headers (J3/J7 on the main PCB, J1/J2 on the keyboard PCB) with 3D-printed spacers between them. The main PCB's KiCAD project uses hierarchical schematics that mirror the Oric's functional blocks: `CPU`, `ULA`, `memory`, `power`, `reset`, `sound`, `tape` and `video_out`. The memory subsystem derives from the OriClone-1 project. ROM bank switching connects ground or +5V to a ROM address line; because both the main-PCB header J1 and the keyboard switch drive the same line, J1 must be left un-jumpered whenever the keyboard PCB is attached to avoid shorting +5V to ground.

## Example usage

A typical build powers the board from a USB +5V supply with both J12 and J13 bridges closed and no regulator fitted (no internal heat). Display is via an RGB SCART cable built per `RGB_Scart_Tape.pdf`; the J11 header near the composite RCA socket selects whether the TRRS socket carries audio+video (jumper 2-3) or stereo sound only (jumper 1-2). Games are loaded from tape, or from modern storage expansions such as Erebus or Loci, which work with the 7805 / external-5V power options.

## Maintenance status

A small community project (5 stars, no forks) by a single author (contact `oldwer@op.pl`), last updated April 2025, with no tagged releases — the repository itself is the deliverable. It is released under CC0-1.0, placing all design files in the public domain.
