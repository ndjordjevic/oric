---
type: source
source_url: https://oric.signal11.org.uk/html/diagrom.htm
tags: [oric-hardware, diagnostic-rom, oric-repair, ula, hcs10017, reverse-engineering, eprom, fault-finding]
related: [48katmos.freeuk.com, oric.free.fr, OldWer-Metaphoric, Board-Folk-Oric-Remix, raxiss.com]
product: signal11-oric
detail_level: standard
created: 2026-05-17
updated: 2026-05-17
---

`oric.signal11.org.uk` ("Oric And Atmos Support") is a small static support site maintained by Mike Brown, dedicated to repairing, testing, and understanding the Oric-1 and Oric Atmos at the hardware level. It hosts six self-contained projects — most importantly a **diagnostic ROM** for fault-finding a dead board and a long-running **reverse-engineering of the proprietary HCS10017 ULA**. For a build-from-scratch or repair project it is the single best source for "is my board actually working?" and "what does the ULA do?".

_All claims below are sourced from ../../raw/web/oric.signal11.org.uk.md unless otherwise noted._

## What it does

The site indexes six Oric hardware projects, each with downloadable documentation and files:

- **Diagnostics** — a diagnostic ROM and optional support PCB.
- **Repair Guide** — a checklist for reviving a dead board.
- **ULA V1** and **ULA Die Shots** — deconstruction and full reverse-engineering of the HCS10017 ULA.
- **Twin ROMS** — a mod to fit two switchable ROMs.
- **Cumana** — an annotated Cumana Disk Interface schematic.

## Diagnostic ROM (the key tool)

A replacement **16K ROM image** that installs on an Oric/Atmos mainboard in place of the BASIC ROM and runs a step-by-step test of the **CPU, ULA, DRAM, VIA, and PSG** and associated circuitry. The download package includes the ROM images, the `.ASM` source, a 2.5 MB PDF manual, and a schematic + PCB layout for an optional external board carrying the ROM, status LEDs, and a ULA-replacement clock source.

- Current revision: **Ver 1.08k** — errata 2023/05/10 notes 1.08k "corrects a small initialization bug with the VIA chip".
- Ships in both a **50 Hz** (standard) and a **60 Hz** screen-compatible version, in the same ZIP.
- It is the recommended first-power-on test for a freshly built or repaired board — it catches assembly faults before guesswork. The same `test108k.rom` is bundled in LOCI release firmware (see [[raxiss.com]]), so it can also be run without burning an EPROM.

## ULA reverse-engineering

The HCS10017 ULA is the one proprietary, undocumented chip every Oric and every Oric clone depends on. This site is the definitive public deconstruction of it:

- **ULA V1** — Mike Brown's 1996 black-box deconstruction of the ULA's internals from observed behaviour (memory inputs, hardware outputs), with some known minor discrepancies.
- **ULA Die Shots** — in July 2018 Lance Ewing (Dreamseal) had a real ULA de-capped; six weeks of reverse-engineering produced complete schematics, documentation, and a simulation, plus high-resolution die-shot images (up to 24k × 24k px) with logic cells and I/O pin areas marked.

This is the resource to read to actually *understand* the ULA rather than treat it as a black box — directly relevant to anyone weighing the original ULA against an open replacement (see §3 of the build journey and the OCULA project).

## Other projects

- **Repair Guide** — a tips checklist for getting a dead Oric board partly working (best used alongside the Oric Schematic and Service Manual). Errata: a clock-frequency reference should read "4.43 MHz", not "8.86 MHz".
- **Twin ROMS** — a mod to fit a second 27128 ROM/EPROM inside the machine for manual selection between Oric-1 (V1.0) and Atmos (V1.1) BASIC; a different approach to the ROMDIS modification.
- **Cumana** — an annotated Cumana Disk Interface schematic, flagging a real error in the original drawing around expansion-port pins 33/34.

## When to use

Use this source when building, testing, or repairing real Oric hardware: burn the diagnostic ROM for first power-on of a new board, follow the Repair Guide for a non-booting machine, and read the ULA pages to understand the HCS10017. It complements the board projects [[OldWer-Metaphoric]] and [[Board-Folk-Oric-Remix]] (which assume a working ULA and a way to verify the build) and the hardware reference at [[48katmos.freeuk.com]] and [[oric.free.fr]].

## Ecosystem

- Diagnostic ROM is also embedded in LOCI release firmware as `test108k.rom` — see [[raxiss.com]] and [[sodiumlb-loci-firmware]].
- Site owner: Mike Brown; content © 2009–2024. Parent site: http://www.signal11.org.uk/.
- Diagnostic ROM page: https://oric.signal11.org.uk/html/diagrom.htm
