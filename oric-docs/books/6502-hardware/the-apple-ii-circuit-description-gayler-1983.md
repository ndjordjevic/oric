# The Apple II Circuit Description

**Author:** Winston Gayler
**Year:** 1983 (Howard W. Sams & Co.)
**Category:** Detailed circuit/schematic reference for a 6502-based home computer
**Source:** `/Users/nenaddjordjevic/pCloud Drive/iCloud-Migration/Programming/Retro/Apple II/The Apple II Circuit Description.pdf`
(duplicate copy: `Apple II/W. Gayler - The Apple II Circuit Description.pdf`)

Not Oric-specific. A detailed circuit description and analysis of the Apple II main board and
keyboard — schematic-level, organized as Overview + Detailed Circuit Analysis per chapter.

## Table of Contents

- **Ch. 1 Introduction** — p.9 — audience, chapter organization, IC/signal nomenclature, waveforms
- **Ch. 2 The Apple II Block Diagram** — p.17 — basic architecture and buses, memory, I/O, video,
  power supply
- **Ch. 3 Clock Generator and Horizontal Timing** — p.24
- **Ch. 4 Video Timing** — p.34
- **Ch. 5 The Memory System** — p.41 — the 4116 DRAM
- **Ch. 6 The 6502 and System Bus** — p.58
- **Ch. 7 On-Board I/O** — p.86
- **Ch. 8 The Video Display** — p.104

**Appendices:** A. Video Techniques (p.139) — basic video display, broadcast standards, color,
overscan · B. Apple's Revisions (p.149) · C. Apple I Schematics (p.162) · D. References (p.165)

---

**Why relevant to the Oric:** Ch. 3–4 (clock generator + video timing) and Ch. 8 (video display)
are a worked schematic-level example of exactly what the Oric's ULA does in `ula.vhd`'s
`u_CPT_H`/`u_CPT_V` counters and per-line address recomputation — same problem (a 6502-era
machine generating TV-compatible video from RAM), different implementation technology (discrete
TTL vs. custom gate array). Ch. 5 (memory system) and Ch. 6 (6502 + system bus) parallel Day 1's
memory-map/CPU material; Ch. 7 (on-board I/O) parallels the Oric's page-3 I/O area.
