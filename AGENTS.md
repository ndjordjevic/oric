# Oric learning — agent instructions

This repo is a personal mono-repo for learning about the Oric retro computer. It contains:

- `wiki/` — a structured knowledge base of ingested sources (the LLM wiki)
- `books/` — repo-wide book catalog at `books/INDEX.md` — TOC indexes of 35 Oric + FPGA/HDL books; consult it to find which book covers a topic
- `projects/` — hands-on learning projects (e.g. `mister-fpga-oric-core-understanding/`)
- `RESOURCES.md` — curated link catalog of Oric hardware, software, community, and FPGA/HDL references
- `build-journey/` — notes and decisions from the Metaphoric clone build

**Related repo:** `../mister-fpga/` covers the MiSTer FPGA platform broadly (hardware setup, FPGA concepts, DE10-Nano). When working on `projects/mister-fpga-oric-core-understanding/`, consult that repo for platform-level context before diving into the Oric-specific core.

---

## For AI agents working in this repo

Before answering **any question** about the Oric retro computer, you MUST:

1. Read `wiki/index.md` to identify relevant pages.
2. Follow `[[wikilinks]]` to drill into relevant source pages.
3. For hardware, troubleshooting, or community questions, also search the **Defence Force forum** directly (see below).
4. Cite wiki page names in your answer.
5. If the answer is not in the wiki, say so clearly, then search/fetch current information online instead of relying on training data alone.

The wiki is the authoritative local source for this domain. Start there, use it whenever it covers the question, and go online for gaps or newer information.

---

## Defence Force forum (live search — do not scrape)

`forum.defence-force.org` is the Oric community forum. Search and read it live with `WebSearch`/`WebFetch` — do not build or run a local scraper/digest for it. A prior attempt at a bulk scrape-and-summarize pipeline (`../oric-forum-digest/`) turned out to be unnecessary overhead (scraping time, ongoing Claude API summarization cost, staleness) once live search was tested and found to work well; that project is retired and should not be revived or re-run.

**When to search the forum:**

- Hardware troubleshooting, repair, or component compatibility questions.
- Clone board questions (Metaphoric, OriClone-1, Oric Remix, Replic'Oric, etc.).
- Storage peripherals (Microdisc, Cumulus, LOCI, Erebus, Cumana, etc.).
- Video output, ULA replacement, or signal questions.
- AY sound chip programming or hardware audio questions.
- Sourcing or identifying period-correct components.

**How to use:**

1. `WebSearch` with `allowed_domains: ["forum.defence-force.org"]` to find candidate threads for the topic.
2. `WebFetch` the specific `viewtopic.php?t=<id>` URL(s) to read the actual thread content and extract facts/community consensus.
3. Cite the thread URL (and title) in your answer.

Note: the forum's WAF blocks scripted requests with browser-like User-Agents (a local `curl`/`requests` script gets 403'd) — `WebSearch`/`WebFetch` avoid this since they run through Anthropic's own fetch infrastructure, not a request from this machine.

---

## Audience background — HDL code walkthroughs

The human is **not** experienced with VHDL, Verilog, or SystemVerilog. When studying or explaining HDL source files (e.g. `Oric.sv`, any `.vhd`/`.v`/`.sv` file), agents must:

- Briefly explain relevant **syntax** and **language constructs** the first time they appear (e.g. `always_ff`, `assign`, `logic`, port maps, generate blocks).
- Assume solid knowledge of **digital electronics** (logic gates, flip-flops, clocks, buses, state machines) and **general programming** — no need to explain those concepts from scratch.
- Keep syntax explanations short (1–2 sentences) — the goal is to unlock the code, not teach HDL in depth.
- When explaining an HDL construct, always include an **analogy to a well-known programming language** (C, Python, JavaScript, etc.) to ground the concept in familiar terms.
- End every explanation with **1–2 plain-English sentences** summarising what the code actually does at a functional level (no jargon).

---

## Git — never auto-commit

**Do not** run `git commit` or `git push` after any file change in this repo — ingest, refresh, lint, project edits, or anything else — **unless the human explicitly asked you to commit or push in this conversation.**

When work is done, list what changed and stop. The human reviews diffs and commits when ready.

---

## Wiki structure

```
wiki/
  index.md          ← start here; lists every ingested source
  overview.md       ← rolling cross-source synthesis (cites [[source pages]])
  log.md            ← append-only ingest/refresh history
  sources/          ← one page per ingested source (<slug>.md)
  .archive/         ← soft-deleted sources (ignore unless needed)

raw/
  github/           ← immutable GitHub repo captures
  youtube/          ← immutable YouTube transcript captures
  web/              ← immutable web page/site captures

inbox.md            ← agents may add URLs to ## Pending via /pin-llm-wiki queue
.pin-llm-wiki.yml   ← wiki config (domain, detail level, source types, lint cadence)
```

**Load order for any question:** `wiki/index.md` → relevant source pages → raw files only for direct citation.

**Wiki management** (ingest, refresh, lint, remove) uses the `/pin-llm-wiki` skill. Invoke it via the Skill tool — all protocol details live in the skill files, not here.
