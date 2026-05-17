# OldWer/Metaphoric

## Metadata
- Stars: 5
- Primary language: (none — hardware/KiCAD project)
- Default branch: main
- Latest release: (none)
- License: Creative Commons Zero v1.0 Universal (CC0-1.0)
- Homepage: (none)
- Fetched: 2026-05-17
- Final URL: https://github.com/OldWer/Metaphoric

## Description
An Oric clone

## README
<img src="./Pictures/MetaphoricLogo.png">

# Metaphoric - an enhanced Oric clone
Metaphoric is an Oric clone with the memory subsystem based on the OriClone-1 project and some additional features:
* Composite video output (RCA socket)
* TRRS audio-video socket for connecting "jack to 3xRCA" cable
* Footprints for both original AY-3-8912 chips and for (much cheaper) AY-3-8910 chips (or other 40-pin clones)
* Ability to use 7905 or 7805 power regulator and also to power the Metaphoric using an external +5V power supply
* Two Atari-standard joystick ports on the keyboard PCB — one is an IJK „Stingy" port, the other is a cursors+space joystick for games that do not support IJK but are controlled with cursors or make it possible to redefine the keys.
* Easily accessible RESET and NMI buttons on top of the keyboard.
* Easily accessible switches for changing the ROM between Oric-1 and Oric Atmos and for disabling the IJK interface (it may interfere with the operation of printer port and it can also corrupt sound in games that do not support IJK, e.g. Manic Miner)
* Automatic hardware V-sync hack - original Orics did not have any way of checking the vertical sync signal, which made it difficult to write games without flickering sprites, so somebody came up with the idea of connecting video sync signal to tape in using an external cable and synchronizing games/demos in that way. Metaphoric has a transistor that connects sync out to tape in when the tape relay is inactive and disconnects it when the relay is active (to allow loading from tape).

# Building the Metaphoric
Note: The main PCB fits in the original Oric-1/Atmos case (the keyboard PCB does not!). If you would like to use the main PCB with the original keyboard and case, do not install J10 (TRRS socket) and J7 (auxiliary connector that supports the extra switches, buttons and ports on the keyboard). Also all the chips near the bottom of the board - IC10, IC15/18, IC5, IC6, IC12 and IC16 - cannot be socketed and must be soldered directly to the board, or the original case won't close.

The repository contains two directories with KiCAD projects for the main PCB and the keyboard PCB. The bill of materials is available in BOM.* files in the respective directories (in .csv, .xlsx and .PDF formats). In the gerbers subdirectories there are gerber files ready for manufacturing (recommended JLCPCB settings were used when exporting the gerbers). In the main PCB's STL subdirectory there are 3D models for a simple case and also for a spacer which you can print in 5 copies and which is used to separate the two boards. In the keyboard's STL subdirectory there is a 3D model for a holder that fits in the big square holes in the keyboard PCB and holds a typical space key stabilizer.

Note about ROMs: You can use either a 28c128 EEPROM or a 27c512 EPROM, appropriate .bin files are in the MetaphoricV2/ROM subdirectory. 27c256 EPROM would be enough to store two 16K banks with Oric-1 and Atmos ROMs, but it has different pinout - it would still work, but it wouldn't be possible to select ROM banks and only the high bank would be available. However, if you happen to have only 27c256 EPROMs, you may cut the trace between the ROM pins 27 and 28 (on the back of the PCB) and run a bodge wire from ROM pin 1 to ROM pin 27; this should make it possible to use a 27c256 EPROM with switchable banks.

Most of the build is pretty self-explanatory, as all the components are described on the PCB. The things to watch for, in no particular order, are as follows:
1. You can omit all the parts in the 'COMPOSITE VIDEO SECTION' if you're only planning to use the RGB output (except for the TRRS socket, which can also be used to output audio, and the J11 header). The file 'RGB_Scart_Tape.pdf' shows how to build a SCART cable, the recommended way of using an Oric, original or cloned.
2. Next to the composite RCA socket there is the J11 header. Jumper on pins 2-3 uses the nearby 3.5mm TRRS socket as audio/video out (ready-made 3.5mm jack-3 x RCA cables can be used). Jumper on pins 1-2 uses the TRRS socket as a regular 3.5mm stereo sound out.
3. You can omit all the parts in the "AMPLIFIER SECTION" if you're not going to use the internal speaker (recommended to skip — sound quality is poor with the internal speaker).
4. The J1 header on the right side of the board can switch the ROM bank, but if the main PCB is connected to the Metaphoric keyboard PCB, it should not be jumpered (the keyboard PCB switch does the same; leaving J1 jumpered risks shorting +5V to ground).
5. In the power section there are footprints for either 7905 or 7805 regulator. 7905 is recommended only for use with original Oric accessories such as floppy drives (or recreations like Cumana Reborn). Modern solutions (Erebus, Loci) can use 7805 or external +5V. Close J12 if using 7905, close J13 if using 7805. Closing both J12+J13 (no regulator installed) allows an external +5V supply, center positive. With a regulator, power with +9V, center positive.
9. The main PCB and keyboard PCB are connected via pin headers - J3 and J7 on the main PCB, J1 and J2 on the keyboard PCB - mounted back to back, with 3D-printed spacers between them, screwed to the case using M3x16 or M3x18 screws.
10. On the keyboard, the joystick ports must be soldered on the back side of the PCB.
11. Solder jumpers JP2 and JP3 configure additional joystick buttons (as in MSX, Amstrad CPC, Sega Master System/Amiga joysticks). See the note in the keyboard schematic.
12. The spacebar stabilizer holder must be printed once normal and once mirrored (not symmetrical), pushed into the keyboard PCB holes, with the stabilizer glued on.

Contact: oldwer@op.pl. License: CC0-1.0.

## Docs
(No docs/ directory. The repository ships a build guide as RGB_Scart_Tape.pdf — a PDF showing how to build a SCART cable for RGB + tape output.)

## Top-level structure
- `LICENSE` — CC0-1.0 public domain dedication
- `MetaphoricV2/` — KiCAD project for the main PCB. Contains hierarchical schematics (`CPU.kicad_sch`, `ULA.kicad_sch`, `memory.kicad_sch`, `power.kicad_sch`, `reset.kicad_sch`, `sound.kicad_sch`, `tape.kicad_sch`, `video_out.kicad_sch`, top `MetaphoricV2.kicad_sch`), `MetaphoricV2.kicad_pcb`, BOM in `.csv`/`.pdf`/`.xlsx`, `gerbers/`, `3DModels/`, `STL/` (case + board spacer models), `svg/`, and `ROM/` with `DualROM27C512.bin` and `DualROM28C256.bin` (dual Oric-1 + Atmos ROM images)
- `MetaphoricKBV2/` — KiCAD project for the keyboard PCB. Contains `MetaphoricKBV2.kicad_pcb`, `MetaphoricKBV2.kicad_sch`, BOM (`.csv`/`.pdf`/`.xlsx`), `gerbers/`, `3DModels/`, `STL/` (spacebar stabilizer holder), `svg/`, `switch small.stp`
- `Pictures/` — build photos and logo (PCB backs, joystick port wiring, assembly shots)
- `README.md` — feature list and full build guide
- `RGB_Scart_Tape.pdf` — SCART cable build instructions
