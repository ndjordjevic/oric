# Understanding the MiSTer Oric core — start here

1. [`plan.md`](plan.md) — the phases and what is done. Coming back after a break? Read `notes/` first.
2. [`MAP.md`](MAP.md) — where to start in the code and how the files connect.
3. Read code in `annotated/`, not `core/`. The annotated copies have plain-English comments
   (marked `★ SECTION n`) above each section.

## What is where

```
plan.md                     ← the plan (phases, checkboxes)
MAP.md                      ← map of the core: layers, files, "where to look for X"
oric-hardware.md            ← the real Oric: chips and memory map (Phase 2)
dev-env.md                  ← tools and commands (only needed to run code)
notes/                      ← short notes per finished phase — read first when you come back
annotated/                  ← commented copies of core files
core/                       ← original upstream code (not in git, never edit)
```

## About `annotated/`

- **Source:** copies of `MiSTer-devel/Oric_MiSTer` at commit `c4cf449` ("Savestate support (#19)").
  `core/` is at the same commit today. Only comments are added; the code is unchanged.
- **Files so far:** `Oric.sv`, `rtl/oricatmos.vhd`, `rtl/spram.v`, `rtl/T65/T65.vhd`, and
  `rtl/rom/README.md` (explains the ROM files without copying them).
- **Point to sections by name** (`oricatmos.vhd ★ SECTION 8`), not by line number. Section names
  stay stable when comments change. A few docs use line numbers; if you add or remove comment
  lines, fix those numbers too (`grep -rn 'Oric.sv:\|oricatmos.vhd:'`).
- If upstream moves on, make a fresh copy and annotate it again. Do not merge.

## Rule: say each fact once

The "what this code does" text lives in the `annotated/` comments. `MAP.md` and other docs link to
it and do not repeat it.
