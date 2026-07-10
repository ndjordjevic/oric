# Project ideas

A running list of candidate Oric (and related retro) projects. Not commitments — just a
backlog to pull from. Move an idea into its own `projects/<name>/` folder once it's actually
started (see `mister-fpga-oric-core-understanding/` for the pattern).

## 1. Explore the Oric machine-code monitor (assembly monitor)

Goal: understand what a "system monitor" — a resident tool for entering, disassembling,
memory-dumping, and single-stepping 6502 machine code — looks like on the Oric, then decide
whether to study/revive an existing one, port one forward, or build something new.

**Correction (2026-07-10):** first pass at this entry assumed nothing native had ever existed
for the Oric, based only on the local wiki/books/forum-digest (which have no dedicated source
on this) plus a shallow web check. A deeper web search (two parallel research passes, with
direct fetches to verify conflicting claims) shows that's wrong — **at least three commercial
monitor/assembler products shipped in 1983**, plus a modern homebrew debugger port. The niche
was not underserved; the tools are just obscure and now hard to find, not absent.

**What already exists — verified:**

- The Oric ROM still has **no built-in monitor** (unlike the Apple II's ROM Monitor) — every
  option below was always third-party.
- **ORICMON** (Tansoft, 1983, by Geoff M. Phillips & Paul Kaufman) — "a complete machine code
  monitor including block move and a mnemonic Assembler/Disassembler," Oric-1 and Atmos
  (16K/48K), cassette. [oric.org listing](https://www.oric.org/software/oric_mon-145.html).
- **ORIC-MON** (PSS, 1983, by A. J. Clarke) — a separate product despite the near-identical
  name; v1.0 Oric-1-only, v1.1 added Atmos support; English + French manuals.
  [oric.org listing](https://www.oric.org/software/oric_mon-79.html).
- **ORION** (AWA Software, later MC Lothlorien, 1983, by S. Hughes) — assembler +
  disassembler + monitor resident at `$8100–$97FF`, with a `PDUMPO` utility to print
  disassembly to the printer port; one owner called it their debugging "bread and butter"
  into the 1990s. [oric.org listing](https://www.oric.org/software/orion-1507.html).
- Durrell Software also sold an "Assembler/Disassembler" package in 1983 (lower confidence —
  seen only via a GameFAQs listing, not independently verified).
- **Period type-in listings** (already catalogued in this repo, still worth typing in as a
  simpler study artifact): *The Oric-1 Program Book* (Vince Apps, 1983) p.117 — catalogued at
  [`../books/oric/the-oric-1-program-book.md`](../books/oric/the-oric-1-program-book.md); and
  *Machine Code for the Atmos and Oric-1* (Bruce Smith, Shiva, 1984) — catalogued at
  [`../books/oric/machine-code-for-the-atmos-and-oric-1.md`](../books/oric/machine-code-for-the-atmos-and-oric-1.md).
- **Modern homebrew:** a real, *native* on-Oric 6502 resident-monitor program exists — a Oric
  port of **NoICE** (a PC-hosted 6502 debugger). The resident monitor (`mon6502.dsk`/`.tap`)
  runs as ordinary Oric machine code and talks to PC-hosted NoICE over a serial link; the
  working demo used Oricutron's `--serial modem:65020` emulation rather than a confirmed real
  serial cable, and it can't debug code that changes the IRQ vector (which rules out most
  games). Discussed in [forum topic 1896](https://forum.defence-force.org/viewtopic.php?t=1896)
  (verified by direct fetch) — not yet in the local forum digest.
- **Modern tooling:** [Oricutron](https://github.com/pete-gordon/oricutron) (the reference
  emulator) separately ships its own full built-in monitor/debugger (F2) — disassembler,
  memory dump, breakpoints, register display, symbol-file loading. This is *emulator*
  tooling, not something that runs on real hardware, but it's the easiest way to learn what a
  6502 monitor's feature set looks like before touching any of the above.
- The [OSDK](https://osdk.org) toolchain (XA assembler; see `RESOURCES.md` §8 and
  `books/INDEX.md`) is the natural choice for any new 6502 assembly work here.
- Other forum threads worth reading if this idea gets picked up, not yet in the local digest:
  [Assembler / disassembler](https://forum.defence-force.org/viewtopic.php?t=1765),
  ["Towards an onboard Oric Assembler/Editor Development environment"](https://forum.defence-force.org/viewtopic.php?t=2430)
  (brainstorming, mentions a tool called MONASM, no shipped result), and a 2015 thread
  recommending **ASMOS** as an accessible on-machine assembler/monitor but noting poor
  documentation for these old tools in general
  ([forum topic 1199](https://forum.defence-force.org/viewtopic.php?t=1199)).

**Why this apparently never became one dominant, well-documented tool** (like Supermon on the
C64 or the Apple ROM Monitor), despite genuinely competitive early sales (~160K UK + 50K+
France in 1983, France's #1 seller that year): Oric Products International went into
receivership twice (Feb 1985, Dec 1987), fragmenting the install base across Oric-1 / Atmos /
Stratos / Telestrat and starving any one tool of a stable, lasting market; period manuals were
often thin or awkwardly translated, so none of the three period tools built the kind of
lasting reputation Supermon did.

Open questions to resolve before starting:
- **Direction:** track down and try to run one of the three period tools (ORICMON, ORIC-MON,
  ORION) on Oricutron or real hardware first — cheapest way to see what "done" looked like in
  1983 — vs. studying/extending the NoICE port toward real serial hardware vs. typing in and
  studying the period BASIC listings vs. writing something new from scratch.
- If extending NoICE or building a native on-hardware monitor: what feature set, and what
  triggers a break — the keyboard NMI key (`swnmi`, wired straight to the 6502's `NMI_n` — see
  [`mister-fpga-oric-core-understanding/01b-oricatmos-vhd-understanding.md`](mister-fpga-oric-core-understanding/01b-oricatmos-vhd-understanding.md)
  §13) is an obvious real-hardware breakpoint mechanism.
- What interface: keyboard command line (like Oricutron's F2 monitor or the period tools) vs.
  a serial link out via Microdisc/LOCI (like the NoICE port) for a host-side debugger.
- Whether working `.tap`/`.dsk` images and manuals for ORICMON/ORIC-MON/ORION actually survive
  in a usable state, or whether this would also become a preservation/archaeology task.

## 2. Reverse-engineer a favorite Oric game (played via MiSTer + joystick)

Goal: pick an Oric game genuinely enjoyed on the MiSTer core with a joystick, then reverse-
engineer it — disassemble, annotate, understand the ROM/RAM layout, sound, and input handling
— as a concrete, motivating way to learn Oric hardware and 6502 assembly, rather than studying
in the abstract.

**Tools already in hand, from work already done in this repo:**

- [`mister-fpga-oric-core-understanding/01b-oricatmos-vhd-understanding.md`](mister-fpga-oric-core-understanding/01b-oricatmos-vhd-understanding.md)
  already documents exactly how joystick input reaches the game: `joystick.sv` maps the MiSTer
  USB gamepad to VIA Port A bits via `via_pa_joy_value`/`via_pa_joy_mask`, selected by
  `joystick_adapter` (see §13). Useful for
  understanding *how* a game reads the joystick in its input-poll routine, and for confirming
  which joystick "protocol" (there were multiple incompatible Oric joystick interfaces
  historically) a given game expects.
- The same core exposes full **snapshot save/restore** (`.sna`) and **MiSTer savestates**
  (F1–F4 save / F5–F8 restore) — see 01b §18. This is a shortcut for RE work: pause the game at
  an interesting moment (e.g. right before a specific event) and capture a complete memory/CPU/
  VIA/PSG/ULA snapshot to pick apart offline, rather than single-stepping from cold boot.
- The core's own `tools/tape-inspect.py` and `tools/sna-inspect.py` (see
  `mister-fpga-oric-core-understanding/core/README.md`) can inspect a game's `.tap`/`.sna` file
  directly — a natural first step before touching a disassembler.
- **Idea #1** (above) is directly complementary — a working machine-code monitor/debugger
  (Oricutron's built-in F2 monitor is the zero-setup option) is what actually drives the
  disassembly and single-stepping.
- The [OSDK](https://osdk.org) XA assembler (`RESOURCES.md` §8) is the natural tool for
  reassembling/annotating extracted code, if the goal extends to modifying or rebuilding parts
  of the game.
- Reference material for reading the disassembly: `oric.free.fr`'s Hardware Programming How-To
  (register-level VIA/PSG/ULA reference) and the *Oric Advanced User Guide: ROM Disassembly*
  (catalogued at [`../books/oric/oric-advanced-user-guide-rom-disassembly.md`](../books/oric/oric-advanced-user-guide-rom-disassembly.md))
  for cross-checking ROM routine calls the game makes.
- One forum thread not yet in the local digest looks relevant: ["Disassemblies"](https://forum.defence-force.org/viewtopic.php?t=584)
  (technical-questions subforum) — worth checking before starting in case the chosen game (or
  a similar one) already has a public partial disassembly to cross-check against.

Open questions to resolve before starting:
- **Which game.** Not yet chosen. Criteria worth weighing: joystick-controlled (matches the
  stated MiSTer + joystick play style); reasonably simple (a first RE project benefits from
  avoiding heavy compression/self-modifying code); ideally well-known enough that community
  notes or an existing partial disassembly exist to cross-check against (see the "Disassemblies"
  thread above); available as a clean `.tap`/`.dsk` dump.
- **Licensing/scope:** RE'ing a commercial game is fine for personal study and understanding,
  but redistributing a modified/annotated binary would raise the same licensing questions noted
  in the sibling `amiga-learning/projects/ideas.md` RE entry — treat this as a personal-notes
  project, not a release.
- **Depth:** full disassembly of the whole game vs. targeting specific subsystems first (input
  handling, main game loop, sprite/character-set update, sound) — the latter is more consistent
  with "make sure I understand Oric HW and assembly," since the goal is understanding, not a
  complete annotated ROM dump.
- **Tooling order:** whether to start with Oricutron's F2 monitor (zero setup) and only build a
  native monitor (Idea #1) if a real-hardware angle becomes worthwhile later.

## 3. Rewrite Choplifter (Apple II) for the Oric

Goal: port/rewrite Dan Gorlin's **Choplifter** (Brøderbund, 1982) — a horizontally-scrolling
helicopter rescue/shooter, one of the best-known Apple II games of its era — from Apple II to
the Oric. This is a step beyond Idea #2: not just reverse-engineering to understand a game, but
reimplementing one on genuinely different graphics/sound hardware.

**Why this game, and why it's a real gap:** Choplifter was ported the same year to Atari 8-bit,
and later to the VIC-20, Commodore 64, Atari 5200, ColecoVision, MSX, and Thomson computers — it
was even ported *backward* to arcade hardware by Sega in 1985 (unusually, home-computer-first).
Checked `oric.org`, the forum digest, `RESOURCES.md`, and `books/INDEX.md`: no evidence it was
ever ported to the Oric. Every contemporary got a Choplifter except this one.

**A major head start already exists:** Quinn Dunki (blondie7575) did a full clean-room reverse
engineering of the original Apple II binary — [`ChoplifterReverse` (GitHub)](https://github.com/blondie7575/ChoplifterReverse),
with an accompanying [write-up](https://blondihacks.com/reversing-choplifter/) — fully commented
6502 source that rebuilds byte-identical to the original. This is real annotated source to study
and adapt, not a raw binary to disassemble from scratch.

**What actually needs rewriting vs. what carries over:**
- Both machines run a plain 6502 (Apple II 6502; Oric 6502 @ 1 MHz) — the game *logic* (flight
  physics, tank/plane AI, hostage state machine, collision detection, scoring) should translate
  fairly directly from the reverse-engineered source.
- **Video is the real rewrite.** Apple II hi-res bitmap graphics vs. the Oric's ULA-generated
  TEXT/HIRES modes with inline "serial attribute" bytes for color/blink (see `oric.free.fr`'s
  Hardware Programming How-To). Neither machine has hardware sprites or hardware scrolling, but
  the two hi-res schemes are structurally different enough that redraw/animation routines need
  rewriting, not porting.
- **Sound is a genuine upgrade opportunity.** The Apple II original used only the single click
  speaker; the Oric has a real AY-3-8912 PSG (3 tone channels + noise + envelope) — an Oric
  version could sound better than the original ever did.
- **Input** — Apple II paddle/joystick port vs. the Oric's VIA-based joystick interface — ties
  directly into Idea #2's research on `joystick.sv`/VIA PA mapping
  ([`01b-oricatmos-vhd-understanding.md`](mister-fpga-oric-core-understanding/01b-oricatmos-vhd-understanding.md)
  §13).
- **Timing** — the Oric's CPU/video RAM contention (`PHI2` timesharing, same doc §8) is a
  real-time constraint the Apple II doesn't share in the same form; frame-timing assumptions in
  the original source likely won't just carry over.
- [OSDK](https://osdk.org)'s XA assembler (`RESOURCES.md` §8) is the natural toolchain for the
  new 6502 code; Oricutron for iteration before deploying to the MiSTer core + joystick.

Open questions to resolve before starting:
- **Scope:** a faithful reimplementation (matching the original's look/feel as closely as Oric
  hardware allows) vs. an Oric-native reinterpretation that leans into the platform's own
  resolution/color/sound tradeoffs rather than trying to pixel-match the Apple II version.
- **Relationship to Idea #2:** is this the specific game that answers Idea #2's open "which
  game" question, making the two the same project — or do they stay separate (Idea #2 as
  "understand an existing Oric game," this as "build a new Oric game from an Apple II source")?
- **Licensing:** same caveat as Idea #2 — this is derivative of a commercial 1982 Brøderbund
  game (via Quinn Dunki's reverse-engineered source, itself a personal project, not an official
  release). Treat as personal learning/study; credit Dan Gorlin/Brøderbund and Quinn Dunki if
  ever shared, and don't sell or widely redistribute a finished build.
- **Starting point:** study `ChoplifterReverse`'s annotated source directly vs. doing an
  independent disassembly of the Apple II binary first for the practice (redundant with Idea #1/
  #2's disassembly-skill goals, but slower).
