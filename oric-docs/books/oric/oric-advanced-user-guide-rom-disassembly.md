# Oric Advanced User Guide — The ROM Disassembly

**Author:** Leycester Whewell (companion to the Adder Publishing "Oric Advanced User Guide")
**Year:** 1984
**Category:** Oric ROM disassembly
**Source:** `/Users/nenaddjordjevic/pCloud Drive/iCloud-Migration/Programming/Retro/Oric/oric_advanced_user_guide_rom_disassembly.pdf`

## Table of Contents

_No formal table of contents._

This document is the standalone "ROM Disassembly" companion (Chapter 8 of the Oric Advanced User Guide). It is a complete commented assembly listing of the Oric Atmos ROM (V1.1), with annotations noting differences from the Oric 1 (V1.0) ROM.

Structure:
- Introductory text ("The ROM Disassembly") describing how the ROM implements BASIC and the operating system, the Floating Point Accumulators (FPA), and 6502 assembly syntax conventions ($ = hexadecimal, # = immediate).
- The ROM is divided into two main sections:
  - **BASIC language** — $C000 to $ECC3
  - **Operating system** — $ECC4 to $FFFF
- The listing covers the full ROM from **$C000–$FFFF**, in address order. Each line shows: address, hex opcode bytes, disassembled mnemonic/operand, and a commentary column.
- Embedded reference tables within the listing include: the BASIC keyword JUMP TABLE / token order (around $C006), the BASIC KEYWORDS table (high bit set on last character of each keyword, from ~$C0E6), and the ERROR MESSAGES table (from ~$C2A6).
- Labelled routine sections include: START/RESTART BASIC, FOR-NEXT variable search, open-space/memory routines, CHECK FOR FREE MEMORY, PRINT ERROR MESSAGES, INSERT/DELETE LINE, DELETE LINE, INSERT LINE, SET LINE LINK POINTERS, INPUT LINE FROM KEYBOARD, READ KEY FROM KEYBOARD, TOKENISE LINE, and onward through the rest of the BASIC interpreter and operating system.

Notes:
- The listing is that of the Oric Atmos ROM (V1.1) — an updated version of the Oric 1 (V1.0) ROM, with bug fixes plus the two new keywords STORE and RECALL (which replace the tokens of INVERSE and NORMAL on the Oric 1).
