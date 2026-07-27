---
type: source
source_url: https://github.com/sodiumlb/loci-hardware
tags: [loci, oric-hardware, pcb-design, kicad, expansion-port, bom, floppy-emulation, rom-emulation, rp2040]
related: [sodiumlb-loci-firmware, raxiss.com]
product: loci-hardware
detail_level: standard
created: 2026-05-17
updated: 2026-05-17
---

The `loci-hardware` repository by sodiumlb is the hardware design counterpart to the LOCI firmware: it contains the PCB production files (Gerbers, BOM, pick-and-place, EasyEDA schematics and layout), FreeCAD case designs, and the GitHub wiki that serves as the primary end-user manual for the LOCI peripheral. LOCI is a 34-pin IDC expansion-bus board that connects to Oric-1/Atmos computers and provides floppy-disk, cassette, and ROM emulation from flash/USB, plus a USB-C host port for HID and CDC devices.

_All claims below are sourced from ../../raw/github/sodiumlb-loci-hardware.md unless otherwise noted._

## What it does

LOCI hardware revision 1.3 is a compact PCB that plugs into the Oric BUS Expansion port via a 34-pin IDC cable. Once connected, it allows the Oric to boot from emulated floppy disks (.DSK), cassette tapes (.TAP), or ROM images (.ROM) stored on LOCI's 15 MB internal flash or on a connected USB thumb drive. A USB-C host port exposes a USB 2.0 Full Speed hub interface for peripherals — storage drives, HID devices (mouse, keyboard, game controllers), and CDC serial devices. The LOCI UI, launched by pressing the Action button, provides a keyboard-driven menu for mounting virtual drives, selecting ROMs, and tuning bus timing. The repo also bundles the GitHub wiki as the end-user reference manual.

## Key features

- Four virtual Microdisc floppy drives (A–D) emulating the WD179x FDC; MFM_DSK format only
- Cassette emulation via Basic ROM patching (Basic 1.0 and 1.1); .TAP file playback with byte-accurate seek
- ROM emulation: replaces the Oric ROM with LOCI ROM, Basic 1.0/1.1, or custom 16 kB .ROM files; Mike Brown's diagnostic ROM included (long-press Action to boot)
- 15 MB internal flash (LittleFS) for user files; USB storage (FAT/exFAT via FatFS)
- ACIA emulation over USB CDC modem devices (e.g. PicoWiFiModemUSB)
- USB HID access for mouse and other HID devices, exposed as new Oric APIs
- Session suspend/resume: pressing Action during a running program suspends it and re-enters the LOCI UI; return restores the program state
- Bus timing tuning: user-adjustable RV1 (MAP delay) and auto-tunable tior (IO read delay) to accommodate temperamental Oric hardware
- Firmware update via USB mass-storage drag-and-drop of a .UF2 file; ROM updatable independently from firmware

## Architecture

The board is built around a Raspberry Pi RP2040 (U1) acting as MIA (Media Interface Adapter), clocked by a 12 MHz crystal. The RP2040 talks to the Oric expansion bus through a 74LVC4245APW bidirectional level-shifter (U3) and a bank of nine SN74LVC2G17DBVR Schmitt-trigger buffers (U11–U19) that condition the 5 V Oric bus signals for the 3.3 V RP2040. A 128 Mbit SPI flash (W25Q128JVSIQ, U4) provides the 15 MB internal user-file storage. The USB-C port is handled by a TUSB321RWBR USB Type-C controller (U21) for CC detection. Three MT9700 load switches (U10, U20, U22) manage the power topology: LOCI can be powered from the Oric expansion port or from the USB-C port, but not both simultaneously — when USB-C is live, the expansion-port power feed is digitally disconnected for safety. Power budget notes recommend a 9V/1A supply for the Oric when LOCI is used with USB peripherals. The three user buttons (Action, Reset, Firmware) are TS-1187A-B-A-B tactile switches. The case designs are in FreeCAD format (two versions: v5 and v6 for rev 1.3).

## Installation

No firmware build is required for end users. Assemble or order the PCB using the production files in `pcb/`:
- `Gerber_loci-1.3_PCB_loci_1.3.zip` — submit to a PCB fab (e.g. JLCPCB)
- `BOM_loci-1.3.csv` — 35 LCSC part numbers for SMT assembly
- `PickAndPlace_PCB_loci_1.3.csv` — for SMT pick-and-place machines

Firmware flashing (after board assembly): hold the Firmware button, connect LOCI via USB-C to a computer, release the button. LOCI appears as a USB storage device; drag the `.uf2` firmware file onto it. Download pre-built firmware releases from [sodiumlb/loci-firmware](https://github.com/sodiumlb/loci-firmware/releases).

Connect to Oric using a short straight 34-pin IDC cable, matching pin 1.

## Example usage

First power-on: connect LOCI to the Oric expansion port. If LOCI is not configured, the Oric boots normally. Press the Action button once to enter the LOCI UI.

In the LOCI UI, navigate to a virtual floppy drive (key `A`), press `Space` to open the file browser, browse to a `.DSK` file on the USB device (device 0 = internal flash, "MSC" = USB drives), and press `Space` to mount it. The Microdisc On/Off switch is set automatically. Press `Esc` to boot. The Oric will boot into the emulated Microdisc environment.

For cassette loading, navigate to the tape drive (`T`), mount a `.TAP` file, and press `Esc` to boot with ROM patching active.

## Maintenance status

13 stars, 2 forks, no stated license, no formal releases. Last pushed January 2025. Maintained by sodiumlb (RaxIss). The commercial product is sold via [[raxiss.com]]; firmware source is at [[sodiumlb-loci-firmware]].
