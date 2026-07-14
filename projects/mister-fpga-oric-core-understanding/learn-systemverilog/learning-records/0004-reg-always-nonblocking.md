# Learning record — SV Lesson 0004: `reg`, `always @(posedge)` & non-blocking assignment

**Date:** 2026-07-14
**Status:** Done.

## Self-check (per MISSION.md's success criteria — can you explain this without the lesson open?)

- [x] `reg` vs `wire` — who can hold a value, and why `wire` can't be written inside an `always` block
- [x] `always @(posedge clk_sys) begin ... end` as the clocked-block trigger, and `begin/end` vs `{ }`
- [x] Non-blocking `<=` — all right-hand sides read old values, all updates land together at the next edge
- [x] Why the last non-blocking assignment to the same signal in one block wins, even though "everything happens at once"
- [x] Reduction-AND `&clr_addr` and what `~&clr_addr` means
- [x] Quiz Q1–Q3 — answer from memory, then check



## Notes / what actually clicked

- Asked for a second worked example of non-blocking assignment beyond the lesson's own — a 2-stage shift register (`q1 <= d; q2 <= q1;`) showing a value takes 2 clock cycles to ripple through, versus the 1-cycle collapse that blocking `=` would cause. Confirms the core rule: `<=` reads are always against pre-edge values.



## Next

- [x] Lesson 0005 — parameterized instantiation & arrays