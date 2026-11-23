# Phase 1 — The map (notes)

## What this phase covered

How the core repo is laid out: which files matter, which to ignore, and which file uses which.
No code was read. The source for all of this is [`../MAP.md`](../MAP.md).

## Key ideas

- **4 layers**, each using the one below it:
  `sys/` (MiSTer framework) → `Oric.sv` (MiSTer glue) → `rtl/oricatmos.vhd` (the Oric) → chip files.
- `sys/` is the same in every MiSTer core. Treat it as a black box. `sys/sys_top.v` is the real
  top of the build, but you do not need to read it.
- `Oric.sv` is the MiSTer glue: menu, file loading, RAM, video and sound out, fast tape, savestates.
- `rtl/oricatmos.vhd` **is the Oric**. It wires the CPU, ULA, VIA, sound chip, keyboard and ROMs together.
- `rtl/ula.vhd` is the most important chip file. The ULA makes the 1 MHz clock, shares RAM between
  the CPU and the screen, and draws the whole screen.
- Some files are MiSTer extras, not the real Oric: fast tape (`tap_*.v`, `cload_patch_rom.v`),
  snapshots and savestates (`snap_*.v`, `savestate_hotkeys.v`, `ddram.sv`).
- `rtl/video.vhd` is dead code. It is in the build list, but nothing uses it.
- `files.qip` is the build list. A file that is not in it is not in the core.

## Your questions

| Question | Answer |
|---|---|
| What does "★ SECTION 11" mean? | Part 11 of one annotated file. Open the file in `annotated/`, search for `★ SECTION 11`, and read down to the next `★`. Each file counts its own sections. |
| Should I read `oricatmos.vhd` in Phase 1? | No. At most, skim its `★ SECTION` header lines. The real read is Phase 3, after Phase 2 explains the real Oric. |

## Where to look

- [`../MAP.md`](../MAP.md) — the layers, the diagram, the file tables, and "where to look for X".
- `core/files.qip` — the build list.

## Still open

Nothing.
