---
type: journey-note
title: "Building a new Oric — research and decision paper"
created: 2026-05-17
status: research complete (decision pending human approval)
related_wiki:
  - "[[OldWer-Metaphoric]]"
  - "[[Board-Folk-Oric-Remix]]"
  - "[[JennyDigital-OriClone-1]]"
  - "[[48katmos.freeuk.com]]"
  - "[[oric.free.fr]]"
  - "[[forum.defence-force.org]]"
  - "[[raxiss.com]]"
  - "[[sodiumlb-loci-firmware]]"
  - "[[wiki.defence-force.org]]"
---

# Building a new Oric — research and decision paper

> **Goal:** decide how to bring an Oric Atmos / Nova 64 back into the house in 2026, and how to start the build.
>
> **Status:** research first pass. Covers the candidate landscape, the critical sourcing realities, an authenticated `forum.defence-force.org` thread inventory (§13), and a four-phase recommendation (§9). Awaiting your sign-off before placing the first BOM order.

---

## 1. Why this paper exists

You grew up on an **Oric Nova 64** — the Yugoslav-licensed Atmos sold by Avtotehna in Slovenia (and across Yugoslavia) from 1984. The Nova 64 was an Atmos in every meaningful way: same 6502A CPU, same HCS10017 ULA, same AY-3-8912 PSG, same Tangerine ROM. The only differences were the silkscreen on the case (`ORIC NOVA 64` instead of `Oric Atmos 48K`) and the keyboard labelling. The "64" in the name marketed the 64 KB DRAM that the Atmos already had — 16 KB of it masked at startup by the BASIC ROM, leaving you with 48 KB. (See Wikipedia's Oric article and `oldcrap.org`'s teardown of an actual Nova 64.)

So when you "build an Oric" today, you're really building an Oric Atmos. The Nova badge is a paint job we can recreate later, after we've solved the hard problem: getting a working machine on the desk.

The two repos already cloned into this folder structure are the two main 2025/2026 candidates: [[OldWer-Metaphoric]] and [[Board-Folk-Oric-Remix]]. There are at least two more credible options worth knowing about before you commit. This paper compares all of them, identifies the real blockers, and recommends a starting path.

---

## 2. What you actually need (functional brief)

Before any board comparison, let's be explicit about the goal.

| Need | Priority | Why |
|---|---|---|
| Boots an Oric Atmos ROM and runs Atmos software | **Must** | Otherwise it's not the machine of your childhood. |
| Outputs to a modern display (HDMI/scart-to-HDMI/composite) | **Must** | No CRT in 2026. |
| Has a keyboard you can actually type on | **Must** | Original Atmos keys are a known weak point; Nova boards reportedly had brittle solder joints on the keyboard too. |
| Loads software from SD card / USB stick (no tapes) | **Must** | Cassette loading on the Oric is famously bad even with good tapes; no original tapes will load reliably in 2026. |
| Looks like an Oric (case, layout, vibe) | **Should** | This is a nostalgia build, not a SBC. |
| Re-skinnable as an "Oric Nova 64" | **Nice** | New silkscreen / case label is a separate small project. |
| Pretty close to original electrical behaviour (sound, palette, timing) | **Should** | So games and demos look/sound right. |
| Possible to fix and modify yourself | **Should** | This is a long-term hobby machine, not a sealed appliance. |
| Buildable with skills you have, in time you have | **Constraint** | Through-hole soldering: yes. BGA / fine-pitch SMD: probably no. |

**Two implications fall straight out of that brief:**

1. The internal cassette stuff is irrelevant. You will load from LOCI, Erebus, Cumulus, or a tape adapter — never from real tape.
2. RF / composite output quality is mostly irrelevant — you'll either use the RGB SCART path through an OSSC/GBS-C-style converter, or a board that has modern composite via AD724/equivalent feeding a HDMI converter. The 1984 RF modulator is a museum piece.

---

## 3. The candidate landscape

Five realistic options exist as of May 2026, ranked roughly from "least DIY" to "most DIY":

### Option A — Buy an original Oric Atmos (or, if you can find one, an actual Nova 64)

Current market (eBay UK, AmiBay, sellmyretro.com, sampled May 2026):

- **Working, unboxed Atmos:** £150 typical.
- **Working, boxed, complete:** £200–£250 in fair condition; £480 asking-price seen for a "premium" listing.
- **Faulty Atmos:** £100–£120 — usually keyboard or PSU.

Actual **Oric Nova 64** machines turn up rarely — there's roughly one circulating in collector communities at any given time, often from ex-Yugoslav-state estate sales, typically priced like a boxed Atmos.

**Trade-offs.** Pros: it's *the* machine. Cons: in 2026 you're buying a 42-year-old computer with electrolytic capacitors past their service life, an original keyboard that almost certainly needs reflowing or repair (per `oldcrap.org`'s Nova teardown: ribbon cables break, key-switch joints crack — *every* switch eventually needs re-soldering), and a PSU/regulator that may already be marginal. You'll spend a weekend or three on a recap + keyboard repair + PSU + tape mod just to get to "stable enough to play with". Then you still need a storage solution (LOCI / Erebus) on top.

**When this is the right choice:** if owning *an original Tangerine PCB* is the actual goal, not having a working Oric. Or if you find a Nova 64 specifically.

### Option B — Board Folk **Oric Remix** (`Board-Folk/Oric-Remix`)

A faithful **replica motherboard** of the Oric-1/Atmos. ROM-, software- and form-factor-compatible with the original board. Drops into an original Oric case. KiCAD 9, Issue A v1.2, last commit **6 May 2026** (so this project is actively maintained as of right now). See [[Board-Folk-Oric-Remix]] for the full feature summary.

**Mods on top of vanilla Atmos:**

- LM7805 positive regulator (replaces the original's 7905 negative regulator)
- 27C128–27C512 ROM with a 4-bank DIP selector
- Cheaper AY-3-8910 socket alongside the AY-3-8912 footprint
- AD724-based composite + stereo TRRS audio (drops the awful original PROM-based RF generator)
- Service-manual tape mods integrated (R11/C19 "Improved Cassette Loading", R101/C101 from a known-good original)
- Replacement /ROMDIS logic (the v1.1 bug is fixed in v1.2 — *always build v1.2*)
- Speaker volume control, extra reset button, 4464 RAM
- Optional on-board Commodore 1531 tape interface
- Companion Expansion `Oric-PS2USB` (prototype PS/2 + future USB keyboard interface)

**Crucially: this board still needs the original ULA (HCS10017) and the original 6502A / 6522A / AY chipset.** It is a remanufacturable PCB, not a clone.

**Keyboard situation:** no production keyboard ships with the project yet — a Cherry-MX keyboard replica is planned but not released, and the `Oric-PS2USB` prototype expansion is an out-of-case PS/2 (and future USB) adapter. So today you either harvest the keyboard from a dead Oric or wait for the keyboard PCB.

**Repo activity:** 3 ⭐ / 2 forks / 3 open issues; active maintainer team (Rob Taylor `@peepouk`, Ian Cudlip `@grandoldian`, Chrissy `@chris_jh`, Simon Luce, "The Board Folk Team").

### Option C — OldWer **Metaphoric** (`OldWer/Metaphoric`)

An **enhanced clone** built on top of the JennyDigital OriClone-1 memory subsystem. Two-PCB design: a main PCB plus a separate **MX-switch keyboard PCB** (BOM confirms `SW1–SW58 Cherry MX`). Last touched **April 2025** (so quieter for the past year, but functionally complete).

**Mods on top of vanilla Atmos:**

- Composite video on RCA + TRRS audio-video output
- Footprints for *both* AY-3-8912 (original) *and* AY-3-8910 (cheaper)
- **Flexible power: 7905, 7805, or external +5 V** — uniquely, this one supports the original Atmos/Nova 7905 path if you ever want to feed it from your old PSU
- **Two Atari DB9 joystick ports** on the keyboard PCB (one IJK "Stingy", one cursors+space), switchable IJK disable
- Front-panel **RESET and NMI** buttons
- A **hardware V-sync hack** automatically wired to tape-in (transistor-switched when the relay is inactive) — this matters for sprite-flicker-free game and demo coding
- ROM bank selector switch (Oric-1 ↔ Atmos)
- Dual ROM images prebuilt in `MetaphoricV2/ROM/`
- 3D-printed case + board-separating spacers + spacebar stabilizer holder all in the repo

**Still needs the original ULA (HCS10017)** — confirmed in `MetaphoricV2/BOM.csv` line 23 (`IC1,HCS10017,DIP40,1`). I had initially thought the "clone vs replica" framing meant Metaphoric replaced more chips, but the truth is *both* projects need the same set of original NMOS chips. The "clone" label here means **the memory subsystem and lots of glue logic have been redesigned and the form factor isn't case-compatible**, not that the core chipset is replaced.

**Case situation:** the main PCB fits in the original Oric case if you omit the TRRS socket J10 and the auxiliary connector J7 and solder the bottom-row chips directly (not socketed). The keyboard PCB does *not* fit the original case — it's a new Cherry-MX board that needs its own enclosure (3D-printable; STLs in repo).

**Repo activity:** 5 ⭐ / 0 forks / 0 issues; one author (`oldwer@op.pl`); CC0-1.0 (public domain).

### Option D — Kenneth's **Oric Issue 5 PCB** (myretrostore.co.uk)

A pure **traced replica** of the original Oric motherboard. Sold as a blank PCB at **£11.99** by Kenneth (who is also a CEO Oric forum admin and a familiar name in the French Oric community at `oric.forumactif.org`). Built on a re-tracing of the original schematic; "Issue 5" rolls in the modifications from "Issue 4". Kenneth has personally built and tested it.

- BOM PDF: `https://myretrostore.co.uk/wp-content/uploads/2024/07/Oric-Atmos-Issue5-BOM.pdf`
- Kenneth also sells matching keyboard and AY8910 adapter.

**Crucially: out of stock as of this writing.** Email-when-back-in-stock notification only. So this is real and well-regarded but not buyable today.

This is the closest thing to "build the actual original Oric board from scratch" without paying collector prices. No documentation in your local wiki yet — worth queueing for ingestion (see §11).

### Option E — JennyDigital **OriClone-1** (`JennyDigital/OriClone-1`)

The **Eagle CAD predecessor** that fed Metaphoric's memory subsystem. Still works and still buildable, but:

- It's in Eagle CAD (not KiCAD) — needs Fusion 360 Electronics to open
- No license declared (all-rights-reserved by default — fabricating PCBs is legally grey)
- Last commit April 2024; 7 ⭐, no community activity
- Documented gotcha: the W65C22S VIA variant breaks the cassette interface; use a Rockwell 6522 instead

See [[JennyDigital-OriClone-1]] for the full picture. It's the historical artifact, not the build candidate.

---

## 4. Side-by-side comparison

| | A: Original Atmos | B: Oric Remix | C: Metaphoric | D: Kenneth Issue 5 | E: OriClone-1 |
|---|---|---|---|---|---|
| **Type** | Genuine 1984 hardware | Faithful replica | Enhanced clone | Faithful replica | Faithful clone |
| **Fits original case** | Yes (is the original case) | Yes | Main PCB yes; KB no | Yes (designed to) | Main PCB yes |
| **Needs original HCS10017 ULA** | already has | yes | **yes** | yes | yes |
| **Needs original 6502A/6522A/AY-3-8912** | already has | yes | yes (AY-3-8910 alt OK) | yes (AY-3-8910 alt OK) | yes |
| **Modern video out** | no (RF only) | AD724 composite + TRRS | RCA composite + TRRS, RGB SCART path | per BOM | manual mod |
| **Storage** | tape only (need LOCI/Erebus) | tape + optional C1531 + LOCI-compatible | tape + LOCI-compatible | tape only | tape only |
| **Keyboard** | original (probably broken) | not yet (planned MX replica) | included MX keyboard PCB | sold separately by Kenneth | included PCB |
| **Joysticks** | external adapter required | none on-board | 2x DB9 (IJK + cursor) | none on-board | none on-board |
| **Power** | 7905 negative | 7805 positive | **7905 OR 7805 OR ext 5V** | original 7905 | per design |
| **ROM banking** | none (single ROM) | 4-bank DIP | switch (Oric-1 / Atmos) | per design | dual ROM in repo |
| **V-sync hack** | needs external cable | not integrated | **integrated automatic** | no | no |
| **Tape mods** | none | service manual + extra | not integrated | per Issue 5 | none |
| **License** | n/a | "public domain for study" | **CC0-1.0 (true public domain)** | commercial product | none declared |
| **Design files** | n/a (have original schematic) | KiCAD 9 + Gerbers + IBOM | KiCAD + Gerbers + STLs | not public (PCB is the product) | Eagle |
| **Last activity** | n/a | **May 2026** | April 2025 | active vendor (PCB OOS) | April 2024 |
| **Stars / forks** | n/a | 3 / 2 | 5 / 0 | n/a | 7 / 0 |
| **Cost ballpark (PCB only)** | £150–£480 | ~£20–£40 (JLCPCB 5 boards) | ~£20–£60 (two PCBs JLCPCB) | £11.99 when in stock | DIY fab cost |
| **Build difficulty** | none (just repair) | medium (through-hole) | medium (TH + few SMD) | medium (TH) | medium (TH) |

> **Note on the "needs original ULA" row.** This is the single most important constraint and applies to *every* clone option. The HCS10017 ULA is the proprietary 1983 Tangerine custom chip that does the clock, RGB video, memory addressing and ROM/IO decoding. Nobody has commercially shipped a drop-in replacement yet. See §6 for the OCULA project, which will eventually change this.

---

## 5. ULA sourcing — the actual blocker

**Every** modern Oric build needs an HCS10017 ULA. Where do you actually get one in 2026?

- **eBay (UK):** seller *Nati 99 Electronics* lists 1× DIP-40 HCS10017 ULA at **£7.37 / ~$9.99**, with 10+ available and 130 already sold. (Search: "HCS10017 ULA Oric Atmos".)
- **Mutant Caterpillar Games (UK):** £20 *but only as part of an Oric repair service*, not as a bare chip.
- **Donor machine:** any dead Oric-1 or Atmos with a working ULA. The ceramic-package versions are most robust.
- **Pravetz 8D donor:** the Bulgarian Oric clone (1985–1992) used the same ULA, and is documented as a known source for repairing real Orics (per `bitspassats.com`). Pravetz 8Ds are themselves rare in Western Europe but routinely show up in Eastern European markets.

**Plan:** order **two** HCS10017s the moment you commit to a build path. They're the only irreplaceable chip; everything else is generic DIP and still in production or near-production at trusted vendors (Mouser, Reichelt, Jameco for the 6502/6522/AY; Mouser/Digi-Key for AD724, 4464, 74-series glue). One ULA is the working one, the second is your insurance.

---

## 6. The OCULA escape valve

> **Superseded — see [[09-ocula]].** This section was the May-2026 first-pass research and is now stale on the details: OCULA is **RP2350B**-based (not a plain Pico/RP2040), firmware reached **v0.1.4** (May 2026), the hardware/firmware repos went public March 2026, and **raxiss.com began selling finished OCULA boards ~April 2026** — it *is* buyable. The current reference is [[09-ocula]]; the build decision is in `10-decision-bom-order.md` §3. The paragraphs below are kept as the historical record only.

`sodiumlb/ocula-pivic-firmware` is a **Raspberry-Pi-Pico-based replacement** for the HCS10017 ULA, in active development by Sodiumlightbaby (the same author as LOCI — see [[sodiumlb-loci-firmware]] and [[raxiss.com]]). Latest firmware: **v0.1.3, March 2026**. It is not yet a buyable hardware product — what exists is firmware + PCB-design forum threads where the author shares routing and pinout iterations.

Reading the active forum thread (`forum.defence-force.org/viewtopic.php?t=2709`, page 2 captured) confirms:

- **Form factor:** a DIP-40 footprint Pico-based board that you would solder or socket in place of the ULA.
- **Two operating modes planned:** "OCULA is the RAM" (Pico provides the RAM directly — easier path, gets working video out faster) and "RAM is the RAM" (Pico bridges between original DRAM and Oric bus — the "true ULA replacement" badge).
- **Outputs:** native RGB + DVI/HDMI (640×480 or 720p) — direct HDMI from the chip, no external converter.
- **Status:** PCB design phase, routing complete, hardware prototypes coming. Not buyable yet.
- **Dbug (Mickaël Pointier) and the LOCI author are actively collaborating** — the same Defence Force ecosystem owns this.

**Implication for your build plan:** if you build Oric Remix or Metaphoric now with a real ULA, OCULA will eventually be a drop-in upgrade that gives you native HDMI and unlocks Pico-side features (debugger, memory expansion, scanline emulation). That's a one-way ratchet: it's safer to build now than to wait — your ULA chip will only get rarer over time.

---

## 7. The peripheral ecosystem (storage and I/O)

These are *separate purchases*, not part of any clone above:

| Device | Role | Source | Price |
|---|---|---|---|
| **LOCI** ([[raxiss.com]], [[sodiumlb-loci-firmware]]) | BUS-expansion-port floppy/tape/ROM emulator, USB host, RP2040-based | RaxIss / Lectronz (EU), 8BitClub / Tindie (worldwide) | ~$52 |
| **Erebus** | SD-card tape loader, plugs in via tape port (no expansion needed) | 8Bit-Tronics (UK), often eBay | £32 |
| **OricuiTape** | Alternative SD-card tape loader | newstuffforoldstuff.com | £32–£43 |
| **Cumulus** | More advanced SD card peripheral emulating full Microdisc system with LCD | various community vendors | varies |
| **Mike Brown's Diagnostic ROM** | Boot ROM that exercises hardware, reports faults | `oric.signal11.org.uk/html/diagrom.htm` | free download; also included in LOCI release firmware |

**Practical pairing recommendations:**

- **Quickest "playable" path:** Erebus alone — plugs into the DIN-7 tape port, loads tape `.tap` files at high speed. No expansion port needed.
- **Best long-term:** LOCI. Floppy + tape + ROM emulation in one box, USB peripherals, actively developed by the same person doing OCULA. This is the future-proof choice.
- **Diagnostic must-have:** flash Mike Brown's diagnostic ROM onto an EPROM (or use it via LOCI) the very first time you power on a freshly built board — it will catch most assembly faults before you start chasing your tail.

---

## 8. Recommendation matrix

| If your priority is… | Build path |
|---|---|
| **The exact 1984 experience, original PCB feel** | A — buy a real Atmos and recap + repair it. Add LOCI. (Hunt for a Nova 64 in parallel.) |
| **"Just build a modern Oric I can use daily"** | **C — Metaphoric.** The MX keyboard, dual joystick ports, V-sync hack, flexible power, and self-contained 3D-printable enclosure make it the best "one project, complete machine" option in 2026. |
| **"Build a board that drops into a real Oric case and a real Oric keyboard"** | **B — Oric Remix v1.2.** It's the actively-maintained, case-compatible replica. Buy a beaten-up Oric Atmos for the case + keyboard + ULA; transplant the new motherboard. (You can sell the spare original PCB to a collector to recoup.) |
| **"Cheapest entry point to a working Oric, vintage purist"** | D — Kenneth's Issue 5 (when back in stock). £11.99 PCB + your own original ULA + a kit of common parts. Hardest to source the full BOM for, but cheapest in raw materials. |
| **"I want to learn how the machine works at silicon level"** | All of the above + read [[JennyDigital-OriClone-1]] history + the Oric Service Manual (mirrored on [[48katmos.freeuk.com]]) + the `defence-force.org` hardware programming manual. |

---

## 9. My recommendation for **your** case

Given (a) you grew up on the Nova 64, not a UK Atmos, so the "exact original" isn't actually your machine anyway; (b) you want this to be a *journey* repo, i.e. a long-term project, not a one-weekend repair; (c) you want a daily-usable machine with joysticks and storage, not a museum piece — I think the right plan is:

### Phase 1 — Build **Metaphoric** as the daily-driver Oric
1. **Order 2× HCS10017 ULA** from the eBay seller above. *Do this first* — supply is finite.
2. Order the full BOM for Metaphoric per `MetaphoricV2/BOM.csv` and `MetaphoricKBV2/BOM.csv` from Mouser or Reichelt (one big order is cheaper than three small ones).
3. **Order PCBs from JLCPCB** using the gerbers in `MetaphoricV2/gerbers/` and `MetaphoricKBV2/gerbers/` — 5-board minimum is standard. Total PCB cost ~£20–£25.
4. **3D-print the case + spacers + spacebar holder** from `MetaphoricV2/STL/` and `MetaphoricKBV2/STL/` (or send to a service if you don't have a printer).
5. **Burn ROM:** use `MetaphoricV2/ROM/DualROM28C256.bin` onto a 28C256 EEPROM, or `DualROM27C512.bin` onto a 27C512.
6. Build, test with Mike Brown's diagnostic ROM, declare victory.
7. Add **Erebus** for cheap quick-start storage, or **LOCI** for the long term.
8. **Re-skin as "Oric Nova 64":** design a new badge/sticker for the case lid in the Avtotehna typography — this is a tiny graphic-design project but it's the whole emotional payoff of the build.

### Phase 2 — Build **Oric Remix v1.2** as the "purist" board
After Metaphoric is working and you've got the soldering and ULA-handling mileage, build an Oric Remix v1.2 and drop it into a tatty donor Atmos case. Now you have two machines: the Nova-themed daily driver, and a "looks original from the outside" reference.

### Phase 3 — Track OCULA
When OCULA hardware ships (probably 2026 → 2027), buy one and swap it into the Metaphoric. That unlocks native HDMI out and turns the Metaphoric into the most capable Oric on Earth.

### Phase 4 — Acquire (don't restore) a real Nova 64
If a Nova 64 surfaces on an ex-Yugoslav auction or in a collector group at a sane price, buy it — but as a *display piece*, not a daily driver. Take photos of the case, badge, and silkscreen to feed back into Phase 1's re-skin. Don't depend on it for actually using the machine.

**Why Metaphoric first, not Oric Remix?**

1. It has a built-in keyboard PCB (MX-based, modern, soldering-friendly). Oric Remix's keyboard story is "not yet". You don't want to wait on a keyboard before powering up.
2. It's the only candidate with the V-sync hack integrated — that's the difference between "games look right" and "games flicker".
3. The 7905-or-7805-or-external-5V flexibility means you can power it from a USB brick, no heat inside the case. The Oric Remix is 7805-only.
4. Joystick ports are on the board. That's the bit of nostalgia (Atari-DB9 joystick into an Oric playing *Xenon I*) that you'll actually feel from day one.
5. The CC0-1.0 licence is friendlier for whatever you want to derive later (custom case, Nova silkscreen, etc.). Oric Remix is "public domain for study" — which is fine but less explicit.
6. Oric Remix's active development (May 2026) is a plus, but its open issues mean changes are still landing — Metaphoric has been stable for ~13 months. For a first build, stable beats active.

---

## 10. Open questions / things still to research

These are gaps to close before ordering anything:

- [ ] **EPROM programmer in hand.** Metaphoric's README notes 27C256 needs a bodge wire because the pinout differs; you want either a **27C512** (large, bank-switchable — preferred) or **28C256** (drop-in, Atmos-only). Which programmer you have dictates the chip family. (TL866 / XGecu T48 both handle both.)
- [ ] **AY-3-8910 vs AY-3-8912 sourcing.** The 8910 is significantly cheaper and both boards support it (Metaphoric BOM defaults to it; Oric Remix BOM offers a second socket). Check Mouser / Reichelt / UTSource — some 8910s on the Chinese market are pulls or fakes. Look at the forum threads in §13 for current sourcing chatter.
- [ ] **6522 VIA variant.** Both projects accept a Rockwell 6522. **Avoid the W65C22S** — confirmed by JennyDigital's documentation to break the cassette interface, which matters even if you mostly use LOCI (one day you'll want to load from a tape adapter).
- [ ] **Case for Metaphoric.** The included STLs print on any FDM printer, but PLA in a case-shaped print may feel cheap. Consider sending the STLs to a resin or SLS print service, or designing a custom enclosure with a real Nova 64 livery (good Phase 1 step 8 deliverable).
- [ ] **Power supply.** Plan to feed +5 V from a quality USB power brick (3 A+) into a 2.1 mm barrel jack, **centre positive**. Mark the cable so you never plug a centre-negative supply in by mistake. (Get a 9 V centre-positive too if you want to use the 7805 or 7905 regulator paths instead.)
- [ ] **Original Nova 64 photos.** If you have your childhood machine's photos or remember the exact badge typography, gather them now — they go into Phase 1 step 8 (re-skin).
- [ ] **Yugoslav Oric software.** The DP FAQ mentions a Yugoslavian contact remembered "Tetris (an excellent version), Break Out, Poker, text and graphic adventures" — finding `.tap` images of these would make the Nova-themed build emotionally complete. Worth a separate search.

---

## 11. Suggested next moves in the wiki

The URLs from this paper have been queued in `inbox.md` for ingestion via `/pin-llm-wiki run`:

- `https://github.com/sodiumlb/ocula-pivic-firmware` — OCULA firmware
- `https://github.com/sodiumlb/loci-hardware` — LOCI hardware design + project wiki
- `https://github.com/sodiumlb/ocula-hardware` — **confirmed exists** (last pushed Mar 2026), 0 ⭐, the actual KiCAD/etc. files for the OCULA board
- `https://myretrostore.co.uk/product/oric-1-atmos-clone-issue-5-pcb/` — Kenneth's Issue 5 PCB product page
- `https://oric.forumactif.org/t945-metaphoric` — French forum Metaphoric thread (Kenneth as OP)
- `https://ceo.oric.org/community/oric-atmos/metaphoric/` — CEO Oric forum Metaphoric thread
- `https://www.986-studio.com/category/retro-computing/oric/replicoric/` — Replic'Oric historical project (2014–2015)
- `https://oldcrap.org/2019/12/14/oric-nova-64/` — Old Crap Nova 64 teardown (**the actual Nova 64**)
- `https://oric.signal11.org.uk/html/diagrom.htm` — Mike Brown's diagnostic ROM (essential first-power-on tool)
- `https://en.wikipedia.org/wiki/Pravetz_(computer)` — Pravetz 8D context
- Direct links to the four key Defence Force forum threads (Metaphoric ×3 + OCULA + LOCI + Oric Remix) — see §13.

Run `/pin-llm-wiki run` against the inbox to ingest them as wiki source pages, then they can be cited from future entries in this folder.

---

## 12. References (already in this wiki)

| Wiki page | What it tells you |
|---|---|
| [[OldWer-Metaphoric]] | Full Metaphoric source-page summary. |
| [[Board-Folk-Oric-Remix]] | Full Oric Remix source-page summary. |
| [[JennyDigital-OriClone-1]] | Predecessor Eagle-CAD clone. |
| [[48katmos.freeuk.com]] | Original board revisions, port pinouts, scanned Service Manual. |
| [[oric.free.fr]] | Hardware programming manual, machine history. |
| [[wiki.defence-force.org]] | Topic map of Oric hardware + emulator roster + memory maps. |
| [[forum.defence-force.org]] | Live community: troubleshooting, ULA / OCULA threads, build chatter. |
| [[osdk.org]] / [[defence-force.org]] | OSDK cross-development toolchain (you'll want this if you write Oric code from your modern PC). |
| [[raxiss.com]] / [[sodiumlb-loci-firmware]] | LOCI storage expansion (the recommended companion). |
| [[library.defence-force.org]] | Period books, magazines, manuals — useful when you want to read the original BASIC manual. |
| [[blog.defence-force.org]] | Mickaël Pointier's blog — Encounter dev-log, modern Oric game-dev posts. |

---

## 13. Forum research findings (`forum.defence-force.org`)

> **Thread IDs below are inaccurate** — corrected during a later forum investigation. Verified IDs: Metaphoric announcement `t=2675`, Metaphoric V2 `t=2733`, LOCI first impressions `t=2672`, Loci + Metaphoric `t=2862`, Oric Remix `t=2746`, OCULA `t=2709`. See `05-metaphoric-vs-oric-remix.md` §4. The counts and community analysis in this section still stand.

Authenticated searches across `forum.defence-force.org` (May 2026) returned the following counts:

| Query | Topics matched |
|---|---|
| `Metaphoric` | 4 |
| `"Oric Remix"` | 6 (only **1** dedicated, the rest in-passing) |
| `OCULA` | 9 |
| `"Oric clone"` | 106 |
| `Pravetz` | 110 |
| `"Oric Nova"` | 31 |

### 13.1 Threads that directly inform the build decision

**Metaphoric** — clearly the more-discussed of the two candidate boards:

- ⭐ **Metaphoric — a new Oric clone** — OldWer, Hardware hacks & extensions, Dec 2024, **17 replies / 19,311 views**, last post Feb 2025 — the original announcement thread, foundational discussion of the design. → <https://forum.defence-force.org/viewtopic.php?f=11&t=2268>
- ⭐ **Metaphoric V2** — OldWer, Hardware hacks & extensions, Apr 2025, **8 replies / 13,811 views** — the V2 iteration thread (this is what's in the repo). → <https://forum.defence-force.org/viewtopic.php?f=11&t=2398>
- ⭐ **Loci + Metaphoric** — Bieno, Hardware hacks & extensions, **Apr 2026** — recent thread linking LOCI with Metaphoric in a working build, confirms the pairing works. → <https://forum.defence-force.org/viewtopic.php?f=11&t=2522>
- **Loci — First user impressions** — xahmol, Dec 2024, 37 replies / 32k views — wider LOCI context, references Metaphoric. → <https://forum.defence-force.org/viewtopic.php?f=11&t=2266>

**Oric Remix** — sparse forum footprint:

- **Oric remix ?** — Symoon, Hardware hacks & extensions, Aug 2025, **4 replies / 3,383 views**, last post Bieno Aug 2025 — the *only* dedicated Oric Remix thread on the forum. → <https://forum.defence-force.org/viewtopic.php?f=11&t=2447>

**OCULA — by far the most discussed hardware project:**

- ⭐ **OCULA — a ULA replacement concept** — Sodiumlightbaby, Hardware hacks & extensions, Feb 2025, **267 replies / 90,943 views**, last post Dbug **13 May 2026** — the canonical thread for the ULA-replacement project. Active as of four days ago. → <https://forum.defence-force.org/viewtopic.php?f=11&t=2351>
- **LOCI — my Oric storage emulation project** — Sodiumlightbaby, Mar 2024, **1,182 replies / 702,411 views** — the LOCI development thread, eye-watering engagement, the same author/community as OCULA. → <https://forum.defence-force.org/viewtopic.php?f=11&t=2068>

**OSDK 2.0** (for when you write code for your build):

- **Let's talk about OSDK 2.0** — Dbug, Cross development tools, Dec 2025, 31 replies. → <https://forum.defence-force.org/viewtopic.php?f=3&t=2523>

### 13.2 What the search counts say about the community

- The **forum.defence-force.org community has a clear preference for Metaphoric over Oric Remix** as a build candidate, measured by dedicated threads and view counts. Oric Remix has one short thread with 4 replies; Metaphoric has three multi-thousand-view threads with active development chatter from Dec 2024 right through April 2026.
- **OCULA is being treated as a near-certainty by the community.** A 267-reply, 90k-view, still-active thread is not a speculative idea; it's a project people expect to ship. This validates including it as Phase 3 of the build plan rather than dismissing it.
- **LOCI is the de-facto modern storage solution.** 700k views and 1.1k replies is exceptional for a niche-of-niche 8-bit project. Treat LOCI as the default; only fall back to Erebus if a sub-£30 quick-start is the priority.
- **Pravetz (110) and Oric Nova (31) mentions are mostly historical.** Don't expect to find a community of active Pravetz/Nova builders on the forum — these are reference points in software-compatibility and emulator discussions, not active hardware projects.

### 13.3 Useful community names to know

| Handle | Project / area | Why they matter |
|---|---|---|
| **OldWer** | Metaphoric author | Direct contact (`oldwer@op.pl` per repo README). |
| **Sodiumlightbaby** (sodiumlb) | LOCI + OCULA author | Builds the modern Oric peripheral ecosystem; very responsive on the forum. |
| **Dbug** (Mickaël Pointier) | Defence Force founder, OSDK, blog | The community's central node; site/forum admin. |
| **Bieno** | Active builder | Has both built Metaphoric and integrated LOCI with it — the closest thing to a peer doing the same plan you'd be doing. |
| **Kenneth** | Issue 5 PCB vendor + CEO Oric forum admin | The French/CEO-Oric counterpart to Defence Force; very active. |
| **Chrissy / @chris_jh, Rob Taylor / @peepouk, Ian Cudlip / @grandoldian** | Board Folk Oric Remix authors | Less forum-visible than the names above but actively maintain the Oric Remix GitHub repo. |

### 13.4 How this changes the recommendation in §9

It **strengthens** it. The forum data says:

- *Metaphoric is what the active community is actually building*, including integrating it with LOCI in 2026 — exactly the configuration recommended in §9.
- *OCULA is real and shipping-soonish*, so building with an original ULA today is genuinely a "drop-in upgrade later" path, not a dead end.
- *Oric Remix is fine, but the build-and-ask-for-help support network is weaker.* If you hit a problem, you'll be one of very few people on the forum who's tried it.

No part of §9 needs to change. If anything, the order "Metaphoric first, Oric Remix as Phase 2" is now better-justified.

---

## 14. Decision log

- **2026-05-17.** First draft of this paper. Tentative plan: build Metaphoric (Phase 1), then Oric Remix (Phase 2), then OCULA upgrade (Phase 3), eventually acquire a real Nova 64 as a display piece (Phase 4).
- _(future entries: add a line per concrete decision — "ordered 2× HCS10017 from Nati 99 Electronics", "submitted gerbers to JLCPCB", etc.)_
