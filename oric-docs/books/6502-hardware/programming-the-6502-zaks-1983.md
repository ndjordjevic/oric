# Programming the 6502

**Author:** Rodnay Zaks
**Year:** 1983 (Sybex)
**Category:** 6502 CPU reference — widely regarded as the best general 6502 programming text
**Source:** `/Users/nenaddjordjevic/pCloud Drive/iCloud-Migration/Programming/Retro/Apple II/Assembly/Programming the 6502 Rodnay Zaks 1983.pdf`

Not Oric-specific. First of Zaks' three-book 6502 series (followed by
[`6502-applications-zaks-1979.md`](6502-applications-zaks-1979.md) and *Advanced 6502
Programming*, not in this library).

## Table of Contents

- **I. Basic Concepts** — p.7 — what is programming, flowcharting, information representation
- **II. 6502 Hardware Organization** — p.38 — system architecture, internal organization of the
  6502, the instruction execution cycle, **the stack**, **the paging concept**, the 6502 chip
- **III. Basic Programming Techniques** — p.53 — arithmetic programs, BCD arithmetic, logical
  operations, subroutines
- **IV. The 6502 Instruction Set** — p.99 — Part 1 overall description (classes of instructions);
  Part 2 each instruction described individually
- **V. Addressing Techniques** — p.188 — addressing modes, 6502 addressing modes, using them
- **VI. Input/Output Techniques** — p.211 — parallel word transfer, bit-serial transfer,
  communicating with I/O devices, I/O scheduling
- **VII. Input/Output Devices** — p.254 — the standard PIO (6520), its control register, the 6530,
  programming a PIO, **the 6522** (VIA — same chip as the Oric's), the 6532
- **VIII. Application Examples** — p.262 — memory clear, polling I/O devices, character
  input/testing, parity generation, ASCII-to-BCD, table search/sum, checksum, string search
- **IX. Data Structures** — p.275 — pointers, lists, searching/sorting; design examples (binary
  tree, hashing, bubble-sort, merge)
- **X. Program Development** — p.343 — hardware/software alternatives, the assembler, macros,
  conditional assembly
- **XI. Conclusion** — p.368

**Appendices** — p.371: A. Hex conversion table · B. Instruction set (alphabetic) · C. Instruction
set (binary) · D. Instruction set (hex + timing) · E. ASCII table · F. Relative branch table ·
G. Hex opcode listing · H. Decimal-to-BCD conversion · I. Answers to exercises

---

**Why relevant to the Oric:** §II's "paging concept" and "the stack" sections are the general
6502 background behind `oric_memory_map.md` §2/§3 (zero page, page 1). §VII covers the **6522
VIA** directly — the same I/O chip the Oric uses (Day 4 of the sprint), from the programmer's
side rather than the Oric-specific register map already documented locally.
