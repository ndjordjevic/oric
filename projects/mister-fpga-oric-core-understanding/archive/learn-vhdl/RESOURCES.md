# VHDL Resources

## Knowledge

- [Nandland — Introduction to VHDL for Beginners](https://nandland.com/introduction-to-vhdl-for-beginners-with-code-examples/)
  Concise, modern, example-driven introduction covering entity/architecture/signals with runnable code. Use for: first-pass syntax lookups, entity/port basics.
- [Free Range VHDL (Ciletti/Chu-style free textbook, MSOE course copy)](https://faculty-web.msoe.edu/johnsontimoj/EE3921/files3921/Book_FreeRangeVHDL.pdf)
  Full free textbook PDF; strong on the entity/architecture relationship and process semantics in depth. Use for: going deeper on `PROCESS`, signal vs. variable, when a quick page isn't enough.
- [VHDL-Online — Entity and Architecture](https://www.vhdl-online.de/courses/system_design/vhdl_language_and_syntax/vhdl_structural_elements/entity_and_architecture)
  Clear structural-element reference with a strong signal-assignment (`<=`) explanation. Use for: concurrent vs. sequential assignment distinctions.
- [Ashenden — VHDL Tutorial (University of Michigan EECS copy)](https://www.eecs.umich.edu/courses/doing_dsp/handout/vhdl-tutorial.pdf)
  Professional-quality reference by one of VHDL's standard textbook authors. Use for: settling ambiguities the shorter tutorials gloss over (type casting rules, `PROCESS` sensitivity-list vs. `WAIT UNTIL` semantics).
- [IEEE 1076 VHDL LRM](https://ieeexplore.ieee.org/document/8938196) *(paywalled — last resort only)*
  The actual language standard, for genuinely disputed edge cases.

## Wisdom (Communities)

- [r/FPGA](https://reddit.com/r/FPGA)
  Same community already listed in `../learn-systemverilog/RESOURCES.md` — cross-language, active, well-moderated. Use for: "is this idiomatic VHDL?" questions once past pure syntax.
- Defence Force forum (`forum.defence-force.org`) — see `../../../AGENTS.md`
  The community around this specific Oric core; useful once questions shift from syntax to "why did SEILEBOST/rampa/Sorgelig design it this way."

## Gaps

- No resource found that walks through `oricatmos.vhd` itself end-to-end — lessons here use the real file directly as the primary text, exactly as the sibling `../learn-systemverilog/` workspace does with `Oric.sv`.
