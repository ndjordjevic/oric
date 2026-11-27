# Phase 2 — The real Oric (notes)

## What this phase covered

The real 1983 machine that the core copies: its chips, its screen modes and its memory map. No
code was read. The source for all of this is [`../oric-hardware.md`](../oric-hardware.md).

## Key ideas

- **The chips.** The 6502 CPU runs programs. The ULA does clocks, address decoding and video.
  The VIA does I/O and timers. The AY-3-8912 makes the sound. There is 48 KB of RAM and a 16 KB ROM.
- **The ULA has 3 jobs.** It makes the 1 MHz clock. It decides which chip answers each address
  (page 3 → I/O, `$C000`+ → ROM, the rest → RAM). It reads the screen from RAM and makes the video signal.
- **Everything comes from one 12 MHz crystal.** Divided by 2 gives the 6 MHz pixel clock, and
  divided by 12 gives the 1 MHz CPU clock. One CPU cycle = one screen byte = 6 pixels. The CPU
  and the ULA take turns on RAM, one half-cycle each.
- **An address is a number, not a place.** The CPU's 16 address wires name 64 KB, and the ULA
  decides which chip answers. `$` means hexadecimal.
- **The screen lives in normal RAM.** TEXT mode holds 40 × 28 character codes at `$BB80`. HIRES
  holds 240 × 200 pixels at `$A000`, 6 pixels per byte, plus 3 text lines from `$BF68`.
- **The ROM** is 16 KB at `$C000`–`$FFFF`. BASIC comes first, then the operating system.
- **The VIA connects to the outside.** Port A plus CA2/CB2 drive the sound chip, and Port A also
  carries printer data. PB0–PB3 scan the keyboard. PB6/PB7/CB1 run the tape. Timer 1 makes an IRQ
  every 1/100 s for the keyboard scan and the cursor.
- **The sound chip has no address of its own.** The CPU reaches it only through the VIA. Its I/O
  port also picks the keyboard columns.
- **The CPU vectors** say where the CPU jumps on RESET (`$F88F`, ROM), IRQ (`$0244`) and NMI
  (`$0247`). IRQ and NMI go through a `JMP` in RAM, so software can take them over.

## Your questions

| Question | Answer |
|---|---|
| Why a 12 MHz crystal divided to 1 MHz? | One crystal feeds both the 6 MHz pixel clock and the 1 MHz CPU clock. The fast clock also lets the ULA split each CPU cycle into halves and time the RAM signals. |
| What are addresses like `$BB80`, and are they in RAM or ROM? | They are numbers that name bytes. `$0000`–`$BFFF` is RAM, except page 3, which is I/O. `$C000`–`$FFFF` is ROM. `$BB80` is in RAM. |
| Who wrote `core/docs/oric_memory_map.md`? | Nikolay Ivanchev (`nikiiv`), in his fork, in May 2026. It is not in upstream. Check its numbers: it had the HIRES end wrong (`$BF67` instead of `$BF3F`). |
| Must I learn the memory map in depth? | No. Know the big blocks (system RAM, I/O at page 3, free RAM, screen, ROM). Look up the rest when needed. |
| Must I learn the CPU vectors in depth? | No. RESET = start-up, IRQ = VIA timer, NMI = break button. They come back in Phase 3 (the wires) and Phase 5 (snapshots, fast tape). |

## Where to look

- [`../oric-hardware.md`](../oric-hardware.md) — chips, screen, VIA wires, memory maps, vectors.
- `core/docs/oric_memory_map.md` — the detailed map, page by page. Check its numbers.

## Still open

The open questions in `oric-hardware.md`. Oric-1 vs Atmos and the 16 KB Oric-1 were answered in
Phase 3 (see `phase-3-top-files.md`).
