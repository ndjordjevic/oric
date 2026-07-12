# Mission: SystemVerilog (learned through the MiSTer Oric core)

## Why
The user is studying the MiSTer FPGA Oric core (`projects/mister-fpga-oric-core-understanding/`) to understand how the Oric Atmos — their first personal computer — actually works at the hardware level, as groundwork for the Metaphoric clone build. They have already read a prose-level architectural walkthrough of `Oric.sv` ([`01a-Oric-sv-understanding.md`](../01a-Oric-sv-understanding.md)) but cannot yet read the SystemVerilog itself — they need the language, not just the architecture, so future source-diving (and eventually writing/modifying HDL) doesn't depend on someone else's prose summary.

## Success looks like
- Read a real block from `Oric.sv` or `oricatmos.vhd`-adjacent `.sv` files cold and explain what it does, without a prior English walkthrough.
- Correctly distinguish combinational constructs (`assign`, `always_comb`) from sequential ones (`always_ff`) and explain why the distinction matters in hardware (not just "different syntax").
- Recognize and explain: module/port declarations, continuous assignment, concatenation `{}`, replication `{n{x}}`, tri-state `'Z`, bit-select/range `[a:b]`, parameter/localparam, generate blocks, and module instantiation with named ports (`.port(signal)`, `.*`).
- Confidently ask the right follow-up question when a construct is unfamiliar, instead of skimming past it.

## Constraints
- No prior VHDL/Verilog/SystemVerilog experience (per `AGENTS.md`'s audience note) — solid digital electronics (gates, flip-flops, clocks, buses, FSMs) and general programming background assumed.
- Learning happens in short sessions alongside the main core-understanding project — lessons must be small enough to finish in one sitting.
- Every new construct should be grounded in an analogy to a familiar programming language (C/Python/JS), per the repo's own HDL-walkthrough convention in `AGENTS.md`.
- Prefer real snippets lifted directly from `Oric.sv` / `oricatmos.vhd` over invented examples — the whole point is to be able to read *this* codebase.

## Out of scope
- Verification/testbench SystemVerilog (classes, interfaces, `assert`, UVM) — this core is synthesizable RTL only; testbench SV is a different, later topic if ever needed.
- VHDL syntax in depth — covered separately via the existing `01b-oricatmos-vhd-understanding.md` walkthrough; this mission is SystemVerilog-first, with VHDL cross-references only where useful for comparison.
- Full digital-design/FPGA-toolchain theory (already covered in `../00-dev-env.md` and the `../../../../mister-fpga` sibling repo).
