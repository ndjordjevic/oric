# Oric learning — agent instructions

Personal mono-repo for learning about the Oric retro computer:

- `oric-docs/oric-llm-wiki/wiki/` — knowledge base of ingested sources (the LLM wiki)
- `oric-docs/books/INDEX.md` — TOC indexes of 44 books (30 Oric, 9 6502/hardware, 5 FPGA/HDL); consult it to find which book covers a topic
- `oric-docs/RESOURCES.md` — curated links: Oric hardware, software, community, FPGA/HDL
- `projects/` — hands-on learning projects (e.g. `mister-fpga-oric-core-understanding/`, `build-journey/`)

**Related repo:** `../mister-fpga/` covers the MiSTer platform broadly (hardware setup, FPGA concepts, DE10-Nano). Consult it for platform-level context before diving into the Oric-specific core.

## Writing style — Simplified Technical English (STE)

Use ASD-STE100 Simplified Technical English for explanations and for docs written in this repo
(plan files, hardware notes, module docs, chat answers). Rules:

- Write short sentences. One idea per sentence.
- Use active voice, not passive voice.
- Use simple, common words. Avoid jargon. Define a needed technical term in plain words on first use.
- Keep noun groups short — about 3 words max.
- Use lists and tables, not long paragraphs, where possible.
- Code identifiers, addresses, and technical names stay as-is (`$C000`, `spram.v`) — STE controls
  the surrounding prose, not code or data tokens.

## Answering Oric questions — wiki first

Before answering **any** Oric question: (1) read `oric-docs/oric-llm-wiki/wiki/index.md`, (2) follow `[[wikilinks]]` into relevant source pages, (3) for hardware/troubleshooting/community questions also search the Defence Force forum (below), (4) cite wiki page names. If the wiki doesn't cover it, say so, then search online — don't rely on training data alone.

## Defence Force forum — live search only, never scrape

`forum.defence-force.org` is the Oric community forum. Search it live: `WebSearch` with `allowed_domains: ["forum.defence-force.org"]`, then `WebFetch` the specific `viewtopic.php?t=<id>` URLs, and cite thread URL + title. Do **not** build or run a local scraper/digest — the retired `../oric-forum-digest/` attempt proved live search works better (no scrape time, API cost, or staleness); never revive it. (The forum's WAF 403s scripted requests from this machine; `WebSearch`/`WebFetch` go through Anthropic's fetch infra and are fine.)

Search the forum for: hardware troubleshooting/repair/compatibility; clone boards (Metaphoric, OriClone-1, Oric Remix, Replic'Oric…); storage peripherals (Microdisc, Cumulus, LOCI, Erebus, Cumana…); video/ULA/signal questions; AY sound chip; sourcing period-correct components.

## Audience — HDL walkthroughs

The human is **not** experienced with VHDL/Verilog/SystemVerilog but knows digital electronics and general programming well.
They want to know **what each code section does**, not what every line or token means.

- Explain code at section level, in plain English: what it does and why it is there.
- Explain a syntax construct only when the human asks, or when the section makes no sense without it. Then keep it to 1–2 sentences, with an analogy to C, Python or JS.

## `projects/mister-fpga-oric-core-understanding/` — rules

Read the project's `README.md`, `plan.md` and `MAP.md` before adding or editing material there.

- `annotated/` holds copies of upstream `Oric_MiSTer` files (commit `c4cf449`) with plain-English `// ★ SECTION n —` / `-- ★ SECTION n —` comments above each section. Only comments are added; code is never changed (check: `diff <(tr -d '\r' < core/<f>) annotated/<f>` shows only added lines). `core/` is the clean upstream clone (gitignored) — never edit it.
- Point to code by section name (`oricatmos.vhd ★ SECTION 8`), not line number. Where a doc does use a line number, fix it after adding or removing comment lines.
- New files (plan Phase 4/5): copy `core/<file>` to `annotated/<file>`, add a short file header + one plain-English `★` comment per code section. Parts the Oric does not really use get one short comment for the whole span.
- Say each fact once: "what this code does" lives in the `annotated/` comments. `MAP.md` and other docs link to it and add only tables and cross-links.

## Git — never auto-commit

Never `git commit` or `git push` after any change **unless the human explicitly asked in this conversation**. When done, list what changed and stop — the human reviews and commits.

## Wiki structure

```
oric-docs/oric-llm-wiki/
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

Load order for any question: `oric-docs/oric-llm-wiki/wiki/index.md` → relevant source pages → raw files only for direct citation. Wiki management (ingest, refresh, lint, remove) goes through the `/pin-llm-wiki` skill — invoke via the Skill tool; protocol details live in the skill files.
