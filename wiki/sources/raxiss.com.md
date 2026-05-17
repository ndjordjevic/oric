---
type: source
source_url: https://www.raxiss.com/article/id/38-LOCI
tags: [loci, oric-hardware, expansion-port, floppy-emulation, rom-emulation, usb, raspberry-pi-pico, storage-emulation]
related: [sodiumlb-loci-firmware]
product: loci
detail_level: standard
created: 2026-05-17
updated: 2026-05-17
---

LOCI is a hardware peripheral by RaxIss that plugs into the Oric BUS Expansion port of Oric-1/Atmos computers. It provides ROM and mass-storage emulation — replacing physical floppy disks and cassette tapes — as well as USB HID and CDC device support. LOCI is sold commercially on Lectronz (EU) and Tindie (worldwide) and is the centrepiece of the raxiss.com site.

_All claims below are sourced from ../../raw/web/raxiss.com.md unless otherwise noted._

## What it does

LOCI emulates floppy disk drives and cassette tape devices for the Oric-1 and Oric Atmos, eliminating the need for physical media. It also emulates ROM chips, allowing the Oric to boot from ROM images stored on the device. Additionally, LOCI exposes a USB host port supporting HID peripherals (mouse, keyboard, game controllers) and CDC devices (serial, serial modem).

## Key features

- Floppy and cassette storage emulation via the Oric BUS Expansion port
- ROM emulation: boot from ROM images including BASIC 1.0, BASIC 1.1b, Pravetz 11a, and diagnostic ROMs
- Built-in ROMs in release firmware: locirom, basic10.rom, basic11b.rom, pravetz11a.rom, test108k.rom, microdis.rom
- USB peripheral support: HID (mouse, keyboard, game controllers) and CDC (serial, serial modem)
- Action button: short press boots the LOCI configuration ROM; long press boots Mike Brown's diagnostic test108k.rom (on diagrom-enabled builds)
- Available pre-built with firmware from RaxIss (Lectronz, EU) and 8BitClub (Tindie, worldwide)

## Architecture and concepts

LOCI is an external hardware module that connects to the Oric's expansion bus. The underlying firmware runs on a Raspberry Pi Pico (RP2040) and is based on the RP6502 Picocomputer architecture, adapted as a MIA (Media Interface Adapter). The MIA handles the interface between the RP2040 and the Oric's 6502 expansion bus, intercepting floppy and tape I/O requests and responding from image files stored on flash or an SD card.

## When to use

LOCI is the primary modern solution for Oric-1/Atmos owners who want to load and run software without physical floppy disks or cassette tapes. It is also useful for developers who need to test ROM images or run diagnostic routines on real hardware.

## Ecosystem

- LOCI firmware source: [[sodiumlb-loci-firmware]]
- LOCI User's Manual: https://github.com/sodiumlb/loci-hardware/wiki/LOCI-User-Manual (hosted in the loci-hardware GitHub wiki)
- LOCI ROM (configuration ROM): https://github.com/sodiumlb/loci-rom
- Mike Brown's Oric Diagnostic ROM: https://oric.signal11.org.uk/html/diagrom.htm
- Sold by RaxIss at Lectronz: https://lectronz.com/products/loci-oric-bus-expansion-port-and-floppy-emulator
- Sold by 8BitClub at Tindie: https://www.tindie.com/products/8bitclub/loci-oric-bus-expansion-port-and-floppy-emulator/
