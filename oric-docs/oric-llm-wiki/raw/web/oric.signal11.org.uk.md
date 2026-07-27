# oric.signal11.org.uk

## Metadata
- Slug: oric.signal11.org.uk
- Pages fetched: 7 (landing + 6 project pages)
- Fetched: 2026-05-17
- Final URL: https://oric.signal11.org.uk/
- llms.txt: absent (404)
- Site owner: Mike Brown (© 2009–2024 Mike Brown)
- Entry point in inbox: https://oric.signal11.org.uk/html/diagrom.htm

## Landing page — https://oric.signal11.org.uk/

"Oric And Atmos Support" — a small static support site for the Oric-1 and Oric Atmos, maintained by Mike Brown. It indexes six Oric hardware projects:

1. **Cumana** — `html/cumana.htm` — "An annotated version of the Cumana Disk Interface schematic"
2. **Repair Guide** — `html/repairguide.htm` — "Hints to getting a broken Oric/ATMOS up and working"
3. **Diagnostics** — `html/diagrom.htm` — "diagnostic ROM and simple hardware can be used to fault find and verify an Oric/ATMOS that is faulty"
4. **Twin ROMS** — `html/twinrom.htm` — "fit a second 27128 EPROM/ROM into an Oric or ATMOS, allowing manual selection"
5. **ULA V1** — `html/ula1.htm` — "black-box deconstruction from the observed behaviour of the Oric ULA HCS10017"
6. **ULA Die Shots** — `html/ula-dieshot.htm` — "Images of the Oric HCS10017 ULA"

Contact: oric@signal11.org.uk. Parent site: http://www.signal11.org.uk/. Also has a forum and blog. Source, documentation and pictures © 2009–2024 Mike Brown.

## Diagnostics page — https://oric.signal11.org.uk/html/diagrom.htm

**Diagnostic ROM and PCB.** "This is a replacement 16K ROM image to install on an Oric/Atmos mainboard to perform step-by-step test CPU/ULA/DRAM/VIA/PSG and associated circuitry. Includes schematic and PCB layout for optional external ROM/status LEDs/ULA replacement clock source and source code."

Downloads:
- Diagnostic ROM images — Ver 1.08k (ZIP 7KB)
- Diagnostic ROM .ASM source — Ver 1.08k (ZIP 23KB)
- Documentation — Ver 1.08 (PDF 2.5M)
- Diagnostics PCB — External ROM board Rev 1 (GIF 164KB)
- EagleCAD Project for Diag PCB (ZIP 48KB)

Errata 2023/05/10: "ROM revision 1.08k corrects a small initialization bug with the VIA chip." Both a Standard (50Hz) version and a 60Hz screen-compatible version are provided within the same ZIP.

Page last updated 10/May/2023.

## Repair Guide page — https://oric.signal11.org.uk/html/repairguide.htm

**Oric and Atmos Repair Guide.** "This document is a list of tips to getting a dead Oric board at least partly working. It would be helpful to have the Oric Schematic and Oric Service Manual on hand too. Use at your own risk!"

Downloads:
- Oric Repair Checklist V1.0 (PDF 61KB)
- Oric Repair Checklist V1.0 Images (ZIP of JPG 524KB)

Errata 2021/02/04: Section 3 — "7. Ensure 8.86MHz clock available at IC24 pins 8, 12 and 5 to IC23 pins 5 and 6." should read "4.43MHz clock".

## ULA V1 page — https://oric.signal11.org.uk/html/ula1.htm

**ULA Deconstruction 1.** "Back in 1996, when there was little hope of finding replacement HCS10017 ULAs for Oric, I began a deconstruction of the ULA's internals, using observed behaviour (the software inputs from memory, hardware outputs). This is the result of that process. There are some known minor discrepancies."

"As of August 2018, I have reverse engineered the actual schematic from a decapped and photographed example of the real silicon and its corresponding verilog file" (see the ULA Die Shots page).

"If you are searching for a replacement ULA for a broken Oric, look on eBay. They are now available from various sellers in Europe as NOS (new-old-stock) parts."

Download: the original 1996 ZIP file of text and PostScript documentation.

## ULA Die Shots page — https://oric.signal11.org.uk/html/ula-dieshot.htm

**ULA Decapped!** "In July 2018, Lance Ewing (Dreamseal) secured the de-capping of an actual Oric ULA. Six weeks of fairly intensive reverse-engineering, drawing and documenting later, we finally have access to the complete schematics, documentation and simulation of the ULA."

Downloads (derived from the DATEL files; die-shot by Mike Connors):
- Original die-shot — full size (24k × 24k pixels, ~100MB) and reduced sizes (8k × 8k, 19MB; 4k × 4k, 7MB)
- README file / credits / notes
- "MJB Guide Pictures" — modified images marking the location of logic cells and I/O pin areas

## Twin ROMS page — https://oric.signal11.org.uk/html/twinrom.htm

**Twin ROMs Mod.** "This is a way to fit a second 27128 ROM/EPROM inside an Oric or Atmos to allow manual selection between Oric (V1.0) and Atmos (V1.1) BASIC, or any other firmware you may wish to load. It's a different method to the ROMDIS modification published elsewhere. Includes schematic and pictures."

Download: Twin ROM 2 documentation (PDF 2.4MB).

## Cumana page — https://oric.signal11.org.uk/html/cumana.htm

**Cumana Disk Interface.** "This is an annotated version of the Cumana Disk Interface schematic."

Important annotation: "the schematic has a small error regarding the connection of the Cumana voltage rails (5v/0v) to Oric's expansion port (P1) at pin 33/34. THERE IS NO CONNECTION between the 5v and 0v rail of the disc interface and pins on the expansion port as shown!" A common connection is required but not explicitly shown; the PSU in the Cumana unit feeds the 7905 regulator (REG1) and the Oric DC jack, so the common line is the "Vcc" (0v/+5v) labelled line.
