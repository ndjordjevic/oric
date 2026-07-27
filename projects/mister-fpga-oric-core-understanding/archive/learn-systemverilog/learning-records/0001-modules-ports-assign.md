# Learning record — SV Lesson 0001: Modules, ports & continuous assignment

**Date:** 2026-07-13
**Status:** Done — went through it cold, understood it completely.

## Self-check (per MISSION.md's success criteria — can you explain this without the lesson open?)

- [x] `module ... endmodule` and what's inside the parens (the port list)
- [x] `assign left = right;` as a permanently-live formula, not a one-time write
- [x] `{ }` as concatenation, not a block
- [x] The three literal forms: `'1`, `'Z`, plain `0` — and why `'Z` needs to exist at all
- [x] Quiz Q1–Q3 (lesson's own questions) — answer from memory, then check



## Notes / what actually clicked

- Caught a real terminology wobble in the lesson itself: "port" (line 118, the formal SV term) vs. "pin" (line 129, the physical-hardware picture) were used interchangeably without an explicit bridge the first time "pin" appeared — flagged and fixed in the lesson text.



## Next

- [x] Lesson 0002 — wires, bit-slices, ternary, module instantiation