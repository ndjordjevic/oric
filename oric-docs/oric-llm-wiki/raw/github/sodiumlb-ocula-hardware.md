# sodiumlb/ocula-hardware

## Metadata
- Stars: 0
- Forks: 1
- Primary language: (none — hardware design files)
- Default branch: main
- Latest release: (none)
- License: BSD 3-Clause "New" or "Revised" License
- Homepage: (none)
- Pushed at: 2026-03-21
- Fetched: 2026-05-17
- Final URL: https://github.com/sodiumlb/ocula-hardware

## Description
Hardware design files for the Oric OCULA ULA replacement project.

## README
# ocula-hardware
Hardware design files for the Oric OCULA ULA replacement project.

## Related projects
[User Documentation](https://github.com/sodiumlb/ocula-docs)
[Firmware](https://github.com/sodiumlb/ocula-pivic-firmware)

## Important notes
OCULA hardware has been designed for low cost assembled production. It is not recommended to attempt manual assembly of anything other than through-hole components (headers, connectors).

Currently only OCULA-is-the-RAM mode is supported by the firmware, which means 2 mux-bridges are required for normal operation. The Micro DVI adapter and cable is optional.

## Main OCULA PCB
See pcb directory for design files for PCB production and PCBA of all surface mounted components. Due to very low clearance inside Oric-1 and Atmos cases, it is recommended to use stacking pin-headers to create flat pins on OCULA to allow low-profile mounting in machines with sockets.

## Mux bridges
The mux bridges use thin PCBs - 0.6mm is the only tested PCB thickness. The 3D printed snap-on frame will require modification if the PCB is different. The mux bridge modification is extremely simple and other solutions can be created. The effort put into this particular mux bridge design is to allow non-destructive but reliable modification of the Oric most people can use.

The current design is best assembled by first snapping the PCB into the 3D printed frame, then soldering in the 8 required pins. Thin, flat, flexible pins are needed here to make good contact with the mux ICs, thus it is recommended making these from the same stacking pin-headers as for the OCULA pins. Take care not to apply too much heat or use too long time, the 3D printed snap-on-frame will warp easily.

## Micro DVI adapter
The micro DVI adapter is optional. See the dvi-micro-adapter for PCB and 3D print adapter design files. The required cable spec is FFC, 20cm, 20pin, 0.5mm pitch, reverse direction (contacts are on opposing side on each end).

The 3D printed Oric adapter is designed to fit in place of the RF modulator. To secure the adapter, a longer screw is needed in place of the original PCB mounting screw fitted next to the RF modulator.

## Using stacking pin row headers to create IC pins
While there are many options for adding IC pins to PCBs, the solution that has provided the best low-cost way to get close to compatible with original IC pins, is to create them from long pinned PCB stacking headers. These have flat pins in a more spring-like metal that serves this alternative application well. This example shows 1x20 row 11mm stacking pin row headers.

# Disclaimer
OCULA is an open source project by and for Oric users. It is provided AS-IS. For more information see each sub-project license agreement.

## Docs

### pcb/README.md — OCULA PCB Notes
The PCB package consists of EasyEDA SCH schematics and PCB board design source files, and Gerber, BOM and PickAndPlace production files for PCBA.

BOM Notes — the following components are intentionally excluded from the BOM:
1. J1 — Serial debug terminal header. Not needed for normal use.
2. R4 — Flash pull-up resistor. A 10k pull-up may be needed for different flash chips.
3. IC1 — The ULA DIP-40 pin layout. IC pin substitutes (pin-headers) must be installed manually after PCBA.

## Top-level structure
- `LICENSE` — BSD 3-Clause
- `README.md`
- `pcb/` — main OCULA PCB design: `BOM_ocula-1.1.csv`, `Gerber_ocula-1.1_PCB_ocula_1.1.zip`, `PCB_PCB_ocula_1.1.json` (EasyEDA), `PickAndPlace_PCB_ocula_1.1.csv`, `SCH_ocula-1.1.json`, `schematics_ocula-1.1.pdf`, `README.md` — current rev 1.1
- `mux-bridge/` — the DIP-16 mux-bridge boards: `pcb/` and `clip-on-frame/` (3D-printed snap-on piggyback adapter)
- `dvi-micro-adapter/` — optional Micro-DVI output adapter: `pcb/` and `oric_adapter/` (3D-printed adapter that mounts in place of the RF modulator)
- `images/` — assembly photos (stacking pin-header jigs, low-profile pins, mounted-in-system shots)
