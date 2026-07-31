# 6502 Applications

**Author:** Rodney (Rodnay) Zaks
**Year:** 1979 (Sybex)
**Category:** 6502 hardware interfacing / applications
**Source:** `/Users/nenaddjordjevic/pCloud Drive/iCloud-Migration/Programming/Retro/Apple II/Assembly/6502 Applications Rodney Zaks 1979.pdf`

Not Oric-specific. Second of Zaks' 6502 series — follows
[`programming-the-6502-zaks-1983.md`](programming-the-6502-zaks-1983.md); scanned copy, TOC
reconstructed by OCR (page numbers approximate/partially illegible).

## Table of Contents

- **I/II. The Input/Output Chips** — p.15 — the 6520 PIA, **the 6522** (VIA), programming the
  6522, the 6530 ROM-RAM I/O timer (RRIOT), the 6532; standard 6502 systems (KIM-1, SYM-1, AIM 65)
- **III/IV. Basic Techniques** — p.57ish
  - Section 1: relays, switches, speaker, a Morse generator, time-of-day clock, home-control
    program, telephone dialer
  - Section 2: combinations of techniques — siren sound, sensing an input pulse, pulse
    measurement, a simple music program, traffic control, multiplication table
- **V. Industrial and Home Applications** — p.145 — traffic-control system, dot-matrix LED,
  displaying switch values, tone generation, music, burglar alarm, DC motor control,
  analog-to-digital conversion (heat sensor)
- **VI. The Peripherals** — p.216ish — keyboard, paper-tape reader/ASCII keyboard, microprinter
- **VII. Conclusions** — p.241
- **Appendix A** — A 6502 assembler in BASIC — p.243
- **Appendix B** — Multiplication-game program listing — p.259
- **Appendix D** — Hexadecimal conversion table — p.273
- **Appendix E** — ASCII conversion table — p.274
- **Appendix F** — 6502 instructions — p.275

---

**Why relevant to the Oric:** the 6522/VIA programming chapter is direct background for Day 4 of
the sprint (`m6522.vhd`) — same chip family the Oric uses for keyboard, tape, printer, and PSG
control, from a hands-on interfacing angle rather than a register-map reference.
