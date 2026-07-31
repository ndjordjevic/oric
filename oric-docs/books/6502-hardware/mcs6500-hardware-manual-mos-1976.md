# MCS6500 Microcomputer Family Hardware Manual

**Author:** MOS Technology, Inc.
**Year:** 1976 (2nd ed.)
**Category:** 6502 CPU reference — primary source (chip manufacturer's own manual)
**Source:** `/Users/nenaddjordjevic/pCloud Drive/iCloud-Migration/Programming/Retro/C64/MCS6500 Hardware Manual Hardback/MCS6500 Hardware Manual Interior.pdf`

Not Oric-specific. The manufacturer's own hardware manual for the MCS6500 family (6501–6505,
which the 6502 belongs to) — the primary source behind every secondary 6502 textbook, including
[`6502-users-manual.md`](../oric/6502-users-manual.md) already catalogued for this project.

## Table of Contents

**Chapter 1 — The MCS6500 Microcomputer System** — p.1
- 1.0 Designing with Microcomputer Systems
- 1.1 Introduction to Microcomputer Systems — organization, basic operation, addressing terms
  (bit, address space, the address page), system components (clock generator, program memory,
  data memory, I/O devices, the microprocessor)
- 1.2 Introduction to the MCS650X Microprocessor Family — 6501, 6502, 6503/6504/6505
- 1.3 MCS6500 System Concepts — bus structure; processor interrupts (applications, prioritizing,
  system interconnect, servicing, IRQ, NMI); system reset
- 1.4 The Microprocessors — 6501 pinouts (address/data bus, R/W, DBE, VMA, BA, RDY, NMI, IRQ,
  RES); 6502 product characteristics, device timing, SYNC, S.O. (Set Overflow)
- 1.5 Peripheral Interface Device — MCS6520 (the PIA): organization, control/data-direction/output
  registers, interface to the 650X bus (data bus, Enable, R/W, chip selects, register selects),
  interface to peripheral devices (PA/PB ports, CA1/CA2/CB1/CB2 interrupt-control lines)
- 1.6 Peripheral Interface/Memory Device — MCS6530 (combined ROM+RAM+I/O+timer): pinout,
  internal ROM/RAM organization

**Chapter 2 — Configuring the Microcomputer System** — p.84
- 2.1 The System Configuration Task
- 2.2 Input/Output Techniques — general-purpose I/O port vs. dedicated peripheral interface
  device, power-on considerations, handshaking on data transfers in/out of the processor
- 2.3 Configuring the Interface Between the Microprocessor and the Support Chips — **address
  assignment in an MCS6500 system (ROM/RAM address assignment)**, interrupts and interrupt
  prioritizing/vectoring, using RDY for slow PROMs / DMA / dynamic-RAM control
- 2.4 Additional System Considerations — peripheral interface devices, RAM, ROM
- 2.5 Evaluating System Performance

**Chapter 3 — Bringing Up the MCS6500** — p.123
- 3.1 Static Testing — single-cycle and single-instruction execution
- 3.2 Dynamic Testing — externally-induced and software loops
- 3.3 System Diagnosis Using Hardware Programmer Aids — KIM, TIM, MDT
- 3.4 Microprocessor Start-Up Procedure — power, basic timing, system reset, address/data bus
  verification, detailed component check

**Appendix A** — reference tables (not extracted in this pass)

---

**Why relevant to the Oric:** §1.3–1.4 (interrupts, NMI/IRQ, RES) is the primary source behind
the Oric's page-2 patchable `JMP` vectors covered in `core/docs/oric_memory_map.md` §7 and
`01-oric-hardware-notes.md`. §2.3.1 (address assignment / ROM-RAM address assignment) is the
generic pattern the Oric's ULA implements as its chip-select logic (I/O at page 3, ROM at
`$C000`) — read this alongside `ula.vhd` on Day 2.

*TOC extracted by OCR/text-layer pass on the first ~25 pages; deeper chapters and the appendix
were not transcribed.*
