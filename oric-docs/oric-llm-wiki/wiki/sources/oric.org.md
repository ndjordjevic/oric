---
type: source
source_url: https://www.oric.org/
tags: [oric-software-archive, cassette-software, machine-code-monitor, assembler-disassembler, community-ratings, download-statistics]
related: [oric.free.fr, osdk.org]
product: oric.org
detail_level: standard
created: 2026-07-10
updated: 2026-07-10
---

`oric.org` ("The Oric Site") is a community-maintained software database for the Oric-1, Atmos, and related machines — per-title pages with scanned manuals, cassette/disk dumps, star ratings, and download counts, cross-referenced against period magazines (Oric Owner, Hebdogiciel). For this wiki it is the primary catalog for tracking down specific period software titles by name, including now-obscure commercial tools with no other online record.

_All claims below are sourced from ../../raw/web/oric.org.md unless otherwise noted._

## What it does

The site indexes Oric software as a searchable, rateable, downloadable archive: games, utilities, demos, and applications, each with its own page (publisher, author, year, machine compatibility, description, and available media). It surfaces rankings (top games, top demos, top utilities, most-downloaded titles) and tracks community contribution stats (comments, screenshots, scanned physical materials) by contributor.

## Key features

- Per-title pages with structured metadata: title, publisher/programmer, year, machine compatibility (Oric-1 / Atmos / both), description, and `.tap`/`.dsk` media availability, often noting transfer-error status and available manual languages.
- Browse/search by title, software house, author, year (spans 1982–2026, i.e. including modern homebrew), and download availability.
- Community star ratings and download counts per title (e.g. Pulsoids at 1,026 downloads was the top download at time of capture).
- Cross-references into period magazines — 94 *Oric Owner* and 66 *Hebdogiciel* issues catalogued as sources for listed titles.
- A rotating "software of the day" / focus feature, plus a recent-additions/modifications feed.

## Architecture and concepts

The site has no separate documentation subsection — it is a flat cataloging database rather than a software project with its own docs site. Its structural backbone is the `/software/` browse section, which surfaces the same ranking widgets as the landing page (top games/demos/utilities) plus the filter set (title/house/author/year/availability). Individual title pages (e.g. `/software/oric_mon-145.html`) are the atomic unit of the archive.

## Main APIs

Not applicable — `oric.org` is a content archive/database with a browse-and-search UI, not a library or service with a programmatic API. The closest equivalent is its filter parameters (title, software house, author, year, download availability) on the `/software/` browse page.

## When to use

Use `oric.org` when trying to identify or verify a specific period Oric software title — especially obscure commercial or PD tools with little presence elsewhere online. It was the source that surfaced three otherwise-undocumented 1983 machine-code monitor/assembler products (ORICMON, ORIC-MON, ORION) during a `projects/ideas.md` monitor-tool investigation, none of which appear in this wiki's other sources ([[oric.free.fr]], [[osdk.org]]) or the local book catalog.

## Ecosystem

`oric.org` sits alongside [[oric.free.fr]] (hardware/programming reference and its own smaller software archive) and [[defence-force.org]] / [[library.defence-force.org]] (community hub and library) as one of the surviving Oric preservation sites, but is distinctly focused on being a rateable, searchable software *database* rather than a documentation or news site. It cross-references [[osdk.org]]'s toolchain lineage indirectly — several cataloged titles (ORICMON, ORION) are 1983-era predecessors to the assembler/monitor role OSDK's XA assembler now fills for modern homebrew.
