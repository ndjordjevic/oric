# Oric learning — agent instructions

Personal mono-repo for learning about the Oric retro computer:

- `wiki/` — knowledge base of ingested sources (the LLM wiki)
- `books/INDEX.md` — TOC indexes of 35 Oric + FPGA/HDL books; consult it to find which book covers a topic
- `projects/` — hands-on learning projects (e.g. `mister-fpga-oric-core-understanding/`)
- `RESOURCES.md` — curated links: Oric hardware, software, community, FPGA/HDL
- `build-journey/` — notes and decisions from the Metaphoric clone build

**Related repo:** `../mister-fpga/` covers the MiSTer platform broadly (hardware setup, FPGA concepts, DE10-Nano). Consult it for platform-level context before diving into the Oric-specific core.

## Answering Oric questions — wiki first

Before answering **any** Oric question: (1) read `wiki/index.md`, (2) follow `[[wikilinks]]` into relevant source pages, (3) for hardware/troubleshooting/community questions also search the Defence Force forum (below), (4) cite wiki page names. If the wiki doesn't cover it, say so, then search online — don't rely on training data alone.

## Defence Force forum — live search only, never scrape

`forum.defence-force.org` is the Oric community forum. Search it live: `WebSearch` with `allowed_domains: ["forum.defence-force.org"]`, then `WebFetch` the specific `viewtopic.php?t=<id>` URLs, and cite thread URL + title. Do **not** build or run a local scraper/digest — the retired `../oric-forum-digest/` attempt proved live search works better (no scrape time, API cost, or staleness); never revive it. (The forum's WAF 403s scripted requests from this machine; `WebSearch`/`WebFetch` go through Anthropic's fetch infra and are fine.)

Search the forum for: hardware troubleshooting/repair/compatibility; clone boards (Metaphoric, OriClone-1, Oric Remix, Replic'Oric…); storage peripherals (Microdisc, Cumulus, LOCI, Erebus, Cumana…); video/ULA/signal questions; AY sound chip; sourcing period-correct components.

## Audience — HDL walkthroughs

The human is **not** experienced with VHDL/Verilog/SystemVerilog but knows digital electronics and general programming well. When explaining HDL:

- Briefly explain each syntax construct on first appearance (1–2 sentences — unlock the code, don't teach HDL in depth).
- Always include an analogy to a well-known language (C, Python, JS…).
- End every explanation with 1–2 plain-English sentences on what the code does functionally.

## Lessons — full-coverage requirement

Any lesson (e.g. `projects/*/learn-*/lessons/`) showing a code excerpt must explain **every line and every token in that excerpt** — the reader must be able to open the same excerpt in the source and have nothing left silently unexplained. Concretely:

- Explaining a construct once via representative lines is **not** enough — walk every line, even when several share the same form; name explicitly what each remaining line ties off/connects ("the remaining N lines tie off these unused ports: …", actually listing them).
- Never silently truncate a block: either show it in full or state clearly what was omitted and why.
- Before finalizing, diff excerpt against prose: every distinct signal name, operator, and literal must be referenced (by name, or via an explicit listed summary).
- Same standard as `learn-*/NOTES.md` ("understand every line"), applied at the level of each excerpt, not just series-wide coverage.

## `projects/mister-fpga-oric-core-understanding/` — study layers

The project's `README.md` defines how its study materials are layered (lessons / annotated source / walkthrough docs / diagram) — read it before adding or editing material there. Rules that must hold:

- `annotated/` holds study snapshots of the upstream `Oric_MiSTer` sources (`Oric.sv`, `rtl/oricatmos.vhd`) with `// ★` / `-- ★` section comments added; pinned to upstream commit `c4cf449` (provenance: `annotated/README.md`). The pristine `core/` clone is a gitignored sibling tracking upstream; its line numbers sit lower (no ★ comments).
- **All lessons, reference cards, and walkthrough docs cite line numbers from `annotated/`** — quote from it, not `core/`, so line numbers match.
- Treat `annotated/` as **frozen**: don't edit its code or re-sync from `core/` — lesson line attributions depend on it. If upstream moves and a refresh is truly needed, re-annotate a fresh copy and re-verify every lesson's line numbers.
- **Each fact lives in exactly one layer** (anti-duplication): section summaries live only as `★` comments in `annotated/`; walkthrough docs (`01a`, `01b`, `04-modules/*`) never restate `★` text — they carry only background, cross-references, tables, and open questions, with a heading + `★` line pointer per section; lessons teach language syntax, never file architecture.
- New modules studied later follow the same pattern: annotate a frozen copy in `annotated/rtl/`, write a thin walkthrough note, check the decoder card covers the module's tokens.

## Git — never auto-commit

Never `git commit` or `git push` after any change **unless the human explicitly asked in this conversation**. When done, list what changed and stop — the human reviews and commits.

## Wiki structure

```
wiki/
  index.md          ← start here; lists every ingested source
  overview.md       ← rolling cross-source synthesis (cites [[source pages]])
  log.md            ← append-only ingest/refresh history
  sources/          ← one page per ingested source (<slug>.md)
  .archive/         ← soft-deleted sources (ignore unless needed)
raw/                ← immutable captures: github/, youtube/, web/
inbox.md            ← agents may queue URLs under ## Pending via /pin-llm-wiki
.pin-llm-wiki.yml   ← wiki config (domain, detail level, source types, lint cadence)
```

Load order for any question: `wiki/index.md` → relevant source pages → raw files only for direct citation. Wiki management (ingest, refresh, lint, remove) goes through the `/pin-llm-wiki` skill — invoke via the Skill tool; protocol details live in the skill files.
