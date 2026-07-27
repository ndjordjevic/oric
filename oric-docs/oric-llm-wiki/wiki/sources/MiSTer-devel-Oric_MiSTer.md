---
type: source
source_url: https://github.com/MiSTer-devel/Oric_MiSTer
tags: [mister-fpga, fpga-core, vhdl, oric-atmos, oric-1, pravetz-8d, tap-loading, snapshot-savestate, microdisc, emulation]
related: [sodiumlb-ocula-hardware]
product: oric-mister
detail_level: standard
created: 2026-06-21
updated: 2026-06-21
---

The `MiSTer-devel/Oric_MiSTer` repository is the official MiSTer platform FPGA core for the Oric-1, Oric Atmos, and Pravetz 8D computers. It implements the complete machine in VHDL/Verilog — 6502 CPU, ULA video, VIA 6522, AY-3-8912 sound, keyboard matrix, Microdisc FDC, and a Smart CLOAD tape engine — and integrates with the MiSTer HPS framework for file loading, OSD configuration, and savestate support. It is the primary route to running Oric software on MiSTer hardware and descended from earlier MiST/SiDi Oric core work.

_All claims below are sourced from ../../raw/github/MiSTer-devel-Oric_MiSTer.md unless otherwise noted._

## What it does

The core boots an Oric-1, Oric Atmos, or Pravetz 8D ROM and runs the selected software image loaded via the MiSTer OSD. It supports three software formats:

- **TAP files** — loaded through the MiSTer file loader into `/media/fat/games/Oric/tap/`; MGL launchers live under `_Games/_Oric/_tap/`.
- **Oricutron `.sna` snapshots** — full machine-state snapshots (RAM, CPU registers, AY, VIA); placed under `/media/fat/games/Oric/snapshots/`; corresponding launchers under `_Games/_Oric/_snapshots/`.
- **EDSK/CPC DSK disk images** — for Microdisc, selected from the OSD; files under `dsk/`.

## Key features

- Oric-1 and Oric Atmos operation with full 64 KiB RAM.
- Pravetz 8D ROM option with correct keyboard mapping and DOS 8D 5.25″ floppy support.
- ULA video, 6502 CPU, VIA 6522, and AY-3-8912 sound fully implemented in RTL.
- Microdisc support with EDSK/CPC DSK images.
- **Smart CLOAD** with three selectable modes:
  - `Fast` — feeds TAP bytes directly while keeping the ROM tape flow in charge; aligns ROM sync to TAP leader bytes.
  - `Ultra` — segment-copy loader for simple CLOAD flows.
  - `Off` — original cassette/VIA behavior.
- **Autoload TAP** — resets into `CLOAD""` after a TAP file is selected.
- **Savestate support** via MiSTer Main framework: F1–F4 save to slots 1–4, F5–F8 restore (requires a tape to be loaded).
- F10/F11 NMI/Reset buttons.

## Architecture

The top-level module is `Oric.sv`, a SystemVerilog file that wires the MiSTer HPS interface to the Oric core. The `rtl/` directory holds the VHDL/Verilog implementation: `oricatmos.vhd` is the top-level machine wrapper; `ula.vhd` implements the video ULA; `m6522.vhd` the VIA; `microdisc.vhd` and `wd1793.sv` the floppy controller; `video.vhd` the video pipeline; `psg.v` the AY sound; `keyboard.sv` and `joystick.sv` the input handling. Tape subsystem modules — `cassette.v`, `tap_byte_streamer.v`, `tap_segment_loader.v`, and `cload_patch_rom.v` — implement the Smart CLOAD engine including ROM read-side patching. Snapshot/savestate is handled by `snap_loader.v`, `snap_ss.v`, and `savestate_hotkeys.v`. The `T65/` subdirectory is the community 6502 soft-core. The `sys/` directory is the shared MiSTer framework, common across all MiSTer cores.

## Installation

Build the core with the provided Docker-based build script:

```sh
./tools/oric-build
```

Options: `--no-deploy` (compile only), `--clean` (remove build artefacts first), `--no-hdmi` (faster dev builds), `--snap-debug` (paint CPU registers on screen after snapshot load). The script expects `Oric.qpf` at the repo root and the `raetro/quartus:mister` Docker image.

Pre-built `.rbf` release files are checked into `releases/` and can be deployed directly to `/media/fat/_Computer/` on a MiSTer without building.

## Example usage

Load a TAP file via the MiSTer OSD after placing it under `/media/fat/games/Oric/tap/`. With Autoload TAP enabled the core resets into `CLOAD""` automatically. For multi-segment tapes the `tools/splitter.py` and `tools/merger.py` utilities handle splitting and recombining segments. To inspect a tape first:

```sh
python3 tools/tape-inspect.py --basic games/Oric/tap/example.tap
```

For disk images, select the EDSK `.dsk` file from the OSD, exit the OSD, then reset. For a bootable disk this is sufficient; for non-bootable disks type `DIR` then `!FILENAME`.

## Maintenance status

Active as of June 2026 (last push 2026-06-11). 9 stars, 15 forks. No formal releases; `.rbf` builds are committed directly to `releases/`. No explicit license in the repository. Credits acknowledge Ron Rodritty (QA), Fernando Mosquera (FPGA), Subcritical (Verilog/VHDL), Ramon Martinez (hardware and FPGA), and Slingshot (SDRAM), plus Sorgelig and the wider MiSTer community.

## Ecosystem

The core descends from the `rampa069/Oric_Mist_48K` MiST/SiDi core, which targets older FPGA platforms. For hardware-level understanding of what the core implements, [[sodiumlb-ocula-hardware]] provides the open ULA schematic that the RTL approximates, and [[oric.signal11.org.uk]] supplies the ULA reverse-engineering and diagnostic ROM used to validate hardware behavior.
