# Oric Resources — link catalog

Repo-wide catalog of Oric hardware, software, build, and learning links, assembled from the
user's Brave bookmarks (`Retro/` → **Oric**). Categorized by topic; duplicates merged.

> Related: deep-dive source pages ingested into the wiki live under
> [`wiki/sources/`](wiki/sources/); the overview synthesis is in
> [`wiki/overview.md`](wiki/overview.md).
>
> *Filtered out from the raw bookmarks: bare Google/eBay search pages, cart pages,
> British Library catalogue searches, an ephemeral Grok conversation link, and
> a generic YouTube search query.*

Assembled 2026-06-21.

---

## 1. Community hubs & central sites

- [Defence Force](https://www.defence-force.org/) — main Oric community hub; news, tools, library
- [Defence Force Forum](https://forum.defence-force.org/) — active community forum
- [Dbug's Blog](https://blog.defence-force.org/index.php?page=main) — deep technical articles from the Defence Force dev; [all articles by year](https://blog.defence-force.org/index.php?year=2009)
- [Welcome to Oric World (oric.free.fr)](http://oric.free.fr/) — reference site: history, hardware, programming
- [Muso's Oric Site (48katmos.freeuk.com)](http://www.48katmos.freeuk.com/) — Atmos-focused; service manual, tips
- [Peter's Oric-1 Page](https://homepages.uni-regensburg.de/~hep09515/oric.html) — personal reference page

## 2. Manuals, books & library

- [The Oric Library — Books (Defence Force)](https://library.defence-force.org/index.php?page=books&entries_per_page=13&content=available&type=manual&current_page=3) — downloadable manuals; [full index](https://library.defence-force.org/books/content/)
- [Oric-1 Manual (PDF)](https://www.defence-force.org/computing/oric/library/lib_manual_oric/files/oric1manual.pdf)
- [Oric-1/Atmos ROM Disassembly v1.1 (PDF)](https://library.defence-force.org/books/content/oric_advanced_user_guide_rom_disassembly.pdf)
- [Oric Service Manual (PDF)](http://www.48katmos.freeuk.com/servman.pdf)
- [Oric-1 and Oric Atmos Books — Internet Archive](https://archive.org/details/oric-books) — free scans of key titles
- [Tangerine Oric-1/Atmos TOSEC 2012 archive (Internet Archive)](https://ia801901.us.archive.org/view_archive.php?archive=/21/items/Tangerine_Oric_1_and_Atmos_TOSEC_2012_04_23/Tangerine_Oric_1_and_Atmos_TOSEC_2012_04_23.zip) — full software preservation set
- [Oric Story — chapter 1 (oric.free.fr)](http://oric.free.fr/STORY/chapter1.html) — history of the Oric

## 3. Hardware reference & programming

- [Hardware Programming How-To (oric.free.fr)](http://oric.free.fr/programming.html) — memory map, I/O, VIA, AY chip
- [Software for Oric (bannister.org)](https://www.bannister.org/software/oric.htm) — utilities and software catalog

## 4. Clones, replicas & open-hardware

- [Metaphoric — Oric clone (OldWer, GitHub)](https://github.com/OldWer/Metaphoric) — modern Oric-1 clone PCB
- [Oric Remix (Board-Folk, GitHub)](https://github.com/Board-Folk/Oric-Remix) — updated KiCad 9 replica of the Oric-1/Atmos motherboard; drop-in replacement requiring original core chips (ULA, 6502A, VIA, AY)
- [OriClone-1 — A New Oric! (JennyDigital, GitHub)](https://github.com/JennyDigital/OriClone-1) — another open-source Oric replica
- [Oric Nova 64](https://www.raxiss.com/article/id/38-LOCI) — see LOCI section; Nova 64 is the target machine

## 5. LOCI mass-storage device

- [LOCI product page (raxiss.com)](https://www.raxiss.com/article/id/38-LOCI) — SD-card mass-storage interface for Oric
- [sodiumlb/loci-firmware (GitHub)](https://github.com/sodiumlb/loci-firmware) — Oric LOCI firmware source

## 6. OCULA — open ULA replacement

- [sodiumlb/ocula-hardware (GitHub)](https://github.com/sodiumlb/ocula-hardware) — PCB design files (see wiki for deep dive)
- [sodiumlb/ocula-pivic-firmware (GitHub)](https://github.com/sodiumlb/ocula-pivic-firmware) — shared OCULA + VIC-20 firmware
- [sodiumlb/ocula-docs (GitHub)](https://github.com/sodiumlb/ocula-docs) — install guide, mux-bridges, modes
- [Oric ULA HCS10017 (Rude Dog Retros)](https://rudedogretros.co.uk/product/oric-ula-hcs10017/) — original ULA chip for sale/repair

## 7. MiSTer / FPGA

- [MiSTer-devel/Oric_MiSTer (GitHub)](https://github.com/MiSTer-devel/Oric_MiSTer) — official MiSTer FPGA core for Oric-1, Atmos, and Pravetz 8D; Smart CLOAD, Microdisc, snapshots, savestates
- [Oric-1 / Atmos Core — MiSTer FPGA Forum](https://misterfpga.org/viewtopic.php?t=4599) — community thread on the MiSTer core
- [rampa069/Oric_Mist_48K (GitHub)](https://github.com/rampa069/Oric_Mist_48K) — older Oric Atmos MiST/SiDi core (predecessor to MiSTer-devel/Oric_MiSTer)

## 8. FPGA / HDL learning (VHDL · Verilog · SystemVerilog)

For studying the MiSTer Oric core (mixed VHDL + Verilog/SystemVerilog). See also the repo-wide book catalog at [`books/INDEX.md`](books/INDEX.md) and the broader platform notes in [`../mister-fpga/RESOURCES.md`](../mister-fpga/RESOURCES.md).

**VHDL**
- [Nandland — VHDL & FPGA](https://nandland.com/) — beginner-friendly, hardware-first; covers both VHDL and Verilog
- [VHDLwhiz](https://vhdlwhiz.com/) — tutorials, testbenches, FSMs, simulation
- [Doulos — VHDL Knowhow / Golden Reference](https://www.doulos.com/knowhow/vhdl/) — concise language reference
- [GHDL documentation](https://ghdl.github.io/ghdl/) — the VHDL simulator used to test individual modules

**Verilog / SystemVerilog**
- [ASIC World — Verilog](https://www.asic-world.com/verilog/) · [SystemVerilog](https://www.asic-world.com/systemverilog/) — the classic free tutorial reference
- [ChipVerify — Verilog & SystemVerilog](https://www.chipverify.com/) — tutorials + worked examples
- [Sutherland HDL — SystemVerilog quick reference](https://sutherland-hdl.com/) — free SV reference cards and "gotchas"
- [Verilator manual](https://verilator.org/guide/latest/) — the Verilog/SV simulator for the core's `.v`/`.sv` modules

**Digital design fundamentals & practice**
- [HDLBits](https://hdlbits.01xz.net/wiki/Main_Page) — interactive Verilog practice problems
- [fpga4fun](https://www.fpga4fun.com/) — small, focused FPGA project tutorials
- [EDA Playground](https://www.edaplayground.com) — online VHDL/Verilog/SV simulator (no install)
- [Intel Quartus Prime Lite](https://www.intel.com/content/www/us/en/products/details/fpga/development-tools/quartus-prime.html) — the MiSTer toolchain (Cyclone V); RTL Viewer + synthesis (Linux/Windows only)

**MiSTer core internals (how cores are built)**
- [Template_MiSTer](https://github.com/MiSTer-devel/Template_MiSTer) — minimal core skeleton; the framework boundary
- [emu — Top Level of a MiSTer core (wiki)](https://github.com/MiSTer-devel/Main_MiSTer/wiki/emu---Top-Level-of-a-MiSTer-core) · [overview of emu (docs)](https://mister-devel.github.io/MkDocs_MiSTer/developer/emu/)
- [Learning to develop a core (forum)](https://misterfpga.org/viewtopic.php?t=78) · [Verilog/HDL books & tutorials (pinned)](https://misterfpga.org/viewtopic.php?t=136)

## 9. Repair, diagnostics & parts

- [Oric Atmos Diagnostic Harness (myretrostore.co.uk)](https://myretrostore.co.uk/product/oric-atmos-diagnostic-harness/) — test harness for fault-finding
- [Oric Microdisc Drive (Computing History)](https://www.computinghistory.org.uk/det/31261/Oric-Microdisc-Drive/) — reference entry for the Microdisc peripheral

## 10. YouTube

- [Generate 8-bit Oric-1 graphics using Copilot!](https://www.youtube.com/watch?v=Vf9Gvi1Y3II) — Oric graphics tooling demo

## 11. Buying (vintage hardware)

- [RARE Oric Atmos Boxed — eBay UK](https://www.ebay.co.uk/itm/198339907875) — example listing for reference pricing

## 12. Emulators & local archives

Local files in the pCloud library (`iCloud-Migration/Programming/Retro/Oric/`), not public URLs:

- **`oric-183.zip`** — Oric v1.8.3, a native **macOS Oric-1 / Atmos emulator** (`Oric.app`), bundled with a "Mega Demo" tape. Useful for running Oric software and cross-checking behavior against the MiSTer core.
- **`ee-320.zip`** — Emulator Enhancer v3.2, a generic macOS emulation utility (not Oric-specific; misfiled in the Oric folder).

## 13. Machine-code monitors, assemblers & debuggers

Found while researching [`projects/ideas.md`](projects/ideas.md) idea #1 — three period commercial tools existed (contrary to the initial assumption that none did), plus a modern homebrew debugger port.

- [The Oric Site — software archive (oric.org)](https://www.oric.org/) — community-maintained Oric software database with scanned manuals and cassette/disk dumps; not previously catalogued in this file
- [ORICMON (oric.org)](https://www.oric.org/software/oric_mon-145.html) — Tansoft, 1983 (Geoff M. Phillips & Paul Kaufman); machine code monitor + block move + mnemonic assembler/disassembler, Oric-1/Atmos
- [ORIC-MON (oric.org)](https://www.oric.org/software/oric_mon-79.html) — PSS, 1983 (A. J. Clarke); a separate product despite the near-identical name; v1.1 added Atmos support
- [ORION (oric.org)](https://www.oric.org/software/orion-1507.html) — AWA Software / later MC Lothlorien, 1983 (S. Hughes); assembler/disassembler/monitor resident at `$8100–$97FF`, plus a `PDUMPO` utility to print disassembly
- [Oricutron (GitHub)](https://github.com/pete-gordon/oricutron) — the reference Oric-1/Atmos/Telestrat/Pravetz 8D emulator; built-in **F2** monitor/debugger (disassembler, memory dump, breakpoints, register display, symbol-file loading)
- [Oricutron user guide](https://github.com/pete-gordon/oricutron/blob/master/Oricutron.guide) — documents the F2 monitor's command set
- [Forum: Oricutron feature request — external debugger support](https://forum.defence-force.org/viewtopic.php?t=1896) — a working NoICE port: a native 6502 resident monitor (`mon6502.dsk`/`.tap`) that runs as ordinary Oric machine code and talks to PC-hosted NoICE over serial; can't debug code that changes the IRQ vector
- [Forum: Assembler / disassembler](https://forum.defence-force.org/viewtopic.php?t=1765)
- [Forum: Towards an onboard Oric Assembler/Editor Development environment](https://forum.defence-force.org/viewtopic.php?t=2430) — brainstorming thread, mentions a tool called MONASM, no shipped result
- [Forum: ASMOS recommendation thread](https://forum.defence-force.org/viewtopic.php?t=1199) — recommends ASMOS as an accessible on-machine assembler/monitor; notes poor documentation across these period tools generally
