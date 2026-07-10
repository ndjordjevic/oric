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
