# Phase 3 — The two top files (notes)

## What this phase covered

The two files that wire the whole machine together: `Oric.sv` (MiSTer glue around the Oric) and
`rtl/oricatmos.vhd` (the Oric itself). We read every `★` section of both. No chip insides yet.

## Key ideas

- **Blocks inside blocks.** A block (VHDL *entity*, Verilog *module*) is a piece of circuit with
  ports. "Placing" a block makes a real copy in the FPGA. All copies run at the same time.
  Ports are not physical pins; only `sys/sys_top.v` touches real FPGA pins.
- **`Oric.sv` = MiSTer services around one block.** Menu (`CONF_STR` → bits in `status`),
  clocks (PLL: 50 MHz in, 24 + 48 MHz out), reset + RAM clear, the ARM link (`hps_io`), video and
  sound out. The Oric block is section 11; nearly everything else is a MiSTer extra.
- **The RAM lives in `Oric.sv`, outside the Oric.** A priority switch (section 10) lets reset
  clear, snapshot load, savestate save and fast tape use it; otherwise the Oric owns it.
- **`oricatmos.vhd` places the chips** and wires them like the real board: CPU (7), ULA (10),
  VIA (11), sound chip (12), keyboard + joystick (13), disk controllers (14, 15), ROMs (9).
- **Clock enable.** Every chip gets the fast 24 MHz clock, but steps only when `ENA_1MHZ` (from the
  ULA) is 1. So the Oric runs at the real 1 MHz.
- **PHI2 shares the RAM** (section 8): PHI2 = 0 → ULA reads the screen, PHI2 = 1 → CPU.
- **The ULA is reset only by the PLL**, so video keeps running during an Oric reset.
- **Section 19 is the final read switch:** tape patch → Pravetz → disk → VIA → ROM → Microdisc ROM
  → RAM. All 5 ROMs run side by side; this switch picks the one the CPU hears.
- **The sound chip and keyboard go through the VIA**, exactly as in Phase 2 (sections 12, 13, 16).
- **MiSTer extras are big but simple:** fast tape (ROM patches, `$C000` mailbox, bus watching in
  `oricatmos` section 17), snapshots and savestates (F1–F4 save, F5–F8 restore), real tape via ADC.
- **Two languages:** VHDL (original Oric model, CPU, VIA) and Verilog/SystemVerilog (MiSTer glue,
  sound, keyboard). Quartus joins them; VHDL needs a `COMPONENT` list for Verilog blocks.

## Your questions

| Question | Answer |
|---|---|
| Is reset part of the Oric or MiSTer? | Sources and RAM clear: MiSTer. What it resets (CPU, VIA…): the Oric. A real Oric does a full reset only at power-on; its button is an NMI (F10 here). |
| What is the "ARM computer"? | The HPS: a dual-core ARM CPU on the same chip as the FPGA. It runs Linux, reads the SD card and USB, draws the menu. |
| Why 4 floppies? | The real Microdisc can select 4 drives. Pravetz mode has 2. |
| What is `CLOAD`? Is there `LOAD`? | `CLOAD`/`CSAVE` = tape load/save in BASIC. No `LOAD` in the ROM; disk systems (Sedoric) add it. |
| Does the core have the Microdisc? | Yes: `microdisc.vhd` + `wd1793.sv`, `.DSK` images, FDD Controller = Auto/Off/On. |
| What is the Microdisc, and how does it connect? | Oric's official floppy add-on (WD1793, 8 KB boot ROM) on the expansion port. Its ROMDIS and MAP wires switch off BASIC and add overlay RAM. |
| Can I still buy one? | Only used. Modern replacements: LOCI (current), Cumulus (out of production), Erebus. |
| What is fast tape? | ROM patches so the loader takes bytes straight from the file. Fast = byte by byte, Ultra = whole block at once, Off = real speed. |
| Can I use a real tape recorder? | Yes: Tape Input = ADC. Saved as Idea #9 in `../../ideas.md`. |
| "Pins" are physical? What is a block? | No: ports of a block inside the FPGA. A block is one module, like a chip on a board or a class you can place many times. |
| Why VHDL and Verilog? | Parts came from different authors and years. Quartus accepts both. |
| Which two disk controllers? | Microdisc (Oric) and an Apple II-style controller (Pravetz 8D). |
| Pravetz 8D vs Atmos? | Bulgarian Atmos clone: same chips; Cyrillic ROM and keyboard; Apple II-style 5.25" disks. |

## Answered open questions from Phase 2

- **Oric-1 vs Atmos in the core:** only the ROM differs. `rom` is used only to pick the ROM and
  to turn on Pravetz mode (`Oric.sv` ★ SECTION 12, `oricatmos.vhd` ★ SECTIONS 6, 19).
- **16 KB Oric-1:** not copied. The core always has 64 KB of RAM (`Oric.sv` ★ SECTION 10).

## Where to look

- `annotated/Oric.sv` — sections 2–3 (menu), 5 (reset), 10 (RAM switch), 11 (the Oric block),
  16 (tape player).
- `annotated/rtl/oricatmos.vhd` — sections 7 (CPU), 8 (RAM sharing), 10 (ULA), 11–13 (VIA, sound,
  keyboard), 16 (VIA wires), 19 (read switch).
- `core/docs/` — maintainer notes on fast tape, snapshots, Pravetz disk.

## Still open

- Why RAM is cleared to `0x01`, not `0x00` (in `oric-hardware.md`).
- Small comment fixes made during this phase: `tape_clk` is unused (`Oric.sv` 5); VIA Port B and
  the misleading `psg_bdir` name (`oricatmos` 11); sound-chip I/O port is an output (12);
  Pravetz shadow = RAM, not ROM (18).
