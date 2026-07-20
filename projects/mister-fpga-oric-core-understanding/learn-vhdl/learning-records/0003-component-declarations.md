# Learning record — VHDL Lesson 0003: `COMPONENT` forward declarations

**Date:** 2026-07-16
**Status:** Done.

## Self-check (per MISSION.md's success criteria — can you explain this without the lesson open?)

- [x] `COMPONENT name PORT (...) END COMPONENT;` as a forward declaration, not an implementation
- [x] Why only `keyboard`/`joystick`/`psg` get a `COMPONENT` block, while VHDL sub-modules (T65, ROMs) don't need one
- [x] The C-prototype / TypeScript-`interface` analogy — shape without a body
- [x] Quiz Q1–Q2 — answer from memory, then check

## Notes / what actually clicked

- Needed a second pass on `COMPONENT` vs. `ENTITY` vs. `ARCHITECTURE` — they read as three flavors of "module thing" at first. What resolved it: `ENTITY`+`ARCHITECTURE` together are one module defining *itself* (interface + logic, in its own file — VHDL's split version of SV's single `module...endmodule`); `COMPONENT` is a *different* file's forward-declared copy of someone else's pin list, needed here specifically because `keyboard`/`joystick`/`psg` are SystemVerilog modules being instantiated from VHDL — a language-boundary crossing that direct `ENTITY work.X` instantiation (used for same-language VHDL sub-modules) can't reliably do.



## Next

- [x] Lesson 0004 — concurrent assignment & `WHEN`/`ELSE`