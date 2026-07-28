# `archive/` — finished work, kept for reference

Nothing in here is abandoned or wrong. It is **completed** work that is no longer an active track,
moved aside so the project root shows only what's currently being worked on.

Archived **on sprint Day 0**, when the project changed gear (see [`../plan.md`](../plan.md) →
"Gear change"): the goal moved from *understand every line and token of HDL syntax* to
*understand what each code block does*. That change retired the lesson series as an active
track — not as a resource.

## What's here

| Folder | What it is | Status |
|---|---|---|
| [`learn-systemverilog/`](learn-systemverilog/) | 10-lesson SystemVerilog syntax series taught from real lines of `Oric.sv`, + a token decoder card + learning records | **Complete** — all 10 lessons done (pre-sprint) |
| [`learn-vhdl/`](learn-vhdl/) | 10-lesson VHDL series taught from `rtl/oricatmos.vhd`, + decoder card + learning records | **Lessons 1–5 done** (pre-sprint); 6–10 written but not worked through |

## When you'd still come back here

- **A construct stops you mid-file.** The decoder cards
  (`learn-*/reference/*-decoder.html`) map *every* token appearing in `Oric.sv` and
  `oricatmos.vhd` to its meaning and the lesson that teaches it. That's the fastest lookup in the
  repo for "what does this symbol mean," and it stays useful indefinitely.
- **You want the syntax behind a block comment.** The `annotated/` files now explain what code
  *does*, deliberately not what the syntax *is*. When you want the latter, it's here.
- **VHDL lessons 6–10** are complete and unread, if you ever want to finish them. They're no longer
  on the critical path — the sprint reads VHDL at block level instead.

## What changed about the rules

`AGENTS.md`'s **full-coverage requirement** — every line and every token of a shown excerpt must be
explained — governs *these lessons*, and they satisfy it. It does **not** apply to the newer
`annotated/rtl/*` block comments, which are deliberately block-level. If you resume lesson work,
the old standard applies again inside this folder.

Relative links inside these files were rewritten on archiving so they still resolve from the new
depth; all 59 were verified. Line-number citations into `annotated/` are unaffected — those files
did not move.
