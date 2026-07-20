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

**Expect an asymmetry — and exploit it (2026-07-16 session).** The **Oric reverse-engineering
scene is thin** compared to the Apple II's: there's no Oric equivalent of that rich catalogue of
beautifully-documented reverses (see the appendix's ~20-title Apple II list). So you'll have far
fewer worked examples to lean on here — it's more a solo deduction effort. **The workaround: use
the well-documented Apple II reverses — especially Robert Baruch's literate-programming Lode Runner
(Idea #4) — as your *textbook on how to read a game*, even though it's a different machine.** The
*method* transfers completely: find the input handler via the keyboard strobe, find the main loop
by breaking in the debugger, work outward from there. Learn the technique on the well-lit examples,
then apply it to the Oric. This also makes Ideas #2 and #4 mutually reinforcing rather than
competing for time.

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

**Confirmed exhaustively (2026-07-16 research session):** there is no Oric Choplifter — not
commercially in the 1980s, not as homebrew/remake since. Cross-checked the historical port lists
(incl. French-language sources), the Defence-Force games catalogue, the Oric Software Repository,
and the modern clone scene (PICO-8, ZX Spectrum "Chopper Defence", Unreal, HTML5 remakes — no Oric
entry). Telling detail: the closest port was the **French Thomson MO5/TO7** version (France Image
Logiciel, 1985) — the Oric was strongest in France, so a French Choplifter would plausibly have
been an Oric title if one were ever going to exist. It went to Thomson instead. Also confirmed:
Quinn Dunki's Apple II reverse is the **only** reverse-engineering of *any* Choplifter version
ever published — no C64/Atari disassembly to cross-reference for how another 8-bit solved the
port, and no arcade decompile. That single repo is the sole documented codebase on Earth.

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

**Difficulty analysis (2026-07-16 session) — where the cost actually sits:**

The reverse-engineered source helps far less than it looks, because ~90% of what makes Choplifter
impressive is its *renderer*, and the renderer is welded to Apple II video hardware with no Oric
counterpart. You'd be re-implementing an engine with the game design as spec, not porting code.

| Subsystem | Portability | Effort |
|---|---|---|
| Game logic / entities / physics / AI | Near-direct, well-documented | Low |
| Tuning constants (the "feel") | Free gift from the reverse | Trivial |
| Input & sound | Rewrite, but small & mechanical | Low |
| Sprite renderer (bit-packing, shift, clip) | Full rewrite for 6px linear | High |
| Colour under serial attributes | New problem, no Apple analogue | **Very high** |
| Smooth parallax scroll + attributes | New, bandwidth-constrained | High |

- **Pixel packing is structurally incompatible.** Apple II packs 7 px/byte with a phase shift on
  every other byte, and Gorlin does real-time division-by-seven to place sprites pixel-accurately.
  The Oric packs 6 px/byte, linear, no phase shift — so every shift/mask/clip calculation has to
  be *rederived*, not adjusted. (Silver lining: 6px linear is far simpler to code than the Apple's
  madness; you lose Gorlin's cleverness but don't need most of it.)
- **Serial attributes are the boss fight.** Coloured sprites moving freely across a two-tone
  horizontally-scrolling background is close to the *worst case* for the Oric's display model —
  every colour transition along a scanline physically consumes a 6-pixel cell and must be
  re-placed every frame as objects move, with colour bleeding to the right of anything that moves.
  On the Apple, a coloured sprite anywhere is essentially free. This is not a skill problem.
- **Scroll bandwidth.** Neither machine scrolls in hardware, but the Oric's ULA steals significant
  memory bandwidth during display *and* you're re-laying attribute bytes during the scroll —
  second-biggest risk after colour.

**Effort estimate:** monochrome playable in ~4–8 weeks of evenings; a colour version that actually
evokes the original in ~3–6 months, with colour/scroll interaction the most likely place to
compromise or give up.

**Scope question — RESOLVED (2026-07-16):** go **Oric-native**, not faithful-pixel-match. Reasoning:
a literal port can't match the Apple (the free-colour scrolling trick is Apple-only, structurally),
but *"best possible Choplifter for the Oric"* can equal or beat it — lock the sky/ground split and
sprite colour zones to attribute-cell boundaries **from day one**, so serial attributes cost almost
nothing and stop bleeding. This is what the best ZX Spectrum games did: embrace the colour model
rather than port into it. You keep Gorlin's entire logic layer and tuning constants (identical
feel), gain the AY-3-8912 for genuinely better sound than the Apple's 1-bit speaker, and spend the
saved effort on Oric-native art direction. The design simply never attempts free-moving
arbitrary-colour sprites over a scrolling two-tone field, so the constraint never bites.

Open questions to resolve before starting:
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

## 4. Port Lode Runner (Apple II) to the Oric — the *easier* twin of Idea #3

Goal: same shape as Idea #3 (Apple II reverse → Oric reimplementation), but on a game whose
architecture *cooperates* with Oric hardware instead of fighting it. Emerged from the 2026-07-16
session while sanity-checking the assumption that "an Apple II reverse is an Apple II reverse."
That assumption is wrong, and usefully so: **difficulty lives almost entirely in the renderer and
scroll model, and Choplifter and Lode Runner sit at opposite ends of that spectrum.**

**Source material — arguably better than Choplifter's.** Robert Baruch's reverse
([`XekriRedmane/lode_runner_reveng`](https://github.com/XekriRedmane/lode_runner_reveng), a
maintained fork of the original) is a *literate program*: a noweb/TeX document (`main.nw` →
`main.pdf`) where prose and code are interleaved, explicitly written to be **read and understood**,
tangling out to a binary byte-for-byte identical to the original disk. Designed as an explanation,
not just commented code.

**Why it's much friendlier to the Oric than Choplifter:**
- **No scrolling at all.** Single-screen, tile-based — the entire level fits one fixed screen.
  Choplifter's hardest Oric problem (smooth h-scroll the Oric physically can't do in hardware)
  *vanishes entirely*.
- **Grid-aligned and largely monochrome.** Mostly white-on-black hi-res, static tile-grid
  background. Choplifter's second-worst problem (free-moving coloured sprites over a two-tone
  scrolling field) doesn't exist here — assign colour per tile-cell aligned to the attribute grid
  and serial attributes cost you almost nothing. *The exact thing that fought Choplifter cooperates
  with Lode Runner.*
- **~28-column tile grid** maps almost perfectly onto the Oric's 40-column cell layout.
- **Already table-driven.** `pixel_shift_table.asm`, `pixel_pattern_table.asm`,
  `row_to_offset_hi/lo_table.asm` — it uses pre-shifted sprite patterns rather than Choplifter's
  real-time divide-by-seven. You *rebuild tables* for 6px linear rather than rewriting geometry,
  and `row_to_offset` actually gets **simpler** on the Oric (linear `$A000 + row×40` vs. the
  Apple's interleaved lookup).

**The new hard part (different flavour):** **150 levels streamed from disk** (16 per track).
Choplifter was single-load — boot once, never touch storage. On the Oric this is a *media* problem,
not a rendering one: tape is painfully slow for that many loads and the Microdisc is rare. Design
around it (pack levels into RAM, accept tape loads between level groups, or target modern SD
storage). Secondary: the dig-hole/refill mechanic mutates the playfield (dynamic tile modification
+ per-cell redraw) — but it's cell-local, never full-screen, so it ports as cheap logic.

Open questions:
- **Idea #3 vs #4 ordering:** Lode Runner is the far safer bet to end up looking and playing like
  the original. Worth doing *first* as the confidence-builder, with Choplifter as the ambitious
  follow-up once the Oric renderer/toolchain muscles exist?
- **Storage target** drives the level-loading design — decide before starting (see the shared
  storage note in the appendix below; it's the same fork as Idea #5's).
- **Licensing:** same caveat as Ideas #2/#3 — derivative of a commercial 1983 Brøderbund title via
  a personal reverse-engineering project. Personal study only; credit Doug Smith/Brøderbund and
  Robert Baruch.
- Sibling candidates in the same literate style, if Lode Runner goes well: **Ali Baba and the Forty
  Thieves** (1982, tile/grid CRPG, single-screen rooms — very Oric-friendly for the same reasons)
  and **Zork I's Z-machine interpreter** (essentially no graphics; the interesting work is fitting
  interpreter + story file in memory — arguably the easiest of all to get running on an Oric).

## 5. Write a dBASE II-class database for the Oric

Goal: a small xBase-style database engine — the dot-prompt, `.DBF` files, `@ SAY/GET` data-entry
forms — native on the Oric Atmos. A completely different *kind* of hard from the game ports:
software-architectural rather than hardware-hostile.

**Reframing the target (the key move):** FoxPro and Clipper as commonly known are 16-bit DOS-era
and can't be scoped down — FoxPro needs megabytes, and Clipper's whole identity is *compiling*
xBase to standalone DOS executables. But the family descends from **dBASE II**, hand-written in
assembly, running on 8-bit CP/M in 64K — and crucially there was a **native Apple II (6502) dBASE II
in 1980**. Same CPU, comparable RAM to the Oric. So this isn't "can it be done" but "how much of
it." Build an **interpreter** (parse-and-execute the dot-prompt and `.prg` line by line, as dBASE II
did), *not* a compiler — the Clipper path is a different, much larger project. Drop it.

| Component | Difficulty on Oric | Notes |
|---|---|---|
| `.DBF` file format | Easy | Header + fixed-length records. Public, dead simple. Almost free. |
| Dot-prompt command parser | Moderate | `USE`/`APPEND`/`LIST`/`LOCATE`/`REPLACE`. Line-oriented tokenizer. |
| Expression evaluator | Moderate | Arithmetic/string/logical + `SUBSTR`, `TRIM`, `DTOC`. Recursive descent. |
| `.prg` procedural language | Moderate–hard | `DO WHILE`, `IF`, `DO CASE`, memvars, parameters. |
| Screen forms (`@ SAY`/`GET`) | Moderate | **Fits the Oric well** — text-cell layout is its comfort zone. |
| Index files (B-tree `.NDX`) | Hard | The one genuinely hard algorithmic piece. Disk-backed B-tree in asm. |
| Memo fields, `SET RELATION` | Hard | Cut entirely from a subset. |

**The two real constraints** (everything hard collapses onto these, the way the games collapsed
onto scrolling and colour):

1. **RAM** — 48K, ~37K usable. dBASE II was tight even in 64K CP/M *as hand-optimized assembly*.
   Interpreter + parser tables + user `.prg` + memvars + record buffers must coexist. This caps how
   rich the language subset can be. A ceiling on ambition, not a blocker.
2. **Storage — this project's "serial attributes."** A database is fundamentally *random access to
   records on secondary storage*, precisely the Oric's weakest area. **The storage target defines
   the product:**
   - **Tape (stock Oric):** effectively no random access. Only sequential batch processing — load
     whole file, operate, write back. Viable *only* if the table fits in RAM (a few hundred small
     records). Below that limit it works fine; above it, impossible rather than merely slow.
   - **Microdisc (3" floppy):** real random access, ~160K/disk — unlocks a genuine xBase with
     indexes and tables bigger than RAM. But rare hardware.
   - **Modern SD interfaces / Telestrat:** random access, effectively unlimited. On a
     modern-equipped Oric or in an emulator, this constraint simply evaporates.

**Suggested MVP** (recognisably dBASE, achievable): `.DBF` create/open/close, `APPEND`,
`DISPLAY`/`LIST`, `GOTO`/`SKIP`, `LOCATE`/`CONTINUE`, `REPLACE`, `DELETE`/`PACK`; the expression
evaluator; a modest `.prg` interpreter; `@ SAY/GET` forms; **linear scan only — no index files in
v1** (accept O(n) `LOCATE`, as early tiny databases did). Dropping the B-tree is the single biggest
scope cut and removes most of the risk; add `.NDX` in v2 once the interpreter is solid.

**Effort:** MVP ~2–4 months of evenings; a genuinely useful *indexed* version ~6–12 months. More
work than a game port (you're building a language runtime **plus** a storage engine), but far less
hardware-hostile — nothing here fights the Oric the way pixel colour does.

**Notably: no reverse-engineering step at all.** The `.DBF` format and dBASE command language are
fully documented public standards, with the whole xBase/Harbour open-source lineage to crib
semantics from. Unlike the games, you're implementing to a spec. The interpreter core
(tokenizer → expression evaluator → statement executor) is the reusable heart; get it right and
adding commands is incremental.

Open questions:
- Check whether **any database software already exists for the Oric**, to know what this would sit
  next to (not yet researched).
- Decide the storage target early — it shapes the assembly layer more than any language choice.

## 6. Write a small CP/M-like OS for the Oric — the capstone

Goal: build a **CP/M-*inspired* 6502 DOS** for the Oric — command interpreter, file abstraction,
block storage layer — framed explicitly as *"build my own DOS in order to understand DOSes."*

**Two framing caveats, stated up front so the scope stays honest:**
- It is **not CP/M itself, and "port CP/M to the Oric" is not a thing that can exist.** CP/M is an
  8080/Z80 operating system *welded to that instruction set* — you cannot port it to a 6502 without
  adding a Z80 co-processor card. What you *can* write is a **CP/M-inspired disk OS for the 6502**:
  the CCP/BDOS/BIOS structure, a file system, a command shell. Real and worthy — just not "porting
  CP/M," and worth being precise about so the goal stays achievable.
- It **lives next to SEDORIC, not replacing it.** The goal is understanding by construction, not
  displacing the Oric's existing, mature DOS.

**Sequencing decision — app before OS (the non-obvious call).** The intuitive order is OS first,
since an OS sits *below* an app. For this learning arc the reverse is better, for two reasons:

1. **The database forces you to build the OS's hardest subsystem anyway.** On the Atmos you get no
   file I/O for free (see the appendix's cc65 caveat), so Idea #5 already requires a storage layer:
   block read/write, a file abstraction, buffer management. That is precisely the most OS-like part
   of an OS — but built in a small, well-defined context where you can actually get it right. You
   arrive at this project having already solved its scariest component.
2. **An app has a natural "done"; an OS doesn't.** The database is finished when it works and you
   use it. An OS's scope is open-ended and very easy to rabbit-hole in — far better to start it
   with a storage layer that's already battle-tested.

**Where it sits in the overall arc.** Across the whole backlog there's a satisfying two-half shape:

- **Goals 1–3 — *the machine*:** understanding the hardware (the in-progress
  [`mister-fpga-oric-core-understanding/`](mister-fpga-oric-core-understanding/) project), then
  reading someone else's code (Idea #2), then producing against a reference (Ideas #3/#4).
  Goal 1 is the foundation the rest stand on and the one you never "finish" — but the Oric is
  close to an *ideal* machine for it: the whole thing fits in one head (6502, one ULA, one sound
  chip, a 16K ROM you can fully understand, no operating system in the way), and Defence-Force's
  coding series documents the deep quirks — ULA address recomputation, serial attributes, timing —
  better than almost any 8-bit machine gets. For an experienced engineer the new material isn't
  *programming*, it's the Oric-specific silicon, so it ramps fast.
- **Goals 4–5 — *systems software*:** an application (Idea #5), then the platform under it (this).

First half is learning how the Oric thinks; second half is building the kind of software that, in
1983, would have made the Oric a serious tool rather than a toy. Writing a CP/M-class DOS *and* a
dBASE-class app for a machine is, more or less, recreating the software stack that turned home
computers into business machines. As a capstone it pulls in everything from the hardware-
understanding work and the database work at once.

**Suggested order:** run goal 1 (hardware understanding) *throughout*, then 2 → 3 → 4 → 5, with
the app-before-OS ordering above being the one deliberate inversion.

**Insert a "goal 0" before any of it (recommended warm-up).** Write one small *original* program
that takes over the machine: seizes RAM, does text I/O through the ROM routines, reads the
keyboard, saves/loads a block to tape or disk. Probably an afternoon's work given an experienced-
engineer background — but it nails down the toolchain, the boot/load flow, and the memory-takeover
model (see appendix) **before** you're simultaneously fighting someone else's undocumented code.
Confidence and plumbing sorted first, *then* reverse-engineering.

**The difficulty curve is not monotonic — don't assume later = harder.** Goals 1–3 are about *the
machine and its graphics*, where the Oric is quirky and sometimes actively hostile (serial
attributes, no hardware scroll, ULA bandwidth theft). Goals 4–5 are about *software architecture*,
where the Oric mostly gets out of your way. So the graphics-heavy middle — a scrolling game — can
genuinely be **harder than the app at the end**. Choose the goal-3 game accordingly (Idea #4 over
Idea #3 as the first port) and the whole path stays enjoyable rather than grinding.

**Also fine: pick only *one* of Ideas #5/#6 as the capstone.** Both are large projects; the arc is
complete with either one. They're presented as 4→5 because of the storage-layer overlap, not
because both are required.

Open questions:
- How much CP/M structure to actually mirror — a real BDOS/CCP/BIOS split (maximum learning, more
  scaffolding) vs. a looser "my own DOS" shape informed by CP/M rather than imitating its layout.
- Whether to target CP/M *API* compatibility at any level (probably not worth it: 6502 vs. Z80
  calling conventions make binary compatibility impossible, and source-level compatibility buys
  little without a CP/M software library to run).
- Interaction with SEDORIC — coexist on separate disks, or read SEDORIC-format media?
- Same storage-target fork as Idea #5 (tape / Microdisc / modern SD) — decide once, share the layer.

---

## Appendix — shared platform notes (apply to Ideas #3, #4, #5, #6)

Captured 2026-07-16; these are cross-cutting, so they live here rather than being repeated per idea.

### Language & toolchain choice

- **C via [OSDK](https://osdk.org)** — the community-standard modern path: `lcc65` (retargeted lcc
  with Fabrice Frances' 6502 code generator, 16- and 32-bit int variants), André Fachat's **XA**
  cross-assembler, peephole optimizer, linker, tape/disk builders. Windows-native (runs under
  Wine). `lcc65` isn't a heavy optimizer, but for control-flow-heavy interpreter logic that barely
  matters. **`osXdk` is the Unix fork** — relevant since this machine is macOS.
- **cc65** — better-known, better-optimizing, native macOS/Linux/Windows, proper Atmos target
  (~37K available, ROM calls supported). **Critical caveat:** its Atmos library implements **no C
  file I/O** — `fopen`/`fread` don't exist, only stdin/stdout hacks. For a *database* that means
  the storage layer is assembly regardless of compiler choice, so cc65's cleaner tooling doesn't
  save you from the hardest plumbing.
- **6502 assembly (XA)** — unavoidable for storage engine and hot paths.
- **Recommended hybrid:** C for the "cold" bulk (parser, expression evaluator, statement
  interpreter, form logic) + hand-written XA assembly for the "hot"/low layers (record buffers,
  field-compare inner loops, index traversal, all actual storage I/O). Mirrors how the era's real
  database engines and the good Oric games were built.
- **Wildcard: Forth** (FIG-Forth lineage existed on the Oric). Unusually good fit for Idea #5
  specifically — Forth *is* an extensible interpreter framework, and a dot-prompt xBase is exactly
  a domain-specific command language; far more memory-frugal than a C runtime. Still drops to
  assembly (or CODE words) for storage I/O. Acquired taste.
- **Oric Extended BASIC** — non-starter for any engine (interpreter-on-an-interpreter). Fine only
  for throwaway prototyping of a form or two.

### Boot & memory-takeover model (how a standalone Oric app actually works)

Don't think *"boot without BASIC."* On a stock Atmos the 16K ROM is **always** mapped at
`$C000–$FFFF` and contains both BASIC *and* the low-level system routines (keyboard scan, screen
output, tape read/write, interrupt handlers). You can't remove it — and you don't want to. The
model is: **load a machine-code binary that then takes over the whole machine** — it reclaims
essentially all of BASIC's RAM (program area, variable space, most of zero page), sets up its own
world, and never returns to the `Ready` prompt, while still calling the ROM's I/O primitives
(exactly as Apple II games called their monitor ROM). BASIC is present but dormant.

- **Tape:** launch with a single `CLOAD""`. The Oric tape header has an **autorun flag** — set it
  and the code executes the moment loading finishes. "Loaded from BASIC" is technically true, but
  it's one command and BASIC is then out of the picture. The normal Oric distribution story.
- **Disk (Microdisc + SEDORIC, or modern SD):** the Microdisc interface has its own boot EPROM, so
  on reset it can boot the disk directly and SEDORIC can autorun your program — closest to "boots
  straight into the app." Cost: SEDORIC is RAM-resident and eats a chunk of memory.
- **Purist option (skip it):** the Oric *can* disable its ROM via the **ROMDIS** line (used by the
  Microdisc and some expansions) and map RAM over `$C000–$FFFF` for a full 64K RAM machine — but
  you lose the ROM's keyboard/screen/tape routines and must write all of that yourself. Rarely
  worth it, and definitely not for a text-mode app that wants exactly those routines.
- **Useful bonus for text-mode apps (e.g. Idea #5):** the 8K HIRES screen RAM around `$A000` is
  only being displayed by the ULA when in HIRES mode. Run in TEXT mode (screen sits up near
  `$BB80`) and that region isn't feeding the display — it becomes usable general RAM. So a
  text-mode app that takes over the machine reclaims **both** BASIC's workspace *and* the unused
  graphics RAM, ending up with meaningfully more than the ~37K a well-behaved BASIC-resident
  program gets.

### Reference: reverse-engineered Apple II software (port-candidate pool)

Roughly 20 titles are publicly reverse-engineered — useful as a candidate pool for future
Apple-II→Oric projects. Grouped by source:

- **[6502disassembly.com](https://6502disassembly.com) (Andy McFadden)** — largest single
  collection: Bill Budge's 3-D Graphics System (1980), Bomber (1978), Caverns of Freitag (1982),
  Deathmaze 5000 (1980), Elite (1984, *partial*), Epoch (1981), The Graphics Magician – Picture
  Painter (1984), Micro-Painter (1980), Penny Arcade (1979), Phantoms Five (1980), Sabotage (1981),
  Scott Adams Adventures / Golden Voyage (1980), Space Eggs (1981), Starship Commander (1981,
  mostly BASIC), Stellar 7 (1983). Also carries system reverses (Applesoft/Integer BASIC, //c ROMs,
  DOS 3.3 boot).
- **Robert Baruch (literate-programming `main.nw` → PDF family):** Lode Runner (1983), Ali Baba and
  the Forty Thieves (1982), Zork I Z-machine interpreter rev 15.
- **Standalone:** Choplifter (1982, Quinn Dunki / blondie7575), Robotron: 2084 (1983, *partial*,
  F. Schuhi).
- **Not reverses — original source released by the author** (equally usable as reference):
  Prince of Persia (Jordan Mechner), The Bilestoad, Pinball Construction Set (Bill Budge).

**Oric-friendliness ranking of that pool:** single-screen / tile-grid / text titles are the
friendly candidates (Lode Runner, Ali Baba, Zork + Scott Adams interpreters, Space Eggs, Bomber);
vector/3D ones (Stellar 7, Elite) are a *different* challenge (line-drawing math rather than
attribute wrangling); free-scrolling coloured ones (Choplifter) are hardest.
