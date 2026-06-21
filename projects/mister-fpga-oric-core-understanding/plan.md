# Understanding the MiSTer FPGA Oric core — study plan

**Goal:** Be able to read the [`MiSTer-devel/Oric_MiSTer`](https://github.com/MiSTer-devel/Oric_MiSTer) source and explain, module by module, how the Oric-1 / Atmos is reconstructed in FPGA logic — CPU, ULA video, VIA, PSG sound, storage, and the MiSTer-specific glue (tape/snapshot/savestate). Stretch goal: simulate a module and (optionally) build the core.

**Definition of done:** an annotated set of notes in this folder — one per major subsystem — plus a block diagram of the core's data/clock path and at least one module simulated and understood via waveforms.

**Project layout:**
```
plan.md          ← this file
docs/            ← book catalog (see docs/INDEX.md): FPGA/HDL + Oric book TOCs; drop learning PDFs here
00-dev-env.md … 06-build-notes.md   ← phase deliverables (created as you go)
04-modules/      ← per-subsystem notes (Phase 4)
05-sim/          ← testbenches + waveforms (Phase 5)
core/            ← cloned Oric_MiSTer source (gitignored sibling)
```

**Why this repo:** the [wiki](../../wiki/index.md) already documents the *real* Oric hardware (register-level manual, ULA reverse-engineering, memory map) and the [core itself](../../wiki/sources/MiSTer-devel-Oric_MiSTer.md). You cannot read `ula.vhd` without knowing what the ULA does — so each code-reading step below is paired with required wiki reading.

---

## Ground truth: what the core actually contains

Mixed-language core. **VHDL** for the machine internals, **Verilog/SystemVerilog** for the MiSTer glue. Verified against the repo tree (master):

```
Oric.sv                 ← emu top module (MiSTer dev top level; wires sys/ ↔ core)
rtl/
  oricatmos.vhd         ← top-level Oric machine wrapper
  ula.vhd  video.vhd    ← ULA + video pipeline (the heart of the Oric)
  m6522.vhd             ← 6522 VIA (I/O, keyboard, tape, timers)
  psg.v                 ← AY-3-8912 PSG (sound)
  keyboard.sv joystick.sv
  microdisc.vhd wd1793.sv pravetz8d_fdc.vhd   ← floppy controllers
  apple2_disk/          ← WD1793 shared with an Apple II disk impl (reuse)
  cassette.v cas_sig_gen.v                     ← original cassette path
  cload_patch_rom.v tap_byte_streamer.v tap_segment_loader.v tap_autorun_keys.v  ← Smart CLOAD tape engine
  snap_loader.v snap_ss.v savestate_hotkeys.v  ← snapshots + MiSTer savestates
  spram.v ddram.sv      ← RAM / SDRAM interface
  pll.v pll.qip pll/    ← clocking (Intel PLL megafunction — NOT simulable open-source)
  T65/                  ← 6502 soft CPU core
  rom/                  ← ROM images AS VHDL: BASIC10/11/22, DIAG10 + TEST108J (← Mike Brown diag ROM),
                          MICRODIS, PRAVETZ8D, ORIC1SDCARD
sys/                    ← MiSTer framework — DO NOT EDIT; real top is sys/sys_top.v, calls emu
tools/                  ← Python tape/snapshot tools (stdlib only) + oric-build (Docker/Quartus)
```

> ⚠️ The README references a `docs/` folder (`oric_memory_map.md`, `oric_to_core_comm.md`, `live_rom_patching.md`, …). **That folder does not exist in the repo** — the README is out of sync. Primary study material is therefore: the code + inline comments, this repo's wiki, and the misterfpga.org Oric thread. If a future core update adds `docs/`, read it first.

---

## MiSTer core anatomy (read once, applies to every core)

- The real top level is `sys/sys_top.v` — it instantiates a module called **`emu`** that the core provides (here, in `Oric.sv`). When Quartus builds, it builds `sys_top`, not your module.
- Everything under **`sys/`** is identical across all cores: OSD, input handling, video scaling, HDMI/VGA output, and **`hps_io`** (the bridge to the ARM/Linux side that loads ROMs, reads the OSD config string, etc.). Treat it as a black box with a known interface — do not try to read it all.
- The **`rtl/`** folder is the actual core. Free-form except `pll`.
- Mental model: `hps_io` hands files/config in → `emu` wires them to the `rtl/` machine → machine produces video/audio/SDRAM traffic → `sys/` formats output. **Your study target is `rtl/` + the `emu` wiring in `Oric.sv`.**

Reading: [emu — Top Level of a MiSTer core (wiki)](https://github.com/MiSTer-devel/Wiki_MiSTer/wiki/emu---Top-Level-of-a-MiSTer-core) · [overview of emu module (docs)](https://mister-devel.github.io/MkDocs_MiSTer/developer/emu/) · [Template_MiSTer](https://github.com/MiSTer-devel/Template_MiSTer)

---

## Phase 0 — Dev environment (START HERE)

The stated goal is **reading and analyzing** code. The whole reading + simulation stack runs **natively on macOS**. Quartus does **not** run on macOS and is **not** needed to read code — defer it.

### 0a. Native MVP ✅ (2026-06-21)
- [x] Install the open-source HDL stack:
      `brew install ghdl icarus-verilog verilator gtkwave python3`
      (GHDL = VHDL sim; Icarus/Verilator = Verilog/SV sim; GTKWave = waveform viewer)
- [x] VS Code + **TerosHDL** extension (bundles linting, simulation, and doc-gen for both VHDL and Verilog) — or standalone HDL LSP extensions (`VHDL LS`, `SystemVerilog`).
- [x] Clone the core locally as a **gitignored sibling** so it stays a separate repo:
      `git clone https://github.com/MiSTer-devel/Oric_MiSTer.git core/` inside this project folder, then add `projects/**/core/` to the repo `.gitignore`.
- [x] Smoke-test the toolchain: run a repo Python tool (`python3 core/tools/tape-inspect.py --help`) and confirm GHDL/Verilator/gtkwave launch.
- **Deliverable:** `00-dev-env.md` ✅ — what was installed, versions, how to launch each tool, and the gitignore decision.

### 0b. Quartus (DEFERRED — only when you want the RTL Viewer or to build a `.rbf`)
- Quartus Prime Lite is Linux/Windows-only. Two routes:
  - **Docker** (build only, no GUI): the core ships `tools/oric-build` targeting the `raetro/quartus:mister` image. Good for producing a `.rbf`.
  - **Linux VM** (e.g. UTM/Parallels): needed if you want the **graphical RTL Viewer / netlist schematic**, which is genuinely useful for grasping how a module elaborates into hardware.
- Not a prerequisite for any reading/simulation phase below. Revisit at Phase 6.

---

## Phase 1 — Orient in the codebase
- [ ] Read `Oric.sv` (`emu`) top-to-bottom; map which `rtl/` modules it instantiates and how `hps_io` signals reach the machine.
- [ ] Read `rtl/oricatmos.vhd` — the machine wrapper. Sketch which sub-modules it connects (CPU ↔ RAM/ROM ↔ ULA ↔ VIA ↔ PSG) and the clock/reset distribution.
- **Deliverable:** `01-block-diagram.md` — a data-path + clock-path block diagram of the whole core (boxes = modules, arrows = buses). This becomes the map you annotate in later phases.

## Phase 2 — Learn the real Oric hardware (so the RTL means something)
Pair with the wiki — this is required reading, not optional:
- [ ] Memory map, 6502/VIA/ULA/PSG architecture → [[oric.free.fr]] (register-level hardware-programming manual).
- [ ] What the ULA actually does + the decapped schematics → [[oric.signal11.org.uk]] (Mike Brown / Lance Ewing reverse-engineering). The core's `rtl/rom/DIAG10` + `TEST108J` ROMs **are** Mike Brown's diagnostic ROM.
- [ ] Cross-check against the Defence Force forum digest and the misterfpga.org Oric thread: <https://misterfpga.org/viewtopic.php?t=4599>.
- **Deliverable:** `02-oric-hardware-notes.md` — annotated memory map + one-paragraph-per-chip summary, in your own words.

## Phase 3 — Enough HDL to read fluently
The core is mixed-language, so you need reading fluency in **both** VHDL and Verilog (not authoring mastery).
- [ ] Skim a VHDL primer and a Verilog primer focused on *reading* synthesizable RTL (processes/`always` blocks, signals vs variables, clocked vs combinational). Use the misterfpga.org pinned lists: [Learning to dev a core](https://misterfpga.org/viewtopic.php?t=78) · [Verilog/HDL books & tutorials](https://misterfpga.org/viewtopic.php?t=136).
- [ ] Use the **`docs/` book catalog** ([`docs/INDEX.md`](docs/INDEX.md)) — VHDL (Pedroni; Brown & Vranesic), Verilog (Palnitkar; Chu's *FPGA Prototyping by Verilog Examples*), and digital-design (Mano) for HDL fluency; plus the Oric hardware/machine-code titles (6502 User's Manual, *Machine Code for the Atmos and Oric-1*, *Oric Advanced User Guide* + ROM disassembly, Service Manual) for Phase 2/4. Online references are in [`../../RESOURCES.md`](../../RESOURCES.md) §8.
- [ ] Optional sandbox: re-type a tiny module into [EDA Playground](https://www.edaplayground.com) and watch it simulate.
- **Deliverable:** `03-hdl-cheatsheet.md` — a personal read-only cheatsheet for the VHDL/Verilog idioms this core uses.

## Phase 4 — Walk the core, module by module (the main event)
Follow the data path. For each: read the module, annotate against the Phase 1 diagram, write a short note. Suggested order (simple → complex):
- [ ] **Clocking** — `pll.v` + how `oricatmos.vhd` derives the ~1 MHz CPU clock / pixel clock (PLL internals are a black box; focus on the divide/enable scheme).
- [ ] **CPU** — `T65/` (6502). Don't read every line; understand the interface (address/data/RW/IRQ/NMI) and how it ties to memory.
- [ ] **Memory** — `spram.v`, `ddram.sv`, `rom/*.vhd` (ROMs are literally VHDL lookup tables; note BASIC10/11/22 = Oric-1/Atmos, DIAG10 = diagnostic).
- [ ] **ULA + video** — `ula.vhd` then `video.vhd`. The payoff module. Re-read [[oric.signal11.org.uk]] alongside. Map text/HIRES modes, attributes, sync generation.
- [ ] **VIA** — `m6522.vhd` (keyboard matrix, tape I/O, timers, PSG control lines).
- [ ] **Sound** — `psg.v` (AY-3-8912: tone/noise/envelope channels).
- [ ] **Input** — `keyboard.sv`, `joystick.sv`.
- [ ] **Storage** — `microdisc.vhd` + `wd1793.sv` (note `apple2_disk/` reuse) + `pravetz8d_fdc.vhd`.
- [ ] **MiSTer glue** — the Verilog tape engine (`cload_patch_rom.v`, `tap_byte_streamer.v`, `tap_segment_loader.v`), then snapshots/savestates (`snap_loader.v`, `snap_ss.v`, `savestate_hotkeys.v`). Cross-reference the core's `tools/tool.md` (TAP/SNA format tools).
- **Deliverable:** `04-modules/<module>.md` per subsystem — purpose, key signals, how it maps to real hardware, open questions.

## Phase 5 — Simulate a module (make it concrete)
Honest scope: **you cannot simulate the whole core** with open-source tools — `sys/` is full of Intel primitives (PLL, HPS, megafunctions). Simulation must be **module-level**, isolating a pure-logic module from the framework.
- [ ] Start with a **single-language, self-contained** module: `m6522.vhd` (GHDL) or `psg.v` / a `tap_*.v` (Icarus/Verilator). Avoid VHDL↔Verilog co-sim at first — it's painful.
- [ ] Write a minimal testbench, dump a VCD, open in GTKWave, and confirm the module behaves as the datasheet/wiki says.
- [ ] Then attempt the rewarding-but-harder `ula.vhd`/`video.vhd` (clock-dependent; needs a believable clock/reset harness).
- **Deliverable:** `05-sim/<module>-tb` + a `05-simulation-notes.md` with annotated waveforms.

## Phase 6 — (Optional / stretch) build & run
- [ ] Stand up Quartus via Docker (`tools/oric-build`) or a Linux VM; open the project, use the **RTL Viewer** on a module you studied to compare your mental model to the elaborated netlist.
- [ ] If hardware is available (see [`../../../mister-fpga/HARDWARE_SETUP.md`](../../../mister-fpga/HARDWARE_SETUP.md)): build a `.rbf`, deploy, and make one small visible change (e.g. tweak a border/video constant) to close the loop.
- **Deliverable:** `06-build-notes.md`.

---

## Required-reading map (wiki ↔ module)

| Studying | Read first |
|---|---|
| Anything | [[MiSTer-devel-Oric_MiSTer]] (core summary) |
| Memory, CPU, VIA, PSG | [[oric.free.fr]] (hardware manual) |
| `ula.vhd`, `video.vhd` | [[oric.signal11.org.uk]] (ULA reverse-engineering) |
| `rom/DIAG10`, `TEST108J` | [[oric.signal11.org.uk]] (diagnostic ROM) |
| Storage / Microdisc | Defence Force forum digest (storage threads) |
| Whole-core context | misterfpga.org t=4599; `[[OldWer-Metaphoric]]` for a hardware cross-reference |

## Open items / decisions
- [ ] Confirm clone location convention (`core/` gitignored sibling) and add to `.gitignore`.
- [ ] Decide whether module notes from Phase 4 get promoted into the wiki as a derived overview once mature.
- [ ] The core repo's own `docs/` is missing upstream — if it reappears, re-prioritize it as primary material. (Not to be confused with this project's `docs/`, which holds your FPGA learning PDFs.)
- [ ] Decide whether the learning PDFs in `docs/` are committed or gitignored (size + copyright) — lean toward gitignoring large/copyrighted books and keeping only an index.

---

## First action item

**Phase 0a — set up the native dev environment** (Homebrew HDL stack + VS Code/TerosHDL + clone the core locally). Everything else builds on being able to open, navigate, and simulate the code. Quartus is explicitly deferred.
