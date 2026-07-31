# TV Typewriter Cookbook

**Author:** Don Lancaster
**Year:** 3rd edition, 2010 (Synergetics Press); original edition 1976 (Howard W. Sams & Co.)
**Category:** TTL-logic video/character-display generation — precursor to
[`cheap-video-cookbook-lancaster-1978.md`](cheap-video-cookbook-lancaster-1978.md)
**Source:** `/Users/nenaddjordjevic/pCloud Drive/iCloud-Migration/Programming/Retro/Electornics/TV Typewriter Cookbook by Don Lancaster 2010.pdf`

Not Oric-specific. Lancaster's earlier (1976) book on building a "TV Typewriter" (TVT) — a
low-cost dot-matrix character display driven off an ordinary TV set — this copy is the 2010
Synergetics reprint.

## Table of Contents

- **Ch. 1 Some Basics** — p.7 — TV fundamentals, dot-matrix scanning, the ASCII computer code,
  Baudot and Selectric codes
- **Ch. 2 Integrated Circuits for TVT Use** — p.26 — baud-rate generators, character generators,
  keyboard encoders, line drivers/receivers, PROMs, RAMs, serial-interface UARTs
- **Ch. 3 Memory** — p.53 — ROMs, dot-matrix character generators, read-write memory, bus
  organization
- **Ch. 4 System Timing — Calculations and Circuits** — p.85 — timing restrictions/circuits,
  blanking, sync/position/video combination
- **Ch. 5 Cursor and Update Circuits** — p.104 — frame-rate cursors, DMA techniques, a
  microprocessor cursor, updating, repeat actions, screen-read circuits
- **Ch. 6 Keyboards and Encoders** — p.130 — keyboard design factors, encoder circuits, mounting
  and interconnect
- **Ch. 7 Serial Interface** — p.153 — baud-rate standards, UARTs, teletype/cassette interfaces,
  modems
- **Ch. 8 Television Interface** — p.184 — direct-video methods, bandwidth, direct RF entry, color
  techniques, RGB
- **Ch. 9 Hard Copy and Color Graphics** — p.208 — hard-copy devices, color graphics, television
  limitations, a 96×96 full-color display

---

**Why relevant to the Oric:** Ch. 2–4 (character generators, memory organization, and system
timing) are the character-display-mode precursor to what `cheap-video-cookbook-lancaster-1978.md`
covers more generally — directly analogous to the Oric's **TEXT mode**: a character ROM feeding a
dot-matrix generator synchronized to TV timing, the same job `ula.vhd` does for the Oric's 40×28
text screen.
