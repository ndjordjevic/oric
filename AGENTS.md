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
3. For hardware, troubleshooting, or community questions, also consult the **Defence Force forum digest** (see below).
4. Cite wiki page names in your answer.
5. If the answer is not in the wiki or digest, say so clearly, then fetch current information online instead of relying on training data alone.

The wiki is the authoritative local source for this domain. Start there, use it whenever it covers the question, and go online for gaps or newer information.

---

## Defence Force forum digest

A structured knowledge base of forum threads from `forum.defence-force.org`, maintained as a separate project.

**Location:** `/Users/nenaddjordjevic/LLMProjects/oric-forum-digest/digests/`

Each subforum is a directory. List the directories to discover available subforums. Each directory has an **`index.md`** listing all topics with digest links. Individual digest files are named `<topic-id>-<slug>.md` and follow a consistent structure: _Question/goal_, _Outcome_, _Key facts_.

**When to consult the digest:**

- Hardware troubleshooting, repair, or component compatibility questions.
- Clone board questions (Metaphoric, OriClone-1, Oric Remix, Replic'Oric, etc.).
- Storage peripherals (Microdisc, Cumulus, LOCI, Erebus, Cumana, etc.).
- Video output, ULA replacement, or signal questions.
- AY sound chip programming or hardware audio questions.
- Sourcing or identifying period-correct components.

**How to use:**

1. Check the relevant subforum `index.md` to find matching topic(s).
2. Read the topic digest file(s) for facts and community consensus.
3. Cite the digest file path and topic ID in your answer (e.g., `hardware-hacks/1149-oric-atmos-from-scratch.md`).

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
