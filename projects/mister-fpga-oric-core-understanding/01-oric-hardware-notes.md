# 01 — The real Oric hardware, in my own words

**Day 1 deliverable · Status: tables filled in; prose to be written in your own words. Accretes all week.**

> **How this document is built.** Day 1 owns the memory map and the CPU. Each later day adds the
> paragraph for the chip it just read, *after* reading that chip's RTL — the ULA on Days 2–3, the
> VIA on Day 4, the PSG and keyboard on Day 5, tape on Day 6. Writing them earlier would just be
> copying a manual; writing them after means they're in your own words, which is the point.
>
> Sources: [`../../oric-docs/books/INDEX.md`](../../oric-docs/books/INDEX.md) (esp. `getting-more-from-your-oric`,
> `oric-advanced-user-guide`, `6502-users-manual`) and the wiki ([[oric.free.fr]] for
> register-level detail, [[oric.signal11.org.uk]] for the ULA).

---

## The machine in one paragraph

The Oric-1 (1983) and Atmos (1984) are the same design: a **6502A at 1 MHz**, 48 KB of RAM, a
**6522 VIA** for all I/O, an **AY-3-8912 PSG** for sound, and — the part that makes an Oric an Oric
— a custom **ULA** that clocks the CPU, decodes memory, *and* generates the video signal. The Atmos
differs from the Oric-1 mainly in ROM version (BASIC 1.1 vs 1.0) and keyboard quality, which is why
this core switches between them by swapping one ROM image.

---

## Memory map

> **Source of truth: `core/docs/oric_memory_map.md` §1**, which is itself consolidated from the AUG
> ROM disassembly, the Defence Force wiki, OSDK, cc65's `atmos.inc`, and [[oric.free.fr]]. The tables
> below follow it. An earlier draft of this file had page 4 folded into free RAM and omitted the two
> character-set regions entirely — corrected on Day 1.

The 6502 sees a **flat 64 KB space with no banking** on the base machine. The ULA generates the chip
selects: page 3 is I/O, `$C000`–`$FFFF` is internal ROM, everything else is the 48 KB DRAM. (A
Microdisc/Jasmin/Telestrat can enable 16 KB of "overlay RAM" hidden *under* the ROM — Day 6 territory.)

### TEXT mode (the power-on default)

| Range | Size | What |
|---|---|---|
| `$0000`–`$00FF` | 256 B | Page 0 — zero page: BASIC + OS variables, and the 6502's fast-addressing scratch |
| `$0100`–`$01FF` | 256 B | Page 1 — the 6502 hardware stack (fixed by the CPU, not a design choice) |
| `$0200`–`$02FF` | 256 B | Page 2 — OS / BASIC system variables (**incl. the IRQ/NMI `JMP`s** — see vectors below) |
| `$0300`–`$03FF` | 256 B | Page 3 — **I/O**: the VIA, plus expansion devices (Microdisc, Jasmin, Pravetz) |
| `$0400`–`$04FF` | 256 B | Page 4 — `$0400`–`$041F` free for user machine code, the rest is DOS workspace |
| `$0500`–`$97FF` | ~37 KB | **Free RAM** — BASIC program + variables, growing upward |
| `$9800`–`$B3FF` | 7 KB | Reserved for HIRES; released to BASIC by `GRAB`, reclaimed by `RELEASE` |
| `$B400`–`$B7FF` | 1 KB | Standard character set (redefinable, ASCII ≥ 32) |
| `$B800`–`$BB7F` | 896 B | Alternate (semi-graphics) character set |
| `$BB80`–`$BFDF` | 1120 B | **TEXT screen** — 28 rows × 40 cols (row 0 is the status line) |
| `$BFE0`–`$BFFF` | 32 B | Spare |
| `$C000`–`$FFFF` | 16 KB | **ROM** — BASIC at `$C000`–`$ECC3`, OS at `$ECC4`–`$FFFF` |

### HIRES mode (after the `HIRES` command)

| Range | Size | What |
|---|---|---|
| `$0000`–`$04FF` | 1280 B | The same five system pages as TEXT mode |
| `$0500`–`$97FF` | ~37 KB | Free RAM |
| `$9800`–`$9BFF` | 1 KB | Standard character set *(moved down from `$B400`)* |
| `$9C00`–`$9FFF` | 896 B | Alternate character set (with a 128-byte gap) |
| `$A000`–`$BF67` | 8000 B | **HIRES bitmap** — 200 lines × 40 bytes, 6 pixels per byte |
| `$BF68`–`$BFDF` | 120 B | Three rows × 40 bytes of TEXT at the bottom of the HIRES screen |
| `$BFE0`–`$BFFF` | 32 B | Spare |
| `$C000`–`$FFFF` | 16 KB | ROM (as above) |

**Two boundary facts worth knowing cold**, because they explain otherwise-arbitrary numbers:
- The HIRES bitmap stops at `$BF67`, not `$BFDF`, because **the ULA always fetches the bottom three
  text rows from `$BF68` regardless of mode**. The bitmap gets what's left: 8000 bytes.
- `6 pixels per byte` is the same 6-pixel cell that one serial-attribute byte occupies — the two
  numbers are the same fact seen from different sides (Day 3).

**Why the top of RAM matters for later projects:** in TEXT mode the `$9800`–`$B3FF` HIRES reservation
isn't being scanned by the ULA, so a machine-code program that takes over the machine can reclaim it
— see `ideas.md`'s appendix (relevant to Ideas #5/#6).

### CPU vectors (`$FFFA`–`$FFFF`)

| Vector | At | Points to | Note |
|---|---|---|---|
| NMI | `$FFFA` | `$0247` | Indirected through a `JMP` in **page 2 RAM** |
| RESET | `$FFFC` | `$F88F` | Straight into ROM — cold start |
| IRQ/BRK | `$FFFE` | `$0244` | Indirected through a `JMP` in **page 2 RAM** |

That RAM indirection is the whole reason ROM behaviour is extensible: tape fast-loaders, debuggers,
Sedoric, and this core's own TAP-segment loader all hook the machine by overwriting the `JMP` at
`$0244` / `$0247`. Worth remembering for Ideas #1 (monitor) and #6 (DOS).

**A core-specific detail that surprised me:** on reset the core doesn't zero RAM — it fills all
64 KB with **`0x01`** (`Oric.sv:349`, `spram_d <= 1`). Open question: whether that mimics real DRAM
power-up state, is needed by the ROM's RAM-sizing routine, or is arbitrary. Worth answering from
`oric-advanced-user-guide-rom-disassembly` when reading the reset vector.

---

## The chips

### CPU — 6502A @ 1 MHz ✅ *(Day 1)*

A stock NMOS 6502; nothing Oric-specific about it. 8-bit data, 16-bit address, so 64 KB of address
space total — which is why ROM and screen RAM have to *share* that space rather than sit outside it.

In this core it's the **T65** soft core (`annotated/rtl/T65/T65.vhd`), a generic reusable 6502 that
also speaks 65C02/65816. The one implementation idea worth carrying forward: **the CPU is not given
a 1 MHz clock.** It runs on the fast system clock and receives a separate `Enable` pulse at 1 MHz
that says "you may advance now." That clock-enable pattern recurs throughout the core, and it's how
an FPGA hosts a period-correct 1980s CPU while keeping fast cycles spare for video and RAM
arbitration.

Memory is a single-port `spram` (`annotated/rtl/spram.v`), so only one party can touch RAM per
cycle — which is *why* `Oric.sv` needs a RAM arbiter at all.

### ULA — "Universal Array Logic", HSC 10017 ⏳ *(Days 2–3)*

Per [[oric.free.fr]], it does three jobs at once: clocks the CPU and peripherals, acts as a crude
MMU (I/O at page 3, ROM at `$C000`), and generates video — **240×224 in 8 colours**, with
foreground/background colour, character set, blink and TEXT/HIRES mode all selected by **serial
attributes**: control bytes placed inline *within screen data*, each occupying a character cell and
holding until the next one.

*Paragraph to be written after reading `ula.vhd` + `video.vhd`.*

### VIA — 6522 ⏳ *(Day 4)*

Ties together keyboard (a **passive matrix the CPU must poll**), tape (**a square wave on port B
bit 7**), the printer port, and the PSG control lines.

*Paragraph to be written after reading `m6522.vhd`.*

### PSG — AY-3-8912 ⏳ *(Day 5)*

3 tone voices + noise + envelope. Reached *through* the VIA rather than being directly addressable.

*Paragraph to be written after reading `psg.v`.*

### Keyboard ⏳ *(Day 5)* · ### Tape ⏳ *(Day 6)* · ### Floppy — Microdisc ⏳ *(Day 6, stretch)*

*To be written on those days.*

---

## Open questions

- [ ] Why does reset fill RAM with `0x01` rather than `0x00`? (`Oric.sv:349`.) Check the reset
      routine at `$F88F` in `oric-advanced-user-guide-rom-disassembly` — does the ROM's RAM-sizing
      code depend on a non-zero fill?
- [x] ~~Exact TEXT/HIRES screen-RAM boundaries~~ — **answered on Day 1** from
      `core/docs/oric_memory_map.md` §1; both layouts are tabulated above, including the two
      character-set regions and the `$BF68` bottom-text-rows quirk that caps the bitmap at 8000 bytes.
- [ ] Oric-1 vs Atmos: differences beyond the ROM image? (The core swaps BASIC10 ↔ BASIC11A — is
      anything else conditional on the machine type?)
- [ ] The 48 KB Atmos vs. the 16 KB Oric-1 "hole" between `$4000` and `$BFFF` — does this core model
      the 16 KB variant at all, or is it always 48 KB?
