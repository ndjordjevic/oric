# `rtl/rom/` — the ROM images

The ROM files are not copied here. Each one is about 1,000 lines of hex bytes with only ~20 lines of
code, and all of them have the same shape. This page explains that shape once. Open the real files
in `core/rtl/rom/`.

## What a ROM file is

Each file is the ROM's bytes written as a VHDL table. The FPGA tool builds the table into the
chip's block RAM. On the real Oric this was a 16 KB ROM chip on the board.

Every file has 3 parts:

| Part | What it does |
|---|---|
| `entity` | The pins: `clk`, `addr` (14 bits = 16 KB), `data` (one byte out) |
| `rom_data` table | The ROM's bytes — BASIC and the operating system, as 6502 machine code |
| one `process` | On each clock tick, output the byte at `addr`. There is no write, so it is read-only |

The CPU sees the ROM at `$C000`–`$FFFF` (16 KB). `oricatmos.vhd` gives each ROM the low 14 bits of
the CPU address (`cpu_ad(13 DOWNTO 0)`, `oricatmos.vhd:502`).

## Which ROMs are in the build

`core/files.qip` lists the files that go into the core. Only 5 of the 13 ROM files are in it:

| File | Entity name | Size | What it is | Used at |
|---|---|---|---|---|
| `BASIC11A.vhdl` | `BASIC11A` | 16 KB | Oric Atmos BASIC 1.1 (default) | `oricatmos.vhd:499` |
| `BASIC10.vhd` | `BASIC10` | 16 KB | Oric-1 BASIC 1.0 | `oricatmos.vhd:506` |
| `PRAVETZ8D.vhd` | `PRAVETZ8D` | 16 KB | Pravetz-8D (Bulgarian clone) | `oricatmos.vhd:513` |
| `PRAVETZ8D_FDC.vhd` | `PRAVETZ8D_FDC` | 256 B | Small boot ROM for the Pravetz disk | `oricatmos.vhd:520` |
| `MICRODIS.vhd` | **`ORICDOS06`** | 8 KB | Microdisc disk controller ROM | `oricatmos.vhd:528` |

**Watch out:** `MICRODIS.vhd` names its entity `ORICDOS06`. A search for "MICRODIS" finds the
file but not the place where it is used.

**Not in the build** (the files exist but are not compiled): `BASIC11.vhd`, `BASIC11B.vhdl`,
`BASIC22.vhd`, `DIAG10.vhd`, `TEST108J.vhdl`, `ORIC1SDCARD.vhd`, `test109.vhd`, `testsector.vhd`.
`DIAG10` and `TEST108J` are Mike Brown's test ROM — see [[oric.signal11.org.uk]].
`MICRODIS.rom` is the raw binary of the Microdisc ROM.

## How the core picks a ROM

- You pick the ROM in the MiSTer menu. The choice takes effect at reset (`Oric.sv` ★ SECTION 12).
- `oricatmos.vhd` ★ SECTION 19 chooses, for each CPU read, whether the byte comes from a ROM, RAM,
  the VIA or a disk controller.
- `Oric.sv` also has an "alt BIOS": a 16 KB RAM (`spram`) that you can fill from a file on the SD
  card. It replaces the built-in ROM.

## To read the ROM code itself

- `oric-docs/books/oric/oric-advanced-user-guide-rom-disassembly.md` — the full ROM, commented
- `oric-docs/books/oric/oric-advanced-user-guide.md` — hardware and ROM reference
