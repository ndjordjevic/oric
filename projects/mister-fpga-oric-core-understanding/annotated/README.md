# Annotated source snapshots

Personal study copies of upstream `Oric_MiSTer` source files, with `// ★` / `-- ★`
comments added while walking through the code (see [`../reference/understanding-Oric-sv.md`](../reference/understanding-Oric-sv.md)).

These are **not** part of the `core/` clone — `core/` is a gitignored sibling that
tracks `MiSTer-devel/Oric_MiSTer` upstream and is kept pristine so it can be
pulled/updated without conflicts. These copies live here, tracked by this repo's
git, so the annotations survive even if `core/` is deleted or re-cloned.

## Snapshot provenance

- Upstream: `MiSTer-devel/Oric_MiSTer`
- Commit: `c4cf449` ("Savestate support (#19)")
- Annotated: pre-sprint (Phase 1a walkthrough)

## Files

- `Oric.sv` — top-level MiSTer `emu` glue module (19 `★` section markers)
- `rtl/oricatmos.vhd` — the Oric Atmos machine wrapper (19 `★` section markers)
- `rtl/spram.v` — generic single-port RAM (sprint Day 1)
- `rtl/T65/T65.vhd` — 6502 CPU soft core; **interface annotated only**, internals
  deliberately out of scope (sprint Day 1)
- `rtl/rom/README.md` — annotates the ROM-file *pattern* instead of copying 13 hex
  dumps; also records which ROMs are actually in the build (sprint Day 1)

## Corrections to frozen files

Frozen means *line numbers never move*, because lessons and walkthrough docs cite them.
A same-line-count text fix is therefore permitted; anything that adds or removes a line is not.

- **Sprint Day 1 — `Oric.sv` line 150.** The `★ RESET & RAM CLEAR` comment said the reset
  counter walks RAM "zeroing it out". It does not: line 349 is `spram_d <= 1;`, so RAM is
  filled with **0x01**. Corrected in place — 1 insertion, 1 deletion, file still 925 lines,
  the `★` still on line 150, so every existing citation is unaffected.

These will drift from `core/` as upstream updates land there. Treat them as a
frozen reference tied to the commit above, not a live mirror. Re-annotate a
fresh copy here if you revisit a file after a core update.
