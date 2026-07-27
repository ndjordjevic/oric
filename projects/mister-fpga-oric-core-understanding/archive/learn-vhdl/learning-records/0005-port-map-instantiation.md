# Learning record — VHDL Lesson 0005: `PORT MAP` instantiation — two spellings, one meaning

**Date:** 2026-07-16
**Status:** Done.

## Self-check (per MISSION.md's success criteria — can you explain this without the lesson open?)

- [x] `label : ENTITY work.X PORT MAP ( port => signal, ... );` — instance label first, `work` as the local-project library, `=>` as VHDL's `.port(signal)`
- [x] The other spelling, `label : component_name port map (...)`, and why it exists only for `COMPONENT`-forward-declared modules (Lesson 3) — functionally identical, not a different kind of instantiation
- [x] Feeding a boolean expression directly into a port (same idea as SV Lesson 7's inline ternary)
- [x] The multi-bit tri-state literal `"ZZZZZZZZ"` vs. SV's single `'Z`
- [x] Quiz Q1–Q2 — answer from memory, then check



## Notes / what actually clicked



## Next

- [ ] Lesson 0006 — `PROCESS` & `rising_edge`