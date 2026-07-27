# oric.free.fr

## Fetch log
- Inbox URL: http://oric.free.fr/
- Final URL: http://oric.free.fr/
- Fetched: 2026-05-17
- Pages: 21 (landing + 7 section pages + STORY contents + 12 story chapters)
- Mode: standard
- llms.txt: absent (HTTP 404)
- Companion GitHub repo: none found
- Note: STORY/preface.html is linked from the contents page but returns HTTP 404 (broken link on the source site).

## Landing page — http://oric.free.fr/
Title: "Welcome to Oric world !"
A hub page linking to eight sections:
- Oric, the story so far (STORY/contents.html)
- Software — Disk Operating Systems, Languages (software.html)
- Hardware, Docs, DIY add-ons (hardware.html)
- Hardware programming (programming.html)
- Emulators, PC Tools (emulator.html)
- The Microtan65 page (microtan.html)
- The Phoenix page (phoenix.html)
- Photo albums (gallery.html)

The site is a long-running static HTML Oric resource. The Phoenix page notes "this oric site was first designed in 1998". The emulator page is authored by Fabrice Frances (author of the Euphoric emulator). The site is hosted on free.fr.

## Software — http://oric.free.fr/software.html
"The System Software page"

Disk Operating Systems (downloads): Oric DOS 1.13; RANDOS (with French translation of the online doc); FT-DOS (with documentation PDF); XL-DOS 0.6 (HTML documentation in French); Sedoric 3.0 (French and English versions, plus a command summary); StratSed for the TeleStrat.

Languages / tools highlighted:
- Tele-ASS manual for Telestrat (re-typed assembler manual, PDF).
- HYPER-BASIC index for Telestrat (~500 KB of re-typed text).
- TDOS / FT-DOS documentation for Jasmin (chapter II of the FT-DOS manual, transferred by Roger Barbier).
- "Sedoric à nu" by André Chéramy — a three-part annotated Sedoric listing plus annexes (PDFs).
- Forth: Forth83 implementation for the Atmos/Sedoric and Telestrat by Michel Zupan; Forth documentation by Thierry Bestel; Forth 83-STANDARD v3.1f (French Sedoric), v3.1g (German Sedoric), v2.4f (French Stratsed); TeleForth 1.2 (Telestrat cartridge, bank 4) with documentation.
- LISP: OricLisp ("expert systems at your fingers").
- C: no native C compiler exists for the Oric, but lcc65 is a C cross-compiler (compile C on a PC, build Oric executables; supports floating point). Also GCC for the 65C02 by Dave MacWherter, offered in the hope someone adapts it to a non-proprietary 6502 assembler and to the NMOS 6502.

## Hardware — http://oric.free.fr/hardware.html
"The hardware page"

Reference documents:
- Oric Hardware Programming How-To (programming.html) plus data sheets.
- "The ULA as viewed by Michael Brown" (HTML, also ASCII with Xfig/Postscript figures, plus a history document).
- Oric Schematics: Oric Motherboard (parts 1 and 2, GIF); Microdisc controller (parts 1 and 2, GIF).
- Telestrat motherboard pictures (parts 1 and 2, JPG).

DIY add-ons:
- DIY serial interface: uses only 4 chips, compatible with the microdisc controller, uses the $031C-031F address range like the Telestrat (PDF diagram + connection list).
- A simple cable to catch the vertical retrace signal: build a two-headed cable from the existing RGB cable, soldering one wire from the SYNC pin of the RGB DIN plug to the TAPE IN pin of a new tape DIN plug; every vertical retrace pulse then generates an interrupt via the VIA (CB1 flag). Used to remove flicker in games/demos.
- An interface to standard Apple2 disk controllers (by George Dramcheff): lets an Apple2 disk controller be connected to an Oric. Pros: read Apple2 disks, few components, 5.25" disks easier to find than 3". Cons: cannot read Oric or PC floppies (Apple2 controllers use GCR not MFM); standard Apple2 drives are single-sided (140 KB formatted).

## Hardware programming — http://oric.free.fr/programming.html
"Hardware Programming on the Oric" by Fabrice Frances (Fifth edition). Contents: Introduction; UAL; VIA; PSG; Keyboard; Printer and joysticks; Screen; Floppy Drive interfaces (Microdisc, Jasmin); Tape; Serial; Real Time Clock; Second VIA (Telestrat); plus appendices (6502 instruction set, 6522 VIA, AY-3-8912 PSG, WD1793 FDC, 6551 ACIA, Intersil ICM7170 RTC data sheets).

Introduction — Oric Hardware: Oric computers are powered by a 6502 processor at 1 MHz. All share the Oric-1/Atmos central architecture: CPU, system bus, a VIA (Versatile Interface Adapter), a UAL (Universal Array Logic), and a PSG (Programmable Sound Generator). On the Telestrat the NMI line is not connected (the reset button connects to the Reset line). The UAL clocks the CPU and peripherals, manages memory-select signals, and displays the screen. The VIA is a 6522, central to the basic peripherals — keyboard, PSG, tape, printer port — and provides 7 interrupt sources and timers. The PSG is a General Instruments AY-3-8912 (identical to Yamaha's 2910); its CMOS technology forced a weird interfacing of select/data lines to the VIA.

UAL: labelled HSC 10017; builds clock signals, memory signals (a simple MMU), and video signals. IO is active when page 3 is addressed; the internal Oric ROM is selected for addresses C000-FFFF. The VIA's 16 registers appear 16 times in page 3; for compatibility, access the VIA at 0300-030F. Video is programmed by inserting control bytes inline with screen data (serial attributes).

VIA: the 6522 has two 8-bit IO ports (A, B) plus control lines. Port A is a secondary bus (PA0..PA7 connect to the PSG data bus and printer port; PSG selection via CA2/CB2). Port B connects to keyboard, tape, printer. VIA line usage: PA0..PA7 = PSG data bus / printer data; CA1 = printer acknowledge; CA2 = PSG BC1; PB0..PB2 = keyboard line demultiplexer; PB3 = keyboard sense; PB4 = printer strobe; PB5 = not connected; PB6 = tape motor control; PB7 = tape output; CB1 = tape input; CB2 = PSG BDIR. Timer 1 is used by the ROM for a 1/100 s interrupt (WAIT, keyboard poll, screen refresh).

PSG: AY-3-8912, three-channel sound generator (square-wave tones plus envelope and noise). On the Oric the three outputs are wired together to the loudspeaker. PSG selection via BDIR/BC1: 00 = not selected, 01 = read register, 10 = write register, 11 = index register selected. PSG register 14 (0Eh) is an IO port used to select a keyboard matrix column.

Keyboard: a passive matrix; the CPU polls it (64 tests). Sense a key by programming a line (0-7) in PB0..PB2 and selecting a column in the PSG IO port; read PB3 (1 = pressed). The Oric-1 keyboard has 57 keys (no FCT key), the Atmos 58; eight matrix locations are unwired.

Printer and joysticks: the Centronics port has 20 pins (10 ground), only 2 control lines (Strobe, Acknowledge). The port is bidirectional and can read joysticks via a PASE interface (bit 7 selects left joystick, bit 6 right; bits 0,1,3,4,5 sense left/right/down/up/fire).

Screen: the ULA displays 224 lines of 240 pixels in 8 colours (1 bit each RGB). Colours set via inline control bytes ("serial attributes", bits 5 and 6 both 0). Screen memory starts at A000 or BB80 depending on character/bitmap mode. Hires mode: 6 low bits of a byte = 6 pixels; bit 7 = inverse video. Text mode: 7 low bits = ASCII 32-127, selecting a char-set byte. Attribute types: foreground colour, text attributes (charset/double height/blinking), background colour, video mode (text/hires, 50/60 Hz). After 200 lines the ULA reads from BF68. Mixing text and hires lines on one screen is possible.

Floppy drive interfaces: all driven by Western Digital FDC family — 177x for the Jasmin, 179x for the Microdisc (and Telestrat). FDC 1793/1773 are compatible but surrounding circuitry differs. FDC accessible at 0310-0313 (Microdisc) or 03F4-03F7 (Jasmin). Microdisc location 0314 write bits: bit 7 EPROM select, bits 6-5 drive select, bit 4 side select, bit 3 double-density enable, bit 2 clock divisor, bit 1 ROMDIS (0 disables internal Basic ROM), bit 0 enable FDC INTRQ. Microdisc also gives access to overlay RAM (C000-FFFF) and the interface's 8 KB EPROM. Jasmin: location 03F8 side select, 03F9 disk controller reset, 03FA overlay RAM access, 03FB ROMDIS, 03FC-03FF drive select.

Tape: writing is a square waveform on bit 7 of VIA port B. Oric-1/Atmos system software mixes 2400 Hz and 1200 Hz. SLOW mode: 4 periods of 1200 Hz = 0, 8 periods of 2400 Hz = 1 (300 baud). FAST mode (1600-2400 baud). One byte is written as 13 bits: a start 0, 8 data bits, a parity bit, three 1 bits. Reading measures edge intervals on CB1.

Serial: no standard serial port on the Oric-1/Atmos; one is standard on the Telestrat. Serial interfaces use the 6551 ACIA at 031C on the Telestrat.

Real Time Clock: a rare extension, useful for BBS use since no Oric OS stores file time/date. The alarm interrupt line was not connected, so the alarm must be polled.

Second VIA (Telestrat): a second 6522 at address 0320, interfacing new hardware and selecting memory banks. PA0..PA2 select one of 8 memory banks (C000-FFFF range): bank 0 = overlay RAM (loaded with StratSed when booting from disk), banks 1-7 from cartridges; bank 7 holds TeleMon and the Telestrat boots on it. Other PA/CA/CB lines connect to joystick ports, mouse buttons, phone-ring detection, and the "Midi" port (which the author argues is not usable as a real MIDI connector). PA4 selects RS232 vs Minitel port for the ACIA.

## Emulators and tools — http://oric.free.fr/emulator.html
"The emulators and tools page" (authored by Fabrice Frances).

Emulators: Amoric 1.5 for Amiga (Jean-François Fabre); ArcOric 1.2 for Acorn Archimedes and Risc PC (Thomas Olsson, Bent Valerius); Atoric 0.9 for Atari (Christian Peppermueller) with an optimization patch for VGA; Emul8D, a Pravetz 8D emulator; Euphoric (by the site author Fabrice Frances) — Euphoric-1 for DOS; MESS; Oricutron, the portable Oric emulator (Peter Gordon) with ports for Windows, MacOS X, MorphOS, AmigaOS.

PC tools: tap2dsk (builds a Sedoric/Stratsed disk image from a tape image); a gateway program for PCs (connect an Oric with a serial interface to the Internet, or two Orics over the Internet); TapeTools collection for Euphoric (WAVCLEAN, WAV2TAP, TAP2WAV); tap2cd (generates audio from tape images; the Oric loads them 10x faster); Oric K7 (Thomas Gemmp — handles individual files in a tape image like a PKware archive); CAP 2.1 (Convert Atmos to PC, by Robert Chéramy); CIP 1.0 (CAP equivalent for disk images); CHKSUM 1.1 (PC equivalent of Sedoric's CHKSUM); disklink (Philippe Menard — transfer 3" Oric disks to PC, Microdisc or Jasmin); Init (Robert Chéramy — format real Oric disks with a PC).

## The Microtan 65 page — http://oric.free.fr/microtan.html
The Microtan 65 is presented as the Oric-1's ancestor — produced by Tangerine Computer Systems. Resources: main board and TANEX schematics (PNG); a Microtan Java emulator; Microtan 65 Users Manual, BASIC Users Manual, TANEX User Manual, XBUG User Manual; Microtan World Magazine; Ray Gannon's description of the Microtan 65; a 1K 6502 programming contest.

Microtan vs ZX80 comparison: 1 KB RAM standard including video memory (pages 2-3 used as video memory, 16x32 chars) — these constraints prevent BASIC use, so the un-extended Microtan was machine-code only. 1 KB ROM standard, containing TANBUG v1 (a primitive monitor); the hardware supports single-stepping programs and interrupting runaway programs. Highly expandable: TANEX added 7 KB static RAM and 14 KB ROM; TANRAM added 40 KB dynamic RAM (48 KB total); a TANDISC board allowed floppy disks with DMA. Video: no ULA — 16 lines of 32 characters (8x16 matrix), flicker-free by exploiting the 6502 idle bus half-period; 1K x 9-bit memory, the 9th bit selecting on-the-fly-generated mosaic characters for a 64x64 total resolution.

## The Phoenix page — http://oric.free.fr/phoenix.html
"The Oric Phoenix page" — a temporary repository for first documentation on the Oric Phoenix. Documents: Phoenix board information (PDF); Phoenix unofficial manual (PDF); Phoenix ROM; Phoenix ROM commented disassembly (txt); Phoenix board pictures and schematics (external Google Photos album).

## Photo albums — http://oric.free.fr/gallery.html
"Links to shared albums on Google Photos." Albums: Gallery of Oric Computers; Oric Phoenix board; New Oric multi-cartridge project; NewGen Oric Notebook version 2; Oric exhibition at Vieumikro 2010; Microtan 2065; 65816 module; First Oric cartridge; Small notebook in Atmos colors.

## STORY — "Oric, the story so far" — http://oric.free.fr/STORY/contents.html
A 12-chapter history of the Oric by Jonathan Haworth (Second Edition, November 1992; Copyright 1989, 1992). Chapters: 1 Conception and Birth; 2 A CLOAD of trouble; 3 Promises, promises; 4 All's well that ends well; 5 Enter the Atmos; 6 Summer madness; 7 Optimism confounded; 8 The final rites?; 9 A Phoenix arisen; 10 Eureka!; 11 Plus ça change; 12 Dream a little dream.

Chapter 1 — Conception and Birth: Tangerine Computer Systems Ltd was set up near Cambridge in October 1979 by Dr. Paul Johnson and Barry Muncaster, producing the Microtan 65. Oric Products International Ltd was incorporated in April 1982 with British Car Auctions as backer; Tangerine acted as R&D house. The Oric-1 evolved from a "Microtan 2" concept (an earlier three-processor "Tangerine Tiger" design was sold off). "Oric" is an anagram of the last four letters of "micro". Official launch party 27 January 1983 at Coworth Park, Ascot; Sales Director Peter Harding pledged to "beat Clive Sinclair". 16K Oric £129, 48K £169.95. The ULA was laid out as a TTL version then turned into CMOS gate arrays by California Devices Inc. The ROM was written mostly by Andy Brown and Chris Shaw; cassette routines (described as shoddy) and Oric Mon by Peter Halford; sound routines by Paul Kaufman.

Chapter 2 — A CLOAD of trouble: the launch was dogged by delivery problems and delayed ROM chips. Severe tape-loading problems emerged; Oric blamed cassette duplicator Cosma. The Oric-1 was exported to France from early 1983 — an exclusive distribution deal was signed 29 June 1983 with A.S.N. ("Oric France"). In March 1983 Fabrice Broche bought his Oric-1 and began disassembling the ROM.

Chapter 3 — Promises, promises: continued promises of peripherals (discs, modem). Oric guarded ROM internals partly because Tangerine had a Microsoft BASIC licence that Oric never obtained for itself. IJK released the PASE joystick interface; the price was cut to £99.95 (16K) by late 1983.

Chapter 4 — All's well that ends well: Edenspring Investments (Barry Muncaster) injected cash. The Oric-1 won the Best Home Computer award in France in October 1983. The Kenure Plastics factory burned down 13 October 1983. Edenspring acquired Oric in November 1983.

Chapter 5 — Enter the Atmos: the Oric Atmos entered full production 16 January 1984 (£170), with the V1.1 ROM and a new keyboard with a Function key. The first V1.1 ROM still had a faulty tape error-checking routine. 160,000 Oric-1s were delivered in 1983. Théoric magazine launched in France, April 1984.

Chapter 6 — Summer madness: an Oric advert comparing the Atmos to the Commodore 64 was censured by the Advertising Standards Authority. Microdiscs reached £299. A dispute raged in France between A.S.N. (Denis Taieb) and Théoric magazine.

Chapter 7 — Optimism confounded: "the beginning of the end." Oric owed ~£2.5 million to suppliers; Pan Books threatened a writ over the Atmos manual. The Modem finally shipped (£100) 18 months late. Denis Taieb resigned from A.S.N. on 1 October 1984.

Chapter 8 — The final rites?: Paul Kaufman and Cathie Burrell left Tansoft to found Orpheus. The Oric Stratos was launched at the Frankfurt Computer Show on 1 February 1985. On 2 February 1985 Edenspring put Oric into receivership — debts £5.5 million, assets £3 million.

Chapter 9 — A Phoenix arisen: ITL Kathmill went into receivership. Six bidders pursued Oric. On 1 June 1985 S.P.I.D. (Jean-Claude Talar) bought Oric for "several hundred thousand pounds"; production moved to Normandy. Tansoft went into liquidation in June 1985; Cumana launched an Oric disc drive (£235).

Chapter 10 — Eureka!: Oric International (formerly Eureka) employed Fabrice Broche and Dennis Sebbag in August 1985 to complete a new disc operating system, Sedoric, launched that autumn to wide praise. In November 1985 Broche began work on the Telestrat — a communication-oriented machine tied to the French Minitel network, with an 11-port design and compiled BASIC, reviewed in early 1986.

Chapter 11 — Plus ça change: the Telestrat finally shipped in late September 1986 (£399). Fabrice Broche published "L'Oric à Nu" (the Naked Oric), a fully commented disassembly of the V1.0 and V1.1 ROMs. Atmos production ceased March 1987. In December 1987 Oric International went into receivership a second time. 6,000 Telestrats were sold in all. The company was wound up in December 1988.

Chapter 12 — Dream a little dream: the post-commercial Oric scene — user groups and magazines (O.U.M. / Oric User Monthly, Club Europe Oric / C.E.O.mag), the Sedoric Manual in English, Dr. Ray McLoughlin's Sedoric V2.0 for 3.5" drives, and annual O.U.M. meetings. Oric Products International "lasted precisely two years and six days." Haworth attributes the failure to over-optimism and crass marketing/pricing decisions, especially the failure to ensure good software early. The history ends "NOT THE END," hoping the Oric name will live on as a hobby.
