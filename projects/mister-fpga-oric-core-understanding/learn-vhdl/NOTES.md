# Notes

- Same scoping preference as `../learn-systemverilog/NOTES.md`: lessons cover **VHDL language syntax** as it appears in `oricatmos.vhd`, not the architectural/functional walkthrough (already covered by `01b-oricatmos-vhd-understanding.md`).
- Follows the file's own `★ SECTION n` comments (see `01b-oricatmos-vhd-understanding.md`) as the syllabus, same approach as the SystemVerilog workspace.
- User already learned SystemVerilog first — lessons should actively bridge to that vocabulary (e.g. "this is VHDL's version of X from SV Lesson Y") rather than re-teach hardware fundamentals from scratch.
- **Stated goal (2026-07-09):** when looking at the source file, the user wants to understand *every line* from the lessons. Mechanism: `reference/vhdl-decoder.html` — a card listing every token/keyword/literal form that appears anywhere in `oricatmos.vhd`, mapped to meaning + lesson. Invariant to maintain: if any token appears in `oricatmos.vhd` that isn't on the decoder card, that's a gap to close. Keep the card exhaustive as lessons evolve.
