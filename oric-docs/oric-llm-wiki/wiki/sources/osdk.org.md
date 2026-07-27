---
type: source
source_url: https://osdk.org/
companion_urls:
  - https://github.com/Oric-Software-Development-Kit/osdk
raw_files:
  - ../../raw/web/osdk.org.md
  - ../../raw/github/Oric-Software-Development-Kit-osdk.md
tags: [osdk, oric-cross-development, 6502-assembler, c-compiler, xa-assembler, rcc16, floppybuilder, sdk-documentation]
related: [defence-force.org, forum.defence-force.org, oric.free.fr, library.defence-force.org, blog.defence-force.org, wiki.defence-force.org, oric.org]
product: osdk
detail_level: standard
created: 2026-05-17
updated: 2026-07-10
---

`osdk.org` is the dedicated documentation website for the Oric Software Development Kit — the modern cross-development toolchain for writing software targeting the Oric-1, Atmos, Telestrat, Pravetz 8D, and Oric Nova 64. It provides the complete reference for every OSDK tool and is the canonical place to look up compiler flags, assembler directives, linker pragmas, and utility documentation. The companion GitHub repository contains the C source of the toolchain itself, built by the same Defence Force team behind [[defence-force.org]].

_All claims below are sourced from ../../raw/web/osdk.org.md unless otherwise noted._

## What it does

The OSDK is a PC-hosted cross-development system for the Oric. Users write programs in BASIC, C, 6502 assembly, or any mix of the three, then invoke a batch-file build process that invokes the compiler, assembler, and linker and produces tape (`.tap`) or disk (`.dsk`) images ready to run on real hardware or in an emulator. The current release is **version 1.23** (April 2026).

## Key features

- **RCC16 C compiler** — an LCC-derived ANSI C compiler targeting the 6502; supports C++ comments; configurable optimisation (`-O2` / `-O3` via `OSDKCOMP`); the standard library is partial (memcpy, printf and similar implemented; most library not available).
- **XA assembler** — a 6502/65c02 assembler forked from XA in 1998; supports relocatable object files, cheap local labels, unnamed labels, and C-style preprocessing directives.
- **Source-level linker** — resolves label references and appends library source code before the final assembly pass; supports language-tag-based localisation via `#pragma osdk replace_characters` and forced symbol inclusion via `#pragma osdk import`.
- **Tape/disk utilities** — Bas2Tap, Tap2Dsk, Tap2Wav, Tap2Cd, WriteDsk, DskTool for moving between BASIC source, tape images, and disk images.
- **FloppyBuilder** — DOS-free disk image generator; stores files linearly for faster access, references them by integer index rather than name, and frees almost all 16KB of overlay memory.
- **Image and data tools** — PictConv (multi-format image conversion), FilePack (compression), Bin2Txt, Ym2Mym (YM → MYM music conversion), Header (tape header injection).
- **MemMap** — reads the assembler symbol list and generates an HTML memory-map report; supports a `-s` flag to list the largest data offenders by size.
- **Emulator integration** — Oricutron is the default emulator (Euphoric also supported); DOSBox mode for Euphoric under Linux.
- **Coverity static analysis** — the toolchain source is scanned for code quality.

## Architecture

The OSDK's build pipeline is batch-file driven: `OSDK_BUILD.BAT` orchestrates the compiler, assembler, linker and image tools. The standard library ships as source rather than binaries — the linker appends needed library source to the project before the final assembly pass, which keeps the library auditable and patchable without touching compiled objects. (../../raw/github/Oric-Software-Development-Kit-osdk.md)

The repository is structured under `osdk/main/` with a separate C source directory per tool: `compiler/`, `xa/` (assembler), `link65/` (linker), `filepack/`, `pictconv/`, `bas2tap/`, `makedisk/`, `MemMap/`, `macrosplitter/`, `Ym2Mym/`, and others. Shared code lives in `common/`. A top-level `rules.mk` and `Makefile` drive a Linux/Mac native build of the whole toolkit from source for those who cannot use the prebuilt Windows executables. The `euphoric_tools/` directory holds legacy Euphoric-era helpers (`Bin2Tap`, `tap2dsk`, `txt2bas`) that predate the main OSDK structure. (../../raw/github/Oric-Software-Development-Kit-osdk.md)

## Installation

Set the `OSDK` environment variable to the install directory (e.g. `C:\OSDK`). Optionally set `OSDKDOSBOX` to enable Euphoric through DOSBox with sound. On Windows the prebuilt archive is sufficient; on Linux extract to the Wine C: drive and set the variables via Wine's registry editor. Verify with `OSDK_BUILD.BAT` in a sample directory — a successful build produces a compiled binary and tape file in a `BUILD/` subfolder. (../../raw/github/Oric-Software-Development-Kit-osdk.md)

## Example usage

A minimal project build cycle:

```
OSDK_MAKEDATA.BAT   ← generate assets (if present)
OSDK_BUILD.BAT      ← compile, assemble, link, produce .tap / .dsk
OSDK_EXECUTE.BAT    ← launch emulator (exit with F10)
```

The OSDK ships five Hello World variants: BASIC, simple C, pure assembly, mixed C/assembly, and C with assembly subroutines demonstrating stack-based parameter passing. Larger bundled samples include Space:1999 (with intro and trailer), Hnefatafl (Viking Chess), the Pushing The Envelope demo, and 4K Kong and Cyclotron (assembly + FilePack compression). (../../raw/github/Oric-Software-Development-Kit-osdk.md)

## When to use

Use the OSDK and `osdk.org` when writing new software for any Oric model. It is the standard modern toolchain for Oric homebrew, with C, assembly, and BASIC support and a managed build, emulator, and disk-image pipeline. `osdk.org` is the reference when looking up specific tool behaviour — compiler data types, assembler directives, linker pragmas, FloppyBuilder commands, or utility flags.

## Maintenance status

Latest release: **v1.23** (April 20, 2026), upgrading XA to 2.3.1, Linker to 1.4, PictConv to 1.3, Compiler to 1.40, and MacroSplitter to 0.2. The GitHub repository (`Oric-Software-Development-Kit/osdk`, 9 stars, C, branch `master`) was last pushed April 2026 and carries no formal licence. The project has been continuously active since version 0.1 (March 2001). One known limitation: the standard library targets the Atmos 1.1 ROM; ROM-calling functions can crash on an Oric-1 or Telestrat. (../../raw/github/Oric-Software-Development-Kit-osdk.md)

## Ecosystem

`osdk.org` is one property of the Defence Force constellation, alongside [[defence-force.org]] (the main site with games, demos, and the Oric Library) and [[forum.defence-force.org]] (the phpBB support board where OSDK bugs and releases are discussed). The OSDK documentation site is deliberately separate from the main site so the toolchain reference is stable and bookmarkable. The software that OSDK produces runs on the original Oric hardware documented in [[oric.free.fr]] and on modern recreations such as Metaphoric and Oric-Remix.

## Documentation

The documentation is structured into five groups: **General** (Introduction, Installation, Creating project, Samples, Known issues, Glossary, Copyright), **Compilation** (Compiler, Assembler, Linker, Bas2Tap, MacroSplitter, MemMap), **Utilities** (Bin2Txt, FilePack, FloppyBuilder, Header, PictConv, Tap2Wav & Tap2Cd, Tap2Dsk, WriteDsk, Ym2Mym), **Emulators** (Euphoric, Oricutron), and **Technical information** (Zero page, Libraries, Memory map, Instruction Set). Each tool page carries a per-version changelog and links to the forum bug tracker.
