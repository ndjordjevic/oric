# Oric learning

A personal mono-repo for learning about the Oric retro computer — original hardware, open-hardware clones, FPGA cores, storage peripherals, and hands-on build projects.

## What's here

```
oric-docs/                 ← reference material, not project output
  oric-llm-wiki/wiki/      ← LLM knowledge base of ingested sources (start at wiki/index.md)
  oric-llm-wiki/raw/       ← immutable source captures backing the wiki
  oric-llm-wiki/inbox.md   ← drop new URLs here for wiki ingestion
  books/                   ← 35 Oric + FPGA/HDL book TOC indexes
projects/                  ← hands-on learning projects, one per subdirectory
  build-journey/           ← notes and decisions from the Metaphoric clone build
RESOURCES.md                ← curated link catalog (hardware, software, community)
AGENTS.md                   ← instructions for AI agents working in this repo
```

## Wiki

The `oric-docs/oric-llm-wiki/wiki/` folder is a Karpathy-style LLM wiki maintained with [pin-llm-wiki](https://github.com/ndjordjevic/pin-llm-wiki). Every source is fetched and summarized into a citable, wikilinked page so you or any AI agent can query it without re-reading the originals. Start at `oric-docs/oric-llm-wiki/wiki/index.md`; `wiki/overview.md` is the cross-source synthesis.

Manage it with the `/pin-llm-wiki` skill:

```
/pin-llm-wiki ingest <url>     # fetch + write a wiki page now
/pin-llm-wiki queue <url>      # add to oric-docs/oric-llm-wiki/inbox.md for later
/pin-llm-wiki lint             # health checks
/pin-llm-wiki remove <slug>    # soft-delete a source
```

To refresh a source, add `<!-- refresh -->` to its `## Completed` line in `oric-docs/oric-llm-wiki/inbox.md` and run `/pin-llm-wiki ingest`.

## Projects

Each subdirectory under `projects/` is a focused study. Current:

- [`projects/mister-fpga-oric-core-understanding/`](projects/mister-fpga-oric-core-understanding/) — studying the MiSTer FPGA Oric core. See its [`plan.md`](projects/mister-fpga-oric-core-understanding/plan.md) and the repo-wide [book catalog](oric-docs/books/INDEX.md) (35 FPGA/HDL + Oric book TOCs). Online VHDL/Verilog/SystemVerilog references are in [`RESOURCES.md`](RESOURCES.md) §8.
- [`projects/build-journey/`](projects/build-journey/) — notes and decisions from the Metaphoric clone build. Not actively worked, kept for reference.

## Related repos

| Repo | What's there |
|---|---|
| [`../mister-fpga/`](../mister-fpga/) | MiSTer FPGA platform study (hardware setup, FPGA concepts, DE10-Nano) — context for the `projects/mister-fpga-oric-core-understanding/` project here |

**Defence Force forum** (`forum.defence-force.org`) — for hardware troubleshooting, clone builds, and community consensus, search it live with `WebSearch`/`WebFetch` (see `AGENTS.md`). The `../oric-forum-digest/` bulk scrape-and-summarize pipeline is retired — live search covers the same needs without scraping time, ongoing API cost, or staleness.
