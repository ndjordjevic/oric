---
type: source
source_url: http://oric.free.fr/
tags: [oric-reference-site, oric-history, hardware-programming, ula, 6502, sedoric, emulators, telestrat]
related: [OldWer-Metaphoric, Board-Folk-Oric-Remix, defence-force.org, forum.defence-force.org, library.defence-force.org, 48katmos.freeuk.com, oric.org]
product: oric.free.fr
detail_level: standard
created: 2026-05-17
updated: 2026-07-10
---

`oric.free.fr` is a long-running static reference site for the Tangerine Oric family of 8-bit home computers, online since 1998 and maintained by Fabrice Frances (author of the Euphoric emulator). It is one of the most complete single-site Oric resources: a full hardware-programming manual, a 12-chapter narrative history of the company, archives of disk operating systems and languages, an emulator and PC-tool collection, and pages on the related Microtan 65 and Oric Phoenix machines. For this wiki it is the authoritative primary reference on how the original Oric hardware works and why the platform exists.

_All claims below are sourced from ../../raw/web/oric.free.fr.md unless otherwise noted._

## What it does

The site is a hub: its landing page links eight sections — the history ("Oric, the story so far"), Software (DOSes and languages), Hardware (reference docs and DIY add-ons), Hardware programming, Emulators and PC tools, the Microtan 65 page, the Oric Phoenix page, and a photo gallery. It serves both as a download archive (ROMs, disk images, tools, manuals) and as a documentation site explaining the Oric at the register level.

## Key features

- **Hardware Programming How-To** — a fifth-edition manual by Fabrice Frances covering every Oric subsystem (UAL, VIA, PSG, keyboard, screen, floppy interfaces, tape, serial, RTC, Telestrat second VIA) with register-level detail, plus appendix data sheets for the 6502, 6522, AY-3-8912, WD1793, 6551 and ICM7170.
- **"Oric, the story so far"** — a 12-chapter company history by Jonathan Haworth (Second Edition, 1992).
- **System software archive** — Oric DOS, RANDOS, FT-DOS, XL-DOS, Sedoric 3.0, StratSed, plus Forth, LISP and C cross-compiler (lcc65, GCC for the 65C02) downloads.
- **Emulators and PC tools** — Euphoric, Oricutron, Amoric, ArcOric, Atoric, MESS, and conversion utilities (tap2dsk, tap2cd, CAP, CIP, disklink, TapeTools).
- **Hardware reference and DIY add-ons** — Oric and Microdisc schematics, Michael Brown's ULA analysis, and buildable projects: a 4-chip serial interface, a vertical-retrace sync cable, and an Apple2 disk-controller interface.
- **Related machines** — dedicated pages for the Microtan 65 (the Oric's ancestor) and the Oric Phoenix.

## Architecture and concepts

The site documents the Oric's hardware architecture in depth. All Oric computers run a 6502 at 1 MHz and share the Oric-1/Atmos design: CPU, system bus, a 6522 VIA, a UAL (Universal Array Logic, labelled HSC 10017) and an AY-3-8912 PSG. The UAL is the heart of the machine — it clocks the CPU and peripherals, acts as a simple memory management unit (IO at page 3, internal ROM at C000-FFFF), and generates the video signal. The ULA displays 224 lines of 240 pixels in 8 colours, with foreground/background colour, character set, blinking and text/hires mode all set by "serial attributes" — control bytes inserted inline with screen data. The 6522 VIA ties together the keyboard (a passive matrix the CPU must poll), tape (a square waveform on port B bit 7), printer port and PSG. The Telestrat adds a second VIA at address 0320 that selects one of 8 memory banks and interfaces Minitel/RS232 communication hardware.

## The history of Oric

The history section traces the platform from Tangerine Computer Systems (founded 1979, maker of the Microtan 65) through the incorporation of Oric Products International in April 1982, the Oric-1 launch in January 1983, the Atmos in January 1984, two receiverships (February 1985 and December 1987), the French ownership era under S.P.I.D./Eureka, and the communication-oriented Telestrat (1986). Recurring themes are chronic over-optimism, tape-loading reliability problems, delayed peripherals, and a strong French market — France is where Sedoric, the Telestrat and the enduring user-group community took root. Oric Products International "lasted precisely two years and six days"; Jonathan Haworth attributes the collapse chiefly to marketing and pricing missteps and the failure to ensure good software early.

## When to use

Consult this source for authoritative detail on how the original Oric-1, Atmos and Telestrat hardware works — register maps, the VIA/PSG/UAL interfaces, video timing, tape and disk encoding — and for the historical context behind the machine. It is the natural companion reference when working on Oric clone or replica hardware, since modern recreations reproduce exactly the chips and timing this site documents.

## Ecosystem

The site sits at the centre of the surviving Oric community: it archives the French-origin Sedoric DOS line, the Euphoric and Oricutron emulators, and PC-side tools for moving software between real machines and emulators. It also documents the Oric's lineage (the Microtan 65) and a later revival machine (the Oric Phoenix), and links DIY hardware projects. Modern open-hardware recreations such as [[OldWer-Metaphoric]] and [[Board-Folk-Oric-Remix]] target precisely the Oric-1/Atmos architecture this site describes, making it an essential reference for builders of those boards.
