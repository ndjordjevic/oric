# An Introduction to Microcomputers, Volume 1: Basic Concepts

**Author:** Adam Osborne
**Year:** 1976 (2nd printing 1977), Adam Osborne and Associates
**Category:** Foundational microprocessor concepts (general, pre-dates the 6502 specifically)
**Source:** `/Users/nenaddjordjevic/pCloud Drive/iCloud-Migration/Programming/Retro/Hardware/Osborne-An Introduction To Microcomputers Volume1.pdf`

Not Oric-specific. Scanned copy, TOC reconstructed by OCR (page numbers not legible for most
entries). One of the earliest general microcomputer textbooks — explains microprocessor concepts
from first principles, architecture-agnostic (the 6502-specific companion volume,
*Volume 2: Some Real Microprocessors*, is not in this library).

## Table of Contents (chapter-level)

- **Ch. 1 What Is a Microcomputer** — evolution of computers, origins of the microcomputer
- **Ch. 2 Some Fundamental Concepts** — number systems (decimal, binary, base conversion, binary
  arithmetic), Boolean algebra and computer logic (OR/AND/XOR/NOT, De Morgan's theorem)
- **Ch. 3 The Makings of a Microcomputer** — memory organization (words, bytes, addresses,
  interpreting memory contents: data vs. character codes vs. instruction codes); the CPU
  (registers, ALU, control unit, status flags, instruction execution/timing/cycles);
  microprogramming; microprocessor-based vs. chip-slice-based microcomputers
- **Ch. 4 Logic Beyond the CPU** — ROM/RAM, programmed I/O, interrupt I/O (a microcomputer's
  response to an interrupt, device select codes, priorities), DMA (cycle-stealing vs.
  simultaneous), serial I/O (sync/async, protocols, modem control)
- **Ch. 5 Programming Microcomputers** — the concept of a programming language, source/object
  programs, assembly language syntax and directives, memory addressing modes (implied, direct, …)

*(Later chapters not extracted in this pass.)*

---

**Why relevant to the Oric:** Ch. 3–4 is the generic version of everything Day 1's memory map and
CPU goals cover — registers, instruction cycles, interrupt handling, ROM/RAM organization —
useful as conceptual background before or after `6502-users-manual.md`, without any 6502-specific
detail getting in the way of the general idea.
