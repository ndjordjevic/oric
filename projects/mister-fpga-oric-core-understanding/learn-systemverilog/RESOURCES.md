# SystemVerilog Resources

## Knowledge

- [ASIC World — SystemVerilog Tutorial](https://www.asic-world.com/systemverilog/tutorial.html)
  Long-running, widely-cited free reference covering syntax, data types, and RTL constructs with runnable examples. Use for: looking up any single construct in isolation (ports, `always_ff`, generate blocks, etc.) once a lesson has introduced it.
- [ChipVerify — SystemVerilog Tutorial](https://chipverify.com/tutorials/systemverilog)
  Practitioner-written, concise pages, one construct per page, each with a minimal code sample. Use for: quick syntax refreshers between lessons; especially good for `always_comb`/`always_ff`/`always_latch` usage rules (chipverify.com/systemverilog/systemverilog-always).
- [ChipVerify — Verilog assign statement](https://chipverify.com/verilog/verilog-assign-statement)
  Use for: continuous assignment semantics (why `assign` runs continuously/concurrently, not once) — directly relevant to Lesson 1.
- [systemverilog.dev — RTL Modeling, Simulation, and Verification](https://systemverilog.dev/3.html)
  Modern (actively maintained) free book-style reference, strong on module/port/interface wiring conventions used in real RTL projects (e.g. `.port_name(signal)` mapping) — closer in style to what `Oric.sv` actually does than toy examples. Use for: module instantiation and port-mapping lessons.
- [IEEE 1800-2017 SystemVerilog LRM](https://ieeexplore.ieee.org/document/8299595) *(behind IEEE paywall — use only to settle a genuine ambiguity, not for routine lookups)*
  The actual language standard. Use for: resolving disagreements between tutorials, or precise semantics of an edge case (e.g. exact `'Z`/`'X` propagation rules).

## Wisdom (Communities)

- [r/FPGA](https://reddit.com/r/FPGA)
  Active, well-moderated subreddit for FPGA/RTL questions across vendors and languages. Use for: "is this idiomatic?" questions once past pure syntax, or toolchain-specific quirks (Quartus, in this project's case).
- Defence Force forum (`forum.defence-force.org`) — see `../../../AGENTS.md`
  Not SystemVerilog-specific, but the community that actually produced/ports this Oric core; useful once questions shift from "what does this syntax mean" to "why did the core author choose this approach."

## Gaps

- No resource yet found that walks through a *complete real MiSTer-style top-level `.sv` file* end-to-end the way `01a-Oric-sv-understanding.md` does in prose — lessons here fill that gap directly using `Oric.sv` itself as the primary text, with the tutorials above as syntax backup only.
