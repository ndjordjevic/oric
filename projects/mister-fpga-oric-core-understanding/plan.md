# Understanding the MiSTer FPGA Oric core — study plan

**Goal:** Be able to read the [MiSTer-devel/Oric_MiSTer](https://github.com/MiSTer-devel/Oric_MiSTer) source and explain, module by module, how the Oric-1 / Atmos is reconstructed in FPGA logic — CPU, ULA video, VIA, PSG sound, storage, and the MiSTer-specific glue (tape/snapshot/savestate). Day 8 adds a hands-on simulation/visualization pass to *concretely confirm* that understanding — no Quartus build, no real hardware needed.

**Definition of done:** you can explain **end-to-end how the Oric Atmos works as a machine**, and open any Oric-relevant core file and say **what each code block does** — without needing to parse every line of HDL syntax. Concretely: `annotated/rtl/` carries block-commented copies of every Oric-proper module, `01-oric-hardware-notes.md` describes the real hardware in your own words, and `07-how-the-oric-works.md` ties the two together in one narrative. Day 8 (below) is a bonus verification pass, not a requirement of this definition — building/deploying to real hardware is explicitly out of scope for this project.

**Project layout:**

```
README.md                        ← how the study layers fit together — read first
plan.md                          ← this file

  ── SPRINT DELIVERABLES — the NN- prefix is the day that produced it ───────
00-repo-map.md                   ← Day 0 · what every folder/file in core/ is for
01-oric-hardware-notes.md        ← Day 1 · the real Oric hardware, in your own words
                                          (created Day 1, then added to through Day 6)
modules/                         ← Days 2–6 · one note per subsystem, day-prefixed:
    02-ula.md                          Day 2 · ULA timing & address generation
    03-video.md                        Day 3 · pixel pipeline & serial attributes
    04-m6522.md                        Day 4 · VIA
    05-psg.md, 05-keyboard-joystick.md Day 5 · sound & input
    06-tape.md                         Day 6 · cassette path
07-how-the-oric-works.md         ← Day 7 · capstone: the end-to-end narrative
08-simulation-and-visualization.md ← Day 8 · watch the CPU/ULA actually run

  ── REFERENCE — no day number: not produced by a sprint day ────────────────
reference/understanding-Oric-sv.md         ← architecture of Oric.sv           (pre-sprint)
reference/understanding-oricatmos-vhd.md   ← architecture of rtl/oricatmos.vhd (pre-sprint)
reference/block-diagram.md                 ← data/clock-path diagrams (pre-sprint; refreshed Day 7)
reference/dev-env.md                       ← toolchain setup (Phase 0; extended Day 8 with SDL2)
sim/                              ← Day 8 testbenches, waveforms, and captured frames

annotated/                       ← ★-annotated frozen source copies (canonical line numbers)
core/                            ← cloned Oric_MiSTer source (gitignored, kept pristine)
archive/                         ← finished tracks kept for reference:
                                     learn-systemverilog/, learn-vhdl/ + decoder cards
```

> **Naming rule:** a leading `NN-` means **"deliverable of Day NN"** — nothing
> else. Files with no number aren't sprint output: they're pre-existing walkthroughs, reference,
> or later-phase material. This replaced the old *phase*-numbered scheme, which broke once the
> sprint existed (`02-oric-hardware-notes.md` was the Phase 2 deliverable, but Day 2 is the ULA —
> the number pointed at the wrong thing). Now Day 2's output is `modules/02-ula.md`, and the number
> always tells you when it was written.

**Why this repo:** the [wiki](../../oric-docs/oric-llm-wiki/wiki/index.md) already documents the *real* Oric hardware (register-level manual, ULA reverse-engineering, memory map) and the [core itself](../../oric-docs/oric-llm-wiki/wiki/sources/MiSTer-devel-Oric_MiSTer.md). You cannot read `ula.vhd` without knowing what the ULA does — so each code-reading step below is paired with required wiki reading.

---



## ⭐ THIS WEEK — 8-day sprint to "I understand how the Oric works"

**Day 0 → Day 8** (Day 0 and Day 1 are the same day — Day 0 is a ~1 hour
orientation pass, not a full day; Day 8 is a bonus verification day, added after Day 7 to replace
the old Phase 5/6 stretch goals — see below). This is the active plan; the phase list further down is the
long-range map that Days 0–7 execute the heart of (Phase 2 + Phase 4).

**Why now:** every project in `[../ideas.md](../ideas.md)` — reverse-engineer an Oric game, port
Lode Runner / Choplifter, write the dBASE-class app, write the CP/M-inspired DOS — is gated on this.
That backlog's own *"goal 1 — understand the hardware to the point of low-level programming"* **is
this week.** Nothing else starts until it's done.

## Gear change (decided Day 0) — read before Day 1


| Until now                                       | This week                                                                             |
| ----------------------------------------------- | ------------------------------------------------------------------------------------- |
| Understand every line and token of HDL syntax   | Understand **what each code block does**; syntax only as far as needed to read it     |
| Lessons + decoder cards = active track          | Lessons are **finished** — a reference to consult, not a track to advance             |
| Phase 4's per-module decoder-card token check   | **Dropped.** It's line-level work and contradicts the new direction                   |
| `annotated/` = 2 files with `★` section headers | `annotated/rtl/` grows to cover **every Oric-proper module**, with per-block comments |


`AGENTS.md`'s **full-coverage requirement** (explain every line and token of an excerpt) governs
**lessons**. It does **not** apply to the new `annotated/rtl/`* block comments — those are
deliberately block-level.

## Annotation standard — the week's primary artifact

Every module annotated this week gets, in `annotated/rtl/<file>`:

1. **File-header block** — what real chip or function this is, its role in the Oric, its key ports,
  and what it deliberately does *not* do.
2. `★ SECTION` **markers** — one line per logical section (same convention as the existing
  `Oric.sv` / `oricatmos.vhd` snapshots).
3. **Per-block comments** — a short plain-English comment above **each** `process` / `always` block /
  state machine / non-obvious mux: *what it does, and why it's there.* No syntax explanation, no
   token-by-token coverage.

`ula.vhd`'s ~13 named processes (`u_CPT_H`, `u_CPT_V`, `u_isattrib`, `u_shf_reg`, `addr_latch`, …)
are the model unit of granularity — roughly one comment block per named process.

**Out-of-scope regions get one span comment, not per-block comments.** Where a day deliberately
scopes something out (e.g. Day 4's shift-register internals in `m6522.vhd`, or `wd1793.sv` if
reached), write a *single* block comment covering the whole span — *"the next N processes implement
the shift register; the Oric doesn't meaningfully use it — interface only, internals not walked"* —
and move on. Without this rule, "a comment above **each** process" and a scope cut contradict each
other on exactly the biggest file of the week.

- **Workflow:** copy `core/rtl/<file>` → `annotated/rtl/<file>`, then annotate. Never edit `core/`.
- **Frozen once written** — same rule and provenance as the existing snapshots (upstream `c4cf449`),
so later notes can cite their line numbers safely.
- `Oric.sv` **and** `oricatmos.vhd` **stay untouched.** They already carry 19 `★` sections each plus the
full `understanding-Oric-sv`/`understanding-oricatmos-vhd` walkthroughs, and every lesson/doc line-number citation points into them.



## Scope — what actually counts as "the Oric"

`rtl/` is ~~7,600 lines, but a large slice is MiSTer emulator convenience rather than the machine.
**In scope (~~2,900 lines) — this *is* the Oric:**


| Day | Focus                                                               | Files (lines)                                          |
| --- | ------------------------------------------------------------------- | ------------------------------------------------------ |
| 0   | *Orientation, not code* — what every folder/file in the repo is for | build system, `sys/` triage, `files.qip`               |
| 1   | Real hardware + memory map + CPU/RAM/ROM                            | `spram.v` (47), `rom/*.vhd`, T65 *interface only*      |
| 2   | ULA part 1 — timing & address generation                            | `ula.vhd` (569)                                        |
| 3   | ULA part 2 + video — pixels & serial attributes                     | `ula.vhd` cont., `video.vhd` (215)                     |
| 4   | VIA 6522 — the I/O hub                                              | `m6522.vhd` (1123)                                     |
| 5   | Sound & input                                                       | `psg.v` (355), `keyboard.sv` (251), `joystick.sv` (66) |
| 6   | Tape + buffer + floppy stretch                                      | `cassette.v` (184), `cas_sig_gen.v` (85)               |
| 7   | Synthesis + proof                                                   | —                                                      |
| 8   | *Bonus: simulate & visualize* — watch the CPU/ULA run for real       | GHDL/Verilator testbenches (no `sys/`, no Quartus)     |


**Explicitly out of scope this week — MiSTer glue, not the Oric:** snapshots/savestates
(`snap_loader.v`, `snap_ss.v`, `savestate_hotkeys.v` — 1,158 lines), the tape *speed-loader* engine
(`cload_patch_rom.v`, `tap_byte_streamer.v`, `tap_segment_loader.v`, `tap_autorun_keys.v` — 694),
`ddram.sv`, and `pll.v` internals (an Intel megafunction black box — the clock-*enable* scheme that
actually matters is in `oricatmos.vhd`, already covered by `understanding-oricatmos-vhd` §7/§10). `understanding-Oric-sv` already documents
how all of this hangs off the top level, which is all that's needed.

---



## Day 0 · Map the territory: what every folder and file in the repo is *for*

**Also today, before Day 1.** Pure orientation, no code reading — the goal is that opening the core
repo never again produces "what even is all this?" You should be able to name any top-level item's
job and say whether it's something you'll ever need to open.

Everything below is *around* the Oric code, not the Oric code itself (that's Days 1–6).

- [x] **The build system — 5 files that explain how the core is actually compiled**
  - `Oric.qpf` — Quartus *project* file. Literally 2 lines (Quartus version + revision name). Nothing to learn
  - `Oric.qsf` — Quartus *settings*: device/pin assignments. **Two lines matter:** `TOP_LEVEL_ENTITY = sys_top` and `source files.qip`
  - `files.qip` — **the manifest, and the most useful file here.** 33 lines listing every RTL source that goes into the build. *If a file isn't in this list, it isn't in the core* — this is how you tell live code from leftovers
  - `Oric.srf` — Quartus "suppressed messages": warnings the author chose to silence. Curiosity only, never study material
  - `build_id.v` — one generated line, ``define BUILD_DATE`, rewritten at build time by` sys/build_id.tcl`
- [x] **The one structural fact that confuses everyone about MiSTer cores:** the top-level entity is `sys_top` **(in** `sys/sys_top.v`**, 44 KB)** — *not* `Oric.sv`. Quartus builds the framework, and the framework instantiates *your* `emu` module. `Oric.sv` is a plug-in, not the root. (Already stated in "MiSTer core anatomy" below — confirm it against the actual `.qsf` today so it's concrete rather than trivia)
- [x] **The folders**


| Folder      | What it is                                                                                                                                                              | Will you open it?                                            |
| ----------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------ |
| `rtl/`      | **The actual core.** Sub-dirs: `T65/` (6502 CPU), `rom/` (ROM images as VHDL tables), `pll/` (Intel megafunction), `apple2_disk/` (WD1793 shared with an Apple II impl) | Yes — Days 1–6 live here                                     |
| `sys/`      | MiSTer framework, 52 files, **identical across every MiSTer core. Never edit.**                                                                                         | Only ~5 of the 52 (below)                                    |
| `tools/`    | Python TAP/SNA utilities (`tape-inspect.py`, `sna-inspect.py`, `ss-convert.py`, `merger.py`, `splitter.py`) + `oric-build` (Docker/Quartus) + `tool.md`                 | Useful later — file-format reference for `ideas.md` projects |
| `releases/` | 11 prebuilt `.rbf` bitstreams, one per release date — the file you'd actually copy to a MiSTer SD card                                                                  | No, but good to know it's the *output*                       |
| `dsk/`      | 6 sample disk images (games + `SEDO40u_DSK.dsk` = SEDORIC DOS)                                                                                                          | Yes if you reach floppy (Day 6) or Ideas #5/#6               |
| `img/`      | 4 screenshots for the upstream README                                                                                                                                   | No                                                           |
| `docs/`     | Maintainer technical notes — **not in official `MiSTer-devel`**; copied locally from [nikiiv/Oric_MiSTer](https://github.com/nikiiv/Oric_MiSTer) (Day 0). Index: `core/docs/docs.md` | Yes — Day 1 / Day 6 (see below) |
| `games/`, `_Games/` | Sample TAP/`.sna` + MGL launchers (same fork source)                                                                                                              | Optional                                                     |


- [x] **Triage** `sys/` **so it stops being a 52-file wall.** Only a handful are ever touched from `Oric.sv`: `emu_ports.vh` (the port list `Oric.sv` includes), `hps_io.sv` (ARM bridge), `video_mixer.sv` + `video_freak.sv` (video output/aspect), `ltc2308.sv` (the ADC behind Day 6's tape input). Everything else — `ascal.vhd`, `sd_card.sv`, `spdif.v`, `yc_out.sv`, the `pll_`* variants, the `.tcl`/`.sdc` build scripts — is framework plumbing you can permanently ignore

- **Deliverable:** `00-repo-map.md` ✅ (Day 0) — lookup table: top-level map, `files.qip` manifest, `sys/` triage, fork-only `docs/`/`games/`/`_Games/` note
- **Self-check:** point at any top-level file or folder and say what it does — and, for each, whether you'll ever need to open it
- **Time-box:** this is a ~1 hour task. If it's taking longer you're reading code, which is Day 1's job



## Day 1 · Foundation: the real machine, memory map, CPU & memory

You cannot read `ula.vhd` without knowing what a ULA *is*, so the week starts on the hardware side.
This is Phase 2, which has been skipped until now and is the real gap.

> **Status (Day 1):** the three *code* items below are annotated and done ✅. The two **reading**
> items are still open — and they're the half that matters most today, because Days 2–6 all assume
> the hardware model. `01-oric-hardware-notes.md` exists as a skeleton with the memory map filled
> in and per-chip sections stubbed; fill the CPU/memory parts as you read.

- [ ] Read [[oric.free.fr]] — memory map + 6502/VIA/ULA/PSG register-level architecture
- [ ] Skim [[oric.signal11.org.uk]] (Mike Brown / Lance Ewing ULA reverse-engineering) — full read is Day 2
- [ ] Read `core/docs/oric_memory_map.md` — consolidated map + page-3 I/O + chip overview (pairs with `01-oric-hardware-notes.md`)
- [ ] Skim `core/docs/manual_atmos.md` as needed — Atmos manual as text (setup, BASIC, tape, graphics, sound, ROM routines)
- [x] `spram.v` (47) — the block-RAM template used for main RAM, file cache, alt-BIOS → `annotated/rtl/spram.v` ✅
- [x] `rom/*.vhd` — ROMs as VHDL lookup tables → `annotated/rtl/rom/README.md` ✅. Annotates the *pattern* rather than copying 13 × ~1,046-line hex dumps. **Finding: only 5 of the 13 ROM files are in** `files.qip` (BASIC11A = Atmos, BASIC10 = Oric-1, PRAVETZ8D, PRAVETZ8D_FDC, MICRODIS); the other 8 — incl. BASIC11/22, DIAG10, TEST108J, ORIC1SDCARD — are *not built*. Also: `MICRODIS.vhd` declares `entity ORICDOS06`, so its filename never appears at the instantiation
- [x] T65 — **interface only** (address / data / R_W_n / IRQ_n / NMI_n / Rdy / Enable). Do *not* read the 6502 internals; 2,468 lines with no Oric-specific content → `annotated/rtl/T65/T65.vhd` ✅ — entity fully annotated, architecture covered by one out-of-scope span comment. Takeaway to carry: the **clock/enable split** (CPU runs on the fast clock, `Enable` pulses at 1 MHz to make it *behave* period-correct) — an idiom reused by nearly every clocked module in the core

- **Deliverables:** `01-oric-hardware-notes.md` — **skeleton created ✅, content pending your reading**: memory map table filled in and verified against the core, CPU section written, all other chips stubbed with a "written on Day N" marker · `annotated/rtl/spram.v` ✅ · `annotated/rtl/T65/T65.vhd` ✅ · `annotated/rtl/rom/README.md` ✅
- **Note — this doc accretes all week.** Don't try to write the per-chip paragraphs today: the ULA's belongs to Days 2–3, the VIA's to Day 4, the PSG's to Day 5, tape's to Day 6, each written *after* reading that chip's RTL. Day 1 is the only day with no buffer behind it and it already carries the whole Phase 2 hardware read — keep it light
- **Self-check:** draw the Oric memory map from memory — what lives at `$0000`, `$0200`, `$A000`, `$BB80`, `$C000`? Why does TEXT mode free up the `$A000` region?



## Day 2 · ULA part 1: timing & address generation (the heart)

The single highest-payoff module in the core, and the most Oric-specific silicon there is.

- [ ] `ula.vhd` (569) — clock division from `CLK_24`, horizontal/vertical counters (`u_CPT_H`, `u_CPT_V`), sync generation, the per-line address-recomputation formula, and CPU↔video RAM contention (`PHI2` timesharing)
- [ ] Pair with [[oric.signal11.org.uk]] in full — the decapped-ULA reverse-engineering is what makes this readable

- **Deliverables:** `annotated/rtl/ula.vhd` (part-1 sections) · start `modules/02-ula.md`
- **Self-check:** explain *why* the Oric physically cannot hardware-scroll — i.e. what the ULA recomputes every line. (This is the constraint behind Idea #3's difficulty in `ideas.md`.)



## Day 3 · ULA part 2 + video: pixels & serial attributes

- [ ] Rest of `ula.vhd` — attribute detection (`u_isattrib`), pixel shift register (`u_shf_reg`), hold/latch registers, `u_ld_reg`
- [ ] `video.vhd` (215) — the output pipeline
- [ ] **The serial-attribute model, in full.** The single most consequential Oric quirk: an attribute byte occupies a 6-pixel cell in screen data and holds until the next one; one byte sets ink *or* paper *or* charset, never two. Every game project in `ideas.md` lives or dies on this

- **Deliverables:** finish `annotated/rtl/ula.vhd` · `annotated/rtl/video.vhd` · `modules/02-ula.md`, `modules/03-video.md`
- **Buffer:** this day deliberately has slack to absorb Day 2 overflow — ULA is allowed to take 1.5 days
- **Self-check:** explain TEXT vs HIRES layout, and exactly what one attribute byte costs you on screen



## Day 4 · VIA 6522: the I/O hub

**The week's biggest file — 1,123 lines and 52 processes, ~4× the ULA's process count. Scoped
deliberately rather than read exhaustively:**

- [ ] **In scope:** the CPU register interface (full register map), PA/PB port I/O, the four jobs the Oric actually gives it — keyboard-matrix column select, PSG bus control (`BDIR`/`BC1`), tape in/out, printer — plus T1/T2 timers at block level and the IFR/IER interrupt logic
- [ ] **Out of scope (state it in the module doc):** shift-register (SR) internals and timer edge-case corner behaviour. Read the interface, skip the guts — the Oric barely exercises them

- **Deliverables:** `annotated/rtl/m6522.vhd` · `modules/04-m6522.md`
- **Self-check:** trace a single keypress end-to-end — matrix row/column → VIA port → IRQ → CPU



## Day 5 · Sound & input

- [ ] `psg.v` (355) — AY-3-8912: register file, tone/noise/envelope generators, the three channels
- [ ] `keyboard.sv` (251) — the Oric keyboard matrix (and the Pravetz layout switch)
- [ ] `joystick.sv` (66) — trivial; ties into `understanding-oricatmos-vhd` §13's VIA PA mapping

- **Deliverables:** three annotated files · `modules/05-psg.md`, `modules/05-keyboard-joystick.md`
- **Self-check:** how does the CPU write one AY register? (the VIA→PSG `BDIR`/`BC1` handshake — the thing Day 4 and Day 5 meet on)



## Day 6 · Tape, buffer, and the floppy stretch

- [ ] `cassette.v` (184) + `cas_sig_gen.v` (85) — the real tape path (as opposed to the MiSTer speed-loaders, out of scope)
- [ ] Read `core/docs/tape_loading.md` — ops view of Tape Load Fast/Ultra/Off (context for the real path vs speed-loaders)
- [ ] **Absorb slippage** from Days 2–5 — this is the designated catch-up day
- [ ] **Stretch, below the line:** the floppy stack — `microdisc.vhd` (515), `wd1793.sv` (910), `pravetz8d_fdc.vhd` (216). A peripheral *add-on*, not the Oric proper, and the first thing to sacrifice if earlier days ran long. Even a file-header-only pass has value here. Pair with `core/docs/pravetz_8d_fdc.md` if you reach Pravetz FDC
- [ ] **Let the *next* project decide whether floppy is optional.** Under "what is the Oric," it's cuttable — but the week is also a prerequisite for all of `ideas.md`, and Ideas **#5 (dBASE)** and **#6 (CP/M-like DOS)** both hinge on Microdisc random-access storage, which is *their* single biggest design fork. So: if #5/#6 is next, the Microdisc path is a genuine prerequisite, not a stretch. If #2/#3/#4 (game RE / ports) is next, Days 2–3's ULA and serial-attribute work already covered what those need, and floppy can go

- **Deliverables:** annotated tape files · `modules/06-tape.md` (· floppy equivalents if reached)
- **Self-check:** how does a byte on tape become a bit the CPU can read?



## Day 7 · Synthesis + proof

- [ ] Write `07-how-the-oric-works.md` — the capstone. One end-to-end narrative: power-on → reset → CPU fetches from ROM → ULA generates video while contending with the CPU for RAM → VIA scans the keyboard and drives the PSG → tape/disk I/O. Real hardware *and* how the core implements it, in a single story. (The `03-` slot is free — Phase 3's cheatsheet was fulfilled by the lesson series.)
- [ ] Refresh `reference/block-diagram.md` with everything learned this week
- [ ] **Cold-read self-test — this is the actual success criterion.** Pick 3 code blocks you haven't specifically discussed **from** `core/rtl/` **— the pristine, uncommented copies** — say what each does, *then* diff your answer against your own `annotated/` comment. (Reading them out of `annotated/` would just be reading your own notes back; `core/` is the same code with the answer removed.) If that works, the week succeeded — the count of annotated files is not the measure
- [ ] Close the loop: confirm `ideas.md` "goal 1" is satisfied, and write down what's still thin

- **Deliverables:** `07-how-the-oric-works.md` · updated `reference/block-diagram.md`



## Day 8 · Bonus: simulate & visualize — watch the CPU/ULA actually run

**Replaces the old Phase 5/6 stretch goals.** Same underlying goal as the rest of the week —
*understand how the Oric works* — but confirmed by watching real signals move instead of reading
a narrative about them. **No Quartus, no `.rbf`, no real hardware:** everything below runs with the
open-source stack from Day 0 (GHDL, Icarus/Verilator, GTKWave), plus SDL2 for the visual pieces.

Researched three tiers, ordered by how realistically each fits in a day. Do Tier 1 always; Tier 2
if Tier 1 goes well; treat Tier 3 as a possible future project, not today's target.

**Tier 1 — watch the CPU run, no new toolchain (do this first)**
- [ ] Load a small 6502 test program (reuse one of Day 1's memory-map self-checks, or a short
  routine from `oric-docs/books/oric/machine-code-for-the-atmos-and-oric-1.md`) into
  [visual6502.org](http://visual6502.org/JSSim/) and step it cycle-by-cycle. This is the
  **transistor-level simulation of the real 6502 die** — not `T65.vhd`, but the chip `T65`
  stands in for. Watching an actual fetch/decode/execute cycle here is the cheapest way to make
  Day 1's "clock/enable split" takeaway concrete.
- [ ] Optional pairing: write a small GHDL testbench around `annotated/rtl/T65/T65.vhd` that loads
  the same program into a mock ROM, dump a VCD, and compare `address`/`data`/`R_W_n` per cycle in
  GTKWave against visual6502's trace for the same program — ties the real chip to the soft core
  that emulates it.

**Tier 2 — watch the ULA draw, scoped to `ula.vhd` + `video.vhd` only**
- [ ] Set up Verilator + SDL2 natively (Homebrew: `brew install sdl2`; Verilator already installed
  from Phase 0). Since `ula.vhd`/`video.vhd` are VHDL, GHDL is the simulator, not Verilator — GHDL
  has no built-in SDL binding, so the realistic path for a single day is the **frame-dump**
  pattern, not a live window: a GHDL testbench samples R/G/B + HSync/VSync every cycle and writes
  completed frames out as PPM images (viewable directly, or stitched into a GIF with `ffmpeg`).
  See [ktln2.org's VGA-simulation-with-Verilator writeup](https://ktln2.org/2020/05/24/vga-controller-simulation/)
  for the exact buffering/vsync-detection pattern (Verilog there, same idea in VHDL/GHDL).
  If a live window is wanted instead, [Project F's Verilator+SDL tutorial](https://projectf.io/posts/verilog-sim-verilator-sdl/)
  is the reference (built for Verilog/Verilator, so only usable directly if `ula.vhd` is
  cross-compiled or reimplemented — the frame-dump route avoids that problem entirely).
- [ ] Feed the testbench a tiny synthetic "screen RAM" — a handful of known attribute + character
  bytes, not a real boot — enough to render one line and *see* the serial-attribute model from
  Day 3: one byte sets ink/paper/charset and holds until the next.

**Tier 3 — the whole machine, boot and watch (stretch — likely its own future project, not Day 8)**
- The actual "load a program and watch the whole Oric work" goal — CPU + RAM/ROM + ULA + VIA + PSG
  together, booting a real `.tap`/`.dsk`, rendering a live screen — is exactly what
  [JimmyStones' `Verilator_Template`](https://github.com/JimmyStones/Verilator_Template) is built
  for: ROM/tape upload simulating the HPS `ioctl` path, live VGA output with zoom, continuous /
  single-step / multi-step execution, `$display` routed to a debug console.
  [alanswx/Colecovision-Verilator_MiSTer](https://github.com/alanswx/Colecovision-Verilator_MiSTer)
  is a real example of this pattern applied to a similarly-scoped 8-bit system (6502-family CPU +
  custom video chip) — the closest existing structural analogy to `Oric_MiSTer`.
- **Caveat found during research:** `Verilator_Template` is **Windows/WSL + Visual Studio only** —
  no native macOS support. Given this project's dev environment is macOS-native (Phase 0), this
  tier needs either the same Windows/Linux VM route already flagged as optional for Quartus, or a
  ground-up SDL2 port of the template's C++ harness — real, multi-day infrastructure work either way.
- The "Intel PLL is a black box" caveat from the old Phase 5 write-up isn't actually a blocker here:
  the standard practice in these templates is to **swap out `sys/` and `pll.v` for a
  testbench-provided clock/reset**, keeping only `rtl/` (the actual Oric machine) instantiated —
  the same MiSTer-glue-vs-Oric-proper scope cut Days 1–6 already use.
- If pursued later, this is arguably its own `ideas.md`-shaped project ("build an interactive
  Oric core debugger/visualizer"), not a one-day sprint task.

- **Deliverables:** `08-simulation-and-visualization.md` — what was tried, what worked, captured
  frames/waveforms (screenshots or the PPM/GTKWave output), and an honest note on whether Tier 3 is
  worth a future project.
- **Self-check:** pick one specific memory write, predict what changes on screen (or what T65 pins
  do) *before* running the testbench, then verify against the actual simulation output.



## Sources per day — use the shelf you already have

Three local collections make this week much easier than reading RTL cold. **Check these before
searching online** — the answer is usually already here.

- `[../../oric-docs/books/INDEX.md](../../oric-docs/books/INDEX.md)` — 30 Oric titles, 9 of them hardware/CPU/ROM
- `[../../oric-docs/oric-llm-wiki/wiki/](../../oric-docs/oric-llm-wiki/wiki/index.md)` — 20 ingested sources; start at `wiki/index.md`, follow `[[wikilinks]]`
- `core/docs/` — maintainer notes (from [nikiiv/Oric_MiSTer](https://github.com/nikiiv/Oric_MiSTer), not official upstream). Index: [`docs.md`](core/docs/docs.md)


| Day             | Books (`oric-docs/books/oric/…`)                                                                                                                                                                       | Wiki                                                                                                                                                                                                                                                                       | `core/docs/` |
| --------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --- |
| 1 · memory/CPU  | `getting-more-from-your-oric` (6502/6522/memory-map/OS chapters) · `6502-users-manual` (Carr — the CPU T65 implements) · `oric-advanced-user-guide` + its `-rom-disassembly` (commented `$C000–$FFFF`) | [[oric.free.fr]] Hardware Programming How-To                                                                                                                                                                                                                               | `oric_memory_map.md` · skim `manual_atmos.md` |
| 2–3 · ULA/video | `oric-atmos-and-oric-1-graphics-and-machine-code-techniques` (Phillips — the serial-attribute bible) · `oric-service-manual` (schematics)                                                              | [[oric.signal11.org.uk]] (Mike Brown / Lance Ewing ULA reverse-engineering, decapped die) · [[sodiumlb-ocula-hardware]] + [[sodiumlb-ocula-pivic-firmware]] — a *modern open-hardware ULA reimplementation*, i.e. someone else's answer to "what does the ULA actually do" | — |
| 4 · VIA         | `getting-more-from-your-oric` (6522 chapter) · `oric-advanced-user-guide`                                                                                                                              | [[oric.free.fr]] (VIA register detail + 6522 datasheet appendix)                                                                                                                                                                                                           | — (memory map already covers page-3 VIA) |
| 5 · PSG/input   | `advanced-programming-for-the-oric`                                                                                                                                                                    | [[oric.free.fr]] (PSG + keyboard matrix; AY-3-8912 datasheet appendix)                                                                                                                                                                                                     | — |
| 6 · tape/disk   | `oric-service-manual`                                                                                                                                                                                  | [[oric.free.fr]] (tape encoding, WD1793 appendix) · [[forum.defence-force.org]] for storage threads                                                                                                                                                                        | `tape_loading.md` · stretch: `pravetz_8d_fdc.md` |
| 7 · synthesis   | `oric-advanced-user-guide`                                                                                                                                                                             | [[MiSTer-devel-Oric_MiSTer]] · [[OldWer-Metaphoric]] (clone hardware cross-check)                                                                                                                                                                                          | — |

**After the sprint / out of scope this week** (same `core/docs/`): `oric_to_core_comm.md`, `live_rom_patching.md`, `sna_support.md`, `oricutron_snapshot_internals.md`, `build.md`, `sys_update.md`, `Oric Rom.md`/`.html`, `timing.md` — MiSTer glue, snapshots, build; not Days 1–7.


**Key facts already in the wiki, worth having before Day 2** (from [[oric.free.fr]]): the ULA is a
*Universal Array Logic*, part number **HSC 10017** — it clocks the CPU, acts as a crude MMU (I/O at
page 3, ROM at `$C000–$FFFF`) *and* generates video; the display is **240×224 in 8 colours**; the
keyboard is a **passive matrix the CPU must poll**; tape is a **square wave on VIA port B bit 7**.

> Per `AGENTS.md`: for hardware/troubleshooting/community questions also search
> `forum.defence-force.org` live (`WebSearch` + `WebFetch`) and cite thread URLs — never scrape it.



## Success criteria for the week

1. Open the core repo and name what any folder or file is for — and whether it's worth opening.
2. Explain the Oric's memory map and each chip's job from memory.
3. Open any Oric-proper module in `annotated/rtl/` and say what any given block does.
4. Explain the serial-attribute colour model and the no-hardware-scroll constraint — the two facts every `ideas.md` game project depends on.
5. Trace one full input→output path end-to-end (keypress → VIA → CPU → RAM → ULA → screen).
6. `07-how-the-oric-works.md` exists and reads as a coherent story, not a pile of notes.
7. *(Bonus, Day 8)* Watched real signals confirm the model above — a CPU trace or a rendered ULA frame, not just a narrative about them.

---



## Ground truth: what the core actually contains

Mixed-language core. **VHDL** for the machine internals, **Verilog/SystemVerilog** for the MiSTer glue. Verified against the repo tree (master).

> This section is the `rtl/` **inventory** — which modules exist and what hardware each models.
> Day 0's `00-repo-map.md` covers the complementary half: the build system, the non-`rtl/`
> folders, and which of `sys/`'s 52 files ever matter. Don't duplicate one into the other.

```
Oric.sv                 ← emu top module (MiSTer dev top level; wires sys/ ↔ core)
rtl/
  oricatmos.vhd         ← top-level Oric machine wrapper
  ula.vhd  video.vhd    ← ULA + video pipeline (the heart of the Oric)
  m6522.vhd             ← 6522 VIA (I/O, keyboard, tape, timers)
  psg.v                 ← AY-3-8912 PSG (sound)
  keyboard.sv joystick.sv
  microdisc.vhd wd1793.sv pravetz8d_fdc.vhd   ← floppy controllers
  apple2_disk/          ← WD1793 shared with an Apple II disk impl (reuse)
  cassette.v cas_sig_gen.v                     ← original cassette path
  cload_patch_rom.v tap_byte_streamer.v tap_segment_loader.v tap_autorun_keys.v  ← Smart CLOAD tape engine
  snap_loader.v snap_ss.v savestate_hotkeys.v  ← snapshots + MiSTer savestates
  spram.v ddram.sv      ← RAM / SDRAM interface
  pll.v pll.qip pll/    ← clocking (Intel PLL megafunction — NOT simulable open-source)
  T65/                  ← 6502 soft CPU core
  rom/                  ← ROM images AS VHDL lookup tables. 13 files present but only 5 BUILT
                          (per files.qip): BASIC11A=Atmos, BASIC10=Oric-1, PRAVETZ8D,
                          PRAVETZ8D_FDC, MICRODIS (whose entity is named ORICDOS06!).
                          NOT built: BASIC11/11B/22, DIAG10 + TEST108J (Mike Brown diag ROM),
                          ORIC1SDCARD, test109, testsector. See annotated/rtl/rom/README.md
sys/                    ← MiSTer framework — DO NOT EDIT; real top is sys/sys_top.v, calls emu
tools/                  ← Python tape/snapshot tools (stdlib only) + oric-build (Docker/Quartus)
```

> **`docs/` status (updated Day 0):** README references `docs/`, `games/`, `_Games/` — they are **not** in official `MiSTer-devel/Oric_MiSTer`, but live on the maintainer fork ([nikiiv/Oric_MiSTer](https://github.com/nikiiv/Oric_MiSTer)). Copied into local `core/` on Day 0. Use them per the Sources table above; primary study material remains annotated RTL + wiki + books.

---



## MiSTer core anatomy (read once, applies to every core)

- The real top level is `sys/sys_top.v` — it instantiates a module called `emu` that the core provides (here, in `Oric.sv`). When Quartus builds, it builds `sys_top`, not your module.
- Everything under `sys/` is identical across all cores: OSD, input handling, video scaling, HDMI/VGA output, and `hps_io` (the bridge to the ARM/Linux side that loads ROMs, reads the OSD config string, etc.). Treat it as a black box with a known interface — do not try to read it all.
- The `rtl/` folder is the actual core. Free-form except `pll`.
- Mental model: `hps_io` hands files/config in → `emu` wires them to the `rtl/` machine → machine produces video/audio/SDRAM traffic → `sys/` formats output. **Your study target is** `rtl/` **+ the** `emu` **wiring in** `Oric.sv`**.**

Reading: [emu — Top Level of a MiSTer core (wiki)](https://github.com/MiSTer-devel/Wiki_MiSTer/wiki/emu---Top-Level-of-a-MiSTer-core) · [overview of emu module (docs)](https://mister-devel.github.io/MkDocs_MiSTer/developer/emu/) · [Template_MiSTer](https://github.com/MiSTer-devel/Template_MiSTer)

---



## Phases 0–4 — superseded by the sprint

These were the plan's original long-range framing before the Day 0–7 sprint existed. All five are
now either done pre-sprint or fully absorbed into the sprint above — nothing here is still open work.
Kept as a record of what fed into the sprint and where each deliverable lives.

| Phase | What it was | Status |
|---|---|---|
| **0 — Dev environment** | Install the open-source HDL stack (GHDL, Icarus, Verilator, GTKWave), clone `core/` as a gitignored sibling, smoke-test the toolchain. Quartus (0b) deferred — Linux/Windows-only, not needed for reading. | ✅ Done pre-sprint → `reference/dev-env.md` |
| **1 — Orient in the codebase** | Read `Oric.sv` and `rtl/oricatmos.vhd` top-to-bottom; sketch how the sub-modules connect. | ✅ Done pre-sprint → `reference/understanding-Oric-sv.md`, `reference/understanding-oricatmos-vhd.md`, `reference/block-diagram.md` (refreshed sprint Day 7), plus the `archive/learn-systemverilog/` and `archive/learn-vhdl/` lesson series |
| **2 — Learn the real Oric hardware** | Memory map, 6502/VIA/ULA/PSG architecture, paired with the wiki. | → **Executed by the sprint**, Day 1 (+ ULA half on Day 2). Deliverable: `01-oric-hardware-notes.md` |
| **3 — Enough HDL to read fluently** | VHDL/Verilog reading fluency, not authoring mastery. | ✅ Done pre-sprint → the lesson series + decoder cards (`archive/learn-*/reference/*-decoder.html`); no separate cheatsheet needed |
| **4 — Walk the core, module by module** | Read each module, annotate, write a short note — clocking → CPU → memory → ULA/video → VIA → sound → input → storage → MiSTer glue. | → **Executed by the sprint**, Days 1–6, at block level (per the Day 0 gear change) rather than the line-level decoder-card check this phase originally specified |

---



## Phases 5–6 — replaced by Day 8

The old "simulate a module" (5) and "optional build & run" (6) phases are **retired.** Simulation
is now **Day 8** of the sprint (above) — same open-source-only, no-Quartus, no-hardware scope, just
folded into the week instead of left as an untimed stretch goal. Building/deploying a `.rbf` to real
hardware is dropped entirely — out of scope for this project, whose goal is understanding the
machine, not building it.

---



## Required-reading map (wiki ↔ module)


| Studying                 | Read first                                                                    |
| ------------------------ | ----------------------------------------------------------------------------- |
| Anything                 | [[MiSTer-devel-Oric_MiSTer]] (core summary)                                   |
| Memory, CPU, VIA, PSG    | [[oric.free.fr]] (hardware manual)                                            |
| `ula.vhd`, `video.vhd`   | [[oric.signal11.org.uk]] (ULA reverse-engineering)                            |
| `rom/DIAG10`, `TEST108J` | [[oric.signal11.org.uk]] (diagnostic ROM)                                     |
| Storage / Microdisc      | Defence Force forum digest (storage threads)                                  |
| Whole-core context       | misterfpga.org t=4599; `[[OldWer-Metaphoric]]` for a hardware cross-reference |




## Open items / decisions

- [ ] Decide whether module notes from Days 1–6 get promoted into the wiki as a derived overview once mature.
- [ ] If/when `docs/` lands in official `MiSTer-devel/Oric_MiSTer`, drop the local fork copy and track upstream.
