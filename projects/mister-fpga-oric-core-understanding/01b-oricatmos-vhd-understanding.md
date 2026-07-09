# 01b — `oricatmos.vhd` understanding

**Date:** 2026-07-09  
**File studied:** `core/rtl/oricatmos.vhd`  
**Role:** The Oric Atmos computer itself — CPU, ULA, VIA, PSG, keyboard, ROMs, and both floppy controllers, wired together into one machine. This is what `Oric.sv` instantiates (see [`01a-Oric-sv-understanding.md`](01a-Oric-sv-understanding.md), Section 11).

**Annotated source:** [`annotated/rtl/oricatmos.vhd`](annotated/rtl/oricatmos.vhd) — a frozen copy with the `★` section comments below inlined at each site (`core/` itself is kept pristine so it can track upstream cleanly; see [`annotated/README.md`](annotated/README.md)).

---

## What this file is

Where `Oric.sv` is scaffolding, `oricatmos.vhd` **is** the Oric — it descends from a 2006 hobbyist VHDL simulation model of the real hardware (SEILEBOST, see Section 1), later extended for MiSTer with snapshot save/restore, a live ROM-patch intercept for fast tape loading, a `$C000` mailbox for host↔core signalling, and Pravetz-8D (Bulgarian Apple II clone) support bolted alongside the original Microdisc floppy path.

Unlike `Oric.sv` (SystemVerilog), this file is **VHDL** — a different HDL with its own syntax. Since this is the first pure-VHDL file walked through in this project, a short primer follows before the section-by-section notes.

---

## VHDL quick syntax primer

- **`ENTITY x IS PORT (...) END;`** — declares the module's interface: every pin, its direction (`IN`/`OUT`), and its type. Like a function signature, or a C header's `extern` declarations — it says what crosses the boundary, not how it works inside.
- **`ARCHITECTURE RTL OF x IS ... BEGIN ... END;`** — the implementation body for that entity, like a class implementing an interface. `RTL` here is just a chosen name for this particular architecture (VHDL lets an entity have multiple named architectures; only one is used).
- **`SIGNAL`** — a persistent wire or register declared at architecture scope. Roughly a module-level variable, except it represents actual hardware wiring that exists all the time, not a temporary that comes and goes.
- **`COMPONENT`** — a forward declaration of another module's port list, so it can be instantiated below by name. Like a C function prototype: it tells the compiler the shape of something defined elsewhere.
- **`PORT MAP (...)`** — wires real signals to a component instance's ports by name when instantiating it. Equivalent to calling a constructor with keyword arguments.
- **Concurrent signal assignment** (`x <= a WHEN cond ELSE b;`) — not a one-shot `if`. This is *always active*: `x` continuously re-evaluates and updates the instant anything on the right-hand side changes. Think of it like a spreadsheet formula, not an imperative statement that runs once and stops.
- **`PROCESS (sensitivity_list) ... END PROCESS;`** or **`PROCESS BEGIN ... WAIT UNTIL rising_edge(clk); ... END PROCESS;`** — a block that only re-evaluates when something in its sensitivity list changes, or (with the `WAIT UNTIL` form) only on a clock edge. This is how VHDL expresses a clocked register/flip-flop — like an event handler that only fires on a specific trigger, versus the "always live" concurrent assignments above.
- **`rising_edge(CLK_IN)`** — true exactly on the clock's 0→1 transition. The hardware equivalent of "on the next tick."

---

## Logical sections (annotated with `-- ★` in source)

### 1 · License & origin _(line 1)_
Original SEILEBOST 2006 simulation model of Oric Atmos hardware, later heavily extended for MiSTer (snapshot save/restore, ROM patch intercept, `$C000` mailbox, Pravetz-8D mode, tape byte-streamer snoops).  
The header is a BSD-style license from the original 2006 author. Everything from Section 6 onward that deals with snapshots, save-states, ROM patching, or Pravetz mode is MiSTer-era addition on top of that base model.

---

### 2 · Library imports _(line 45)_
Standard IEEE packages: `std_logic` types and numeric/unsigned arithmetic.  
`std_logic_1164` gives the `STD_LOGIC` / `STD_LOGIC_VECTOR` types (a wire that can be `0`, `1`, `Z` high-impedance, or a few other states — richer than a plain boolean). `numeric_std` adds `UNSIGNED`/`SIGNED` arithmetic on those vectors, roughly VHDL's answer to `#include <stdint.h>` plus operator overloading for math on bit-vectors.

---

### 3 · Entity: module interface (all ports) _(line 50)_
Declares every signal crossing the boundary between `Oric.sv` and this machine wrapper: keyboard, tape, audio, video, RAM bus, floppy/SD, CPU halt, snapshot restore inputs, snapshot save outputs, ROM patch intercept, `$C000` mailbox, and tape-byte-streamer snoops.  
This is a big port list because `oricatmos` is the single point of contact between the "real Oric" logic and all the MiSTer-specific plumbing in `Oric.sv`. Roughly a third of the ports (everything from `cpu_regs_set` down to `tap_byte_consume`) exist purely for MiSTer features — snapshot restore/save and fast tape loading — with no equivalent on real 1983 hardware.

---

### 4 · Architecture: internal signal declarations _(line 184)_
All wires and registers connecting sub-modules to each other inside this wrapper: CPU bus, VIA ports, PSG control, ULA chip-selects, ROM data buses, disk-controller signals for both Microdisc and Pravetz-8D, and snapshot save/halt state.  
Notice some comments are in French (`-- Gestion des resets`, `-- Clavier : émulation par port PS2`) — a leftover from the original French-language SEILEBOST codebase. This block is essentially the "cabling manifest" for the whole file: every signal declared here gets driven and consumed by the component instantiations later on.

---

### 5 · Component declarations (keyboard, joystick, PSG) _(line 322)_
VHDL-93 style forward declarations so Verilog sub-modules (`keyboard.sv`, `joystick.sv`, `psg.v`) can be instantiated by component name below.  
Mixed-language projects like this one need `COMPONENT` declarations to bridge Verilog modules into VHDL — VHDL can't just "import" a `.sv` file the way `ENTITY work.X` works for other VHDL files (see Section 7's `ENTITY work.T65` for the contrast). It's a manual prototype VHDL requires when the real definition lives in a different language.

---

### 6 · Reset, Pravetz mode decode & controller/expansion-port mux _(line 389)_
Builds `RESETn`, detects Pravetz-8D mode from `rom = "10"`, decodes the two Pravetz address windows (`$0310–$031F` FDC softswitches; `$0320–$03FF` bank ROM), then routes all ULA expansion-port control signals (`MAPn`, `ROMDISn`, `IOCONTROLn`, `ECE`, IRQ, SD bus) to either the Microdisc or Pravetz FDC depending on which mode is active.  
This is the fork in the road between "normal Oric with Microdisc floppy" and "Pravetz-8D with Apple II-style disk controller" — everything downstream (Sections 14–15) that talks to a floppy goes through this mux first.

---

### 7 · CPU: T65 soft-core 6502 instantiation + snapshot-save halt _(line 436)_
Wires the T65 6502 core: address/data/RW bus, IRQ from VIA and disk controller, NMI from keyboard. The `save_halt` process stalls the CPU at the next opcode-fetch boundary (`Sync = '1'`) so the snapshot engine can capture a consistent register/PC state without a mid-instruction freeze.  
`T65` is a well-known open-source 6502-compatible core (see `rtl/T65/`) — this project doesn't reimplement the CPU, it reuses this existing one. The `p_save_halt` process is MiSTer-specific: real 6502 hardware has no concept of "pause between instructions for a snapshot," so this logic watches for `Sync='1'` (the CPU's own signal for "I'm about to fetch a new opcode") and only then engages the stall, guaranteeing the captured `PC` is a legitimate resume point.

---

### 8 · RAM bus arbitration & SRAM control _(line 478)_
When `PHI2 = 0` (the ULA's video-fetch half of the clock) the address bus goes to the ULA's video address; when `PHI2 = 1` (the CPU half) it goes to the CPU. Also drives chip-select, output-enable, and write-enable to the external 64 KB SRAM, and exports `phi2` so `Oric.sv` can sync the rest of the system.  
This is classic Oric-1/Atmos memory contention: the CPU and video hardware take turns reading RAM within a single clock cycle, alternating on `PHI2`. It's why an Oric CPU effectively runs at 1 MHz even though the master clock is 4 MHz — half the cycles go to video.

---

### 9 · ROM instantiations (Atmos, Oric-1, Pravetz-8D, Microdisc) _(line 495)_
All ROMs are VHDL lookup tables — giant `CASE` statements compiled into block RAM. They all see the CPU address continuously; the CPU data-in mux (Section 19) selects which one's output actually reaches the CPU.  
Every possible ROM image (Atmos BASIC, Oric-1 BASIC, Pravetz-8D, Microdisc DOS) is instantiated simultaneously and always "running" in parallel — none of them are powered down or disabled. Only one gets picked at the very end, in Section 19's priority mux, which is a simpler and more hardware-idiomatic approach than trying to selectively enable/disable individual ROMs.

---

### 10 · ULA instantiation (chip selects, RAM control, video output) _(line 539)_
The ULA is the heart of the Oric: it generates the 1 MHz CPU clock enable, arbitrates RAM between CPU and video, produces chip-select signals for ROM/RAM/IO, and renders the video (text + HIRES modes) as R/G/B + sync signals.  
"ULA" (Uncommitted Logic Array) was the actual custom chip in the real Oric that did all of this in one package; `ula.vhd` is a from-scratch reimplementation of its behavior. This is the single most important sub-module in the file — nearly every other section either feeds it an input or consumes one of its outputs.

---

### 11 · VIA (M6522) instantiation (I/O, tape, IRQ, snapshot) _(line 577)_
The 6522 VIA is the Oric's main I/O chip: Port A carries PSG data and the keyboard row mask; Port B drives keyboard column select, tape motor (`CB1` = tape-in, `CB2`/`PB7` = tape-out), and the PSG `BDIR`/`BC1` control lines. Generates the CPU IRQ. Snapshot ports allow full register restore.  
The 6522 VIA is a real, well-documented off-the-shelf chip from the era (also used in the C64, BBC Micro, Apple II, etc.) — `m6522.vhd` reimplements its full register set, including timers. Its ports are multiplexed for several jobs at once (sound chip control lines share Port A with keyboard row data), which is why Section 16 needs careful muxing logic to sort out who's driving what.

---

### 12 · PSG (AY-3-8912) instantiation (sound) _(line 635)_
The AY-3-8912 produces three tone channels (A/B/C) plus noise and envelope. Controlled by the VIA: `BDIR`/`BC1` select bus mode (latch address / write / read), Port A carries the data byte. The mixed mono output and individual channel outputs feed the audio mixer in `Oric.sv`. Snapshot ports allow full register save and restore.  
The AY-3-8912 doesn't have its own address/data bus in the usual sense — the VIA's Port A doubles as its data bus, and two VIA control lines (`BDIR`, `BC1`) act like a 2-bit "mode selector" telling the PSG whether the current byte on Port A is a register address, a value to write, or a request to read back. This is period-accurate: the real hardware worked exactly this way.

---

### 13 · Keyboard & joystick instantiations _(line 673)_
`keyboard.sv` scans the Oric keyboard matrix: column select comes from VIA `PB[2:0]`, row mask from PSG `IOA`; outputs `kbd_int` (key pressed), `swnmi` (F1 NMI key), `swrst` (reset key). `joystick.sv` maps MiSTer USB gamepad buttons to VIA PA bits.  
The Oric keyboard is a scanned matrix, not individually wired keys — the VIA selects a column, the PSG's spare I/O port reads back which rows are active in that column, and software repeats this for every column to build a full keypress map. `swnmi`/`swrst` are soft equivalents of physical NMI/Reset buttons, triggered by specific key combinations.

---

### 14 · Pravetz-8D FDC controller _(line 708)_
The Pravetz-8D is a Bulgarian Apple II clone that used an Oric body. Its disk controller is an Apple Disk II-style FDC (soft switches at `$0310–$031F`). Active only when `rom = "10"`; shares the SD card bus with drives 0 and 1 (drives 2/3 forced to zero in Section 6's mux).  
This is a completely different disk-controller architecture from the Oric's native Microdisc (Section 15) — it exists in the same file because the Pravetz-8D used Oric-compatible hardware but ran Apple II-derived disk software, so the core needs to emulate an Apple-style FDC when that ROM/mode is selected.

---

### 15 · Microdisc controller _(line 739)_
The Microdisc is the standard Oric floppy interface (WD1793 FDC). It plugs into the Oric expansion port and asserts `ROMDISn`/`MAPn` to bank in its own 8 KB ROM (`$C000–$DFFF`). Controls up to 4 disk images via the MiSTer SD-card bridge. Active when `rom != "10"` (Pravetz mode off).  
This is the "normal" Oric floppy path most users will hit. Like a real Microdisc cartridge, it works by temporarily hiding part of the address space (`$C000–$DFFF`) and substituting its own ROM/RAM there — `ROMDISn`/`MAPn` are exactly the same expansion-port signals a physical Microdisc board would assert.

---

### 16 · VIA port wiring (PA/PB mux, keyboard, PSG, tape, printer) _(line 798)_
Port A mux: when the VIA is in read mode (`CB2 = 0`, `BDIR = 0`) returns joystick OR VIA output; when the PSG is driving the bus, returns PSG readback. Port B feeds the keyboard row back on bit 3 (`kbd_int`). Also drives tape-out (`PB7`), cassette motor relay (`PB6`), and printer strobe/data lines.  
This is the resolution logic for all the "who's actually driving this wire" questions raised in Sections 11–13 — Port A alone is shared by the joystick, the VIA's own output, and the PSG's readback path, and this block picks the right one based on the current bus state (`CB2`, `BDIR`).

---

### 17 · CPU address snoops ($C000 mailbox, CLOAD name, tape byte streamer) _(line 818)_
Combinational logic that watches the CPU address/data bus every `PHI2` cycle and pulses signals out to `Oric.sv` when specific addresses are touched: `$C000` write → LED mailbox; `$027F` write → CLOAD filename detect; ROM `$E735` read → `tap_sync_request`; ROM `$E6CE` read → `tap_byte_consume`.  
None of this exists on real hardware — it's MiSTer-only plumbing that lets `Oric.sv` "spy" on specific memory addresses without modifying how the CPU or ROM actually behaves. `$C000` sits inside the normal ROM read-window (reads still return the real ROM byte), but a *write* to that same address is otherwise meaningless to the hardware, so it's repurposed as a side-channel: software can `POKE` a value there purely to signal the host (e.g. light the disk LED) with zero risk of breaking compatibility.

---

### 18 · Pravetz bank/shadow register _(line 854)_
Clocked register updated when the CPU writes to `$0380–$0383` in Pravetz mode. Address bit 1 selects the FDC ROM bank (two 256-byte halves of `$0320–$03FF`); bit 0 enables "shadow" mode — maps Pravetz ROM over the top of `$C000–$FFFF`, hiding the BASIC ROM so the Pravetz OS can run from its own ROM image.  
This is a real, period-accurate bank-switching register, not a MiSTer addition — the actual Pravetz-8D hardware needed exactly this mechanism to let its own OS take over the address space that would otherwise hold Oric BASIC.

---

### 19 · CPU data-in mux (priority ROM/RAM read decoder) _(line 876)_
Every clock cycle, exactly one source wins the CPU's `DI` (data-in) bus. Priority order (highest first): ROM patch intercept → Pravetz FDC soft-switches → Pravetz bank ROM → expansion port (Microdisc) → VIA → ROM Atmos/Oric1/Pravetz/Loadable → Microdisc ROM → RAM. Gated on `PHI2 = 1` (the CPU half of the clock) so video-fetch cycles never corrupt the CPU read.  
This is the payoff for Section 9's "instantiate every ROM at once" approach — all those parallel ROM/RAM/IO sources are competing for the CPU's single data-in wire, and this `PROCESS` is the tie-breaker, checked top-to-bottom every cycle. The ROM patch intercept sits at the very top of the priority list specifically because it needs to override *any* other ROM choice during fast tape loading, regardless of which ROM (Atmos/Oric-1/Pravetz) is actually selected. Note the inline comment on lines 889-892 explaining why the patch is additionally gated on `ula_CSROMn='0'` — without that gate, a cold-boot RAM-detection routine reading a low-RAM address that happens to share the patch range's low 14 bits would get the patch byte instead of real RAM, and misreport a tiny amount of free memory.

---

## Modules instantiated inside `oricatmos`

| Module | Hardware it emulates |
|---|---|
| `T65` | MOS 6502 CPU (from `rtl/T65/`) |
| `BASIC11A` / `BASIC10` / `PRAVETZ8D` / `PRAVETZ8D_FDC` / `ORICDOS06` | ROM lookup tables (Atmos, Oric-1, Pravetz-8D, Pravetz FDC bank, Microdisc DOS) |
| `ULA` | Uncommitted Logic Array — video + memory contention |
| `M6522` | 6522 VIA (I/O, keyboard, tape, timers) |
| `psg` | AY-3-8912 sound chip |
| `keyboard` | Oric keyboard matrix scanner |
| `joystick` | MiSTer USB gamepad → VIA PA mapping |
| `PRAVETZ8D_FDC_CTRL` | Apple Disk II-style FDC (Pravetz-8D mode) |
| `Microdisc` | WD1793-based Oric floppy interface |

## How this fits with `Oric.sv`

`Oric.sv` (see [`01a`](01a-Oric-sv-understanding.md), Section 11) instantiates this whole file as a single black box named `oricatmos`. Everything MiSTer-specific that `oricatmos.vhd` exposes — snapshot save/restore ports, the ROM patch intercept, the `$C000` mailbox, the tape byte-streamer snoops — exists solely so `Oric.sv`'s tape-loading, snapshot, and save-state logic (`Oric.sv` Sections 14, 17, 18) can reach *into* the machine without altering how the emulated hardware itself behaves.
