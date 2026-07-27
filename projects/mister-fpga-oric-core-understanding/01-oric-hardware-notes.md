# 02 — The real Oric hardware, in my own words

**Started:** 2026-07-27 (sprint Day 1) · **Status: skeleton — accretes all week.**

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

Verified against the core on Day 1; cross-check against [[oric.free.fr]] when reading it.

| Range | Size | What | Confirmed by |
|---|---|---|---|
| `$0000`–`$00FF` | 256 B | Zero page — the 6502's fast-addressing scratch | 6502 architecture |
| `$0100`–`$01FF` | 256 B | Hardware stack (fixed by the 6502) | 6502 architecture |
| `$0200`–`$02FF` | 256 B | System variables | — |
| `$0300`–`$03FF` | 256 B | **I/O page** — the VIA lives here | [[oric.free.fr]]: "IO at page 3" |
| `$0400`–`$97FF` | ~37 KB | Free RAM — BASIC program + variables | — |
| `$9800`–`$BB7F` | ~9 KB | HIRES screen RAM *(when in HIRES)* | — |
| `$A000` | — | HIRES bitmap base | `understanding-Oric-sv` §13 |
| `$BB80`–`$BFDF` | 1 KB | TEXT screen RAM (40×28) | `understanding-Oric-sv`, `plan.md` Day 0 |
| `$C000`–`$FFFF` | 16 KB | **ROM** — BASIC + OS + I/O routines | ROM tables are 16384 B (`addr` = 14 bits) |

**Why the top of RAM matters for later projects:** in TEXT mode the HIRES region isn't being
scanned by the ULA, so a machine-code program that takes over the machine can reclaim it — see
`ideas.md`'s appendix (relevant to Ideas #5/#6).

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

- [ ] Why does reset fill RAM with `0x01` rather than `0x00`?
- [ ] Exact TEXT/HIRES screen-RAM boundaries — the table above is assembled from the core; confirm
      against [[oric.free.fr]]'s memory map and note any disagreement.
- [ ] Oric-1 vs Atmos: differences beyond the ROM image?
