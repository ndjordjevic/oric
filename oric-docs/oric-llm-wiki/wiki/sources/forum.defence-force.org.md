---
type: source
source_url: https://forum.defence-force.org/index.php
tags: [oric-community, phpbb-forum, oric-support, hardware-hacks, osdk-support, 6502-discussion, oric-troubleshooting]
related: [defence-force.org, oric.free.fr, osdk.org, library.defence-force.org, blog.defence-force.org, wiki.defence-force.org]
product: defence-force
detail_level: standard
created: 2026-05-17
updated: 2026-05-17
---

`forum.defence-force.org` is the phpBB community forum of the Defence Force site — the main active discussion board for the Oric family of computers. It is the community arm of [[defence-force.org]] and the OSDK project, and the place where Oric users and developers ask hardware troubleshooting questions, report OSDK bugs, share assembly and BASIC techniques, and discuss new hardware extensions. For this wiki it is the primary source of current, problem-specific community knowledge — and a searchable archive when a question is not answered by the other sources.

_All claims below are sourced from ../../raw/web/forum.defence-force.org.md unless otherwise noted._

## What it does

The forum is a standard phpBB message board dedicated entirely to the Oric. It hosts 16 sub-forums covering general discussion, magazines and books, games, demos, operating systems, emulators, cross-development tools, disk/tape converters, graphics and audio tooling, the AY sound chip, BASIC, 6502 assembly, C, technical questions, and hardware hacks. It is moderately busy and long-running — the largest sub-forums hold thousands of posts (Games ~7,400, General Discussion ~6,300, Hardware hacks ~5,000).

## Forum structure

The 16 sub-forums, with their topic/post counts at capture time:

- **General Discussion** (663 / 6325) — anything off-topic for the other forums.
- **Mags and books** (74 / 701) — Oric magazines (CEO Mag, OUM, Rhetoric, Théoric, Hebdogiciel) and books.
- **Games** (341 / 7441) — Oric games, existing and wished-for.
- **Demos** (68 / 746) — Oric demo discussion.
- **Operating systems, utilities and other serious software** (91 / 1064) — Sedoric, Randos and other Oric DOSes.
- **Emulators** (158 / 2541) — Euphoric, MESS, Amoric and other emulators.
- **Cross development tools** (152 / 1464) — the OSDK: bug reports, feature requests, usage help.
- **Tape and floppy disk converters** (73 / 1437) — Tap2Wav, Tap2CD, Tap2Dsk, Sedoric Disc Manager, tape header editors.
- **Painting tricks** (54 / 652) — techniques for the Oric video chip.
- **Audio tools** (29 / 401) — samplers, trackers, sound-chip editors.
- **AY sound chip** (37 / 283) — the most technical forum, focused on the AY sound chip.
- **BASIC programming** (72 / 569) — BASIC 1.x (Oric-1/Atmos) and HYPERBASIC (Telestrat).
- **6502 assembly coding** (106 / 989) — efficient 6502 assembly on the Oric.
- **C programming** (62 / 913) — C via OSDK cross-compilation.
- **Technical questions** (259 / 3310) — how the machine works, model differences, peculiar details.
- **Hardware hacks and extensions** (216 / 4999) — hardware vsync, adding a VIA or AY, modern extensions.

## What gets discussed

Sampling recent topics shows the forum is the live edge of the Oric scene. *Cross development tools* tracks OSDK releases (1.21, 1.22, 1.23) and forward planning ("Let's talk about OSDK 2.0"), plus alternative toolchains such as the Pas6502 Pascal cross-compiler. *Hardware hacks and extensions* is dominated by modern storage and ULA-replacement projects — the LOCI storage emulator, an "OCULA" ULA-replacement concept, and interactions with hardware such as Metaphoric. *Technical questions* is heavy with repair and diagnostics threads (Atmos not booting, DRAM oddities, Microdisc issues, VIA/cassette faults). *6502 assembly coding* collects concrete coding problems — page-zero usage, page-boundary bugs, fast HIRES fills, flood-fill routines.

## Search

The forum is publicly browsable, but the phpBB **search system requires a logged-in member account** — guests are refused with "you are not permitted to use the search system". With an authenticated session, search supports keyword queries over topic titles, first posts or full post text, restriction to chosen sub-forums, and topic-or-post result modes. This makes the forum a queryable knowledge base for specific Oric problems once authenticated.

## When to use

Use the forum when the other wiki sources do not answer a specific, practical question — a hardware fault, an OSDK build error, a particular 6502 or BASIC technique, or the status of a modern extension. It complements the reference material: where [[oric.free.fr]] documents how the machine works and [[defence-force.org]] documents the toolchain, the forum captures the troubleshooting and project chatter that only exists as community discussion.

## Key threads — the Oric-clone build (curated 2026-05-17)

A targeted, logged-in read of the threads most relevant to building a Metaphoric clone. (Note: the thread IDs originally recorded in `projects/build-journey/00-build-vs-buy-research.md` §13 were inaccurate; the corrected `t=` values are below.)

### Metaphoric — a new Oric clone — `t=2675` (Dec 2024)

OldWer's original announcement of Metaphoric. Establishes the design intent: an Oric clone with the memory subsystem based on OriClone-1, plus conveniences — cheaper AY-3-8910, composite video, speaker amplifier, common-type relay. The mainboard fits an original Oric enclosure with the original keyboard, but the new Cherry-MX keyboard PCB does not. OldWer frames it as "as period-correct as possible" — only the video encoder is a part unavailable in the 1980s; everything else is through-hole, "primarily meant as a fun soldering project". Discussion with Dbug covers the joystick interface: Metaphoric uses a 7-diode IJK "Stingy" interface plus a cursor+spacebar port, with a **switch to disable IJK** because the IJK strobe shares the D5 line and can interfere with the printer port. The full 14-transistor IJK interface can still be wired to the printer port if a two-player IJK game is wanted.

### Metaphoric V2 — `t=2733` (Apr 2025)

OldWer's announcement that the **Metaphoric V2 design files are on GitHub** (`github.com/OldWer/Metaphoric`) — the version in this wiki as [[OldWer-Metaphoric]]. Recaps the V2 feature set: composite video (RCA), TRRS audio/video socket, dual AY-3-8912/AY-3-8910 footprints, selectable 7905/7805/external-5V power, two DB9 joystick ports on the keyboard PCB, front-panel RESET and NMI, Oric-1/Atmos ROM switch, IJK-disable switch, automatic hardware V-sync hack. Community reaction is enthusiastic (Sodiumlightbaby, Chema, Bieno, ibisum) with repeated interest in organising a larger production run or crowdfunding a "new-era Oric". Kenneth asks about ROMDIS pin compatibility when a UVPROM is used; OldWer confirms the ROM gets disabled correctly (e.g. when using LOCI).

### Loci — First user impressions — `t=2672` (Dec 2024)

A LOCI user-experience thread. Most relevant finding for a clone build: a user reports trying **LOCI both with an original Atmos and with a Metaphoric clone — and confirms it works on the clone, with identical behaviour on both machines**. This validates the LOCI + Metaphoric pairing recommended in the build journey. The thread also covers practical LOCI usage: USB sub-directories do work (exFAT, upper/lowercase fine); the Boot/Return UI — `[Return]` resumes the suspended session, `[Esc]` cold-boots — was a common point of confusion; firmware state-handling around `.dsk`/cold-boot was being improved (FW 0.2.2 era).

### OCULA — a ULA replacement concept — `t=2709`

The canonical OCULA development thread (18 pages, active into 2026). Read in detail for `projects/build-journey/01-decision-bom-order.md` §3: OCULA only became reliable on *genuine* Oric boards around late-2025/early-2026 firmware, and the single attempt on record to run it on an Oric *clone* (an unknown homebrew board) never booted past a garbage screen. No one has tried OCULA in a Metaphoric.

### Other-forum Metaphoric threads (non-Defence-Force)

- **`oric.forumactif.org/t945-metaphoric`** — the French "Forum Oric" Metaphoric thread. Thread content is **login-walled to guests**, so it could not be captured here; listed for completeness.
- **`ceo.oric.org/community/oric-atmos/metaphoric/`** — the Club Europe Oric (CEO) page "Metaphoric – Atmos", posted by Kenneth, 25 April 2025. Summarises OldWer's GitHub project: dual DB9 joystick ports (one cursor+space, one IJK with disable switch), dual AY-3-8910/PSG footprint, selectable power polarity via jumpers, front-panel reset, internal speaker removed and RF upgraded to PAL composite, dual-ROM design with ROMDIS. A reply (ftmb) notes the board appears compatible with original housings and the keyboard connector seems positioned identically to original boards.

## Ecosystem

The forum is one property of the Defence Force constellation alongside the main site, the OSDK documentation site and the blog — all covered by [[defence-force.org]]. Its subject matter overlaps the reference material in [[oric.free.fr]] (emulators, magazines, hardware) and the modern hardware projects in this wiki: forum threads actively discuss extensions and ULA replacements of the kind reproduced by boards like Metaphoric. It is the social and support layer of the Oric preservation community.
