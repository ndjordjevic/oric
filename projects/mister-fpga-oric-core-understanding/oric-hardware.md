# The real Oric — hardware in short

This page is about the **real 1983 machine**, not the FPGA code. For where each part lives in the
code, see [`MAP.md`](MAP.md).

Sources: wiki [[oric.free.fr]] (Hardware Programming How-To), `core/docs/oric_memory_map.md`
(the best local memory map), and `oric-docs/books/INDEX.md` (`oric-advanced-user-guide`,
`getting-more-from-your-oric` ch. 3).

## The machine in one paragraph

The Oric-1 (1983) and Oric Atmos (1984) are the same design. A 6502 CPU runs at 1 MHz. The ULA, a
custom chip, makes the clocks, decides what is at each address, and draws the screen. A 6522 VIA
does the input and output. An AY-3-8912 chip makes the sound. There is 48 KB of RAM (16 KB on the
small Oric-1) and a 16 KB ROM with BASIC. The Atmos differs mainly in its ROM (BASIC 1.1, not 1.0)
and a better keyboard.

## The chips

| Chip | Job |
|---|---|
| **6502 CPU** | Runs the programs. 8-bit data, 16-bit address, so it sees 64 KB in total. ROM, RAM, I/O and screen must all share these 64 KB. |
| **ULA** (HCS 10017) | Clocks the CPU and the other chips. Selects I/O for page 3 (`$0300`–`$03FF`) and ROM for `$C000`–`$FFFF`. Reads screen bytes from RAM and makes the video signal. |
| **VIA** (6522) | The I/O chip: keyboard, sound-chip control, tape, printer. Has timers and makes interrupts. Its 16 registers sit at `$0300`–`$030F`. |
| **AY-3-8912** | Sound: 3 tone channels, noise and an envelope. On the Oric the 3 outputs go to one speaker. |
| **RAM** | 48 KB. The CPU and the ULA take turns on it: the ULA reads the screen, then the CPU gets its turn. |
| **ROM** | 16 KB at `$C000`–`$FFFF`: BASIC at `$C000`–`$ECC3`, the operating system at `$ECC4`–`$FFFF`. |

### The screen (ULA)

- 240 × 224 pixels, 8 colours (each of red, green, blue is on or off).
- **Serial attributes:** colours and modes are set by special bytes inside the screen data. One
  such byte sets ink colour, paper colour, character set/blink/double height, or the mode
  (TEXT/HIRES, 50/60 Hz). It takes up one character cell on screen and lasts until the next one
  on that line.
- TEXT mode: 40 × 28 characters at `$BB80`. HIRES mode: 240 × 200 pixels at `$A000`, 6 pixels per
  byte, plus 3 text lines at the bottom.
- The Oric has no hardware scrolling and no sprites.

### The VIA's wires

| VIA line | Connected to |
|---|---|
| PA0–PA7 | Sound-chip data bus, and printer data |
| CA1 | Printer acknowledge |
| CA2, CB2 | Sound-chip control (`BC1`, `BDIR`) |
| PB0–PB2 | Keyboard: pick one of 8 lines |
| PB3 | Keyboard: answer (1 = key pressed) |
| PB4 | Printer strobe |
| PB6 | Tape motor |
| PB7 | Tape out |
| CB1 | Tape in |

The ROM uses VIA timer 1 for an interrupt every 1/100 s (keyboard scan, `WAIT`, cursor).

### Sound chip

The AY-3-8912 has no address bus of its own. The CPU talks to it through the VIA: Port A carries
the byte, and `BDIR`/`BC1` say what to do (pick a register, write, or read). The sound chip also
has its own I/O port (register 14), which the Oric uses for the keyboard.

### Keyboard

A passive grid. The CPU must test it: it picks a line with VIA PB0–PB2, picks keys with the sound
chip's I/O port, then reads PB3. Oric-1: 57 keys. Atmos: 58 (adds FUNCT).

### Tape

- Writing: a square wave on VIA PB7. Reading: the VIA times the edges on CB1.
- Slow mode = 300 baud: a `0` is 4 periods of 1200 Hz, a `1` is 8 periods of 2400 Hz.
  Fast mode is faster (about 1600–2400 baud).
- One byte = 13 bits: start bit, 8 data bits, parity, three stop bits.

### Floppy (Microdisc, an add-on)

A WD1793 disk controller on the expansion port, at `$0310`–`$0313`. It can switch off the BASIC
ROM, put its own 8 KB ROM at `$E000`–`$FFFF`, and put extra "overlay" RAM under the ROM area.

## Memory map

From `core/docs/oric_memory_map.md` §1.

### TEXT mode (the power-on default)

| Range | Size | What |
|---|---|---|
| `$0000`–`$00FF` | 256 B | Page 0 (zero page): BASIC and OS variables; the 6502's fast-access area |
| `$0100`–`$01FF` | 256 B | Page 1: the 6502 stack (fixed by the CPU) |
| `$0200`–`$02FF` | 256 B | Page 2: system variables, including the IRQ/NMI `JMP`s (see vectors) |
| `$0300`–`$03FF` | 256 B | Page 3: **I/O** — the VIA, plus add-ons (Microdisc, Jasmin, Pravetz) |
| `$0400`–`$04FF` | 256 B | Page 4: `$0400`–`$0420` free for machine code; the rest is DOS work space |
| `$0500`–`$97FF` | ~37 KB | **Free RAM** for BASIC programs and variables |
| `$9800`–`$B3FF` | 7 KB | Kept for HIRES. `GRAB` gives it to BASIC, `RELEASE` takes it back |
| `$B400`–`$B7FF` | 1 KB | Standard character set (can be changed) |
| `$B800`–`$BB7F` | 896 B | Alternate (block-graphics) character set |
| `$BB80`–`$BFDF` | 1120 B | **TEXT screen**: 28 rows × 40 columns (row 0 = status line) |
| `$BFE0`–`$BFFF` | 32 B | Spare |
| `$C000`–`$FFFF` | 16 KB | **ROM** |

### HIRES mode (after the `HIRES` command)

| Range | Size | What |
|---|---|---|
| `$0000`–`$04FF` | 1280 B | The same 5 system pages |
| `$0500`–`$97FF` | ~37 KB | Free RAM |
| `$9800`–`$9BFF` | 1 KB | Standard character set (moved down from `$B400`) |
| `$9C00`–`$9FFF` | 896 B | Alternate character set (plus a 128-byte gap) |
| `$A000`–`$BF67` | 8000 B | **HIRES picture**: 200 lines × 40 bytes, 6 pixels per byte |
| `$BF68`–`$BFDF` | 120 B | 3 text lines at the bottom of the screen |
| `$BFE0`–`$BFFF` | 32 B | Spare |
| `$C000`–`$FFFF` | 16 KB | ROM |

Two facts behind the odd numbers:
- The HIRES picture stops at `$BF67` because, after line 200, the ULA always reads the bottom 3
  text lines from `$BF68`, in both modes.
- "6 pixels per byte" and "one attribute takes a 6-pixel cell" are the same fact.

In TEXT mode the ULA does not read `$9800`–`$B3FF`, so a machine-code program can use it as extra
RAM (see `../ideas.md`, appendix).

### CPU vectors (`$FFFA`–`$FFFF`)

| Vector | At | Goes to | Note |
|---|---|---|---|
| NMI | `$FFFA` | `$0247` | A `JMP` in page 2 RAM |
| RESET | `$FFFC` | `$F88F` | Straight into ROM (cold start) |
| IRQ/BRK | `$FFFE` | `$0244` | A `JMP` in page 2 RAM |

NMI and IRQ go through RAM, so a program can change where they go. Tape loaders, debuggers and
Sedoric hook the machine this way, by changing the `JMP` at `$0244` or `$0247`.

## Open questions

- [ ] Why does the core fill RAM with `0x01` at reset, not `0x00`? (`annotated/Oric.sv` ★ SECTION
      5.) Does the real Oric's RAM test at `$F88F` need it? Check
      `oric-advanced-user-guide-rom-disassembly`.
- [ ] Oric-1 vs Atmos: is there any difference in the core besides the ROM (`BASIC10` vs
      `BASIC11A`)?
- [ ] The core always has 64 KB of RAM. Does it ever copy the 16 KB Oric-1?
