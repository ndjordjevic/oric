---
type: journey-note
title: "Line-item BOM and order plan"
created: 2026-05-18
status: order-ready — line-item expansion of [[10-decision-bom-order]] §6 / §8 #7
related_wiki:
  - "[[OldWer-Metaphoric]]"
  - "[[raxiss.com]]"
  - "[[forum.defence-force.org]]"
---

# Line-item BOM and order plan

> **Purpose:** the part-by-part shopping list. This is the §8 #7 expansion of [[10-decision-bom-order]] §6 — the *category strategy* there, turned into a list with references, quantities, and the [[10-decision-bom-order]] substitutions already applied.
>
> **Source of truth:** `MetaphoricV2/BOM.csv` and `MetaphoricKBV2/BOM.csv` from the `OldWer/Metaphoric` repo (CC0-1.0, fetched 2026-05-18). Where this doc differs from those CSVs, the difference is a deliberate decision from [[10-decision-bom-order]] and is flagged **⚠ SUBSTITUTION**.
>
> **Prices** are rough estimates for budgeting only — confirm live at the vendor. Generic DIP logic and passives are pennies; the cost is dominated by the ULA, LOCI, and the keyboard switches.

---

## 0. Substitutions applied (repo BOM → this doc)

Read this first — these are the four places this list deliberately departs from the repo CSV:

| Repo BOM says | This doc orders | Why |
|---|---|---|
| IC7 = **28C256** EEPROM | **27C512 EPROM** | [[10-decision-bom-order]] §6 — switchable Oric-1/Atmos banks; burns on your T48; repo ships `DualROM27C512.bin`. Same DIP28 socket. |
| IC15 = **AY-3-8910** | **KC89C72** *or* **YM2149F** | [[10-decision-bom-order]] §8 #4 — genuine new AY parts carry the keyboard-matrix drive bug; these clones do not. Same DIP40 footprint. |
| IC11 = "CPU 6502", IC10 = "VIA 6522" | **NMOS 6502A** and **NMOS 6522A** (Rockwell/Synertek) | [[10-decision-bom-order]] §6 — 2 MHz-rated NMOS; avoid W65C02/W65C22S. |
| IC13/IC19 = L7805/L7905 regulator | **omit** | [[10-decision-bom-order]] §6 power plan — external +5 V from a USB brick; close J12+J13, fit no regulator. |
| IC1 = HCS10017 ×**1** | HCS10017 ×**2** | [[10-decision-bom-order]] §3 — one + an irreplaceable-part spare. |

---

## 1. Main PCB (`MetaphoricV2`) — integrated circuits

| Ref | Part to order | Footprint | Qty | Order | Notes |
|---|---|---|---|---|---|
| IC1 | **HCS10017 ULA** | DIP-40 | 1 | **2** | The one irreplaceable chip. eBay *Nati 99 Electronics* ~£7.37 ea. Order first. |
| IC11 | **6502A** (NMOS, 2 MHz) | DIP-40 | 1 | 1 | Rockwell/Synertek/UMC NMOS. **Not** WDC W65C02. |
| IC10 | **6522A VIA** (NMOS, 2 MHz) | DIP-40 | 1 | 1 | Rockwell or Synertek. **Not** W65C22S. Beware AliExpress "R6522AP" fakes. |
| IC15 | **KC89C72** or **YM2149F** | DIP-40 | 1 | 1 | PSG. See §0. KC89C72 ~5 €/5 pcs. |
| IC7 | **27C512 EPROM** | DIP-28 | 1 | 1 (+1) | See §0. Burn `DualROM27C512.bin` on the T48. A spare blank is cheap. |
| IC5, IC6 | **4464 DRAM** (64K×4) | DIP-18 | 2 | 2 (+1) | 41464-class 120 ns or faster. |
| IC2 | **74F04** | DIP-14 | 1 | 1 (+1) | **74F** family specifically — clock buffer, speed matters. |
| IC8 | **74LS00** | DIP-14 | 1 | 1 (+1) | |
| IC3, IC4 | **74LS257** | DIP-16 | 2 | 2 (+1) | Address muxes (the ICs OCULA's mux-bridges later clip onto — see [[09-ocula]]). |
| IC9 | **74LS365** | DIP-16 | 1 | 1 (+1) | |
| IC12 | **ICM7555** (CMOS 555) | DIP-8 | 1 | 1 | TLC555 is an equivalent. |
| IC14 | **LM358** | DIP-8 | 1 | 1 | Dual op-amp. |
| IC16 | **LM386** | DIP-8 | 1 | *0–1* | Amplifier section — **optional**, [[10-decision-bom-order]] §6 recommends skipping the internal speaker. |
| IC17 | **AD724** (AD724JRZ) | SOIC-16W | 1 | 1 | ⚠ **The only SMD part.** SOIC-16W, 1.27 mm pitch — hand-solderable with care. Composite-video encoder; keep it for the day-1 HDMI path. |

---

## 2. Main PCB — DIP sockets

Socket every IC (no case → no need to solder chips directly; [[10-decision-bom-order]] §0 #2). Turned-pin (machined) sockets recommended for the four DIP-40s; standard dual-wipe is fine elsewhere. The AD724 (SOIC) has no socket.

| Socket | Qty | Order | For |
|---|---|---|---|
| DIP-40 | 4 | 4 (+1) | IC1, IC10, IC11, IC15 |
| DIP-28 | 1 | 1 | IC7 |
| DIP-18 | 2 | 2 | IC5, IC6 |
| DIP-16 | 3 | 3 (+1) | IC3, IC4, IC9 |
| DIP-14 | 2 | 2 (+1) | IC2, IC8 |
| DIP-8 | 3 | 2–3 | IC12, IC14, (IC16 if fitted) |

---

## 3. Main PCB — resistors

All ¼ W, metal film. Cheap — order each value in a pack of 10+; spares cost nothing.

| Value | Refs | Qty |
|---|---|---|
| 10 R | R47 | 1 |
| 68 R | R37, R38, R42 | 3 |
| 75 R | R58 | 1 |
| 220 R | R3, R24, R25, R26, R27 | 5 |
| 470 R | R21 | 1 |
| 560 R | R4 | 1 |
| 1 k | R1, R2, R9, R12, R20, R22, R48, R49 | 8 |
| 1.8 k | R43, R44, R45 | 3 |
| 2.2 k | R5, R8, R28, R29, R30, R33, R34, R35 | 8 |
| 4.7 k | R23, R39, R40, R41 | 4 |
| 10 k | R13, R14, R16, R17, R19 | 5 |
| 12 k | R15 | 1 |
| 22 k | R10, R11, R46 | 3 |
| 47 k | R6, R7 | 2 |
| 100 k | R18, R36 | 2 |
| 1 M | R31, R32 | 2 |

**Total: 50 resistors, 16 values.**

---

## 4. Main PCB — capacitors

| Value | Type | Refs | Qty |
|---|---|---|---|
| 30 p | Trimmer | C28 | 1 |
| 2.2 n | Ceramic | C5, C9 | 2 |
| 10 n | Ceramic | C6 | 1 |
| 47 n | Ceramic | C2, C4, C30 | 3 |
| 100 n | Ceramic | C1, C3, C8, C10–C24, C26, C27 | 20 |
| 2.2 µF | Electrolytic | C7 | 1 |
| 10 µF | Electrolytic | C32 | 1 |
| 100 µF 25 V | Electrolytic | C25 | 1 |
| 220 µF | Electrolytic | C29, C31 | 2 |

**Total: 32 capacitors.** 100 n is the decoupling cap — order a pack of 30+.

> **C21 note:** C21 is one of the 100 n decoupling caps here (not the reset cap people discuss for OCULA). The OCULA C21→100 µF reset mod in [[09-ocula]] §5.1 is a *different* board's C21 numbering — irrelevant to this Metaphoric BOM. Build the Metaphoric BOM as-is.

---

## 5. Main PCB — diodes, transistors, crystals, relay

| Ref | Part | Footprint | Qty | Order |
|---|---|---|---|---|
| D1–D4, D6–D12 | **1N4148** | DO-35 | 11 | pack of 50 |
| D5 | **BAT85** Schottky | DO-35 | 1 | 1 (+1) |
| T1, T3, T5, T8 | **2N3904** NPN | TO-92 | 4 | 5 |
| T2 | **BS170** N-ch MOSFET | TO-92 | 1 | 2 | ⚠ doc 10 §8 #4 called this "BS107" — the board uses **BS170**; order BS170. |
| T4, T6, T7 | **BC549B** NPN | TO-92 | 3 | 4 |
| Q1 | **12 MHz** crystal | HC-49/U | 1 | 1 | System clock. |
| Q2 | **4.433619 MHz** crystal | HC-49/U | 1 | 1 | PAL colour subcarrier for the AD724 composite path. |
| K1 | **SRD-05VDC-SL-C** relay | — | 1 | 1 | Tape relay (also part of the auto V-sync hack). |
| SW1 | Tact switch (6 mm) | — | 1 | 1 | On-board push switch. |

---

## 6. Main PCB — connectors

| Ref | Part | Qty | Order? | Notes |
|---|---|---|---|---|
| SV2 | **2×17 IDC box header** (34-pin) | 1 | **yes** | Expansion bus — **this is the LOCI port.** |
| SV1 | **2×10 IDC box header** (20-pin) | 1 | yes | Printer port. |
| J3 | 1×14 pin header (male, 0.1″) | 1 | yes | To keyboard J1. |
| J7 | 1×13 pin header (male, 0.1″) | 1 | yes | To keyboard J2 (joysticks). |
| J1, J11 | 1×3 pin header (male, 0.1″) | 2 | yes | ROM-bank select / TRRS mode select. **+ 2 jumper shunts.** |
| J6 | 1×2 pin header | 1 | optional | Speaker — skip if omitting the amplifier. |
| J4 | Barrel jack (2.1 mm) | 1 | yes | Power in. |
| J5 | RCA socket | 1 | yes | Composite video out. |
| J10 | **TRRS socket PJ-322** | 1 | yes | Audio/video out (jack-to-3×RCA cable). |
| SK1 | **DIN-8 socket** | 1 | yes | RGB out — needed later for the SCART cable ([[10-decision-bom-order]] §5). |
| J2 | DIN-7 socket | 1 | optional | Tape port — skippable (storage is LOCI). |
| J9 | 1×12 header | 1 | **skip** | Marked *unpopulated* in the repo BOM. |

> The 0.1″ male pin headers (J1, J3, J6, J7, J11) total **35 pins** — buy one 40-pin breakaway header strip. SV1/SV2 are separate shrouded IDC box headers.
>
> **Build-time safety note (repo README §4):** when the keyboard PCB is connected, **J1 must NOT be jumpered** — the keyboard's BANKSEL switch does the same job, and a jumper left on J1 risks shorting +5 V to ground. Fit the J1 header, but leave its shunt off in the keyboard configuration.

---

## 7. Keyboard PCB (`MetaphoricKBV2`)

| Ref | Part | Qty | Order | Notes |
|---|---|---|---|---|
| SW1–SW58 | **Cherry MX tactile (Brown-style)** switches | 58 | 60 | Switch type decided — [[10-decision-bom-order]] §8 #5. |
| — | **MX keycaps** | 58 | 58 | Incl. one spacebar cap. ⚠ Not in the repo BOM. Standard MX profile; legends won't match the Oric layout unless you order custom/blank caps — cosmetic only. |
| — | **MX spacebar stabilizer** | 1 | 1 | ⚠ Not in BOM. README: glued into the 3D-printed holder. |
| U1 | **4051** analog mux | 1 | 1 | DIP-16. |
| — | DIP-16 socket | 1 | 1 | For U1. |
| SW59, SW60 | Tact switch (6 mm) | 2 | 2 | RESET, NMI. |
| SW62, SW63 | 3-pin slide switch (SPDT) | 2 | 2 | BANKSEL, IJK-DISABLE. |
| J3, J4 | **DB-9 connector** | 2 | 2 | Atari joystick ports — solder to the **back** of the PCB. |
| J1 | 1×14 pin header **female** (0.1″) | 1 | 1 | Mates main J3. |
| J2 | 1×13 pin header **female** (0.1″) | 1 | 1 | Mates main J7. |
| D1 | LED 5 mm | 1 | 1 | Power LED. |
| D2–D8 | 1N4148 | 7 | (in the pack of 50) | |
| R1 | 1.2 k resistor | 1 | 1 | LED series resistor. |

---

## 8. PCBs, peripherals and connectivity

| Item | Qty | Where | Est. price | Notes |
|---|---|---|---|---|
| **MetaphoricV2** main PCB | 1 (5 min.) | JLCPCB | ~£12 / 5 | Gerbers: `MetaphoricV2/gerbers/`. |
| **MetaphoricKBV2** keyboard PCB | 1 (5 min.) | JLCPCB | ~£12 / 5 | Gerbers: `MetaphoricKBV2/gerbers/`. |
| **LOCI** | 1 | RaxIss / Lectronz (EU) or 8BitClub / Tindie | ~$52 | Storage + diagnostic ROM + BBS ACIA. See [[08-loci]]. |
| **Raspberry Pi Pico W** | 1 | Mouser / Pi reseller | ~£8 | BBS modem — **must be the W**. Flash `PicoWiFiModemUSB`. See [[10-decision-bom-order]] §4.2. |
| **Composite→HDMI converter box** | 1 | generic | ~£10 | Day-1 video to a modern monitor. |
| **5 V USB PSU ≥3 A + centre-positive 2.1 mm barrel cable** | 1 | generic | ~£10 | Daily power. Mark the cable so a centre-negative supply never goes in. |
| **M3×16 / M3×18 screws** | 4 | generic | ~£2 | Hold the two PCBs + 3D-printed spacers together. |

**3D-printed (not bought):** board spacers ×5, spacebar-stabilizer holder ×2 (one mirrored), optional case — STLs in `MetaphoricV2/STL/` and `MetaphoricKBV2/STL/`.

**Deferred — second batch, not now** ([[10-decision-bom-order]] §4.3, the wired-`minicom` 6551 ACIA card): 6551 ACIA, 74HC138, 74HC09, DIP sockets, a TTL-level FTDI/USB-serial cable.

---

## 9. Order plan by vendor

1. **eBay — first, today.** 2× HCS10017 ULA (Nati 99 Electronics). Supply only shrinks.
2. **JLCPCB.** Submit both gerber sets (5-board minimum each).
3. **Mouser / Reichelt — one consolidated order.** Everything in §1–§7 *plus* the Raspberry Pi Pico W. Notable line items to source deliberately: NMOS 6502A, NMOS 6522A (Rockwell/Synertek — confirm stock, [[10-decision-bom-order]] §8 #3), KC89C72/YM2149F PSG, 4464 DRAM, AD724JRZ, 74F04. Generic passives/diodes/sockets fill the rest.
4. **Keycap vendor.** 58 MX keycaps + 1 spacebar stabilizer (decide blank vs custom-legend).
5. **RaxIss / Lectronz.** LOCI (~$52) — separate purchase.

Rough all-in estimate: PCBs ~£25 · electronic parts (ICs/passives/connectors) ~£40–60 · 58 MX tactile switches ~£25–35 · 58 keycaps ~£25–60 (blank vs custom-legend) · 2× ULA ~£15 · LOCI ~£40 ($52) · Pico W + video converter + power ~£28. **Order of ~£230–280 total** — the keyboard (switches + keycaps) and LOCI dominate, not the electronics. The keycap spread is the biggest variable: budget toward the high end if you want custom Oric-legend caps.

---

## 10. Pre-order checklist

- [ ] 2× HCS10017 ordered (do this first).
- [ ] Both gerber sets submitted to JLCPCB.
- [ ] Confirmed a **Rockwell/Synertek NMOS 6522A** is in stock at the chosen distributor — not W65C22S ([[10-decision-bom-order]] §8 #3).
- [ ] PSG choice locked: KC89C72 or YM2149F.
- [ ] Pico **W** (not plain Pico) on the Mouser order.
- [ ] 58 tactile MX switches + 58 keycaps + 1 spacebar stabilizer.
- [ ] **AD724 (AD724JRZ) confirmed in stock** at Mouser/Digikey — *not* "on order". It is NRND (not recommended for new designs) and the only single-source line item; if it has dried up, the composite-video section needs a rethink before ordering. It is also the one hand-soldered SMD part.
- [ ] LOCI ordered from RaxIss/Lectronz.

---

## 11. Decision log

- **2026-05-18.** Line-item BOM created from `MetaphoricV2/BOM.csv` + `MetaphoricKBV2/BOM.csv` (repo fetched via `gh api`, 2026-05-18). Closes [[10-decision-bom-order]] §8 #7. Five substitutions applied and flagged (§0): ROM 28C256→27C512, PSG AY-3-8910→KC89C72/YM2149F, CPU/VIA→NMOS, regulator omitted (external +5 V), ULA ×1→×2. Repo BOM totals: main PCB 50 resistors / 32 capacitors / 12 diodes / 14 ICs / 15 DIP sockets; keyboard PCB 58 MX switches / 1× 4051 / 2× DB-9. Noted T2 is **BS170** (doc 10 §8 #4 said "BS107" imprecisely).
