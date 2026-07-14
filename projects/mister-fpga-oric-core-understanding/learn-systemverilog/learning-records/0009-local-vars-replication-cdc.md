# Learning record — SV Lesson 0009: Local variables, replication & clock-domain crossing

**Date:** 2026-07-14
**Status:** Done.

## Self-check (per MISSION.md's success criteria — can you explain this without the lesson open?)

- [x] Declaring a `reg` inside an `always` block — private, block-scoped, but still persists across cycles like any other `reg`
- [x] The double-flop synchronizer pattern for crossing a signal between two independent clock domains, and why it's needed
- [x] Reading `ce_pix <= ~old_clk & clk_pix2;` as edge-detection (Lesson 6's idiom) combined with a domain-crossed signal
- [x] The replication operator `{n{x}}` vs. plain concatenation `{a, b}`
- [x] Quiz Q1–Q2 — answer from memory, then check



## Notes / what actually clicked



## Next

- [x] Lesson 0010 (Capstone) — read the rest of Oric.sv cold