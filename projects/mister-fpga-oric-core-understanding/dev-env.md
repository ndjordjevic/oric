# Dev environment

Machine: Pop!_OS 24.04 (Ubuntu 24.04 base). You need these tools only to run code (plan Phase 6).
Reading and annotating needs none of them.

## Tools

Installed 2026-11-16:

```bash
sudo apt install ghdl iverilog verilator gtkwave libsdl2-dev
```

| Tool | Version | What it is for |
|---|---|---|
| ghdl | 4.1.0 | Check and simulate VHDL files (`.vhd`) |
| iverilog | 12.0 | Simulate Verilog files (`.v`) |
| verilator | 5.020 | Check Verilog/SystemVerilog files (`.v`, `.sv`) |
| gtkwave | 3.3.116 | View signal waveforms (`.vcd` files) |
| libsdl2-dev | 2.30.0 | Only to show a simulated screen in a window |
| python3 | 3.12.3 | Run the tape/snapshot tools in `core/tools/` |

## The `core/` clone

```bash
cd projects/mister-fpga-oric-core-understanding
git clone https://github.com/MiSTer-devel/Oric_MiSTer.git core
```

Then copy `docs/`, `games/` and `_Games/` from the fork
[nikiiv/Oric_MiSTer](https://github.com/nikiiv/Oric_MiSTer) into `core/` (they are not in the
official repo). Add a lint stub: `core/build_id.v` with one line, `` `define BUILD_DATE "000000" ``.
`.gitignore` already ignores `core/`.

## Commands

```bash
# Check a VHDL file. This core needs the two -f flags (it uses the old
# Synopsys std_logic_unsigned package; without them: 'operator "=" is overloaded').
ghdl -a -fsynopsys -fexplicit core/rtl/ula.vhd

# Simulate VHDL: analyse → elaborate → run → write waveform
ghdl -a -fsynopsys -fexplicit my_tb.vhd
ghdl -e -fsynopsys -fexplicit my_tb
ghdl -r -fsynopsys -fexplicit my_tb --vcd=wave.vcd
gtkwave wave.vcd

# Simulate Verilog
iverilog -o sim my_tb.v core/rtl/psg.v && ./sim

# Check Verilog
verilator --lint-only -Wno-fatal core/rtl/psg.v

# Look inside a tape or snapshot file
python3 core/tools/tape-inspect.py game.tap --basic
python3 core/tools/sna-inspect.py game.sna
```

## Known noise

- Checking `Oric.sv` on its own gives ~30 errors and warnings. It uses MiSTer framework files in
  `sys/` and the VHDL machine. These are not bugs. Check single `rtl/` files instead.
- A full build of the whole core needs Intel Quartus. This project does not need one.

## Test run (2026-11-16)

All OK: ghdl on `ula.vhd`, `video.vhd`, `m6522.vhd` and the 4 T65 files (0 errors); iverilog on
`spram.v`; verilator on `psg.v` (warnings only); `tape-inspect.py --help`.
