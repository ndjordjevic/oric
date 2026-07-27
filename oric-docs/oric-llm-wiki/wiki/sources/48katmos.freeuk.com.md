---
type: source
source_url: http://www.48katmos.freeuk.com/
tags: [oric-atmos, oric-1, hardware-specs, roms, circuit-diagrams, software-lists, rhetoric-magazine, oric-ports, tangerine]
related: [oric.free.fr, library.defence-force.org]
product: 48katmos
detail_level: standard
created: 2026-05-17
updated: 2026-05-17
---

`48katmos.freeuk.com` is a personal fan site for the Tangerine Oric Atmos and Oric-1 computers, maintained by Steve Marshall ("Muso") — founder of the Rhetoric user-group magazine. It is a compact but technically detailed reference covering hardware specifications from original Oric sales brochures, ROM variants and identification, port pinouts, hardware circuit diagrams (including a rare scanned Service Manual), a curated software essentials list, and community-compiled software databases. Where [[oric.free.fr]] approaches the Oric from an emulator-author's technical and historical perspective, this site documents the collector's and hardware-tinkerer's view — board revisions, PSU repair, sound modifications, and the print magazines that sustained the English-language Oric community.

_All claims below are sourced from ../../raw/web/48katmos.freeuk.com.md unless otherwise noted._

## What it does

The site provides Oric hardware and software reference material for enthusiasts and collectors. Its primary audiences are people wanting to understand or repair their Oric hardware, and those cataloguing or rediscovering Oric software. The site also documents Rhetoric — the English-language Oric user-group magazine Steve Marshall ran for roughly three years — making it the primary source on that publication's history and disks.

## Key features

**Hardware specifications** — Full Atmos specifications transcribed from the original Oric sales brochure: 6502A processor, 16K/48K RAM configurations, display modes (character 28×40 and graphics 200×240), the General Instrument 8912 three-channel sound synthesizer, cassette interface (Tangerine format at 300 or 2400 baud), Centronics printer port (20-pin IDC), and BUS expansion port pinouts with all 6502A data/address/control lines listed.

**ROM identification guide** — Covers all Oric-1 and Atmos ROM variants: hand-labelled 2764 EPROM pairs (early Oric-1), Mitsubishi EPROM pairs, and single production ROMs (Hitachi). Documents Atmos V1.1 and its two sub-variants (identifiable via `PEEK(#E4B6)` = 162 or 142), and the Rockwell variant. Explains the IC11 chip and when it was dropped.

**Oric-1 PCB revision guide** — Describes the four major PCB issues (1–4) with photographs, noting which boards appeared in Oric-1s vs Atmoses, the two logo variants, and RAM configurations.

**Hardware projects and circuit diagrams** — Downloadable files: Oric-1/Atmos circuit diagram (2 GIF parts), Microdisc circuit details, CUMANA interface diagram, Serial port diagram, PSU repair document, Twin ROM project (Atmos-to-Oric-1 switchable), sound modification project. The scanned Oric Service Manual (PDF) — described as likely the only known surviving copy — is available here; a French translation by Romuald Line with CEO supplement is also provided.

**Port documentation** — RGB DIN pinouts (Red/Green/Blue/SYNC/GND), cassette/sound DIN pinouts (Tape In/Out, Sound, motor relay), Centronics 20-pin IDC wiring, BUS expansion connector map, and power supply requirements (9V DC centre-positive, 5.4VA).

**Software essentials list** — Steve Marshall's curated picks across five categories: utilities (Nibble, BDDisk, Sonix, Lorigraph, Easytext, Base Plus, Compiler), arcade games (Xenon 1, The Hellion, Psychiatric, IJK Invaders, and others), strategy (IJK Chess, Tetrix, Don't Panic, Magnetix), adventures (Ankhsemanon, Hitch Hiker's Guide, Kinburn Encounter), and simulations (Roland Garros, Triathlon, Grand Prix).

**Software lists database** — Three downloadable lists (commercial, magazine type-ins, public domain/informal) compiled from Brian Kidd's A to Z, Dave Dick's records, The'oric magazine, and Jim Groom's list. Available as Microsoft Works, CSV, and PDF. Also includes the Ultimate Hi-Score Chart and an Oric Books list (with ISBN data).

## Architecture and concepts

The site is a static HTML collection of individual topic pages, hosted on a free UK hosting provider. It is self-contained with no external CMS; pages are maintained manually. Circuit diagrams are hosted as GIF images and PDF scans. Software lists are provided in multiple formats for database import. The site dates from circa 2000 (copyright notice) and content reflects the period when Rhetoric magazine had just concluded (25 issues, ~3 years).

The site makes clear the author's dual identity as both a hardware-oriented collector and a community organiser: he scanned the Service Manual to preserve it, documents board revisions from personal inspection, curates software recommendations from hands-on use, and ran the Rhetoric magazine to sustain the English-speaking community after OUM (Oric User Monthly, Dave Dick's pioneering publication) closed.

## When to use

Use this source when:
- Identifying a specific Oric-1 or Atmos board revision from physical inspection
- Identifying an Atmos ROM variant using the `PEEK(#E4B6)` test
- Looking up original port pinouts (RGB, cassette/sound, printer, BUS expansion, power)
- Downloading the Oric Service Manual or Microdisc circuit diagrams
- Finding specific hardware modification projects (Twin ROM, sound output, PSU repair)
- Getting a curated starting point for Oric software (essentials list)
- Researching Rhetoric magazine history or accessing its disk archives
- Cross-referencing against the comprehensive software catalogue (commercial, type-in, PD)

## Ecosystem

The site references several organisations that appear elsewhere in this wiki: Club Europe Oric (CEO) at ceo.oric.org, which continues to publish a magazine and disks; OUM (Oric User Monthly) as the historical predecessor to Rhetoric; and Romuald Line's oric.org community. The Swedish Oric Homepage is cited as the source of GPD Software entries in the software list. The site also references defence-force.org for an RGB/SCART wiring diagram, linking it to [[defence-force.org]] and the wider Defence Force community. The software lists were a collaborative effort involving Brian Kidd, Dave Dick, Jim Groom, and Steve Marshall, with database support for sorting by title and publisher.
