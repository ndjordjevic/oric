# Learning record — SV Lesson 0006: Edge-detection idioms

**Date:** 2026-07-14
**Status:** Done.

## Self-check (per MISSION.md's success criteria — can you explain this without the lesson open?)

- [x] The delayed-copy pattern (`img_mountedD <= img_mounted;`) and why comparing a signal to itself can never detect a change
- [x] Reduction-OR `|x` vs. bitwise-OR `a | b` — same symbol, different arity/meaning
- [x] Reading `~|img_mountedD && |img_mounted` as "nothing mounted last cycle, something mounted now"
- [x] The XOR toggle-detector pattern (`old_keystb ^ ps2_key[10]`) and why it produces exactly one pulse cycle per flip
- [x] Quiz Q1–Q2 — answer from memory, then check



## Notes / what actually clicked



## Next

- [x] Lesson 0007 — reading a large port map