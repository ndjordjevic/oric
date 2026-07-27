---
type: source
source_url: https://github.com/sodiumlb/ocula-pivic-firmware
tags: [ocula, pivic, firmware, ula-replacement, raspberry-pi-pico, rp6502, c, dvi, oric-hardware]
related: [sodiumlb-ocula-hardware, sodiumlb-ocula-docs, sodiumlb-loci-firmware]
product: ocula-pivic-firmware
detail_level: standard
created: 2026-05-17
updated: 2026-05-17
---

The `ocula-pivic-firmware` repository by sodiumlb is the C firmware source shared by **two** open video-chip replacement devices: **OCULA** (a modern implementation of the Oric HCS10017 ULA) and **PIVIC** (a modern implementation of the Commodore VIC-20's MOS 6560/6561 VIC-I). It is BSD-3-Clause licensed and built on the RP6502 (Rumbledethumps Picocomputer 6502) framework, running on a Raspberry Pi Pico.

_All claims below are sourced from ../../raw/github/sodiumlb-ocula-pivic-firmware.md unless otherwise noted._

## What it is

A single firmware codebase serving the OCULA/PIVIC "twins". For the Oric, the OCULA firmware reimplements the ULA's functions — video generation, system memory handling, and Phi system-clock generation — on Pico hardware. The latest release is **v0.1.4** (May 2026); released firmware is distributed as `.UF2` files on the repository's Releases page.

## Repository structure

- `src/firmware/` — the firmware proper: `main.c`, plus `oric/` (Oric/OCULA code), `vic/` (VIC-20/PIVIC code), `modes/`, `mon/` (the USB monitor program), `sys/`, `term/`, `usb/`.
- Dependencies are git submodules: `pico-sdk`, `pico-extras`, `pico_hdmi` (digital DVI/HDMI output), `tinyusb`, `littlefs`, and `emu2149` (AY-3-8910 sound emulation).
- `memmap_xram.ld` / `memmap_xram_rp2350.ld` — linker scripts for RP2040 and RP2350.
- CMake build; **Release target builds only** — debug builds are too slow for stable operation.

## Building

Requires the Raspberry Pi Pico C/C++ toolchain (`cmake`, `gcc-arm-none-eabi`, `libnewlib-arm-none-eabi`). Submodules must be initialised (`git submodule update --init`, including `src/pico-sdk`'s own submodules). Standard out-of-tree CMake build.

## Current capability

Per [[sodiumlb-ocula-docs]], the firmware currently implements **only OCULA-is-the-RAM mode** (which needs the mux-bridge motherboard modification); DRAM-is-the-RAM mode — the true non-invasive drop-in — is not yet implemented. The firmware also provides a USB CDC serial **monitor program** for configuration (`SET SPLASH`, `SET DVI`, `SET MODE`, `STATUS`, memory read/write).

## Relevance to the build

This is the open firmware behind the OCULA hardware in [[sodiumlb-ocula-hardware]]. For the Metaphoric build it is part of the optional OCULA experiment (`projects/build-journey/01-decision-bom-order.md` §3): the firmware's reliability on genuine Orics improved through late-2025/2026 releases, but it was buggy earlier and has no confirmed clone support.

## Ecosystem

- Hardware: [[sodiumlb-ocula-hardware]]
- User documentation: [[sodiumlb-ocula-docs]]
- Built on the RP6502 framework — the same lineage as the LOCI firmware [[sodiumlb-loci-firmware]] (both by sodiumlb).
- The PIVIC half targets the Commodore VIC-20 (out of scope for this Oric wiki).
