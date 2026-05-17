---
type: source
source_url: https://wiki.defence-force.org/doku.php?id=oric:main
tags:
  [
    dokuwiki,
    defence-force,
    oric-hardware,
    oric-software,
    memory-map,
    emulators,
    oric-links,
    community-docs,
  ]
related:
  [
    defence-force.org,
    forum.defence-force.org,
    library.defence-force.org,
    osdk.org,
    blog.defence-force.org,
    oric.free.fr,
  ]
product: defence-force
detail_level: standard
created: 2026-05-17
updated: 2026-05-17
---

`wiki.defence-force.org` is the Defence Force **DokuWiki** — a collaboratively edited reference that complements the static sites and forums in the Defence Force family. Its hub page for Oric (`oric:main`) is a structured table of contents spanning hardware (systems, chips, peripherals, homebrew storage and audio), PC-side tools, modern software releases, development topics (memory layouts, compatibility across Oric-1 / Atmos / Telestrat), and long-running projects such as Wurlde and Impossible Mission. For this wiki it is the authoritative **outline** of what the Defence Force documentation set tries to cover — with deeper narrative living in [[defence-force.org]], toolchain detail in [[osdk.org]], period literature in [[library.defence-force.org]], discussion in [[forum.defence-force.org]], and articles in [[blog.defence-force.org]].

_All claims below are sourced from ../../raw/web/wiki.defence-force.org.md unless otherwise noted._

## What it does

The wiki runs on DokuWiki and is open to forum-active contributors (accounts are issued by the webmaster to reduce spam). Its root index lists three major namespaces — Oric, general software development (“Soft”), and Ubuntu — with **[[Oric:Main|The Oric main wiki page]]** acting as the portal into Oric-specific articles. That portal enumerates hardware lines from Microtan through Telestrat, internal subsystems (motherboard, PSU, 6502/ULA/VIA/ROM/AY chips and modern socket replacements), mass-storage and controller peripherals, printers and serial gear, homebrew expansions (RTC, SD interfaces such as Cumulus/Erebus), and audio add-ons. It also links outward to resource lists, FAQs, emulator pages, cross-development and disk tools, editors, and pointers for sending binaries to real hardware.

## Key features

- **Namespace-organised articles** — topics are grouped under predictable paths (`Oric:Hardware:…`, `Oric:Software:…`, project roots like `Oric:wurlde:main`) so related pages stay linked and searchable inside the wiki engine.
- **Curated link hub** — the `oric:links` page aggregates major Oric sites, forums (including [[forum.defence-force.org]]), IRC (#oric on IRCnet), development entry points (historically pointing at OSDK on `osdk.defence-force.org`), demoscene listings, and forum member homepages.
- **Emulator roster** — `oric:emulators` splits actively maintained emulators (including **Oricutron** and **Clock Signal**, with upstream repos on GitHub, plus MAME) from legacy entries tied to classic platforms (Amoric, Euphoric family, Caloric fork, etc.), many cross-linked to [[oric.free.fr]]’s emulator pages.
- **Concrete technical tables** — exemplified by the BASIC text-mode memory map: page-zero/stack/layout regions, Sedoric and BASIC RAM boundaries, hire/text screen RAM ranges, and a detailed page-3 I/O decode listing VIA, disk controllers (Microdisc/Jasmin/Pravetz variants), ACIA, joystick interfaces, RTC, and lightpen addresses.

## Architecture and concepts

The capture reflects DokuWiki’s native markup (headings with `=====`, wiki links like `[[Oric:FAQ]]`, interwiki prefixes such as `[[wp>oric|Oric]]`, and embedded images via `{{ … }}`). Content is therefore **modular**: the main page is an outline whose leaves live in separate articles — FAQs may be sparse stubs (the captured FAQ showed a single peripherals question with an external auction link), while reference pages such as memory maps carry dense tables. Community boundaries mirror Defence Force’s other properties: candid discussion stays on the phpBB forum; the wiki holds durable, structured documentation.

## Main APIs

There is no programmatic API — navigation is entirely through DokuWiki URLs (`doku.php?id=…`, `doku.php?do=index`). Editors interact through the wiki UI once credentialed; readers consume pages over HTTPS like any other site.

## When to use

Consult [[wiki.defence-force.org]] when you need a **topic map** of Defence Force’s Oric coverage — quick orientation to hardware families, tooling categories, and project landing pages — before drilling into forum threads, blog posts, or the OSDK docs linked from [[defence-force.org]] and [[osdk.org]]. Use the emulators and memory-map articles when choosing an emulator or validating address ranges against hardware registers.

## Ecosystem

The wiki index stresses coordination with the Defence Force forum: accounts are reserved for people already active there, keeping unstructured chat on phpBB while durable articles live in the wiki. The captured `oric:links` page stitches that community to wider resources — international forums, IRC, pouet.net demo listings, and SDK/documentation entry points that overlap with [[defence-force.org]] and [[osdk.org]].
