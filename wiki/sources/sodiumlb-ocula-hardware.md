---
type: source
source_url: https://github.com/sodiumlb/ocula-hardware
tags: [ocula, oric-hardware, ula-replacement, hcs10017, pcb, easyeda, mux-bridge, dvi, open-hardware]
related: [sodiumlb-ocula-pivic-firmware, sodiumlb-ocula-docs, OldWer-Metaphoric, oric.signal11.org.uk, raxiss.com, MiSTer-devel-Oric_MiSTer]
product: ocula-hardware
detail_level: standard
created: 2026-05-17
updated: 2026-05-17
---

The `ocula-hardware` repository by sodiumlb holds the open hardware design files for **OCULA** — a modern, open-source replacement for the proprietary HCS10017 ULA used in the Oric-1, Atmos, and Oric clones. It is BSD-3-Clause licensed: EasyEDA schematics and PCB sources plus Gerber/BOM/PickAndPlace production files for the main board, the mux-bridge boards, and an optional Micro-DVI adapter.

_All claims below are sourced from ../../raw/github/sodiumlb-ocula-hardware.md unless otherwise noted._

## What it is

OCULA is a DIP-40-shaped board that drops into the original ULA socket. The repository provides everything needed to have it fabricated and assembled. Because OCULA is a surface-mount design, the README explicitly states it is **not recommended to hand-assemble anything beyond the through-hole connectors** — the main board is meant to be ordered as a PCBA (assembled) job; only `IC1`, the ULA DIP-40 pin layout, is left for manual pin-header installation.

## Repository contents

- **`pcb/`** — the main OCULA board, current revision **1.1**: EasyEDA schematic/PCB JSON sources, `schematics_ocula-1.1.pdf`, Gerbers, `BOM_ocula-1.1.csv`, and PickAndPlace file for PCBA.
- **`mux-bridge/`** — the DIP-16 mux-bridge boards (`pcb/`) and a 3D-printed snap-on piggyback frame (`clip-on-frame/`).
- **`dvi-micro-adapter/`** — the optional Micro-DVI output adapter: PCB plus a 3D-printed Oric case adapter that mounts in place of the RF modulator.
- **`images/`** — assembly photos.

## Key design notes

- **OCULA-is-the-RAM mode needs 2 mux-bridges.** The current firmware only supports OCULA-is-the-RAM mode, which requires both mux-bridge boards installed on the Oric motherboard's two 74LS257 address muxes (IC8 and IC20). The bridges connect each mux-bit input pair through a resistor — resistors rather than shorts so an original ULA still works if swapped back. See [[sodiumlb-ocula-docs]] for the full pin mapping.
- **Low case clearance.** Oric-1/Atmos cases leave very little room above the PCB. The recommended mounting is to form OCULA's pins from long stacking pin-headers (flat, spring-like, low-profile) rather than turned-pin headers or extra sockets.
- **Mux-bridge PCBs are 0.6 mm** thick — the only tested thickness; the 3D-printed snap-on frame is matched to it.
- **Micro-DVI adapter** is optional; needs a 20 cm, 20-pin, 0.5 mm-pitch, reverse-direction FFC cable.
- BOM intentionally omits the serial-debug header (J1), a flash pull-up (R4), and IC1's pins.

## Relevance to the build

For the Metaphoric build (see `build-journey/01-decision-bom-order.md` §3), OCULA is the *open* alternative to the proprietary HCS10017 — the design files here are exactly what makes "understand every piece" possible for the ULA. The caveats: OCULA must be ordered assembled (SMD), and OCULA-in-Metaphoric compatibility is unverified — the mux-bridge pin mapping documented in [[sodiumlb-ocula-docs]] is stated to apply to *original* Oric motherboards, and Metaphoric has a redesigned memory subsystem.

## Ecosystem

- Firmware: [[sodiumlb-ocula-pivic-firmware]]
- User documentation: [[sodiumlb-ocula-docs]]
- OCULA shares its firmware with the VIC-20 PIVIC project (the OCULA/PIVIC twins).
- Forum development thread: `forum.defence-force.org` thread `t=2709` — see [[forum.defence-force.org]].
- Same author (sodiumlb) as the LOCI storage peripheral — see [[raxiss.com]].
