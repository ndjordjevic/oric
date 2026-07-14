# Learning record — SV Lesson 0008: Chained ternary as a priority encoder

**Date:** 2026-07-14
**Status:** Done.

## Self-check (per MISSION.md's success criteria — can you explain this without the lesson open?)

- [x] Reading a stacked `cond ? a : b` chain top-to-bottom as an if/else-if ladder, first match wins
- [x] Why it has to be written as nested ternaries (not if/else) when the target is a continuously-live `wire`
- [x] The same pattern muxing address buses, not just constants, with an unconditional fallback at the end
- [x] `[WIDTH-1:0]` using a named `localparam` expression as the bus width instead of a hardcoded number
- [x] Quiz Q1–Q2 — answer from memory, then check



## Notes / what actually clicked



## Next

- [x] Lesson 0009 — local vars, replication & clock-domain crossing