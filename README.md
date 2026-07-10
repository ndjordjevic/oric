# Oric learning

A personal mono-repo for learning about the Oric retro computer — original hardware, open-hardware clones, FPGA cores, storage peripherals, and hands-on build projects.

## What's here

```
wiki/           ← LLM knowledge base of ingested sources (start at wiki/index.md)
projects/       ← hands-on learning projects, one per subdirectory
build-journey/  ← notes and decisions from the Metaphoric clone build
RESOURCES.md    ← curated link catalog (hardware, software, community)
inbox.md        ← drop new URLs here for wiki ingestion
AGENTS.md       ← instructions for AI agents working in this repo
```

## Wiki

The `wiki/` folder is a Karpathy-style LLM wiki maintained with [pin-llm-wiki](https://github.com/ndjordjevic/pin-llm-wiki). Every source is fetched and summarized into a citable, wikilinked page so you or any AI agent can query it without re-reading the originals. Start at `wiki/index.md`; `wiki/overview.md` is the cross-source synthesis.

Manage it with the `/pin-llm-wiki` skill:

```
/pin-llm-wiki ingest <url>     # fetch + write a wiki page now
/pin-llm-wiki queue <url>      # add to inbox.md for later
/pin-llm-wiki lint             # health checks
/pin-llm-wiki remove <slug>    # soft-delete a source
```

To refresh a source, add `<!-- refresh -->` to its `## Completed` line in `inbox.md` and run `/pin-llm-wiki ingest`.

## Projects

Each subdirectory under `projects/` is a focused study. Current:

- [`projects/mister-fpga-oric-core-understanding/`](projects/mister-fpga-oric-core-understanding/) — studying the MiSTer FPGA Oric core. See its [`plan.md`](projects/mister-fpga-oric-core-understanding/plan.md) and the repo-wide [book catalog](books/INDEX.md) (35 FPGA/HDL + Oric book TOCs). Online VHDL/Verilog/SystemVerilog references are in [`RESOURCES.md`](RESOURCES.md) §8.

## Related repos

| Repo | What's there |
|---|---|
| [`../mister-fpga/`](../mister-fpga/) | MiSTer FPGA platform study (hardware setup, FPGA concepts, DE10-Nano) — context for the `projects/mister-fpga-oric-core-understanding/` project here |
| [`../oric-forum-digest/`](../oric-forum-digest/) | Defence Force forum scraped into a markdown knowledge base — hardware troubleshooting, clone builds, community consensus |
