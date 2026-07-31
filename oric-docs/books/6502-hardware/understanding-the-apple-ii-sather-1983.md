# Understanding the Apple II

**Author:** Jim Sather
**Year:** 1983 (Quality Software)
**Category:** Circuit-level hardware bible for a 6502-based home computer — closest single-machine
analog to what this project is doing for the Oric
**Source:** `/Users/nenaddjordjevic/pCloud Drive/iCloud-Migration/Programming/Retro/Apple II/Assembly/Understanding the Apple ii Jim Sather 1983.pdf`

Not Oric-specific. Scanned copy, TOC reconstructed by OCR. A legendary reverse-engineering-style
book: explains *how the Apple II hardware actually works*, chip by chip and signal by signal — the
same kind of understanding this project is building for the Oric via `annotated/rtl/`.

## Table of Contents

- **Ch. 1 The Apple II — An Overview**
- **Ch. 2 Bus Structure of the Apple II**
- **Ch. 3 Timing Generation and the Video Scanner**
- **Ch. 4 The 6502 Microprocessor**
- **Ch. 5 RAM in the Apple II**
- **Ch. 6 ROM in the Apple II**
- **Ch. 7 Address Decoding and Input/Output**
- **Ch. 8 Video Generation**
- **Ch. 9 The Disk Controller**
- **Ch. 10 Maintenance and Care of the Apple II**

**Appendices:** A. 6502 data · B. BASIC program listings · C. A logic-circuits primer · D. A
number-systems primer · E. Apple II revisional information · F. Historical notes · G. A technical
conversation with Steve Wozniak · H. Baseplate/motherboard removal · Glossary · Schematic diagrams
· Index · Foldouts

---

**Why relevant to the Oric:** Ch. 3 (Timing Generation and the Video Scanner) and Ch. 7 (Address
Decoding and I/O) are the closest published analog to what the Oric's **ULA** does in one chip —
the Apple II does the same job (clock division, video-address generation, chip-select decoding)
with discrete TTL logic instead of a custom gate array, which makes it a useful worked example
before or alongside Day 2–3's `ula.vhd`. Ch. 8 (Video Generation) is the same comparison for pixel
output. Ch. 4 covers the 6502 itself, and Ch. 5/6 cover RAM/ROM organization — general background
for Day 1.
