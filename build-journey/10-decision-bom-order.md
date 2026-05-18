---
type: journey-note
title: "Build decision and BOM/order plan"
created: 2026-05-17
status: draft — under discussion, nothing ordered yet
supersedes_decision_in: "[[00-build-vs-buy-research]]"
related_wiki:
  - "[[OldWer-Metaphoric]]"
  - "[[Board-Folk-Oric-Remix]]"
  - "[[JennyDigital-OriClone-1]]"
  - "[[raxiss.com]]"
  - "[[sodiumlb-loci-firmware]]"
  - "[[forum.defence-force.org]]"
---

# Build decision and BOM/order plan

> **Purpose:** turn the research in [[00-build-vs-buy-research]] into a concrete build decision and a buyable parts list.
>
> **Status:** DRAFT. This doc is written to be argued with. §2 (board) decided: Metaphoric V2. §3 (ULA vs OCULA) decided after a forum investigation: build with the original ULA, treat OCULA as a later open experiment. Remaining open items are in §8 — none are blockers. Nothing is ordered.

---

## 0. Your constraints (the decision inputs)

From your comments on `00`, the brief is now narrower and clearer than the research doc assumed:

| # | Your requirement | Effect on the decision |
|---|---|---|
| 1 | **Build it yourself.** Buy hardware only as donor parts. | Kills Option A (buy a real Atmos). |
| 2 | **No case, no Nova badge.** Want a working machine you understand. | Kills Oric Remix's one advantage (case-compatibility). Re-skin/case phases dropped. |
| 3 | **Fully functional keyboard, included in the build.** | Strongly favours Metaphoric (keyboard PCB in-repo). Oric Remix has *no* keyboard yet. |
| 4 | **DB9 joystick ports** (nice-to-have). | Favours Metaphoric (2× DB9 on the keyboard PCB). Oric Remix has none. |
| 5 | **Kenneth's Issue 5 is out** — not open source, PCB not orderable. | Option D removed. |
| 6 | **Every part must be open; you want to understand every piece.** | This is the big one — see §3. It reframes the ULA decision. |
| 7 | **One machine**, not a collection. | No "Phase 2 build Oric Remix". One board, one build. |

---

## 2. Board decision — **Metaphoric** (decided)

This is no longer a close call. Against your brief:

- **Keyboard:** Metaphoric ships a complete Cherry-MX keyboard PCB (`MetaphoricKBV2/`, `SW1–SW58`). Oric Remix has *no* keyboard you can build today — req #3 alone settles it.
- **Joysticks:** Metaphoric puts 2× Atari DB9 on the keyboard PCB (one IJK "Stingy", one cursor+space). Oric Remix: none. Satisfies req #4.
- **Case:** you don't want one, so Oric Remix's "drops into a real Oric case" edge is worth nothing to you (req #2).
- **License:** Metaphoric is **CC0-1.0** — true public domain, verified on the repo. Oric Remix has *no license file declared* (all-rights-reserved by default; the project only describes itself as "public domain for study"). For req #6, CC0 is unambiguous; Oric Remix is not.
- **Power flexibility:** Metaphoric runs from 7905, 7805, **or** external +5 V. You'll feed it +5 V from a USB brick — no regulator, no heat, no mains transformer.

**Decision: build the Metaphoric V2** (`MetaphoricV2/` main PCB + `MetaphoricKBV2/` keyboard PCB).

One caveat carried forward from `00`: Metaphoric's last commit is April 2025 (~13 months stale) vs Oric Remix's May 2026. For a *first build* that stability is a plus, and the forum shows people actively building Metaphoric in 2026 (incl. with LOCI). Not a concern.

---

## 3. The one real open question — original ULA vs OCULA

Every Oric clone needs the video/timing/decoding chip. You have two ways to satisfy that, and **your req #6 ("every part open, understand every piece") points the opposite way from the research doc.**

### Option 3A — Original Tangerine HCS10017 ULA

- A proprietary 1983 custom chip. **No schematics, no design files, no way to understand it.** It is the one black box in the machine.
- Known to work in Metaphoric — the repo has a `ULA.kicad_sch` and a DIP-40 socket (`IC1`) designed exactly for it.
- Hand-solderable (it's a socket — you don't even solder the chip).
- Sourcing: eBay seller *Nati 99 Electronics*, ~£7.37 each, DIP-40, stock available.
- Video out is then **composite** (RCA) — you reach a modern monitor via a ~£10 composite→HDMI dongle, or use the RGB-SCART path into a GBS-Control/OSSC-class converter.

### Are they "interchangeable"? — No.

Your assumption was that OCULA and the original ULA both just sit in the same socket and swap freely. They do **not**:

- The **HCS10017** is a true drop-in: it sits in the DIP-40 `IC1` socket and that is the entire installation.
- **OCULA** has a DIP-40 footprint so it physically *fits* `IC1` — but the firmware currently only supports **"OCULA-is-the-RAM" mode**, which *also* requires installing **2 separate "mux-bridge" boards** that clip onto the host machine's DRAM multiplexer ICs. So OCULA is "ULA socket + extra hardware mod", not a swap.

### Option 3B — OCULA (`sodiumlb/ocula-hardware` + `ocula-pivic-firmware`)

A Raspberry-Pi-Pico-based **open-source** ULA replacement. Verified state:

- **Both repos are BSD-3-Clause** — genuinely open: KiCAD PCB files, firmware source, user docs (`sodiumlb/ocula-docs`). The *only* ULA option that satisfies "understand every piece."
- Hardware repo has a finished main PCB, a Micro-DVI adapter, and the mux-bridge boards. Native **DVI/HDMI out**, no converter.
- **SMD board** — README says hand-assembly is not recommended beyond through-hole connectors; you'd order it **assembled (PCBA) from JLCPCB**.

### What the forum actually says (checked 2026-05-17, `forum.defence-force.org` OCULA thread `t=2709`, 18 pages)

I logged in and read the OCULA thread. The picture is clear and it is **not** in OCULA's favour for a first build:

1. **OCULA was buggy on *original* Orics until very recently.** User *iss* (Oct–Dec 2025): tested OCULA on *two good original Oric boards* → "Oric doesn't boot at all… garbage screens", despite mux-bridges and OCULA correctly fitted. A firmware update fixed booting → "Oric works! … all stable" — **but that same update broke DVI output** (`p33696`). Sodiumlightbaby has since iterated the firmware; *iss* reports a later update stable (`p33766`). So OCULA on a *real* Oric only became reliable around **Dec 2025 – early 2026**.
2. **The one person who tried OCULA on a *clone* never got it working.** *Chema* (Oct 2025 → Feb 2026): "I did not manage to make my Oric clone work with OCULA." Good OCULA splash screen, then boots to garbage; reverting to the original chips, the clone works fine (`p33518`, `p33542`). His clone is an *unknown homebrew board* ("a friend mounted it for me", unbranded RAM) with suspected clock-generation quirks — **it is not a Metaphoric and not an OriClone-1.** As of Feb 2026 he had fallen behind and not retested (`p34138`).
3. **Nobody has ever tried OCULA in a Metaphoric.** A forum search for `metaphoric` + `ocula` returns zero compatibility discussion. The Metaphoric and OCULA repos do not reference each other.

**Conclusion:** OCULA-in-Metaphoric is **unverified**, and the *only* clone data point that exists (a different clone) is a failure. OCULA itself only stabilised on genuine hardware a few months ago.

### The honest framing — recommendation: **3A now, OCULA as an open experiment**

Yes, req #6 ("every part open") philosophically favours OCULA — the HCS10017 is the one black box you can never study. But for a *first build with money committed*, betting the whole machine on unproven clone compatibility is the wrong risk. Recommended path:

1. **Build with the original HCS10017 ULA (3A).** It is the only *known-good* path for Metaphoric — the repo's `ULA.kicad_sch` and `IC1` socket are designed for it. The machine is then guaranteed to boot.
2. **Also order the OCULA hardware** (it's cheap, BSD-3, fully open). Once the Oric works on the real ULA, try OCULA as a *learning project*: you study its open design, attempt the swap, and if it works you gain native HDMI; if it doesn't, you still have a working computer and you've lost nothing but a JLCPCB order.

This keeps the build certain, still puts an open, studyable part in your hands, and makes you potentially the *first* person to report OCULA-in-Metaphoric — useful to the community either way.

**Still worth doing:** post a direct question to the forum asking OldWer (Metaphoric author) and Sodiumlightbaby whether OCULA is expected to work with Metaphoric's OriClone-1-based memory subsystem. If OldWer says "yes, designed-compatible", that upgrades OCULA from "experiment" to "plan". I can draft that question — see §8 #1.

### ULA quantity (if we go 3A)

**Order 2.** Not to build two computers — you're building one. The HCS10017 is the only irreplaceable part in the whole machine and the supply only ever shrinks. A spare is ~£7. The alternative is a build halted mid-assembly by one dead chip with no same-day replacement. Cheap insurance; order two.

---

## 4. Software loading — **LOCI**

You asked "how do I load software — LOCI?" Yes.

- **LOCI** is a bus-expansion-port emulator (floppy + tape + ROM, USB host), RP2040-based, ~$52 from RaxIss/Lectronz (EU) or 8BitClub/Tindie (worldwide). It's the de-facto modern Oric storage solution and the same author as OCULA — the ecosystem is coherent.
- **Openness nuance (req #6):** the **LOCI firmware is BSD-3-Clause** (open), but the **LOCI *hardware* repo has no license declared** (technically all-rights-reserved). That sounds like a req-#6 violation — but it isn't really: you're going to **buy LOCI as a finished product**, not fabricate the PCB. You're not putting an un-open *design* into your machine; you're plugging in a purchased peripheral that runs open firmware. Different question. I'm flagging it so it's a conscious choice, not a surprise.
- **Cheaper alternative:** Erebus (~£32, SD-card tape loader, plugs into the tape port). Fine as a quick-start, but LOCI is the better long-term answer and pairs with the rest of the ecosystem. Recommend going straight to LOCI.
- **Diagnostic ROM:** burn Mike Brown's diagnostic ROM to an EPROM (or run via LOCI) for first power-on — it catches assembly faults before you start guessing.

---

## 5. Video out — depends on §3

§3 is decided as 3A, so this is the plan:

- **Primary (build day 1):** Metaphoric outputs **composite** on the RCA socket. Use a ~£10 composite→HDMI converter box into any HDMI monitor. Cheapest, works immediately.
- **Better picture (optional):** build the RGB-SCART cable (`RGB_Scart_Tape.pdf` in the repo) into a GBS-Control/OSSC-class RGB→HDMI scaler — much sharper than composite. The RGB signal is the recommended way to use an Oric.
- **Future, if the OCULA experiment succeeds:** **native DVI/HDMI** straight off the OCULA board (640×480 / 720p) via the Micro-DVI adapter, no converter at all.

There is **no native USB-C** path. Plan on HDMI. (A USB-C monitor that accepts HDMI-alt-mode, or a cheap HDMI→USB-C adapter, covers a USB-C-only monitor.)

---

## 6. BOM and sourcing plan

The **authoritative parts lists already exist in the repo** and we should order *from them*, not from a list I retype:

- `MetaphoricV2/BOM.csv` — main PCB
- `MetaphoricKBV2/BOM.csv` — keyboard PCB

(Both also as `.pdf` / `.xlsx`.) Next step is to expand this into a full line-item table with live prices straight from those CSVs. For now, the **sourcing strategy by category:**

| Category | Parts | Where | Notes |
|---|---|---|---|
| **The ULA** | HCS10017 ×2 | eBay — Nati 99 Electronics | ~£7.37 ea. Order first; supply is finite. Buy 2 — one + a spare (see §3). |
| **NMOS core** | 6502A CPU, 6522A VIA, AY-3-8910 PSG | Mouser / Reichelt / UTSource | **6522: use a Rockwell 6522 — NOT the W65C22S** (breaks the cassette interface, per JennyDigital docs). AY-3-8910 is the cheap PSG both BOMs accept; beware fakes/pulls on the Chinese market — buy from a reputable seller. |
| **Memory** | 4464 DRAM etc. per BOM | Mouser / Reichelt | Per `MetaphoricV2/BOM.csv`. |
| **ROM chip** | **27C512 EPROM** (decided) | Mouser / Reichelt | Gives switchable Oric-1/Atmos banks. Repo has prebuilt `DualROM27C512.bin`. Avoid 27C256 (needs a bodge wire, loses bank switching). Burns directly in the T48 you already own. |
| **Glue logic + passives** | 74-series, resistors, caps, regulators, sockets, headers | Mouser / Reichelt | One consolidated order is much cheaper than three. Buy DIP **sockets** for every IC — sockets everywhere on a first build. |
| **Keyboard** | 58× Cherry MX switches, keycaps, 2× DB9 connectors | Mouser / a keycap vendor | MX switches are a taste choice (tactile recommended for a typewriter feel). DB9 connectors solder to the **back** of the keyboard PCB. |
| **Video** | AD724 + composite section parts | Mouser / Digi-Key | Per BOM's "COMPOSITE VIDEO SECTION". Skip the "AMPLIFIER SECTION" — internal speaker sound is poor. Plus a ~£10 composite→HDMI converter box. |
| **PCBs** | MetaphoricV2 + MetaphoricKBV2 gerbers | JLCPCB | 5-board minimum each, ~£20–25 total. Use `MetaphoricV2/gerbers/` and `MetaphoricKBV2/gerbers/`. |
| **OCULA** *(optional — the open experiment, §3)* | OCULA main PCB (PCBA) + 2× mux-bridge + Micro-DVI adapter + FFC cable | JLCPCB PCBA | SMD — order **assembled**. From `sodiumlb/ocula-hardware`. FFC cable spec: 20 cm, 20-pin, 0.5 mm pitch, reverse. Order this *after* the machine works on the real ULA, not in the first batch. |
| **Peripheral** | LOCI | RaxIss / 8BitClub | ~$52. Separate purchase. |
| **Power** | First power-on: your **DPS-150** bench supply set to 5.0 V with a current limit. Daily use: USB brick 5 V ≥3 A + 2.1 mm barrel jack, **centre-positive** | generic | Close J12+J13 on Metaphoric for external +5 V. Use the DPS-150 for the first smoke test — set a ~500 mA limit so a solder bridge trips the limiter instead of cooking a chip. Mark any barrel-jack cable so a centre-negative supply never goes in. |

---

## 7. Tools — what you have, and the one gap

You documented your bench in `build-journey/tools/`. It is a genuinely strong kit for this build — see `tools/` for each instrument. Mapped to the job:

### What you already have (and how it earns its place here)

| Tool | Role in this build |
|---|---|
| **BackBit Chip Tester Pro V2** | **Incoming-parts QA.** Test every standard DIP IC *before* soldering — 6502A, 6522, 74-series glue, 4464 RAM. Catches dead/fake chips while they're still pullable. Also rips a burned ROM back to SD with SHA1 verification so you can confirm the EPROM image. *Limits:* it tests standard logic/RAM/ROM only — it has **no test for the HCS10017 ULA or the AY-3-8910 PSG** (both are custom, not standard logic). It can also program BackBit "CornBit" multi-ROMs, but **not** plain 27C512/28C256 — see the gap below. |
| **DPS-150 bench PSU** | First power-on at a current-limited 5 V — see §6 power row. The single biggest safety upgrade over a USB brick for smoke-testing. |
| **DSO-TC3** | Scope + component tester — verify the ~1 MHz clock is alive, sanity-check passives before fitting. |
| **DSLogic Plus** | Logic analyser — for debugging bus/decoding faults if the board doesn't boot. Heavy artillery; hopefully unused. |
| **Logic probes (610B, LP1)** | Quick "is this pin toggling" checks during bring-up. |
| **2× multimeter (EX350, DMT99)** | Continuity checks before power-on, polarity verification. |
| **LCR-ST1** | Identify/verify capacitor and inductor values before fitting. |
| **Digital microscope** | Inspect solder joints — especially the 58 keyboard-switch joints and any fine work. |
| **SG-003A signal generator / USB power meter / RPi Debug Probe** | Bench extras; not on the critical path for this build. |

### EPROM programmer — already covered

The Chip Tester reads/rips ROMs but does **not burn** standard EPROMs. That gap is closed: **you already own an XGecu T48** (confirmed 2026-05-17).

- The T48 burns the **27C512** directly in its main 40-pin ZIF socket — no adapter needed (the 27C512 is DIP28).
- You also have an **A45U / ADP_D42_EX-A** adapter (PLCC44 / DIP42 — for 27C800/27C160/27C322-class chips). **Not needed for this build** — the Oric ROM is a small DIP28 part. Keep it for other projects.
- **No tool purchase is required for this build.** ROM chip → **27C512** (switchable Oric-1/Atmos banks; repo ships `DualROM27C512.bin`).

### Still need (consumables, not instruments)

| Item | Why |
|---|---|
| Temperature-controlled soldering iron | ~120 through-hole joints + 58 keyboard switches. All through-hole — within your skills. (OCULA, if chosen, ships pre-assembled — nothing to solder.) |
| Flush cutters, solder, flux, desoldering braid | Standard. |

---

## 8. Open items to resolve before ordering

1. ~~**★ OCULA-in-Metaphoric compatibility (§3).**~~ **Investigated 2026-05-17** (forum thread `t=2709` read). Verdict: unverified, and the only clone attempt on record failed. **Decision: build 3A (original ULA) now; treat OCULA as a separate open experiment.** Still open — *optional* — post a direct question to OldWer/Sodiumlightbaby to learn whether OCULA is design-compatible with Metaphoric; I can draft it.
2. ~~**EPROM programmer (§7).**~~ **Resolved 2026-05-17:** you already own an XGecu T48. No tool purchase needed. ROM chip → 27C512, burns directly in the T48.
3. **6522 sourcing (§6).** Confirm a Rockwell-made 6522 is available from your chosen distributor — *not* the W65C22S.
4. **AY-3-8910 authenticity (§6).** Decide a trusted seller; fakes are common.
5. **MX switch choice (§6).** Tactile / linear / clicky — your call; affects keycap order too.
6. **Decide LOCI vs Erebus (§4).** Recommendation is LOCI; confirm the ~$52 spend is fine.
7. **Read the actual repo BOM CSVs.** Before the order goes in, I expand §6 into a priced line-item list straight from `MetaphoricV2/BOM.csv` + `MetaphoricKBV2/BOM.csv`.

---

## 9. Proposed order of operations

1. Order **2× HCS10017 ULA** first — longest/most fragile supply.
2. Expand §6 into a full line-item BOM; place one consolidated Mouser/Reichelt order.
3. Submit both gerber sets to JLCPCB.
4. Burn the ROM and the diagnostic ROM (T48).
5. Build keyboard PCB and main PCB; socket everything. Test ICs on the Chip Tester before fitting.
6. First power-on with the diagnostic ROM, powered from the current-limited DPS-150.
7. Add LOCI; load software.
8. **Later — the OCULA experiment:** order OCULA hardware (PCBA), study its design, attempt the swap. Bonus, not a dependency.

---

## 10. Decision log

- **2026-05-17.** Draft created. Board decided: **Metaphoric V2** (constraints #1–#7 settle it). Open question: original ULA vs OCULA — left for discussion, gated on a forum compatibility check. Nothing ordered.
- **2026-05-17.** §3 resolved. Read the `forum.defence-force.org` OCULA thread (`t=2709`): OCULA only stabilised on *genuine* Orics ~Dec 2025–early 2026; the single clone attempt on record (Chema, an unknown homebrew clone) never booted; nobody has tried OCULA in a Metaphoric. **Decision: 3A — build with the original HCS10017 ULA; order OCULA hardware separately as an open experiment after the machine works.** Clarified that OCULA and the original ULA are *not* freely interchangeable (OCULA needs mux-bridge mods).
- **2026-05-17.** Tools inventory (`build-journey/tools/`) reviewed. Strong bench QA/debug kit confirmed (Chip Tester Pro V2, DPS-150, DSO-TC3, DSLogic Plus, etc.). EPROM programmer confirmed: user already owns an **XGecu T48** (+ an A45U/DIP42 adapter not needed here). No tool purchases required. ROM chip → 27C512.
- _(future entries: one line per concrete decision — "§3 resolved to 3A/3B", "ordered 2× HCS10017", "gerbers to JLCPCB", etc.)_
