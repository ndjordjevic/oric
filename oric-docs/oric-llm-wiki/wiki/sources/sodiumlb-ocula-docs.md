---
type: source
source_url: https://github.com/sodiumlb/ocula-docs
tags: [ocula, documentation, user-manual, ula-replacement, mux-bridge, dvi, oric-hardware, installation]
related: [sodiumlb-ocula-hardware, sodiumlb-ocula-pivic-firmware, OldWer-Metaphoric, oric.signal11.org.uk]
product: ocula-docs
detail_level: standard
created: 2026-05-17
updated: 2026-05-17
---

The `ocula-docs` repository by sodiumlb is the user documentation for **OCULA**, the open-source Oric ULA replacement device. The repository tree itself is nearly empty (a README and an images folder) — the substantive content is the **OCULA User Manual** hosted in the repository's GitHub **wiki**. The repo is GPL-3.0 licensed.

_All claims below are sourced from ../../raw/github/sodiumlb-ocula-docs.md (which captures the wiki User Manual, Rev 1.1 hardware) unless otherwise noted._

## What OCULA is

OCULA is a drop-in-shaped (DIP-40) replacement for the HCS10017 ULA in the Oric-1, Atmos, and clones. It outputs **TTL RGB analogue video** and, simultaneously, **DVI digital video** (multiple modes), and it generates the Phi system clock so no motherboard clock circuit is needed.

## The two RAM modes

The manual explains the central design split:

- **DRAM-is-the-RAM mode** — OCULA behaves like the original ULA, using the motherboard's DRAM, **no motherboard modification needed**. This is the true non-invasive drop-in — **but it is not yet implemented**.
- **OCULA-is-the-RAM mode** — all system memory is served from OCULA's internal SRAM; motherboard DRAM is unused. This **requires modifying the two 74LS257 address muxes (IC8, IC20)** with mux-bridge boards so the lower CPU address bits reach the ULA. This is currently the **only implemented mode**.

So today, fitting OCULA always means: replace the ULA **and** install 2 mux-bridges. The manual gives the full IC8/IC20-to-CPU/ULA pin mapping — and explicitly warns this mapping applies to **original Oric motherboards**; "other implementations may have rearranged mux pairs". That caveat is the heart of the OCULA-in-Metaphoric uncertainty.

## Installation highlights

- **ULA socket:** Oric case clearance is very low — OCULA's pins should be made from long stacking pin-headers, not turned pins (which damage leaf sockets).
- **Reset:** OCULA boots in ~70µs, too slow for the Oric's short RC reset; a manual reset/IRQ/NMI may be needed at power-on. Recommended fixes: enlarge reset capacitor C21 (~100–150µF) or fit a modern reset circuit. Future LOCI firmware will reset the Oric on power-on.
- **LOCI compatibility:** OCULA's MAP timing differs from the original ULA — LOCI's RV1 trimmer may need adjustment (a value of 5 reported to work for early testers).
- **Power:** +5V from the Oric VCC pin and/or USB; protection diodes prevent back-powering either way.
- **DVI:** optional; needs a 20-pin 0.5mm-pitch reverse FFC cable; the Oric case adapter mounts where the RF modulator was.

## Configuration

No in-device configuration UI yet. Settings are changed via OCULA's USB CDC serial **monitor program** (`minicom`/`screen`/WebSerial): `SET SPLASH`, `SET DVI`, `SET MODE`, `STATUS`, `REBOOT`, and direct memory read/write. Firmware updates use Pico-style `.UF2` drag-and-drop (hold BOOTSEL, connect USB).

## Relevance to the build

This manual is the practical reference for the OCULA experiment in `projects/build-journey/01-decision-bom-order.md` §3. Its most important takeaway for a Metaphoric builder: OCULA today is **not** a pure drop-in (DRAM-is-the-RAM mode is unimplemented), it needs the mux-bridge modification, and the documented mux pin mapping is for original Oric boards — Metaphoric's redesigned memory subsystem may not match.

## Ecosystem

- Hardware: [[sodiumlb-ocula-hardware]]
- Firmware: [[sodiumlb-ocula-pivic-firmware]]
- OCULA User Manual (wiki): https://github.com/sodiumlb/ocula-docs/wiki/OCULA-User-Manual
- Diagnostic and ULA-reverse-engineering context: [[oric.signal11.org.uk]]
