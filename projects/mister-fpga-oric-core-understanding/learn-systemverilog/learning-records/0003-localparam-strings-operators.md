# Learning record — SV Lesson 0003: `localparam`, string concatenation & boolean operators

**Date:** 2026-07-13
**Status:** Done.

## Self-check (per MISSION.md's success criteria — can you explain this without the lesson open?)

- [x] `localparam` as a compile-time constant, and how `{ }` concatenation builds `CONF_STR` from string literals
- [x] The four status-decode operators: `~` (bitwise NOT), `==`, `>=`, and a bare unwidthed `wire` as a 1-bit boolean
- [x] Why `~` and `!` differ once you're not dealing with a single bit
- [x] Quiz Q1–Q3 — answer from memory, then check

## Notes / what actually clicked

- The lesson's "Primary source" links were stale — `chipverify.com/tutorials/verilog` and `asic-world.com/systemverilog/tutorial.html` both resolved but only to generic overview pages, not the operators/parameters content they were cited for. Fixed lesson 3's own links, then swept all 20 lessons the same way: found and replaced several more broken/mismatched links (dead PDFs, wrong pages reused for unrelated topics) with verified, on-topic pages.



## Next

- [x] Lesson 0004 — `reg`, `always @(posedge)` & non-blocking assignment