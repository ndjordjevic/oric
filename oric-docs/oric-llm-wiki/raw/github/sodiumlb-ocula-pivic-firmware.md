# sodiumlb/ocula-pivic-firmware

## Metadata
- Stars: 10
- Forks: 2
- Primary language: C
- Default branch: main
- Latest release: v0.1.4 (2026-05-04)
- License: BSD 3-Clause "New" or "Revised" License
- Homepage: (none)
- Pushed at: 2026-05-15
- Fetched: 2026-05-17
- Final URL: https://github.com/sodiumlb/ocula-pivic-firmware

## Description
Firmware for the OCULA and PIVIC Oric ULA / MOS VIC replacement project.

## README
# Oric OCULA and VIC-20 PIVIC Firmware

This is the firmware source for two related video replacement devices. It is using the Rumbledethumps' Picocomputer 6502 (RP6502) https://picocomputer.github.io/ as a starting point, framework, and some modules.

## Oric OCULA
A modern implementation of the HCS10017 ULA, used in Oric 8-bit computers like the Oric-1, Atmos and clones.

## VIC-20 PIVIC
A modern implementation of the MOS VIC 6560 and 6561, used in Commodore VIC-20 8-bit computers.

## Dev Setup
This is only for building the OCULA and PIVIC firmware.

Install the C/C++ toolchain for the Raspberry Pi Pico (see "Getting started with the Raspberry Pi Pico"):
```
sudo apt install cmake gcc-arm-none-eabi libnewlib-arm-none-eabi build-essential gdb-multiarch
```

All dependencies are submodules. The following will download the correct version of all SDKs:
```
git submodule update --init
cd src/pico-sdk
git submodule update --init
cd ../..
```

To build from the command line in a separate build directory:
```
mkdir build
cd build
cmake ../
make
```
Note that debug target builds are currently too slow for stable operation. Use Release target builds.

## Related projects
* OCULA documentation project — https://github.com/sodiumlb/ocula-docs/wiki
* OCULA hardware project
* PIVIC documentation project — https://github.com/sodiumlb/pivic-docs/wiki
* PIVIC hardware project

## Top-level structure
- `CMakeLists.txt` — top-level CMake build
- `LICENSE` — BSD 3-Clause
- `README.md`
- `.gitmodules` — all SDK/library dependencies are git submodules
- `src/` — firmware source:
  - `firmware/` — the firmware itself: `main.c`, `main.h`, `modes/`, `mon/` (monitor program), `oric/` (Oric/OCULA-specific code), `vic/` (VIC-20/PIVIC-specific code), `sys/`, `term/`, `usb/`, `str.c/.h`, `tusb_config.h`
  - `boards/` — board definitions
  - submodules: `pico-sdk/`, `pico-extras/`, `pico_hdmi/`, `tinyusb/`, `littlefs`, `emu2149` (AY-3-8910 emulation library)
  - `memmap_xram.ld`, `memmap_xram_rp2350.ld` — linker scripts (RP2040 and RP2350)
- `.github/`, `.vscode/` — CI and editor config

## Notes
- Built on the RP6502 (Rumbledethumps Picocomputer 6502) framework.
- The same firmware codebase serves both OCULA (Oric ULA) and PIVIC (VIC-20 VIC) — twin projects.
- `pico_hdmi` submodule provides the digital DVI/HDMI video output; `emu2149` provides AY sound-chip emulation.
- Released firmware `.UF2` files are published on the repo's Releases page.
