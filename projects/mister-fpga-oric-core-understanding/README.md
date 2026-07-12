# Understanding the MiSTer Oric core — start here

Goal and phase plan: [`plan.md`](plan.md). This README explains how the study materials fit together, because the same code is covered by several **layers** that answer different questions — they complement each other and must not duplicate each other.

## The layers

| Layer | Where | Question it answers |
|---|---|---|
| **Lessons + decoder cards** | [`learn-systemverilog/`](learn-systemverilog/), [`learn-vhdl/`](learn-vhdl/) | "How do I read this *language* at all?" — syntax only, taught from real lines of this core |
| **Annotated source** | [`annotated/`](annotated/README.md) | "What is this section of code doing, right where I'm reading it?" — frozen study copies with `★` section comments |
| **Walkthrough docs** | [`01a-Oric-sv-understanding.md`](01a-Oric-sv-understanding.md), [`01b-oricatmos-vhd-understanding.md`](01b-oricatmos-vhd-understanding.md) | "How is this file architected, and how do its parts connect?" — the map, not the territory |
| **Block diagram** | [`01-block-diagram.md`](01-block-diagram.md) | "How do the files and subsystems relate?" |

## Reading order (new session / coming back cold)

1. **Can't read the language yet?** Do the lessons: `learn-systemverilog/lessons/` for `Oric.sv`, `learn-vhdl/lessons/` for the `.vhd` files. Keep the decoder card (`learn-*/reference/*-decoder.html`) open beside any source file — it maps every token in the file to its meaning and lesson.
2. **Reading the code?** Read `annotated/Oric.sv` / `annotated/rtl/oricatmos.vhd`, not `core/` — the `★` comments carry each section's summary, and all line numbers cited anywhere in this project refer to the annotated copies.
3. **Need the big picture first?** `01a`/`01b` give the architecture per file, `01-block-diagram.md` the cross-file map.

## Division of labour (the anti-duplication rule)

Each fact lives in exactly one layer:

- **Section summaries** ("what does this block do") live as `★` comments in `annotated/` — the walkthrough docs deliberately do **not** repeat them.
- **Walkthrough docs** (`01a`, `01b`, future `04-modules/*.md`) carry only what inline comments can't: background, real-hardware comparisons, cross-section/cross-file connections, tables, open questions. Per section: a heading with the `★` line number, plus that extra context.
- **Lessons** teach language constructs, never file architecture; the decoder cards index tokens, not behavior.

When Phase 4 (see `plan.md`) walks the remaining `rtl/` modules, each module follows the same pattern: annotate a frozen copy in `annotated/rtl/` (`★` summaries inline), write a thin `04-modules/<module>.md` for the connective context, and check the decoder card still covers every token (extend the lessons only if a genuinely new construct appears).

## Directory map

```
plan.md              ← study plan + phase checklist
README.md            ← this file
00-dev-env.md        ← toolchain setup (GHDL, Icarus, Verilator, GTKWave)
01-block-diagram.md  ← data/clock-path diagrams (Mermaid)
01a-*.md / 01b-*.md  ← per-file architecture walkthroughs
annotated/           ← frozen ★-annotated source snapshots (canonical line numbers)
core/                ← pristine upstream clone (gitignored sibling — never annotate)
learn-systemverilog/ ← SV lesson series + decoder card + mission/notes
learn-vhdl/          ← VHDL lesson series + decoder card + mission/notes
```
