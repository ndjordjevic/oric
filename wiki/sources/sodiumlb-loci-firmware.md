---
type: source
source_url: https://github.com/sodiumlb/loci-firmware
tags: [loci, oric-hardware, firmware, raspberry-pi-pico, rp2040, floppy-emulation, rom-emulation, mia, c]
related: [raxiss.com]
product: loci-firmware
detail_level: standard
created: 2026-05-17
updated: 2026-05-17
---

The `loci-firmware` repository by sodiumlb contains the C firmware source for the Oric LOCI device, a storage- and ROM-emulation peripheral for Oric-1/Atmos computers. Built on the RP6502/Picocomputer architecture, its core component is a MIA (Media Interface Adapter) running on the Raspberry Pi Pico (RP2040) that bridges the Oric expansion bus with modern flash storage and USB peripherals.

_All claims below are sourced from ../../raw/github/sodiumlb-loci-firmware.md unless otherwise noted._

## What it does

The firmware enables the LOCI hardware to emulate floppy disk drives and cassette tape devices on the Oric expansion bus, intercept ROM reads to serve ROM images from embedded flash, and support USB HID and CDC devices. It is the software component of the LOCI product sold by RaxIss; end users typically flash pre-built `.uf2` release images rather than building from source. The repository also includes embedded ROM files (LOCI ROM, Mike Brown's diagnostic ROM) packaged into release builds.

## Key features

- MIA (Media Interface Adapter) firmware adapting RP6502 architecture for Oric bus compatibility
- Floppy and tape storage emulation served from flash/SD
- ROM emulation: embedded ROMs compiled into the firmware image (locirom, basic10, basic11b, pravetz11a, test108k, microdis)
- Mike Brown's Oric Diagnostic ROM included in release builds (long-press Action button to boot)
- USB HID and CDC host support via TinyUSB
- FAT filesystem support via FatFs; LittleFS for internal flash storage
- CMake-based build system; cross-compiles for ARM Cortex-M0+ (Pico)
- BSD 3-Clause licensed

## Architecture

The project is structured as a CMake project targeting the Raspberry Pi Pico SDK. Key dependencies are managed as Git submodules: `pico-sdk`, `tinyusb`, `fatfs`, `littlefs`, and `pico-extras`. The core firmware lives in `src/mia/` (the MIA implementation), with the linker script `memmap_xram_mia.ld` placing the firmware in extended RAM. ROM images placed in `src/roms/` before a CMake reconfiguration are compiled into the image as binary data objects.

## Installation

Install the ARM toolchain and Pico SDK build prerequisites:
```
sudo apt install cmake gcc-arm-none-eabi libnewlib-arm-none-eabi build-essential gdb-multiarch
```

Initialise submodules (do not recurse fully — takes too long; use the two-step approach):
```
git submodule update --init
cd src/pico-sdk && git submodule update --init && cd ../..
```

Build:
```
mkdir build && cd build
cmake ../
make
```

## Example usage

Example programs targeting the Oric+LOCI environment are in `examples/`:
- `blink/` — minimal blink demo
- `helloworld_64tass/` — hello world assembled with 64tass
- `helloworld_cc65/` — hello world compiled with cc65
- `rp6502.py` — Python helper script for the RP6502 API

End users flash pre-built firmware releases (`.uf2` files) from the releases page or from https://www.raxiss.com/article/id/38-LOCI.

## Maintenance status

11 stars, 3 forks, BSD 3-Clause license. Latest release: v0.3.1. Last pushed: March 2026. Actively maintained by sodiumlb (RaxIss). The companion LOCI product page and pre-built firmware downloads are at [[raxiss.com]].
