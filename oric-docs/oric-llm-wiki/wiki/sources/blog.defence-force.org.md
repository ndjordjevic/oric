---
type: source
source_url: https://blog.defence-force.org/
tags: [oric-blog, defence-force, game-dev, retro-computing, encounter-game, adeline-software, oriclopedia, floppy-emulation, 6502-assembly, oric-history]
related: [defence-force.org, forum.defence-force.org, osdk.org, library.defence-force.org, wiki.defence-force.org]
product: blog-defence-force
detail_level: standard
created: 2026-05-17
updated: 2026-05-17
---

`blog.defence-force.org` is the personal technical blog of Mickaël Pointier ("Dbug"), the creator of the OSDK and the Defence Force website. Running since at least the mid-2010s on a custom flat-file PHP engine, the blog covers Oric Atmos development and retro-computing in depth — from hardware archaeology and floppy emulator mods to full game post-mortems and Adeline Software insider accounts. It is one of the richest primary sources on real-world Oric game and demo development, and the home of the Oriclopedia video series.

_All claims below are sourced from ../../raw/web/blog.defence-force.org.md unless otherwise noted._

## What it does

The blog publishes long-form articles by a single author (Mickaël Pointier / Dbug) across roughly a dozen categories. Oric-focused posts cover hardware teardowns, emulator and floppy setup guides, keyboard-handling tutorials, and graphics-programming deep dives. Game-development posts document the full lifecycle of the Encounter adventure game — from a failed 1984 attempt through a 2018 BASIC prototype to the 2024 commercial release. A parallel thread covers Adeline Software (Time Commando, Little Big Adventure) from the inside, including level-creation workflows, marketing materials, and internal tool architecture. Since 2026 the blog also hosts a series on measuring and improving AI coding productivity using Claude Code, making the blog itself the guinea pig for one of its own case studies.

## Key features

- **Article archive from ~2015 to 2026** covering Oric, Atari ST, Adeline Software, hardware hacking, and personal essays; older OSDK-focused articles cross-post to osdk.org.
- **Oriclopedia video series** (2019–): vulgarisation videos on Oric publishers (Tansoft, Loriciels, IJK, Ere Informatique, Severn Software), hardware (Oric Family models, MCP40, Microdisc, peripherals), and historical context — aimed at newcomers rather than hobbyist insiders.
- **Encounter dev-log** (2018–2024): the most thorough public record of writing a commercial Oric game in 2024, including financial post-mortem, pixel-art workflow, 6502/FloppyBuilder engine design, localisation (EN/FR), and distribution via itch.io.
- **Floppy and storage guides**: practical walkthroughs for GoTek/HxC setup with FlashFloppy firmware, OLED-screen and buzzer installation, drive-selector switch wiring, and HFE disk image conversion.
- **Adeline Software series** (2021): detailed insider articles on Time Commando's ACF/XCF format, resource management, LibMenu standardisation, level-creation workflows, and the organic (non-top-down) design culture at the studio.
- **AI productivity series** (2026): two-article series on measuring AI session productivity with real data and a case study modernising the PHP blog itself with Claude Code.
- Categories include: `oric`, `game`, `adeline`, `atari`, `pixels`, `demo`, `building`, `floppy`, `mos6502`, `ai`, `video`, `zen`, `tech`, `norway`, `power`, `web`, `art`, `event`.

## Architecture and concepts

The blog is a flat-file CMS written in plain PHP (no framework, no database), running since 2009. Articles are stored as text files with a custom markup language, served by ~1,000 lines of procedural PHP. As of 2026 it has been modernised using Claude Code: PHP deprecations fixed (array\_pad pattern replacing trim(null)), RSS feed added (rss.php scanning 20 most recent posts with full \<content:encoded\>), OpenGraph/Twitter Card meta tags added, and readable URL slugs appended. No docs pages or API exist; the primary navigation is the chronological front page.

## When to use

Consult this source for:
- **Oric game development case studies** — the Encounter post-mortems are the most detailed public account of shipping a modern Oric game commercially.
- **Oric hardware archaeology** — original Tansoft/IJK/Loriciels/Ere Informatique publisher history, the Beginner's Guide to the Oric Atmos from 1984, the Oriclopedia video catalogue.
- **Floppy emulator setup** — GoTek + FlashFloppy + Microdisc practical guide with photos.
- **Adeline Software internal history** — Time Commando level workflow, resource formats (ACF/XCF), LibMenu.
- **AI-assisted retro-platform development** — the 2026 series is the only known account of AI-assisted modernisation of a retro-era PHP CMS, with actual session data.

## Ecosystem

The blog is part of the Defence Force network: the main site is [[defence-force.org]], the community forum is [[forum.defence-force.org]], the OSDK documentation lives at [[osdk.org]], and archived books/magazines are at [[library.defence-force.org]]. Many OSDK tutorial articles were cross-posted from osdk.org to the blog (or vice versa). The Encounter game source code is at `github.com/Dhebug/Encounter` (not yet ingested as a separate source). The Oriclopedia video series is hosted on YouTube.
