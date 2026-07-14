# 01a — `Oric.sv` understanding

**Date:** 2026-06-22  
**File studied:** `core/Oric.sv`  
**Role:** Top-level MiSTer `emu` module — the wiring harness that connects the MiSTer platform (ARM CPU, SD card, OSD, HDMI) to the Oric Atmos computer core.

**Annotated source:** [`annotated/Oric.sv`](annotated/Oric.sv) — a frozen copy carrying a `// ★` headline comment at the top of each section (`core/` itself is kept pristine so it can track upstream cleanly; see [`annotated/README.md`](annotated/README.md)).

> **How to read this doc:** each `// ★` comment in the annotated source is a one-line headline for its section. Under each heading below, the opening sentences are a plain-English explanation of **what that block of code actually does** — read start to finish, this doc is a guided tour of the whole file. (That plain-English lead intentionally overlaps the terse `★` headline; everything after it — background, cross-section connections, tables — is context the inline comment can't carry.)

---

## What this file is

`Oric.sv` is **not** the Oric computer itself. It is the glue layer that:
- Defines the on-screen menu
- Receives settings, files, and peripherals from the ARM Linux side
- Instantiates the actual Oric (`oricatmos`) and all supporting subsystems
- Produces video, audio, and storage I/O for the MiSTer framework

The real computer lives in `rtl/oricatmos.vhd`. Everything in `Oric.sv` is scaffolding around it.

---

## Logical sections (headlines at the `// ★` comments in [`annotated/Oric.sv`](annotated/Oric.sv))

### 1 · MODULE SETUP _(line 27)_
Unused SDRAM/UART/SD pins are set to high-impedance (`'Z`) so they don't interfere with anything. The USER LED lights up during file downloads, floppy activity, tape ADC, or software-controlled pokes.

### 2 · OSD MENU & ASPECT RATIO _(line 48)_
`CONF_STR` is a mini-language string the MiSTer framework parses to build the OSD menu. Every option maps to a bit range in the 128-bit `status` register. `video_freak` reads the aspect ratio bits and adjusts horizontal/vertical scaling — 4:3 by default for the original Oric look.

### 3 · OSD SETTINGS DECODE _(line 122)_
Rather than scattering `status[59:58]` throughout the code, this block gives every setting a meaningful name (`tape_load_mode`, `tape_mode_fast`, `tap_autorun_en`, etc.). Nothing computes here — it's purely aliasing.

### 4 · CLOCK GENERATION _(line 136)_
The DE10-Nano has a single 50 MHz crystal. The PLL multiplies/divides it into `clk_sys` (core + RAM) and `CLK_VIDEO` (HDMI pixel clock). The `locked` signal goes high once clocks are stable — nothing trusts any logic until then.

### 5 · RESET & RAM CLEAR _(line 150)_
Three sources can trigger reset: the MiSTer framework, the OSD "Reset & Apply" button, or the physical board button. On any reset, `clr_addr` counts from 0 to 131071 (all of RAM), then `reset` is de-asserted. A simple `tape_clk` divider (toggles every cycle) is also initialised here.

### 6 · HPS FRAMEWORK INTERFACE _(line 177)_
This connects the FPGA to the board's small ARM computer, which is what actually reads files off the SD card and listens to the USB keyboard/joystick. **HPS** = Hard Processor System: the ARM CPU cores built into the DE10-Nano's Cyclone V chip, running Linux, separate from the FPGA fabric — they drive the OSD menu, load ROM/disk/tape files, and forward USB input. `hps_io` is the standard MiSTer black-box bridge to it: plug in `CONF_STR` and `VDNUM(4)` (four virtual drives) and it handles everything. The `ioctl_*` signals stream file bytes into the core (TAP, SNA, ROM); the `sd_*` signals manage raw sector reads/writes for floppy drives.

### 7 · DISK IMAGE MANAGEMENT _(line 257)_
Uses classic edge-detection (compare `img_mounted` to a delayed copy) to catch the exact clock cycle an image is inserted. At that moment it checks: is the file marked read-only AND does it have content? If yes, the drive's write-protect flag is set.

### 8 · KEYBOARD & TAPE AUTORUN _(line 273)_
The `tap_autorun_keys` module hijacks the keyboard and injects fake PS/2 keystrokes (e.g. `CLOAD ""` + Enter) when a tape finishes loading. The key-strobe logic detects the toggle on `ps2_key[10]` and converts it to a single-cycle "new key event" pulse — like a doorbell that rings exactly once per keypress.

### 9 · CORE SIGNAL DECLARATIONS _(line 312)_
Declares the three AY-3-8912 audio channels (`psg_a/b/c`), 1-bit RGB video signals, sync and blank signals, tape in/out, and the 18-bit file cache address/data wires. The `FILE_CACHE_NUMWORDS = 196608` (192 KB) constant is also defined here.

### 10 · RAM ARBITER + MAIN RAM _(line 346)_
Priority order (highest first): reset clear → snapshot restore → save-state dump → tape fast-load → normal CPU access. A `spram #(.address_width(16))` block RAM instance provides the actual 64 KB single-port RAM.

### 11 · ORIC ATMOS COMPUTER CORE _(line 385)_
The `oricatmos` module (defined in `rtl/oricatmos.vhd`) contains the 6502 CPU, ULA, VIA, PSG, keyboard matrix, tape interface, and floppy controllers. All the signals prepared above are plugged in here. The `cpu_halt` port freezes the CPU during snapshot/tape-load operations.

**Key sub-modules instantiated inside `oricatmos`:**

| Module | Hardware it emulates |
|---|---|
| `T65/` | MOS 6502 CPU |
| `ula.vhd` / `video.vhd` | ULA (video + memory contention) |
| `m6522.vhd` | 6522 VIA (I/O, keyboard, tape, timers) |
| `psg.v` | AY-3-8912 sound chip |
| `keyboard.sv` | Oric keyboard matrix |
| `microdisc.vhd` / `wd1793.sv` | Microdisc floppy controller |

### 12 · ROM SELECTION & FDD READY _(line 497)_
ROM choice is latched only on reset (no hot-swap). The OSD menu order doesn't match the internal ROM numbering, so a lookup table translates between them. Selecting the Pravetz ROM automatically activates the Bulgarian keyboard layout.

### 13 · VIDEO OUTPUT PIPELINE _(line 512)_
This turns the Oric's crude video into a signal a modern HDMI screen accepts. The Oric outputs pure 1-bit RGB (each of red/green/blue is simply fully on or fully off), so the pipeline: (1) safely hands the pixel clock from the `clk_sys` domain to the `CLK_VIDEO` domain, (2) inverts active-low sync to active-high for VGA/HDMI, (3) expands each 1-bit colour to 4 bits by replication `{4{r}}`, (4) feeds into `video_mixer`, which adds scanlines or HQ2x smoothing per the OSD choice.

### 14 · BIOS & TAPE ROM PATCHES _(line 549)_
An `altbios` SPRAM (2¹⁴ = 16 KB) can receive a custom ROM streamed via `ioctl`. The `cload_patch_rom` module watches the address the CPU is reading from ROM and silently substitutes patched bytes when fast/ultra tape mode is active — the CPU has no idea it's being given different instructions.

### 15 · AUDIO MIXING _(line 581)_
This blends every sound source in the machine into the final stereo signal sent out over HDMI. `tapeAudio` is the 1-bit tape signal scaled up to 11 bits at low or high volume (bit-shifting). The three AY sound-chip channels are summed into three stereo combinations (AB, AC, BC), and how they're assigned to left/right depends on the stereo mode: mono sends all channels equally to both sides; ABC/ACB modes pan channels differently (Western vs Eastern European convention).

### 16 · FILE CACHE & CASSETTE PLAYER _(line 594)_
The `filecache` SPRAM holds whichever file is currently loaded. A priority mux decides whose address reaches it each cycle (file download > save-state DMA > snapshot restore > tape segment loader > byte streamer > cassette player). The `cassette` module reads bytes sequentially and converts them back to 1-bit audio — exactly what a real tape player sends to the Oric's EAR socket.

### 17 · TAPE SPEED LOADERS _(line 667)_
These make loading from tape almost instant instead of the real Oric's several minutes. The trick: instead of playing the tape audio in real time, the FPGA watches for the ROM's load routines and feeds data straight into memory. Three sub-systems do this:

| Sub-system | Mode | How it works |
|---|---|---|
| `tap_segment_loader` | Ultra | Patched CLOAD writes `1` to `$C000`; FPGA intercepts, DMAs the next segment into RAM directly, updates BASIC pointers, releases CPU |
| `tap_byte_streamer` | Fast | Patched ROM GETTAPEBYTE reads current byte as an immediate operand; streamer pre-fetches the next byte each time one is consumed |
| `$C000` mailbox + LED | Both | Watches CPU writes to `$C000`; value `1` triggers the segment loader and optionally lights the USER LED; value `0` clears it |

### 18 · SNAPSHOT & SAVE-STATES _(line 736)_
This saves and restores the entire state of the machine — every chip's registers and all of RAM — so you can freeze the Oric and pick up exactly where you left off. Two paths:
- **Load `.sna`** (`snap_loader`): reads the SNA file from the shared file cache and writes each field to the right chip via dedicated `_we`/`_addr`/`_data` ports. CPU is halted throughout.
- **Save-state hotkeys** (`snap_ss` + `savestate_hotkeys`): F1–F4 halt the CPU, stream a full Oricutron-format snapshot into DDR RAM, then release. F5–F8 copy the slot back into the file cache and re-run `snap_loader`. The `ddram` module abstracts the DE10-Nano's external 800 MB DDR3 RAM where slots are stored.

Save-states are only allowed when content is loaded and nothing else is busy (`allow_ss` guard).

### 19 · PHYSICAL TAPE INPUT _(line 913)_
The `ltc2308_tape` module digitises the analogue audio from the DE10-Nano's LTC2308 ADC — so you can load from an actual 1980s cassette. The last line of the module selects the tape source: `tape_in = tapeUseADC ? tape_adc : casdout`.

---

## Modules instantiated at top level (in `Oric.sv`)

| Module | Purpose |
|---|---|
| `pll` | Clock synthesis |
| `video_freak` | Aspect ratio correction |
| `hps_io` | ARM ↔ FPGA bridge |
| `tap_autorun_keys` | Keyboard injection for autorun |
| `spram` (×3) | Main RAM (64 KB), file cache (192 KB), alt BIOS (16 KB) |
| `oricatmos` | **The Oric computer** |
| `video_mixer` | HDMI video output |
| `cload_patch_rom` | ROM intercept for tape speed |
| `cassette` | Virtual tape deck |
| `tap_segment_loader` | Ultra tape loader |
| `tap_byte_streamer` | Fast tape loader |
| `snap_loader` | SNA snapshot restore |
| `savestate_hotkeys` | F1–F8 key detection |
| `snap_ss` | Save-state engine |
| `ddram` | External DDR3 RAM interface |
| `ltc2308_tape` | Physical ADC tape input |
