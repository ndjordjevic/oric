# sodiumlb/ocula-docs

## Metadata
- Stars: 2
- Forks: 1
- Primary language: (none — documentation)
- Default branch: main
- Latest release: (none)
- License: GNU General Public License v3.0
- Homepage: (none)
- Pushed at: 2026-03-22
- Fetched: 2026-05-17
- Final URL: https://github.com/sodiumlb/ocula-docs

## Description
Documentation for OCULA, the Oric ULA replacement device.

## README
# ocula-docs
Documentation for OCULA, the Oric ULA replacement device

[OCULA User Manual](https://github.com/sodiumlb/ocula-docs/wiki/OCULA-User-Manual)

## Top-level structure
- `LICENSE` — GPL-3.0
- `README.md` — points to the OCULA User Manual in the repo's GitHub wiki
- `docs/` — `images/` only; the substantive documentation lives in the GitHub **wiki**, not the repo tree

## Docs — OCULA User Manual (from the GitHub wiki, Rev 1.1 hardware)

Fetched from https://github.com/sodiumlb/ocula-docs/wiki/OCULA-User-Manual on 2026-05-17.

### Device overview
OCULA is a device replacement for the HCS10017 uncommitted logic array (ULA) used in the Tangerine Oric family. It aims to be a low-production-cost, drop-in replacement in the size and shape of the DIP-40 original, with modern conveniences. It is part of the OCULA/PIVIC twins project (PIVIC targets the Commodore VIC-20's MOS 6560/6561 VIC-I).

Feature details:
- OCULA-is-the-RAM mode
- TTL RGB analogue video output
- Simultaneous DVI digital video output (multiple DVI modes)
- Phi system clock generation (no motherboard clock circuit needed)

### Compatibility — LOCI
Current OCULA firmware does not have the exact same MAP timing as the original ULA. RV1 adjustment on LOCI may be needed when changing from ULA to OCULA. An RV1 value of 5 has been reported to work well for the first testers.

### Hardware revisions
- Rev 1.0 — initial prototype. Erratum: DVI connector solution did not work when mounted in case (fixed in Rev 1.1).
- Rev 1.1 — switched to PIVIC-style FFC display connector and lower-cost 2MB flash. Erratum: USB-C connector extends a little close to the mux bridges.

### Hardware/firmware limitations
- System clock generation doesn't start fast enough for Oric reset (manual reset may be needed).
- Only OCULA-is-the-RAM mode is implemented so far — requires mux bridges.

### RAM modes
The original Oric ULA manages and refreshes system DRAM, controlling the muxing of ULA and CPU addresses into DRAM row/column addresses.
- **DRAM-is-the-RAM mode** (not yet implemented): OCULA behaves like the original ULA, using motherboard DRAM. No motherboard modifications needed.
- **OCULA-is-the-RAM mode** (the only implemented mode): all system memory is mapped to and served from OCULA's internal SRAM; motherboard DRAM is not used. The ULA address bus to the muxes is switched from output to input, and the two 74LS257 muxes (IC8 and IC20) on the Oric motherboard must be modified with bridged connections that route the lower CPU address bus to the ULA. A small DIP-16 mux-bridge PCB bridges each pair of mux-bit inputs with a resistor (~4.7kΩ) — resistors instead of shorts protect CPU and ULA from each other if an original ULA is used. This mode is the foundation for future advanced on-device features (extended RAM, breakpoints, tracing).

### System reset
The Oric ULA must provide at least two system-clock periods for the 6502 to reset properly. The original Oric RC reset circuit is tuned for only a few microseconds and is degraded by aging. OCULA boots in ~70µs, still not fast enough to catch the short reset. Recommendations: lengthen the reset (increase reset capacitor C21 to ~100–150µF), install a modern reset circuit, or use a manual reset / IRQ / NMI button. Future LOCI firmware will be able to reset the Oric on power-on.

### Firmware update
In-device upgrade not yet implemented; normal "Pico style" UF2 drag-and-drop is used: power off, hold BOOTSEL, connect USB-C, release button, OCULA mounts as USB storage, copy the `.UF2` file. Released firmware: https://github.com/sodiumlb/ocula-pivic-firmware/releases

### Configuration
In-device configuration not yet implemented. Changes are made via OCULA's internal monitor program over USB CDC serial (minicom/screen/WebSerial). Monitor commands: `HELP`, `STATUS`, `SET`, `REBOOT`, memory read/write. `SET SPLASH 0|1`, `SET DVI <num>`, `SET MODE 0|1` (0 = DRAM-is-the-RAM, not implemented; 1 = OCULA-is-the-RAM, mux bridges required).

### Installation — mode selection
| Use case | OCULA Mode | Replace ULA | Mux Bridges | DVI adapter | Note |
|---|---|---|---|---|---|
| Pure ULA replacement | DRAM-is-the-RAM | Yes | No | No | Not supported yet |
| ULA replacement + DVI | DRAM-is-the-RAM | Yes | No | Yes | Not supported yet |
| ULA and RAM replacement | OCULA-is-the-RAM | Yes | Yes | No | |
| ULA and RAM replacement + DVI | OCULA-is-the-RAM | Yes | Yes | Yes | |

### Power
Rev 1.1 can be powered with +5V from the Oric motherboard VCC pin and/or over USB. Two diodes ensure power flows only into OCULA — it cannot power the Oric over USB nor vice versa. Solder bridges SW1/SW2 bypass the protection diodes (experts only).

### ULA socket
Oric-1/Atmos case clearance is very low. Turned-pin headers or extra sockets likely won't fit. Best solution: create OCULA's pins from long-pinned PCB stacking headers (flat, spring-like pins, low profile). Turned pins damage single/dual-leaf sockets; directly mounting OCULA in such sockets is not recommended.

### Mux bridges — pin mapping (original Oric motherboards; other implementations may differ)
The 74LS257 muxes IC8 and IC20 have each mux-bit input pair bridged, connecting CPU address bits 0..7 to the ULA. Can be done by hand with ~4.7kΩ resistors, or with the project's DIP-16 bridge PCB + 3D-printed snap-on piggyback adapter (solderless friction fit — verify all 16 bridge points with a multimeter).

| Mux IC | Pin | Signal | System IC | Pin |
|---|---|---|---|---|
| IC8 | 2/3/5/6/10/11/13/14 | MA1/A1/MA0/A0/A5/MA5/A4/MA4 | ULA/CPU | 36/10/38/9/14/2/13/3 |
| IC20 | 2/3/5/6/10/11/13/14 | MA3/A3/MA2/A2/A6/MA6/A7/MA7 | ULA/CPU | 4/12/37/11/15/40/16/39 |

### DVI
Optional digital DVI output, parallel with the original RGB. Needs a 20-pin 0.5mm-pitch opposite-side-pads FFC cable (silver pads facing DOWN at both ends) and a connector adapter. The Micro-HDMI-type Oric case adapter fits in the RF-modulator space (requires desoldering the modulator and a longer mounting screw).
