# Annotated source snapshots

Personal study copies of upstream `Oric_MiSTer` source files, with `// ★` / `-- ★`
comments added while walking through the code (see [`../01a-Oric-sv-understanding.md`](../01a-Oric-sv-understanding.md)).

These are **not** part of the `core/` clone — `core/` is a gitignored sibling that
tracks `MiSTer-devel/Oric_MiSTer` upstream and is kept pristine so it can be
pulled/updated without conflicts. These copies live here, tracked by this repo's
git, so the annotations survive even if `core/` is deleted or re-cloned.

## Snapshot provenance

- Upstream: `MiSTer-devel/Oric_MiSTer`
- Commit: `c4cf449` ("Savestate support (#19)")
- Annotated: 2026-06-22 (Phase 1a walkthrough)

## Files

- `Oric.sv` — top-level MiSTer `emu` glue module (19 `★` section markers)
- `rtl/oricatmos.vhd` — the Oric Atmos machine wrapper (19 `★` section markers)

These will drift from `core/` as upstream updates land there. Treat them as a
frozen reference tied to the commit above, not a live mirror. Re-annotate a
fresh copy here if you revisit a file after a core update.
