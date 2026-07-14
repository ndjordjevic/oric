# Learning record — SV Lesson 0002: Wires, bit-slices, ternary & module instantiation

**Date:** 2026-07-13
**Status:** Done.

## Self-check (per MISSION.md's success criteria — can you explain this without the lesson open?)

- [x] `wire [1:0] ar = status[122:121];` — declaring + wiring in one line, and `[msb:lsb]` slicing
- [x] The ternary operator `cond ? a : b` and sized literals (`12'd4`)
- [x] Module instantiation shape: `.*` auto-wiring vs. explicit named ports, and why explicit overrides auto
- [x] `.PORT()` — empty parens meaning deliberately unconnected
- [x] Quiz Q1–Q3 — answer from memory, then check



## Notes / what actually clicked

- Chased two names used in the lesson's own excerpt back to where they actually come from, since neither is declared locally in this section: `video_freak` is defined in `core/sys/video_freak.sv` (MiSTer framework, `sys/`, out of scope — lesson now names this). `VGA_DE` (fed into `.VGA_DE_IN`) is `Oric.sv`'s own top-level output port (from the Lesson 1 `sys/emu_ports.vh` include) — not yet driven at this point in the file; its real value comes from `video_mixer`'s `.*` auto-wiring much later (line 539). Same "used before its driving point is visible" idea as SV Lesson 1's gotcha, one level weirder since it's a port, not a wire — lesson now traces the full chain.



## Next

- [ ] Lesson 0003 — `localparam`, string concatenation & boolean operators