# Understanding the MiSTer Oric core — start here

Goal and phase plan: [`plan.md`](plan.md). This README explains how the study materials fit together, because the same code is covered by several **layers** that answer different questions — they complement each other and must not duplicate each other.

## The layers

| Layer | Where | Question it answers |
|---|---|---|
| **Lessons + decoder cards** | [`archive/learn-systemverilog/`](archive/learn-systemverilog/), [`archive/learn-vhdl/`](archive/learn-vhdl/) | "How do I read this *language* at all?" — syntax only, taught from real lines of this core. **Complete (2026-07-14/16) — a finished reference, not an active track** |
| **Annotated source** | [`annotated/`](annotated/README.md) | "What is this code doing, right where I'm reading it?" — frozen study copies with a file-header block, `★` section comments, and (from 2026-07-27) **a plain-English comment per logic block**. The project's primary artifact |
| **Walkthrough docs** | [`reference/understanding-Oric-sv.md`](reference/understanding-Oric-sv.md), [`reference/understanding-oricatmos-vhd.md`](reference/understanding-oricatmos-vhd.md) | "How is this file architected, and how do its parts connect?" — the map, not the territory |
| **Block diagram** | [`reference/block-diagram.md`](reference/block-diagram.md) | "How do the files and subsystems relate?" |

## Reading order (new session / coming back cold)

1. **Can't read the language yet?** Do the lessons: `archive/learn-systemverilog/lessons/` for `Oric.sv`, `archive/learn-vhdl/lessons/` for the `.vhd` files. Keep the decoder card (`learn-*/reference/*-decoder.html`) open beside any source file — it maps every token in the file to its meaning and lesson.
2. **Reading the code?** Read `annotated/Oric.sv` / `annotated/rtl/oricatmos.vhd`, not `core/` — the `★` comments carry each section's summary, and all line numbers cited anywhere in this project refer to the annotated copies.
3. **Need the big picture first?** `understanding-Oric-sv`/`understanding-oricatmos-vhd` give the architecture per file, `reference/block-diagram.md` the cross-file map.

## Division of labour (the anti-duplication rule)

Each fact lives in exactly one layer:

- **"What does this code do"** lives inline in `annotated/` — `★` section summaries plus per-logic-block comments. The walkthrough docs deliberately do **not** repeat them.
- **Walkthrough docs** (`understanding-Oric-sv`, `understanding-oricatmos-vhd`, future `modules/*.md`) carry only what inline comments can't: background, real-hardware comparisons, cross-section/cross-file connections, tables, open questions. Per section: a heading with the `★` line number, plus that extra context.
- **Lessons** teach language constructs, never file architecture; the decoder cards index tokens, not behavior.

When the [7-day sprint](plan.md) walks the remaining `rtl/` modules, each follows the same pattern: annotate a frozen copy in `annotated/rtl/` (file header + `★` summaries + per-block comments), then write a thin `modules/<module>.md` for the connective context. The old per-module decoder-card token check was **dropped on 2026-07-27** — see the plan's "gear change" note: the project now targets block-level understanding, not line-and-token coverage.

## Directory map

**A leading `NN-` means "produced by Day NN of the [sprint](plan.md)"** — that's all it means.
Unnumbered files aren't sprint output (pre-existing walkthroughs, reference, later phases).

```
plan.md                          ← study plan: the 7-day sprint + long-range phases
README.md                        ← this file

  ── sprint deliverables, numbered by the day that produced them ──
00-repo-map.md                   ← Day 0 · what every folder/file in core/ is for
01-oric-hardware-notes.md        ← Day 1 · the real Oric hardware, in your own words
modules/02-ula.md                ← Day 2 · ULA timing & address generation
modules/03-video.md              ← Day 3 · pixel pipeline & serial attributes
modules/04-m6522.md              ← Day 4 · VIA
modules/05-psg.md  +  modules/05-keyboard-joystick.md    ← Day 5 · sound & input
modules/06-tape.md               ← Day 6 · cassette path
07-how-the-oric-works.md         ← Day 7 · capstone, end-to-end narrative

  ── reference, no day number ──
reference/understanding-Oric-sv.md         ← architecture of Oric.sv           (was 01a-)
reference/understanding-oricatmos-vhd.md   ← architecture of rtl/oricatmos.vhd (was 01b-)
reference/block-diagram.md                 ← data/clock-path diagrams (refreshed Day 7)
reference/dev-env.md                       ← toolchain setup (GHDL, Icarus, Verilator, GTKWave)
sim/, simulation-notes.md        ← testbenches + waveforms
build-notes.md                   ← Quartus build notes

annotated/                       ← frozen ★-annotated source snapshots (canonical line numbers)
core/                            ← pristine upstream clone (gitignored sibling — never annotate)
archive/                         ← finished work, kept for reference (see archive/README.md)
  learn-systemverilog/           ← SV lesson series + decoder card + mission/notes
  learn-vhdl/                    ← VHDL lesson series + decoder card + mission/notes
```
