---
type: journey-note
title: "OCULA — the open ULA replacement"
created: 2026-05-18
status: reference — confirmed later experiment; build with original HCS10017 ULA first
related_wiki:
  - "[[sodiumlb-ocula-docs]]"
  - "[[sodiumlb-ocula-hardware]]"
  - "[[sodiumlb-ocula-pivic-firmware]]"
  - "[[raxiss.com]]"
  - "[[forum.defence-force.org]]"
---

# OCULA — the open ULA replacement

> **Role in this build:** OCULA is the open-source alternative to the proprietary HCS10017 ULA — the one "black box" chip in any Oric. The decision in [[10-decision-bom-order]] §3 is to build with an original HCS10017 first, then attempt the OCULA experiment later. This doc is the reference you need when that moment arrives.
>
> **Status (2026-05-18):** firmware v0.1.4, hardware Rev 1.1, repos made public March 2026. Working on original Atmos machines. **OCULA-in-Metaphoric is unverified** — the mux-bridge pin mapping is documented for original Oric motherboards only; see §6.

---

## 1. What OCULA is

OCULA is a **DIP-40-shaped PCB** that drops into the HCS10017 ULA socket in any Oric-1, Atmos, or clone. It is built around the **RP2350B** microcontroller and does the following:

- Reimplements all ULA functions: video generation (text, LORES, HIRES, double-height), address decoding, system clock (Phi)
- Outputs **TTL RGB analogue video** on the same pins as the original ULA
- Outputs **DVI digital video** simultaneously via a micro-HDMI connector (with adapter board)
- Generates the Phi system clock internally — **ignores the 12 MHz oscillator** on ULA pin 7
- Provides a USB CDC serial **monitor interface** for configuration

OCULA is the work of **sodiumlb** (same author as the LOCI storage peripheral, operating commercially as RaxIss). The hardware and firmware share a codebase with the VIC-20 PIVIC project ("OCULA/PIVIC twins").

**Licences:** hardware BSD-3-Clause, firmware BSD-3-Clause, docs GPL-3.0.

---

## 2. The central design split — two RAM modes

This is the most important thing to understand before attempting OCULA.

| Mode | What it does | Status | Motherboard mod required |
|---|---|---|---|
| **DRAM-is-the-RAM** | OCULA behaves like the original ULA; motherboard DRAM is used normally | **Not yet implemented** | None |
| **OCULA-is-the-RAM** | All system memory is served from OCULA's internal SRAM; motherboard DRAM is bypassed | **The only implemented mode** | Yes — 2 mux-bridge interposer boards |

**Practical consequence today:** fitting OCULA means fitting OCULA *and* installing mux-bridge interposers on the two 74LS257 address multiplexer ICs. There is no non-invasive drop-in mode yet.

> **Source conflict to be aware of.** The `ocula-docs` wiki (read 2026-05-17) states unambiguously that only OCULA-is-the-RAM mode is implemented. The forum digest of thread `t=2709` (268 posts through 2026-05-13) phrases OCULA-is-the-RAM as "optional". Firmware v0.1.4 (May 2026) may have changed things. **Verify against the current user manual at `github.com/sodiumlb/ocula-docs/wiki/OCULA-User-Manual` before starting the experiment.**

### What OCULA-is-the-RAM mode gives you

- OCULA has >500 kB internal SRAM → up to **256 kB of banked RAM** (far beyond the Oric's standard 64 kB)
- Machines with failed DRAM chips can still boot — but shorted/hot DRAM chips may still draw current; inspect them
- RAS/CAS signals to the DRAM are suppressed entirely; the DRAM sits idle

---

## 3. Why RP2350B (not RP2040)

The choice of MCU is not arbitrary:

- The HCS10017 has **40 pins**. The RP2040 has only 30 GPIO pins — not enough to emulate all ULA signals efficiently using PIO.
- The **RP2350B** has **47 GPIO pins**, giving enough budget to map all address, data, control, and video signals into contiguous GPIO ranges that the PIO state machines require.
- The RP2350B PIO constraint: each PIO instance must use GPIO 0–31 *or* GPIO 16–47. All address lines must be contiguous within one PIO group.

### The E9 errata (and why you need the A4 stepping)

The RP2350B has a silicon bug (errata E9): GPIO pins in high-impedance input mode leak ~120 µA. This causes the address lines coming from the mux bridges (which are high-impedance sources) to sit at a logic-high instead of a clean low.

| RP2350B stepping | E9 errata | Mux bridge resistors | Simultaneous original ULA + OCULA |
|---|---|---|---|
| Before A4 | Present — 120 µA leakage | Need 2 kΩ pull-downs | Not possible |
| **A4 stepping** | **Fixed** | Weaker bridging sufficient | **Possible** |

**When ordering OCULA or fabricating a board: verify you are getting RP2350B A4 stepping.** RaxIss boards should use A4; check before buying if self-fabricating.

---

## 4. Hardware layout

| Element | Function |
|---|---|
| **DIP-40 pins** | Made from 1×20 11 mm stacking pin-headers (flat, spring-like). Low-profile — original Oric cases have very little clearance above the ULA. Do **not** use turned-pin headers or extra sockets. |
| **USB-C port** | Dual use: power input and USB CDC monitor interface. Protection diodes prevent back-powering the Oric through OCULA's USB. |
| **BOOTSEL button** | Hold while connecting USB-C to a computer → OCULA appears as USB mass storage for `.uf2` firmware drag-and-drop. |
| **Open-drain reset pad** | A fly-wire from this pad to the motherboard reset signal gives OCULA visibility of the RESET line (not present in the standard ULA socket). |
| **FFC connector** | Connects to the optional DVI adapter board via a 20-pin, 0.5 mm-pitch, reverse-direction, ~20 cm FFC cable. |

### Associated boards

| Board | What it is | Mandatory? |
|---|---|---|
| **Mux-bridge PCBs (×2)** | 0.6 mm-thick DIP-16-sized boards with a 3D-printed PLA snap-on clip frame. Piggyback onto IC8 and IC20 (74LS257). Resistors (not shorts) so original ULA can be swapped back in. | **Yes** — in current firmware |
| **Micro-DVI adapter board** | Mounts non-destructively in the RF modulator space in the Oric case; presents a micro-HDMI socket externally. | No — analogue RGB still works without it |

---

## 5. Installation procedure

This is the sequence for a first-time OCULA installation on an **original Oric or Atmos**. The Metaphoric caveats are in §6.

### 5.1 C21 reset capacitor mod (mandatory)

The Oric's reset RC circuit has τ ≈ 2 ms (R = 2.2 kΩ, C21 = 1 µF). OCULA needs ~49 ms from VCC to clock-running — **the stock reset pulse is too short and OCULA may miss it entirely.**

Replace C21 with a larger capacitor:

| C21 value | Reset pulse (approx) | Status |
|---|---|---|
| 1 µF (stock) | ~2 ms | Too short — OCULA misses reset |
| **100 µF** | **~44 ms** | **Recommended** |
| 150 µF | ~66 ms | Adds margin |
| 220 µF | ~97 ms | Confirmed safe upper bound |

> This mod also **improves reset reliability on any Oric** even with the original ULA — it is safe to do early in the build.

### 5.2 Socket preparation

- Remove the HCS10017 from its socket.
- If the ULA socket has leaf contacts (common in original machines), **do not push turned-pin headers through them** — they will damage the leaf socket. Use long stacking headers.
- OCULA does not use ULA pin 7 (the 12 MHz oscillator input) — leave that pin unpopulated or ignored.
- A fly-wire from OCULA's open-drain reset pad to the motherboard reset line is **optional but recommended** — without it, OCULA cannot observe RESET.

### 5.3 Mux-bridge installation

The ULA socket only carries the upper address bits A15–A8. A7–A0 are not wired to the socket. To expose them:

1. Locate IC8 and IC20 on the Oric motherboard (74LS257 address multiplexers).
2. Clip the 3D-printed snap-on frame onto each IC. The frame is matched to 0.6 mm PCB thickness.
3. Press each mux-bridge PCB into the frame. The bridge sits piggyback over the IC without desoldering anything.
4. Verify resistor values match the RP2350B stepping: 2 kΩ pull-downs for pre-A4; weaker for A4.

> **The documented IC8/IC20 pin mapping is for original Oric motherboards.** The ocula-docs user manual explicitly warns: *"Other implementations may have rearranged mux pairs."* Metaphoric redesigned the memory subsystem — verify the pin mapping against Metaphoric's schematic before clipping bridges onto anything. See §6.

### 5.4 DVI adapter board (optional)

1. Route the 20-pin, 0.5 mm-pitch, reverse-direction FFC cable from OCULA's FFC connector, under the keyboard, to the RF modulator space.
2. Mount the DVI adapter board in the RF modulator space. It is non-destructive — no cutting or drilling.
3. The micro-HDMI socket is now externally accessible at the RF modulator cutout.
4. Analogue RGB output continues to work simultaneously.

### 5.5 Power-on and first test

1. Do **not** connect OCULA via USB-C while the Oric is powered from its expansion bus or vice versa — protection diodes handle back-power, but it is good practice to pick one source.
2. Power on the Oric. If the C21 mod is in place, the machine should boot without pressing Reset.
3. If the machine doesn't boot: press the physical Reset button. If still no boot, check C21 value and mux-bridge orientation.
4. Connect OCULA USB-C to a computer to reach the monitor interface (next section).

---

## 6. OCULA-in-Metaphoric: the open question

**OCULA has not been confirmed working on a Metaphoric clone** as of the forum digest (2026-05-13) and wiki sources (2026-05-17).

The specific risk:

- The mux-bridge installation requires connecting bridge inputs to the CPU address lines A7–A0 on **IC8 and IC20 (74LS257)**.
- The ocula-docs user manual gives the exact pin mapping — and explicitly states it is for **original Oric motherboards**.
- Metaphoric's memory subsystem is a redesign from OriClone-1. The 74LS257 ICs may be present and positioned differently, or the mux pair assignment may differ.

**How to verify before attempting:**

1. Read `MetaphoricV2/` KiCAD schematics — identify IC8 and IC20 equivalents and their pin assignments.
2. Compare against the IC8/IC20 pin mapping in the ocula-docs user manual.
3. If any mux pair is rearranged, the bridge connection points will differ.
4. **Post to the Defence Force forum** (`forum.defence-force.org`) asking sodiumlightbaby or OldWer directly about Metaphoric + OCULA mux bridge mapping. As of the forum digest, Sodiumlightbaby participates actively in the OCULA thread (`t=2709`).

> **Reset-cap designator caveat.** §5.1 and §14 say "replace C21". That `C21` is the *original Oric* reset capacitor. On the **Metaphoric**, `C21` is a 100 nF decoupling cap ([[11-bom-and-orders]] §4) — *not* the reset cap. When the OCULA experiment starts, identify the Metaphoric reset capacitor from `MetaphoricV2/reset.kicad_sch` and enlarge *that* one to ~100 µF; do not touch Metaphoric's C21.

> **This is why the §3 decision holds.** Original HCS10017 first, OCULA experiment later — after verifying the mux mapping against the Metaphoric schematic (and ideally after someone else has confirmed it).

---

## 7. DVI output

OCULA outputs DVI video via the micro-HDMI connector (with adapter board). The signal is generated by the RP2350B's HSTX peripheral. Analogue RGB runs simultaneously at all times regardless of DVI state.

### DVI modes (firmware v0.1.3+)

Select with `set dvi <n>` in the USB monitor. Run `set dvi` with no argument to list available modes.

| Mode | Resolution | Refresh | Notes |
|---|---|---|---|
| VGA 640×480p60 | 640×480 | 60 Hz | Standard; pixel-doubled from Oric output |
| VGA 640×480p6x | 640×480 | ~59.2 Hz | Matches Oric-60Hz native timing |
| std 576p 720×576p50 | 720×576 | 50 Hz | Standard PAL DVI |
| **576p 720×576p5x** | 720×576 | ~50.08 Hz | **Matches Oric-50Hz exactly** — best for EU 50 Hz displays |
| std 480p 720×480p60 | 720×480 | 60 Hz | Standard NTSC DVI |
| 480p 720×480p6x | 720×480 | ~59.2 Hz | Matches Oric-60Hz native |

> At 27 MHz dotclock: TMDS bit rate = 270 Mbit/s, RP2350B internal clock = 135 MHz (within its 150 MHz rating). 720p would require ~370 MHz and is not recommended.

**Non-standard timings** (the 5x/6x modes) differ from certified DVI/HDMI specs by a fraction of a Hz. Most modern displays handle them; some strict DVI monitors may refuse the signal. If a display doesn't sync, try the `std` variant of the same resolution.

### DVI audio (firmware v0.1.4)

OCULA can embed AY audio in the DVI signal by snooping CPU writes to VIA registers and running an emu2149 AY-3-8910 emulation.

- Off by default. Enable: `set audio 1` in the USB monitor.
- **May cause DVI signal failure on pure DVI monitors** (DVI has no audio standard — audio is carried via HDMI extensions). If DVI fails after enabling audio, disable it.

---

## 8. Configuration — USB CDC monitor

Connect OCULA's USB-C port to any computer. It appears as a USB CDC serial device. Open with `minicom`, `screen`, or the WebSerial browser interface.

| Command | Effect |
|---|---|
| `STATUS` | Show current OCULA state, firmware version, config |
| `SET SPLASH` | Configure the splash screen on boot |
| `SET DVI <n>` | Select DVI output mode (list modes with `SET DVI` alone) |
| `SET MODE` | Video mode settings |
| `SET AUDIO 1` / `SET AUDIO 0` | Enable / disable DVI audio |
| `REBOOT` | Restart OCULA firmware |
| Memory read/write | Direct bus access for debugging |

There is no in-device configuration UI — all settings go through this monitor interface.

---

## 9. Firmware updates

1. Download the latest `.uf2` from `github.com/sodiumlb/ocula-pivic-firmware/releases`.
2. Hold the BOOTSEL button on OCULA, then connect OCULA via USB-C to a computer.
3. OCULA appears as a USB mass storage device.
4. Drag the `.uf2` onto it. OCULA reboots with new firmware.

---

## 10. Firmware history

All firmware releases are at `github.com/sodiumlb/ocula-pivic-firmware/releases`.

| Version | Date | Key change |
|---|---|---|
| **v0.1.0** | Oct 2025 | First release to first-wave testers |
| **v0.1.1** | Late 2025 | Major fix to decode PIO program — MAP signal compatibility; splash screen configurability |
| **v0.1.2** | Early 2026 | Data bus now driven during ULA clock phase → LOCI screen-mode detection works correctly |
| **v0.1.3** | 2026 | Multiple DVI output modes added (`set dvi`) |
| **v0.1.4** | May 2026 | DVI audio via AY emulation (emu2149, VIA write snooping); pin test mode |

Notable pre-release findings:
- **E9 errata** (GPIO leakage) found during first system test; workaround was 2 kΩ pull-down resistors on mux bridges; permanently fixed in A4 stepping of RP2350B.
- **LOCI RV1=5 fix** confirmed by multiple testers as the correct value when OCULA is installed (vs 10 for original ULA).
- **C21=100µF** confirmed by testers as resolving the "boots without pressing Reset button" issue.

---

## 11. Where to get OCULA

| Source | Type | Notes |
|---|---|---|
| **raxiss.com** | Finished board | First commercial batch planned ~April 2026. This is ISS (forum participant). Preferred — avoids SMD assembly risk. |
| Self-fabricate | PCBA job | Hardware repo is public (BSD-3-Clause). EasyEDA sources + Gerbers + BOM/PickAndPlace in `sodiumlb/ocula-hardware`. Main board is SMD — **the README explicitly says do not hand-assemble**; order as PCBA (JLCPCB or similar). Only the DIP-40 pin-header pins need manual installation. |

**If self-fabricating:** also order:
- **2× mux-bridge PCBs** (0.6 mm thickness — the only tested thickness; the 3D-printed clip frame is matched to it)
- **3D-printed clip frames** (files in `mux-bridge/clip-on-frame/`)
- **Micro-DVI adapter board** (optional; `dvi-micro-adapter/`)
- **FFC cable** — 20-pin, 0.5 mm pitch, reverse direction, ~20 cm length

---

## 12. LOCI + OCULA compatibility

OCULA changes the MAP signal timing relative to the original ULA. Without adjustment, LOCI floppy emulation will misbehave.

| Setting | Value with original ULA | Value with OCULA |
|---|---|---|
| LOCI RV1 (`tmap`) | ~10 (default) | **5** |
| LOCI `tior` | ~8 (scan with `s`) | Same procedure |

Set LOCI RV1 to 5 after installing OCULA. The adjustment is documented in the LOCI user manual and confirmed by multiple testers in forum thread `t=2709`. See [[08-loci]] §7 for the full timing tuning procedure.

The firmware fix in **v0.1.2** (data bus driven during ULA clock phase) resolved an issue where LOCI could not correctly detect the Oric's current screen mode. If running LOCI + OCULA, use firmware v0.1.2 or later.

---

## 13. Extended RAM and register map (OCULA-is-the-RAM mode)

When OCULA-is-the-RAM mode is active:

- **System RAM:** served from OCULA's internal SRAM (RP2350B has >500 kB). Up to 256 kB can be banked.
- **DRAM:** RAS/CAS suppressed. DRAM chips are idle — machines with failed DRAM can boot. Shorted/hot chips may still draw current; inspect them before relying on this.
- **Write-only register bank:** 64 locations at `$C0xx`–`$FFxx` (ROM space). Writes to ROM space are normally harmless on an Oric (MAP overlay is not active), so these locations are safe to use as OCULA configuration registers from software.
- **Safe RAM scratch:** the 256-byte page at `$03xx` (within the I/O address range) is the only page of RAM that OCULA can safely use without conflicting with any existing Oric software.

---

## 14. First-use checklist (when the OCULA experiment starts)

- [ ] Verify raxiss.com has stock, or plan PCBA fabrication with A4-stepping RP2350B.
- [ ] Before ordering mux bridges: open Metaphoric V2 KiCAD schematics and confirm IC8/IC20 equivalent mux pin assignments match the ocula-docs mapping. If they differ, post to forum `t=2709` before proceeding.
- [ ] Replace C21 with 100 µF (up to 220 µF safe). Do this even before OCULA arrives — it is a safe standalone mod.
- [ ] Prepare OCULA DIP-40 pins: long stacking pin-headers, low-profile. Do not use turned-pin headers.
- [ ] Install mux-bridge PCBs on IC8 and IC20 using the 3D-printed clip frames. Verify orientation.
- [ ] Fly-wire OCULA's open-drain reset pad to the Metaphoric reset line.
- [ ] Power on. If no boot: press physical Reset. If still no boot: check C21 and bridge orientation.
- [ ] Connect OCULA USB-C to Mac. Open monitor (`minicom -D /dev/cu.usbmodem... -b 115200`). Run `STATUS`.
- [ ] If DVI adapter fitted: try `set dvi` in monitor, select 576p 5x mode for best 50 Hz match.
- [ ] Set LOCI RV1 to 5 (if LOCI is also fitted). Test floppy emulation with a known-good `.DSK`.
- [ ] Do **not** enable `set audio 1` on first power-on — confirm DVI signal stability first.

---

## 15. Decision log

- **2026-05-18.** OCULA reference doc created. Sources: [[sodiumlb-ocula-docs]] (user manual Rev 1.1), [[sodiumlb-ocula-hardware]] (Rev 1.1 PCB), [[sodiumlb-ocula-pivic-firmware]] (firmware to v0.1.4), [[forum.defence-force.org]] digest `hardware-hacks/2709-ocula-a-ula-replacement-concept.md` (268 posts through 2026-05-13). Decision in [[10-decision-bom-order]] §3 unchanged: original HCS10017 first, OCULA experiment later. OCULA-in-Metaphoric mux mapping unverified.
