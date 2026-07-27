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

> **Plan: self-source the BOM.** In forum thread `t=2733` OldWer offered Metaphoric V2 **kits at €120** — PCBs, all components, keys, keycaps, and a 3D-printed case (€10 off if you supply your own keys/keycaps, another €10 off for your own resistors/caps). Only two were offered back in April 2025, so they are likely long gone, and the decision is to self-source rather than chase a kit. **Where to check kit availability if you change your mind:** the Metaphoric V2 forum thread `t=2733` on `forum.defence-force.org` (post a reply asking), or email OldWer directly at `oldwer@op.pl` (the contact in the repo README). There is no shop — the kit only ever existed as a forum offer. A kit would have eliminated the biggest first-build risk (counterfeit ICs, see §6 / §8 #4); self-sourcing means the Chip Tester QA step in §9 matters more.

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
- **OCULA** has a DIP-40 footprint so it physically *fits* `IC1` — but it may need **2 separate "mux-bridge" interposer boards** clipped onto the host's two `74LS257` address multiplexers (`IC8`, `IC20`) to expose the low address bits. So OCULA is "ULA socket + possible hardware mod", not a guaranteed swap.

  > **Sources conflict on whether the mux bridges are mandatory.** The `ocula-docs` wiki (read 2026-05-17) stated only **"OCULA-is-the-RAM" mode** is implemented — which *requires* the mux bridges. The `forum.defence-force.org` digest of OCULA thread `t=2709` (synthesised from 268 posts through 2026-05-13) frames OCULA-is-the-RAM as an *optional* mode for replacing the DRAM, implying a plain ULA-replacement mode exists that does **not** need the bridges. Firmware v0.1.4 (May 2026) may have changed which modes are implemented. **Re-verify against the current OCULA user manual before attempting the experiment.** This does not affect the §3 decision either way — OCULA stays a later experiment.

### Option 3B — OCULA (`sodiumlb/ocula-hardware` + `ocula-pivic-firmware`)

An **RP2350B**-microcontroller-based **open-source** ULA replacement (not RP2040 — OCULA needs the RP2350B's extra GPIO to emulate the 40-pin ULA; the A4 stepping is required to fix the E9 GPIO-leakage errata). Verified state:

- **Both repos are BSD-3-Clause** — genuinely open: KiCAD PCB files, firmware source, user docs (`sodiumlb/ocula-docs`). The *only* ULA option that satisfies "understand every piece."
- Hardware repo has a finished main PCB, a Micro-DVI adapter (micro-HDMI connector), and the mux-bridge boards. Native **DVI/HDMI out**, no converter.
- **SMD board** — README says hand-assembly is not recommended beyond through-hole connectors. Two ways to get one: order it **assembled (PCBA) from JLCPCB**, or — per OCULA thread `t=2709` — buy it finished from **raxiss.com** (iss), who began a commercial OCULA batch ~April 2026. Buying from raxiss gives a known-good assembled board, the same way you're buying LOCI; prefer that over self-ordering PCBA.
- **Reset caveat:** OCULA takes ~49 ms from power-on to running, far longer than the Oric's stock ~2 ms reset RC. Fitting OCULA requires increasing `C21` from 1 µF to **100 µF** (up to 220 µF is confirmed safe) — a mod that also improves power-on reset reliability for any Oric.

> **Deep reference: [[09-ocula]].** Covers OCULA end to end — the two RAM modes, why RP2350B (and the A4-stepping requirement), the mux-bridge installation, the C21 reset mod, DVI output modes, firmware history, where to buy, and a Metaphoric-specific first-use checklist. Read it before the OCULA experiment begins; it is not needed for the first build.

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

## 4. Software loading and connectivity — **LOCI**

You asked "how do I load software — LOCI?" Yes. LOCI is also the hub for the connectivity goals (BBS, Mac terminal): storage in §4.1, BBS in §4.2, the wired `minicom` link in §4.3.

### 4.1 Storage — LOCI

- **LOCI** is a bus-expansion-port emulator (floppy + tape + ROM, USB host), RP2040-based, ~$52 from RaxIss/Lectronz (EU) or 8BitClub/Tindie (worldwide). It's the de-facto modern Oric storage solution and the same author as OCULA — the ecosystem is coherent. **Full reference: [[08-loci]].**
- **Openness nuance (req #6):** the **LOCI firmware is BSD-3-Clause** (open), but the **LOCI *hardware* repo has no license declared** (technically all-rights-reserved). That sounds like a req-#6 violation — but it isn't really: you're going to **buy LOCI as a finished product**, not fabricate the PCB. You're not putting an un-open *design* into your machine; you're plugging in a purchased peripheral that runs open firmware. Different question. I'm flagging it so it's a conscious choice, not a surprise.
- **Cheaper alternative:** Erebus (~£32, SD-card tape loader, plugs into the tape port). Fine as a quick-start, but LOCI is the better long-term answer and pairs with the rest of the ecosystem. Recommend going straight to LOCI.
- **Diagnostic ROM:** LOCI ships Mike Brown's diagnostic ROM (`test108k`) **built into its firmware** — long-press the Action button at first power-on to run the CPU/ULA/DRAM/VIA/PSG tests ([[08-loci]] §4). Since LOCI is on the order, **no separate EPROM burn is needed** for diagnostics.
- **LOCI + Metaphoric — confirmed working** (forum digest, threads `t=2672` and the dedicated `t=2862`). Metaphoric's `ROMDIS`/UVPROM is auto-disabled when LOCI is fitted (confirmed by OldWer, `t=2733`) — no jumper to set. Two tuning notes from the forum if LOCI misbehaves on first use: the `RV1`/`tmap` timing trimmer defaults to ~10 (raise to ~12 if floppy emulation fails); a `!ROM` error means the flash needs re-bootstrapping with the Raxiss firmware. *(If you later run LOCI together with OCULA, `RV1` must instead be set to **5** — OCULA's MAP timing differs. Not relevant on the original ULA.)*

### 4.2 BBS connectivity — order a Pico W now

The cleanest 2026 path onto a BBS needs **no expansion card** — it rides on LOCI. Full detail in [[06-bbs-connectivity]].

- LOCI emulates a 6551 ACIA over its USB-C host port. Plug a **Raspberry Pi Pico W** flashed with `PicoWiFiModemUSB` firmware into LOCI; it presents as a USB-CDC Hayes AT modem and connects outbound over WiFi to Telnet BBSes.
- **Order the Pico W now** (~£8). It must be the **Pico *W*** (with WiFi) — a plain Pico will not work. This is the only extra part the BBS goal needs.
- Bonus — this *also* satisfies "Mac as a terminal": the modem's TCP server mode (`AT$SP=2323`) lets the MacBook `telnet <pico-ip> 2323` into an Oric terminal session over WiFi, no wires. See [[07-serial-link-minicom]] §3.

### 4.3 Wired `minicom` serial link — a deferred second build

If you specifically want `minicom` over a **wired** FTDI link (not WiFi), that needs a real hardware UART the Oric does not have. Full analysis in [[07-serial-link-minicom]].

- The recommended path is a small **6551 ACIA expansion card** on the 1 MHz bus (6551 ACIA + `74HC138` decoder + `74HC09` gate). The card's TTL TX/RX pins go to a **TTL-level** FTDI/USB-serial cable into `minicom` on the Mac.
- This is explicitly a **build-it-after-the-Metaphoric-works** project — it is **not** in the first order. Its parts are listed in §6 as a *deferred* line so you can add them to a later batch, not hunt for them now.
- For the first build, §4.2's Pico W covers both BBS and Mac-as-terminal. The wired card is a refinement, not a day-one need.

---

## 5. Video out — depends on §3

§3 is decided as 3A, so this is the plan:

- **Primary (build day 1):** Metaphoric outputs **composite** on the RCA socket. Use a ~£10 composite→HDMI converter box into any HDMI monitor. Cheapest, works immediately.
- **Better picture (optional):** build the RGB-SCART cable (`RGB_Scart_Tape.pdf` in the repo) into a GBS-Control/OSSC-class RGB→HDMI scaler — much sharper than composite. The RGB signal is the recommended way to use an Oric.
  - **Watch the R/B swap:** the forum (`t=2669`) notes the ULA's red and blue colour outputs are swapped in *all* publicly available Oric schematics and ULA pinouts. If colours come out wrong on the SCART cable, use Mike Brown's corrected pinout — `oric.signal11.org.uk/html/ula-dieshot.htm`, Appendix A.
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
| **NMOS core** | 6502A CPU, 6522A VIA, AY PSG | Mouser / Reichelt / UTSource | **CPU:** 2 MHz-rated **NMOS 6502A**. Avoid the WDC **W65C02** — it lacks the illegal opcodes some Oric software relies on (Rockwell R65C02 / Synertek SY65C02 are pin-compatible if you must go CMOS, but NMOS is the safe call). **VIA:** 2 MHz-rated **NMOS 6522A** (Rockwell, Synertek) — **NOT the W65C22S** (different signal levels, expansion-bus quirks, a known WDC hardware bug). Beware AliExpress "R6522AP": counterfeit CMOS remarks (paint fails the acetone test) that lack the PB3 internal pull-up the keyboard needs. **PSG:** see the rewritten §8 #4 — the forum changes this choice. Short version: order **KC89C72** or **YM2149F**, *not* a "genuine" new-stock AY-3-8910. |
| **Memory** | 4464 DRAM etc. per BOM | Mouser / Reichelt | Per `MetaphoricV2/BOM.csv`. |
| **ROM chip** | **27C512 EPROM** (decided) | Mouser / Reichelt | Gives switchable Oric-1/Atmos banks. Repo has prebuilt `DualROM27C512.bin`. Avoid 27C256 (needs a bodge wire, loses bank switching). Burns directly in the T48 you already own. |
| **Glue logic + passives** | 74-series, resistors, caps, regulators, sockets, headers | Mouser / Reichelt | One consolidated order is much cheaper than three. Buy DIP **sockets** for every IC — sockets everywhere on a first build. |
| **Keyboard** | 58× Cherry MX **tactile (Brown-style)** switches, keycaps, 2× DB9 connectors | Mouser / a keycap vendor | Switch type **decided: tactile** — bump without click, typewriter feel. DB9 connectors solder to the **back** of the keyboard PCB. |
| **Video** | AD724 + composite section parts | Mouser / Digi-Key | Per BOM's "COMPOSITE VIDEO SECTION". Skip the "AMPLIFIER SECTION" — internal speaker sound is poor. Plus a ~£10 composite→HDMI converter box. |
| **PCBs** | MetaphoricV2 + MetaphoricKBV2 gerbers | JLCPCB | 5-board minimum each, ~£20–25 total. Use `MetaphoricV2/gerbers/` and `MetaphoricKBV2/gerbers/`. |
| **OCULA** *(optional — the open experiment, §3)* | OCULA main PCB + 2× mux-bridge + Micro-DVI adapter + FFC cable | **raxiss.com** (preferred) or JLCPCB PCBA | SMD — never hand-assemble. **Buy it finished from raxiss.com** (commercial OCULA batch started ~April 2026) — known-good, same as buying LOCI. Self-ordering PCBA from `sodiumlb/ocula-hardware` is the fallback. FFC cable spec: 20 cm, 20-pin, 0.5 mm pitch, reverse. Also budget a 100 µF cap for the `C21` reset mod (§3). Order this *after* the machine works on the real ULA, not in the first batch. |
| **Peripheral** | LOCI | RaxIss / 8BitClub | ~$52. Separate purchase. See [[08-loci]]. |
| **Connectivity — BBS** | Raspberry Pi Pico **W** | Mouser / Pi reseller | ~£8. Must be the **W** (WiFi) variant. Flash `PicoWiFiModemUSB`; plugs into LOCI's USB-C. Covers BBS *and* Mac-as-terminal over WiFi. Order with the main batch. See §4.2 / [[06-bbs-connectivity]]. |
| **Connectivity — wired serial** *(deferred — second batch)* | 6551 ACIA + `74HC138` + `74HC09` + DIP sockets; **TTL-level** FTDI/USB-serial cable (FT232/CP2102/CH340) | Mouser / Reichelt | A small 1 MHz-bus expansion card built **after** the Metaphoric works — for `minicom` over a wired link. **Not in the first order.** FTDI cable must be **TTL-level**, not RS-232. See §4.3 / [[07-serial-link-minicom]]. |
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
4. **AY sound chip choice (§6) — the forum reframes this.** The Oric keyboard matrix scans through the AY's I/O port; reading two keys on the same row depends on the AY's port output winning a drive fight. Genuine *old* GI **AY-3-8912** chips win it; new Microchip **AY-3-8910/8912** and many clones do **not** — Ctrl/Shift key combinations silently fail (forum `t=2669`, `t=2675`). Two consequences: (a) **Metaphoric V2 already ships the diode keyboard-fix** (reverse diodes on the AY column lines + a BS170 FET — `T2` in the BOM, see [[11-bom-and-orders]] §5), so a "weak" chip still works on this board; (b) the *best* chips to order are **KC89C72** (a currently-manufactured AY clone, ~5 EUR for 5 pcs, works even without the fix) or **YM2149F** (including Chinese repaints — also works without the fix). **Do not** hunt for a "genuine" new-stock AY-3-8910 — that is the part most likely to carry the keyboard bug. So this is no longer a "beware fakes" problem; it is a "pick KC89C72 or YM2149F" decision.
5. ~~**MX switch choice (§6).**~~ **Resolved 2026-05-18: tactile (Brown-style)** — bump, no click. Order 58× tactile MX switches + matching keycaps.
6. ~~**Decide LOCI vs Erebus (§4).**~~ **Resolved 2026-05-18: LOCI** (~$52). Erebus dropped.
7. ~~**Read the actual repo BOM CSVs.**~~ **Resolved 2026-05-18:** §6 expanded into a full line-item list in **[[11-bom-and-orders]]** — both repo BOM CSVs parsed, the five [[10-decision-bom-order]] substitutions applied, vendor order plan and pre-order checklist included. Order from doc 11.
8. **Connectivity (§4).** Decided: add a **Raspberry Pi Pico W** to the main order for BBS + Mac-as-terminal over WiFi. The wired-`minicom` 6551 ACIA card is a deferred second build — confirm you are happy deferring it (the Pico W covers the terminal goal in the meantime). Also queue `PicoWiFiModemUSB` firmware and a search for Oric terminal software ([[06-bbs-connectivity]] §4) — not order blockers.

---

## 9. Proposed order of operations

1. Order **2× HCS10017 ULA** first — longest/most fragile supply.
2. Expand §6 into a full line-item BOM; place one consolidated Mouser/Reichelt order — **include the Raspberry Pi Pico W** in this batch.
3. Submit both gerber sets to JLCPCB.
4. Burn the dual ROM (`DualROM27C512.bin` → 27C512) on the T48. *(No separate diagnostic-ROM burn — LOCI ships `test108k` built in.)*
5. Build keyboard PCB and main PCB; socket everything. Test ICs on the Chip Tester before fitting.
6. First power-on powered from the current-limited DPS-150; run LOCI's built-in diagnostic ROM (long-press Action) before loading any software.
7. Add LOCI; load software. Flash the Pico W with `PicoWiFiModemUSB` and plug it into LOCI → BBS access and Mac-as-terminal over WiFi.
8. **Later — wired serial:** build the 6551 ACIA expansion card (§4.3) if you want `minicom` over a wired FTDI link. Deferred, not a dependency.
9. **Later — the OCULA experiment:** order OCULA hardware (§3 / [[09-ocula]]), study its design, attempt the swap. Bonus, not a dependency.

---

## 10. Decision log

- **2026-05-17.** Draft created. Board decided: **Metaphoric V2** (constraints #1–#7 settle it). Open question: original ULA vs OCULA — left for discussion, gated on a forum compatibility check. Nothing ordered.
- **2026-05-17.** §3 resolved. Read the `forum.defence-force.org` OCULA thread (`t=2709`): OCULA only stabilised on *genuine* Orics ~Dec 2025–early 2026; the single clone attempt on record (Chema, an unknown homebrew clone) never booted; nobody has tried OCULA in a Metaphoric. **Decision: 3A — build with the original HCS10017 ULA; order OCULA hardware separately as an open experiment after the machine works.** Clarified that OCULA and the original ULA are *not* freely interchangeable (OCULA needs mux-bridge mods).
- **2026-05-17.** Tools inventory (`build-journey/tools/`) reviewed. Strong bench QA/debug kit confirmed (Chip Tester Pro V2, DPS-150, DSO-TC3, DSLogic Plus, etc.). EPROM programmer confirmed: user already owns an **XGecu T48** (+ an A45U/DIP42 adapter not needed here). No tool purchases required. ROM chip → 27C512.
- **2026-05-18.** Revisited against the `forum.defence-force.org` digest knowledge base. Changes folded in: **(§6/§8 #4)** AY chip recommendation reversed — order **KC89C72 or YM2149F**, not a genuine AY-3-8910, because new/genuine Microchip AY parts carry the keyboard-matrix drive bug while those clones do not (Metaphoric V2's diode fix covers it either way). **(§3)** OCULA corrected to **RP2350B**-based (not RP2040); flagged a source conflict over whether the mux-bridge interposers are mandatory; noted OCULA needs a `C21` 1 µF→100 µF reset mod; added **raxiss.com** as a commercial OCULA source (~April 2026) preferred over JLCPCB PCBA. **(§2)** Noted OldWer's €120 Metaphoric kit offer (`t=2733`) — worth asking about before self-sourcing. **(§5)** Added the ULA R/B pinout-swap warning for the SCART cable. **(§4)** Added LOCI `RV1` tuning notes and confirmed LOCI+Metaphoric works (ROMDIS auto-disabled). No change to the board or ULA decisions.
- **2026-05-18.** Connectivity folded in ahead of ordering. §4 expanded and retitled "Software loading and connectivity" with three subsections: §4.1 LOCI storage, §4.2 BBS (Raspberry Pi **Pico W** + `PicoWiFiModemUSB` via LOCI — added to the main order, ~£8), §4.3 wired `minicom` 6551 ACIA card (deferred second build, parts listed in §6 but explicitly not in the first order). §6 BOM gained two connectivity rows; §8 gained item #8; §9 order of operations updated (Pico W in the consolidated order; diagnostic-ROM burn dropped — LOCI ships `test108k`). Cross-links added: §3→[[09-ocula]], §4→[[08-loci]]/[[06-bbs-connectivity]]/[[07-serial-link-minicom]]. No change to board or ULA decisions.
- **2026-05-18.** Pre-order decisions confirmed by the builder. **Kit:** self-source the BOM (do not chase a kit; §2 updated with where to check availability — forum `t=2733` / `oldwer@op.pl`). **MX switches:** tactile (Brown-style) — §6 and §8 #5 updated. **Storage:** LOCI confirmed, Erebus dropped — §8 #6 closed. Wired 6551 ACIA card remains deferred (§4.3) as planned.
- _(future entries: one line per concrete decision — "§3 resolved to 3A/3B", "ordered 2× HCS10017", "gerbers to JLCPCB", etc.)_
