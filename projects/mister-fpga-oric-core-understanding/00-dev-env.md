# Phase 0a — Dev Environment

Setup date: 2026-06-21

## Installed tools

| Tool | Version | How installed | Binary path |
|---|---|---|---|
| ghdl | 6.0.0 (LLVM backend) | `brew install ghdl` (cask) | `/opt/homebrew/bin/ghdl` |
| iverilog | 13.0 | `brew install icarus-verilog` | `/opt/homebrew/bin/iverilog` |
| verilator | 5.048 | `brew install verilator` | `/opt/homebrew/bin/verilator` |
| gtkwave | 3.3.107 | `brew install gtkwave` (cask) | `/Applications/gtkwave.app` + `/opt/homebrew/bin/gtkwave` |
| python3 | 3.14.5 | pre-installed | `/opt/homebrew/bin/python3` |
| teroshdl (Python pkg) | 3.0.0 | `pip3 install teroshdl --break-system-packages` | — |

## Cursor / TerosHDL

- **TerosHDL extension** v6.0.14 installed in Cursor (`~/.cursor/extensions/teros-technology.teroshdl-6.0.14-universal`)
- Tool paths left **empty** in TerosHDL settings — it picks up all binaries from PATH (`/opt/homebrew/bin`)
- Python path left **empty** — uses system Python3

## ghdl — Gatekeeper note

ghdl is distributed as an unsigned binary (no Apple notarization). Homebrew has deprecated it (removal 2026-09-01). To unblock it after install, a manual Gatekeeper exception was added via **System Settings → Privacy & Security → Allow Anyway**. The quarantine attribute was also cleared:

```bash
xattr -dr com.apple.quarantine /opt/homebrew/Caskroom/ghdl/6.0.0/
```

If ghdl stops working after a macOS update, repeat the Gatekeeper exception, or fall back to:
- **EDA Playground** (https://www.edaplayground.com) — online GHDL/VHDL simulator, no install
- **Docker**: `docker run --rm -v $(pwd):/work ghcr.io/ghdl/ghdl:latest ghdl --version`

## Core clone

The Oric_MiSTer core is cloned as a gitignored sibling:

```bash
cd projects/mister-fpga-oric-core-understanding
git clone https://github.com/MiSTer-devel/Oric_MiSTer.git core/
```

`.gitignore` entry added at repo root:
```
projects/**/core/
```

## TerosHDL project setup

TerosHDL stores its project list and config in two files in `$HOME`:

- `~/.teroshdl2_prj.json` — project list (files, toplevel, watchers)
- `~/.teroshdl2_config.json` — global settings (linters, formatters, etc.)

These were generated automatically. Key decisions:

- **Project type:** `genericProject` (not Quartus — `quartus_sh` is not installed on macOS)
- **Files:** all 43 HDL files from `core/` and `core/rtl/` recursively; `sys/` excluded (MiSTer framework black box)
- **Toplevel:** `core/Oric.sv` (the `emu` module)
- **VHDL linter:** `ghdl` (default was already correct)
- **Verilog/SV linter:** `verilator` (default was `modelsim` → caused `vlog: command not found` error)

To regenerate after a core update (e.g. new files added):

```bash
python3 << 'EOF'
import json, os

core = "/Users/nenaddjordjevic/retro-computers/oric/projects/mister-fpga-oric-core-understanding/core"

files = []
for root, dirs, fnames in os.walk(core):
    dirs[:] = [d for d in dirs if d != 'sys']
    for fname in fnames:
        if any(fname.endswith(ext) for ext in ['.sv', '.v', '.vhd']):
            files.append(os.path.join(root, fname))

files.sort()
file_entries = [{"name": f, "is_include_file": False, "include_path": "",
                 "logical_name": "", "is_manual": True,
                 "file_type": "", "file_version": "", "source_type": "none"}
                for f in files]

prj = {
    "project_list": [{"name": "Oric_MiSTer", "project_type": "genericProject",
                      "files": file_entries,
                      "toplevel": os.path.join(core, "Oric.sv"),
                      "watchers": []}],
    "selected_project": "Oric_MiSTer"
}

with open(os.path.expanduser("~/.teroshdl2_prj.json"), "w") as f:
    json.dump(prj, f, indent=2)
print(f"Wrote {len(files)} files")
EOF
```

Then reload Cursor: `Cmd+Shift+P` → `Developer: Reload Window`.

## Smoke-test results (2026-06-21)

```
python3 core/tools/tape-inspect.py --help  → OK (usage printed)
ghdl -a smoke_test.vhd                     → OK (GHDL analyze passed)
iverilog -o /dev/null smoke_test.v         → OK
verilator --lint-only smoke_test.v         → OK
```

## How to launch each tool

```bash
# Simulate a VHDL file (analyze → elaborate → run → dump VCD)
ghdl -a mymodule.vhd
ghdl -e mymodule_tb
ghdl -r mymodule_tb --vcd=wave.vcd

# Open waveform
open -a gtkwave wave.vcd       # macOS
gtkwave wave.vcd               # CLI

# Compile and simulate Verilog
iverilog -o sim mymodule_tb.v mymodule.v
./sim

# Lint Verilog/SV
verilator --lint-only mymodule.v

# Inspect a TAP file
python3 core/tools/tape-inspect.py somegame.tap --basic

# Inspect a snapshot
python3 core/tools/sna-inspect.py somegame.sna
```
