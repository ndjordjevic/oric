---
type: source
source_url: https://www.defence-force.org/
companion_urls:
  - https://github.com/Oric-Software-Development-Kit/Oric-Software
raw_files:
  - ../../raw/web/defence-force.org.md
  - ../../raw/github/Oric-Software-Development-Kit-Oric-Software.md
tags: [osdk, oric-cross-development, 6502-toolchain, lcc-compiler, xa-assembler, floppybuilder, oric-games, defence-force]
related: [oric.free.fr, forum.defence-force.org, osdk.org]
product: defence-force
detail_level: standard
created: 2026-05-17
updated: 2026-05-17
---

Defence Force (`defence-force.org`) is the personal Oric and Atari software-development site of Mickaël Pointier ("Dbug"), online since 1997 and still actively updated. Its centrepiece is the OSDK — the Oric Software Development Kit — a modern cross-development toolchain that builds Oric programs in BASIC, C and assembler from a PC. The site also publishes Oric games and demos, hosts the long-running "Oric Library" archive of scanned books and magazines, and runs the "Oriclopedia" video series. For this wiki it is the authoritative source on how new Oric software is written today, and the companion GitHub repository archives the source code of those games and demos.

_All claims below are sourced from ../../raw/web/defence-force.org.md unless otherwise noted._

## What it does

Defence Force is a hub for active Oric (and Atari) development and preservation. It distributes the OSDK toolchain, releases finished Oric games (Encounter, 1337, Blake's 7, Space:1999, Impossible Mission, Oricium) on itch.io and Steam, publishes Oric and Atari demos, and archives Oric-era literature. The OSDK itself is a cross-compiler suite: it runs on a modern PC and produces tape and disk images that run on real Oric hardware or in an emulator.

## Key features

- **OSDK** — a cross-development kit supporting BASIC, C and 6502/65c02 assembler, separately or mixed in one project, with a bundled emulator (Oricutron, with Euphoric as an alternative).
- **A complete tool suite** — the RCC16 C compiler, the XA assembler, a source-level linker, and utilities for tape/disk image generation (Bas2Tap, Tap2Dsk, FloppyBuilder, WriteDsk), data and image conversion (FilePack, PictConv, Bin2Txt), tape headers, music conversion (Ym2Mym) and memory-usage reporting (MemMap).
- **Published Oric games and demos** — modern releases with source code, screenshots and documentation; demos that won first place at STNICCC 2000.
- **The Oric Library** — downloadable PDFs of Oric magazines (Théoric, Micr'Oric, Oric Owner, Oric Computing, CEO Mag) and programming books.
- **A source-code archive** — the companion GitHub repository collects the source of many Oric demos, games, routines and tools by numerous contributors, organised under a shared `public/oric/` tree and per-author `users/` folders (../../raw/github/Oric-Software-Development-Kit-Oric-Software.md).

## Architecture

The OSDK's defining design choice is that its standard library is distributed as **source code**, not as binary library files: the linker appends the needed library source before the final assembly pass, which makes it easy to add functions and fix bugs. The RCC16 compiler is an Oric-targeted port of LCC; because the 6502 is 8-bit, pointers and `int` are 16 bits while `char` and `short` are 8 bits. The XA assembler forked from the official XA source around 1998 and has since selectively re-integrated upstream features while adding OSDK-specific extensions; it supports standard 6502 and Rockwell 65c02 opcodes and can emit relocatable `o65` object files. A separate disk subsystem, FloppyBuilder, replaces a general-purpose DOS for games and demos: since content is fixed at build time it stores files linearly and references them by integer index, freeing the DOS metadata space and almost all 16KB of overlay memory. The companion GitHub repository is organised as a two-tier archive — a curated `public/oric/` tree (assets, demos, games, hardware, routines, tools) and a `users/` tree of per-contributor project folders (../../raw/github/Oric-Software-Development-Kit-Oric-Software.md).

## Installation

The OSDK is installed by unzipping a release (versions are published from `osdk_0_9.zip` through the current `osdk_1_22.zip`) and setting a single `OSDK` environment variable pointing to the install folder. An optional `OSDKDOSBOX` variable lets the bundled Euphoric emulator run under DOSBox with sound. The toolchain runs on Windows natively and on Linux via Wine. Installation is verified by building and running a bundled sample such as `hello_world_simple`.

## Example usage

An OSDK project is built by running `OSDK_BUILD.BAT` in its folder (preceded by `OSDK_MAKEDATA.BAT` if present) and run with `OSDK_EXECUTE.BAT`, which launches the emulator. Hello-World samples ship for BASIC, C, assembly, and mixed C/assembly (demonstrating passing parameters across the C/assembly boundary via the stack). Larger worked examples include the full released source of the Space:1999 game and the Hnefatafl Viking-chess game. The companion GitHub repository extends this with many more complete projects — demos such as the STNICCC 2000 entry and games such as 4kkong and cyclotron — most of which build with the OSDK (../../raw/github/Oric-Software-Development-Kit-Oric-Software.md).

## When to use

Use Defence Force and the OSDK when you want to write new software for the Oric rather than study the original machine: the OSDK is the standard modern toolchain for Oric homebrew, supporting C and assembler with a managed build, emulator and disk-image pipeline. Turn to the site's games, demos and the Oric Library when you want finished examples, released source code, or scanned period documentation.

## Maintenance status

The site is actively maintained: its change history runs continuously from 1997 to 2026, dominated by OSDK releases — version 0.1 (March 2001) through 1.22 (February 2026, upgrading the XA assembler, linker, header tool and PictConv). The author also publishes frequent technical blog articles. The companion GitHub repository (9 stars, Assembly, default branch `master`) was last pushed in January 2026 and replaced an earlier osdn.net SVN host; neither it nor the site declares a formal licence (../../raw/github/Oric-Software-Development-Kit-Oric-Software.md). One documented limitation: the OSDK library currently targets the Atmos 1.1 ROM, so ROM-calling programs can crash on an Oric-1 or Telestrat.

## Ecosystem

Defence Force sits alongside the wider Oric community: it bundles the Euphoric and Oricutron emulators (Euphoric also archived at [[oric.free.fr]]), and its Oric Library overlaps the magazine and book preservation effort found there. The site spans associated properties — the `osdk.org` documentation site, the `blog.defence-force.org` blog, a phpBB forum and wiki, itch.io and Steam storefronts for the games, and the "Oriclopedia" / "Upgrade Time" YouTube series. The OSDK is the production toolchain behind essentially all recent Oric homebrew, and the games and demos it produces are precisely the software that runs on the original and recreated Oric hardware documented elsewhere in this wiki.

## Documentation

The OSDK documentation lives at `osdk.org` and is organised into General information (Introduction, Installation, Creating project, Samples, Glossary), Compilation (Compiler, Assembler, Linker, Bas2Tap, MacroSplitter, MemMap), Utilities (Bin2Txt, FilePack, FloppyBuilder, Header, PictConv, Tap2Wav/Tap2Cd, Tap2Dsk, WriteDsk, Ym2Mym), Emulators (Euphoric, Oricutron) and Technical information (Zero page, Libraries, Memory map, Instruction Set). Each page carries a per-tool version history and a comment thread.
