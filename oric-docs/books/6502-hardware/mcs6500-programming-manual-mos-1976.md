# MCS6500 Microcomputer Family Programming Manual

**Author:** MOS Technology, Inc.
**Year:** 1976 (2nd ed.)
**Category:** 6502 CPU reference — primary source (chip manufacturer's own manual)
**Source:** `/Users/nenaddjordjevic/pCloud Drive/iCloud-Migration/Programming/Retro/C64/MCS6500 Programming Manual Hardback/MCS6500 Programming Manual Interior.pdf`

Not Oric-specific. Companion to
[`mcs6500-hardware-manual-mos-1976.md`](mcs6500-hardware-manual-mos-1976.md) — the manufacturer's
own instruction-set/programming manual, the primary source behind every secondary 6502 textbook.

## Table of Contents

- **Ch. 1 Introductory Remarks** — p.1 — manual introduction, microprocessor architecture
- **Ch. 2 The Data Bus, Accumulator and Arithmetic Unit** — p.3 — LDA/STA, ADC/SBC (incl.
  multiple-precision, signed, and decimal/BCD arithmetic), AND/ORA/EOR
- **Ch. 3 Concepts of Flags and Status Register** — p.24 — Carry, Zero, Interrupt Disable,
  Decimal Mode, Break, Overflow, Negative flags; SEC/CLC/SEI/CLI/SED/CLD/CLV
- **Ch. 4 Test, Branch and Jump Instructions** — p.31 — program-counter/fetch mechanics, JMP,
  relative addressing, all branch instructions (BMI/BPL/BCC/BCS/BEQ/BNE/BVS/BVC), CMP, BIT
- **Ch. 5 Non-Indexing Addressing Techniques** — p.50 — pipelining, memory utilization, implied /
  immediate / absolute / zero-page / relative addressing
- **Ch. 6 Index Registers and Index Addressing Concepts** — p.69 — absolute indexed, zero-page
  indexed, indirect, indexed-indirect, indirect-indexed, indirect absolute
- **Ch. 7 Index Register Instructions** — p.96 — LDX/LDY/STX/STY/INX/INY/DEX/DEY/CPX/CPY,
  TAX/TXA/TAY/TYA
- **Ch. 8 Stack Processing** — p.103 — the push-down stack concept, JSR/RTS, stack implementation
  in the 6501–6505, PHA/PLA, TXS/TSX, PHP/PLP
- **Ch. 9 Reset and Interrupt Considerations** — p.124 — **vectors, reset/restart, start function,
  initialization-sequence considerations, interrupt handling, RTI, software polling for interrupt
  causes, fully-vectored interrupts (JMP indirect), non-maskable interrupt, BRK, memory map**
- **Ch. 10 Shift and Memory Modify Instructions** — p.148 — LSR/ASL/ROL/ROR, accumulator-mode
  addressing, read/modify/write instructions, INC/DEC
- **Ch. 11 Peripheral Programming** — p.157 — using the MCS6520 (PIA) for I/O, interrupt control,
  shortcut polling sequences
- *(Chapters 12+ and appendices not transcribed in this pass — likely decimal-mode detail,
  instruction-set summary tables, appendices)*

---

**Why relevant to the Oric:** Ch. 9 is the primary source behind the reset/NMI/IRQ vector
mechanics documented in `core/docs/oric_memory_map.md` §7 and `01-oric-hardware-notes.md` — this
is the manufacturer's own explanation of exactly the "fully-vectored interrupt / JMP indirect"
pattern the Oric ROM uses to make its page-2 vectors patchable.

*TOC extracted by text-layer pass on the first ~25 pages; deeper chapters and appendices were not
transcribed.*
