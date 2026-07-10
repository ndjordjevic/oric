# Mission: VHDL (learned through the MiSTer Oric core)

## Why
The user is studying the MiSTer FPGA Oric core (`projects/mister-fpga-oric-core-understanding/`) to understand how the Oric Atmos — their first personal computer — actually works at the hardware level, as groundwork for the Metaphoric clone build. `Oric.sv` (SystemVerilog, covered in the sibling [`../learn-systemverilog/`](../learn-systemverilog/) workspace) is only the glue layer; the actual computer — CPU wiring, ULA, VIA, PSG, ROM banking, disk controllers — is `rtl/oricatmos.vhd`, written in VHDL. The user has already read a prose-level architectural walkthrough of that file ([`01b-oricatmos-vhd-understanding.md`](../01b-oricatmos-vhd-understanding.md)) but cannot yet read the VHDL itself.

## Success looks like
- Read a real block from `oricatmos.vhd` cold and explain what it does, without a prior English walkthrough.
- Correctly distinguish VHDL's two big regions — concurrent signal assignment (`<=`, `WHEN/ELSE`) vs. sequential `PROCESS` blocks (`IF/ELSIF`, `rising_edge`) — and explain why that split exists in hardware, not just as syntax trivia.
- Recognize and explain: `ENTITY`/`PORT`, `ARCHITECTURE`, `SIGNAL`, `COMPONENT` forward declarations, `PORT MAP` instantiation (both `ENTITY work.X` and plain component form), bit ranges (`DOWNTO`), aggregates (`OTHERS => '0'`), type casts (`TO_UNSIGNED`, `unsigned(...)`), and the `WHEN ... ELSE` priority-chain idiom.
- Confidently compare a VHDL construct to its SystemVerilog counterpart already learned (e.g. `WHEN/ELSE` vs. chained ternary, `PROCESS` vs. `always`) rather than learning it as if from scratch.

## Constraints
- No prior VHDL/Verilog/SystemVerilog experience (per `AGENTS.md`'s audience note) — solid digital electronics and general programming background assumed. Since SystemVerilog was learned first (see `../learn-systemverilog/`), lessons should lean on that vocabulary as a bridge rather than re-teaching hardware concepts from zero.
- Learning happens in short sessions alongside the main core-understanding project — lessons must be small enough to finish in one sitting.
- Every new construct should be grounded in an analogy — to a familiar programming language AND, where useful, to the equivalent SystemVerilog construct already learned — per the repo's HDL-walkthrough convention in `AGENTS.md`.
- Prefer real snippets lifted directly from `oricatmos.vhd` over invented examples.

## Out of scope
- VHDL testbench-only constructs (`ASSERT`, simulation-only procedures) — this file is synthesizable RTL only.
- Full digital-design/FPGA-toolchain theory (already covered in `../../00-dev-env.md` and the `../../../mister-fpga` sibling repo).
- The Verilog sub-modules instantiated as VHDL `COMPONENT`s (`keyboard.sv`, `joystick.sv`, `psg.v`) — their *internals* are SystemVerilog, already in scope of `../learn-systemverilog/`; here they only matter as VHDL component declarations/instantiations.
