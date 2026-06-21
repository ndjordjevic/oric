# MiSTer-devel/Oric_MiSTer

## Metadata
- Stars: 9
- Primary language: VHDL
- Default branch: master
- Latest release: (none)
- License: (none)
- Homepage: (none)
- Fetched: 2026-06-21
- Final URL: https://github.com/MiSTer-devel/Oric_MiSTer

## Description
Oric-1 and Oric Atmos for MiSTer

## README
# Oric / Oric Atmos for MiSTer

This repository contains an Oric-1, Oric Atmos, and Pravetz 8D FPGA core for
the MiSTer platform. The current development focus is making the core practical
for day-to-day software use: TAP loading, snapshot restore, ROM selection,
Microdisc support, and MiSTer launcher files.
The latest additions:
- Pravetz 8D DOS 8D support for 5.25 floppy disks, compatible with the hardware for the Bulgarian clone
- Fixed F11/F10 Reset/NMI buttons

The core descends from the earlier MiST / SiDi Oric FPGA work. The original
project notes and credits are preserved below, but this README now reflects the
current MiSTer tree.

## Current Status

Implemented and actively maintained:

- Oric-1 and Oric Atmos operation with full 64 KiB RAM.
- Pravetz 8D ROM option with proper keymapping
- ULA video, 6502 CPU, VIA 6522, AY-3-8912 sound and keyboard matrix handling.
- Microdisc support with EDSK / CPC DSK images.
- TAP loading through the MiSTer file loader.
- Original cassette-audio loading path via VIA cassette input behavior.
- Smart CLOAD menu with three modes:
  - `Fast`: default mode, keeps the ROM tape flow in charge while feeding TAP
    bytes directly and aligning ROM sync to TAP leader bytes.
  - `Ultra`: segment-copy loader for simple CLOAD flows.
  - `Off`: original cassette/VIA behavior.
- Autoload TAP setting for resetting into `CLOAD""` after a TAP is selected.
- Oricutron-compatible `.sna` snapshot loading for RAM, CPU, AY and VIA state.
- Savestate support via the MiSTer Main savestate framework: **F1-F4** save
  to slots 1-4, **F5-F8** restore. Requires a tape to be loaded. Disk support may eventually come.
- MGL launcher samples for TAP files and snapshots.
- Pravetz 8D DOS support

## Repository Layout

- `rtl/` - VHDL/Verilog implementation modules.
- `docs/` - technical notes and implementation references.
- `tools/` - build, TAP inspection, TAP merge/split, and SNA inspection tools.
- `games/Oric/tap/` - TAP files using the target MiSTer games layout.
- `games/Oric/snapshots/` - Oricutron `.sna` files using the target games layout.
- `_Games/_Oric/_tap/` - sample MGL launchers for TAP files.
- `_Games/_Oric/_snapshots/` - sample MGL launchers for snapshots.
- `dsk/` - disk images in the supported EDSK format.
- `releases/` - checked-in release `.rbf` builds.

Start with `docs/docs.md` for the documentation index and `tools/tool.md` for
the tool summary.

## Building

Build the core with:

```sh
./tools/oric-build
```

The build script compiles `Oric.qpf`. Its deployment behavior is intended for
the maintainer's local MiSTer setup, so check `docs/build.md` before relying on
it unchanged.

Useful references:

- `docs/build.md` - build workflow, clean builds, release naming, and troubleshooting notes.
- `tools/tool.md` - command summaries and examples.

## Loading Software

For TAP files, place software under the MiSTer games path:

```text
/media/fat/games/Oric/tap
```

The matching MGL launchers belong under:

```text
/media/fat/_Games/_Oric/_tap
```

For snapshots, place `.sna` files under:

```text
/media/fat/games/Oric/snapshots
```

The matching snapshot MGL launchers belong under:

```text
/media/fat/_Games/_Oric/_snapshots
```

## Documentation Highlights

- `docs/tape_loading.md` - TAP modes, Autoload TAP, Smart CLOAD, Fast vs Ultra, and cassette fallback.
- `docs/sna_support.md` - Oricutron snapshot support and restore details.
- `docs/oric_memory_map.md` - Oric memory map, I/O windows, vectors, and hardware overview.
- `docs/oric_to_core_comm.md` - communication between the 6502 and FPGA core.
- `docs/live_rom_patching.md` - ROM read-side patching used by Smart CLOAD.
- `docs/Oric Rom.md` - searchable Atmos ROM disassembly.

## Disk Images

Despite the `.dsk` extension, disk images must use the de facto EDSK / CPC DSK format. To convert Oric disk images, use HxCFloppyEmulator and export as `CPC DSK file`, keeping the `.dsk` extension for MiSTer use.

If a disk is bootable, select it from the OSD, exit the OSD, then reset the core. If it is not bootable, try `DIR` and then `!NAME_OF_FILE_TO_RUN`.

## Original Project Credits

This core builds on earlier Oric FPGA preservation work for MiST and SiDi.

- Ron Rodritty: team coordination and QA testing.
- Fernando Mosquera: FPGA.
- Subcritical: Verilog and VHDL.
- ManuFerHi: hardware consulting.
- Chema Enguita: Oric software.
- SiliceBit: Oric hardware.
- ZXMarce: hardware support.
- Ramon Martinez: Oric hardware, software, and FPGA coding.
- Slingshot: SDRAM work and advice.

Thanks also to Sorgelig, Gehstock, DesUBIKado, RetroWiki, and friends.

## Docs
_(docs/ directory referenced in README but not present as a top-level directory in the fetched tree — contents likely embedded inline or not yet committed.)_

## Top-level structure
- `.gitignore` — gitignore
- `Oric.qpf` — Quartus project file (top-level project definition)
- `Oric.qsf` — Quartus settings file (pin assignments, synthesis options)
- `Oric.srf` — Quartus suppress-warnings file
- `Oric.sv` — Top-level SystemVerilog module; MiSTer HPS interface and core wiring
- `Oric.srf` — Quartus suppress-warnings file
- `README.md` — main documentation
- `clean.bat` — Windows build-artifact cleanup script
- `files.qip` — Quartus IP file list
- `dsk/` — disk images in EDSK/CPC DSK format
- `img/` — screenshots/images
- `releases/` — checked-in `.rbf` release builds
- `rtl/` — VHDL/Verilog implementation: `oricatmos.vhd`, `ula.vhd`, `m6522.vhd`, `microdisc.vhd`, `video.vhd`, `psg.v`, `keyboard.sv`, `joystick.sv`, `cassette.v`, `snap_loader.v`, `tap_byte_streamer.v`, `tap_segment_loader.v`, `cload_patch_rom.v`, `savestate_hotkeys.v`, `wd1793.sv` (FDC), `T65/` (6502 core), and ROM files
- `sys/` — MiSTer framework system files (shared across all MiSTer cores)
- `tools/` — build script (`oric-build`), TAP tools (`tape-inspect.py`, `splitter.py`, `merger.py`), SNA tools (`sna-inspect.py`), savestate conversion (`ss-convert.py`), and `tool.md` summary

## Tools summary (tools/tool.md)

### Build tool
- `oric-build` — compiles `Oric.qpf` inside `raetro/quartus:mister` Docker image; deploys `.rbf` to MiSTer. Options: `--no-deploy`, `--clean`, `--no-hdmi`, `--snap-debug`.

### TAP inspection and manipulation
- `tape-inspect.py` — prints structure of `.tap` files; handles multi-segment tapes; detokenizes BASIC. Modes: `--short`, `--basic`, `--full`.
- `splitter.py` — splits multi-segment `.tap` into one file per segment.
- `merger.py` — concatenates multiple `.tap` files; `--replace-cload` rewrites tokenized CLOAD to PRINT in BASIC segments.

### Snapshot tools
- `sna-inspect.py` — decodes Oricutron `.sna` typed-block containers; validates block structure; decodes CPU/AY/VIA blocks.
- `ss-convert.py` — converts between MiSTer savestates (`.ss`) and Oricutron `.sna` snapshots. Modes: `to-sna`, `to-ss`, `inspect`.
