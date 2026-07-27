# Learning record — VHDL Lesson 0004: Concurrent assignment & `WHEN`/`ELSE`

**Date:** 2026-07-16
**Status:** Done. No further questions.

## Self-check (per MISSION.md's success criteria — can you explain this without the lesson open?)

- [x] `<=` outside a `PROCESS` = continuous assignment (like SV's `assign`); the same symbol inside a `PROCESS` means something different (Lesson 6)
- [x] `value WHEN condition ELSE value` as VHDL's ternary — value-first word order, mirrored from SV's `cond ? a : b`
- [x] Chaining `WHEN/ELSE` as the same top-to-bottom priority-list idiom as SV Lesson 8's chained ternary, with a bare final value as fallback
- [x] `NOT`/`AND`/`OR` as VHDL's spelled-out boolean operators vs. SV's `~`/`&`/`|`
- [x] What the Microdisc controller is (a real period floppy-disk expansion board, WD1793-based) vs. the mutually-exclusive Pravetz option, and the `md_`/`pravetz_`/`cont_` signal-name prefixes



## Notes / what actually clicked

- Asked what "Microdisc" refers to in `md_MAPn` — it's a real 1980s Oric floppy-disk controller add-on (WD1793 chip), one of two mutually-exclusive disk-controller options this core emulates (the other being the Bulgarian Pravetz-8D). `cont_` prefixes mark the merged/selected result after the Pravetz-vs-Microdisc mux.



## Next

- [x] Lesson 0005 — port map instantiation