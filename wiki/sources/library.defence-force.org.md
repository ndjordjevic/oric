---
type: source
source_url: https://library.defence-force.org/
tags: [oric-library, document-preservation, oric-magazines, oric-books, 6502-reference, retro-archive, pdf-archive, defence-force]
related: [defence-force.org, forum.defence-force.org, oric.free.fr, osdk.org]
product: defence-force
detail_level: standard
created: 2026-05-17
updated: 2026-05-17
---

`library.defence-force.org` is the Oric Library — a digital archive of 818 books, magazines, manuals, and datasheets related to the Oric family of computers, maintained by Mickaël Pointier as part of the [[defence-force.org]] constellation. It is the single largest collection of Oric-era documentation available online, spanning 16 countries and peak publication years of 1983–1984, with 62% of entries available as downloadable PDFs. It is the wiki's primary source for period literature: programming books, user-group newsletters, and the Oric-specific magazines that no longer exist in print.

_All claims below are sourced from ../../raw/web/library.defence-force.org.md unless otherwise noted._

## What it does

The library catalogs and distributes scanned PDFs of Oric-era documents. Users browse by type (book, magazine, manual, datasheet, generic, publicity), language, year, author, or publisher; search results show availability status and link to downloads. The site's stated mission is to preserve "rare or fragile documents which have some historical relevance," especially newsletters from Oric user groups worldwide. Submission of new or higher-quality scans is welcomed via webmaster@defence-force.org.

## Key features

- **818 entries** across books (125), magazines (606), manuals (54), and datasheets (10), with a small number of generic and publicity items.
- **62% downloadable** — books have the highest availability (95%), manuals 87%, datasheets 100%; magazines are 51% available.
- **Multi-language coverage** — French is the largest language group (417 entries) followed by English (326), German (33), Norwegian (11), Danish (8), and 10 further languages including Bulgarian, Japanese, Slovenian, Croatian, Serbian, Macedonian, Dutch, and Spanish.
- **16-country span** representing the Oric's surprisingly wide international user base; many entries are issues of national Oric user-group newsletters that exist nowhere else in digital form.
- **Filterable and sortable catalog** — by type, language, author, year, publisher; sortable by name, date, author, or publisher.
- **Community-sourced** — 25+ named contributors scanning from personal collections, plus sources including Archive.org, Abandonware-Magazines, Oric.org, and Silicebit.

## Architecture and concepts

The library is a web application backed by a database. Each entry carries structured metadata: title, author(s), year, publisher, language, type, and availability flag. The public interface exposes filtered and paginated browsing; no login is required. Entries without PDFs are listed as "missing" to make gaps visible for prospective contributors.

## Main content

**Books** (125 English-language entries span 4 pages; French-language books additional):
Oric-specific programming titles (e.g., *20 games for the ORIC-1*, *30 Hour BASIC — Oric Edition*, *40 educational games for the Oric Atmos*, *Advanced Programming for the Oric*, *An introduction to Programming the Oric-1*) alongside generic 6502 references that Oric programmers relied on (Lance Leventhal's *6502 Assembly Language Programming*, Rodnay Zaks' *Advanced 6502 programming*, etc.).

**Magazines** (606 entries across 47 pages):
National Oric user-group newsletters and magazines in their original languages: *Oric Brugerbladet* (Danish, 7+ issues), *ATMOSPHÄRE* / *ATMOSphere* (German, multiple issues), *Atmosphere Mag* (French), plus the widely cited French magazines *CEO Mag*, *Théoric*, *Micr'Oric*, and English titles *Oric Owner*, *Oric Computing*, and *Hebdogiciel* issues featuring Oric content. Peak magazine publication years were 1983–1984.

**Manuals** (54 entries, 87% available):
Hardware and software manuals for the Oric range and its peripherals.

**Datasheets** (10 entries, all available):
Component-level datasheets for chips used in Oric hardware.

## When to use

Use this library when you need primary documentation from the Oric era: the original Oric BASIC manual, a user-group newsletter discussing a specific hardware trick, a programming book that an existing piece of code was written against, or a magazine article covering a historical software release. It is the complement to [[oric.free.fr]]'s narrative history and hardware-programming reference — that site explains how the machine works; the library provides the period literature that was written for the machine's original audience.

## Ecosystem

The library is one property of the Defence Force constellation alongside [[defence-force.org]] (OSDK, games, blog) and [[forum.defence-force.org]] (the phpBB board, which has a dedicated "Mags and books" sub-forum with 701 posts discussing the library's contents). The [[oric.free.fr]] site also archives some Oric documentation and ROMs, making the two sites complementary preservation resources.
