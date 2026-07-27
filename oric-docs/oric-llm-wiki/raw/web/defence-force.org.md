# defence-force.org

## Fetch log
- Inbox URL: https://www.defence-force.org/
- Final URL: https://www.defence-force.org/
- Fetched: 2026-05-17
- Pages: 6 (landing + OSDK documentation index + 4 key OSDK doc pages)
- Mode: standard
- llms.txt: absent (HTTP 404)
- Companion GitHub repo: https://github.com/Oric-Software-Development-Kit/Oric-Software (discovered from the landing-page "github repository" link)

## Landing page — https://www.defence-force.org/
Title/description: "Defence-Force: Oric and Atari software development". Site banner: "All content © 1997-2026 Mickaël Pointier and friends."

Defence Force is the personal Oric and Atari software-development site of Mickaël Pointier ("Dbug" / "Mike"), online since 1997. The current site is a "work in progress attempt at rewriting the main site"; legacy content remains on the old site (`index_old.htm`) and is being migrated. Left-hand navigation: News/Main, Oric Games, Oric Demos, Atari Demos, Associated sites.

Associated properties linked from the site:
- `blog.defence-force.org` — the Defence Force blog (technical articles on Oric programming, retro-computing, and the author's video-game career).
- `osdk.org` — the OSDK (Oric Software Development Kit) site, with its own documentation, downloads and articles.
- `defenceforce.itch.io` — itch.io pages for the Oric games 1337, Blake's 7, Impossible Mission, Oricium, Space:1999.
- GitHub: `github.com/Oric-Software-Development-Kit/Oric-Software` — source code of the games and demos.
- A phpBB forum and a wiki; a YouTube channel (the "Oriclopedia" and "Upgrade Time" video series); Twitter and Facebook pages.

Oric games published by Defence Force (available on itch.io, some on Steam): Encounter (released December 2024 on Steam and itch.io; an "HD" project; reviewed in Retro Gamer #269, BrewOtaku #006 scoring 85%, and Spanish magazine CAAD #68 scoring 9/10), 1337 (an Elite conversion), Blake's 7, Space:1999, Impossible Mission, Oricium (a Uridium conversion), plus older releases such as 4k Kong and CycloTron.

Defence Force demos: Oric demos (Barbitoric, Buggy Boy, Pushing the Envelope, Phaleon Gigademo, 256-byte intros such as Glitch Love) and Atari ST/STe demos. Demos won first place at STNICCC 2000.

The "Oric Library" is a long-running archive of downloadable Oric books and magazines (Théoric, Micr'Oric, Oric Owner, Oric Computing, CEO Mag, Rhetoric, plus user manuals and programming books).

The change history on the landing page spans 1997–2026 and is dominated by OSDK releases (versions 0.1 in March 2001 through 1.22 in February 2026) and blog articles. Recent notable entries: a 2026 blog article about modernizing the homemade PHP blog using Claude Code; OSDK 1.22 (February 2026) upgrading XA to 2.3.0, the Linker to 1.2, Header to 1.2 and PictConv to 1.2. The infrastructure ("Miniserve" webserver) has suffered several hardware failures over the years.

## OSDK — Oric Software Development Kit — http://osdk.org/

The OSDK is a cross-development toolchain for building Oric software on a modern PC. "All content © 2001-2026 by the OSDK Authors." It natively supports BASIC, C and assembler, separately or mixed in one project, and is distributed as a downloadable zip (versions osdk_0_9.zip through osdk_1_22.zip on the download page).

### Documentation index — http://osdk.org/index.php?page=documentation
Documentation sections:
- General information: Introduction, Installation, Creating project, Samples, Known issues, Glossary, Copyright.
- Compilation: Compiler, Assembler, Linker, Bas2Tap, MacroSplitter, MemMap.
- Utilities: Bin2Txt, FilePack, FloppyBuilder, Header, PictConv, Tap2Wav & Tap2Cd, Tap2Dsk, WriteDsk, Ym2Mym.
- Emulators: Euphoric, Oricutron.
- Technical information: Zero page, Libraries, Memory map, Instruction Set.

Each documentation page has a Disqus comment field and (for tools) a version history.

### Installation — http://osdk.org/index.php?page=documentation&subpage=installation
The only required setup is an `OSDK` environment variable pointing to the install folder (e.g. `SET OSDK=C:\OSDK` in AUTOEXEC.BAT, or via the Windows system-properties Environment Variables dialog). An optional `OSDKDOSBOX` variable points to a DOSBox executable so the Euphoric emulator can run with sound. The toolchain can be used on Linux via Wine. To verify the install, build and run a sample (e.g. `Osdk\sample\hello_world_simple`, run `OSDK_BUILD.BAT`).

### Compiler — http://osdk.org/index.php?page=documentation&subpage=compiler
RCC16 is an Oric-targeted version of the LCC compiler. It is decently ANSI-compliant and supports both C and C++-style comments. Optimisation level is set via the `OSDKCOMP` variable (default `-O2`; `-O3` for more aggressive optimization). Data types on the 8-bit 6502: pointers are 16 bits, `char`/`short` are 8 bits, `int` is 16 bits. Some standard library functions (memcpy, printf, ...) are implemented but most of the C standard library is not; some functions are quick hacks calling ROM routines, which makes such code work only on the Atmos (ROM releases differ between Oric-1, Atmos and Telestrat).

### Assembler — http://osdk.org/index.php?page=documentation&subpage=assembler
XA supports standard 6502 opcodes and the Rockwell 65c02 CMOS opcodes; undocumented 6502 opcodes are not supported (use `.byte` directives). The OSDK's XA originally forked from the XA source around 1998; the OSDK fork has selectively integrated features from the official XA branch (now at 2.4.1, available at floodgap.com/retrotech/xa and github.com/fachat/xa65) while adding OSDK-specific extensions. The single program `xa` assembles one or more source files into an object file, and can also produce relocatable files in the `o65` format. Key flags: `-C` error on CMOS opcodes, `-w`/`-W` enable/disable 65816 opcodes, `-c` produce object files with undefined references.

### Linker — http://osdk.org/index.php?page=documentation&subpage=linker
The linker resolves label references and appends library source code to the build. Notably the OSDK library is distributed as *source code* included by the linker before the final assembly pass — unlike most SDKs which use binary library files — so it is easy to add functions and fix bugs. Switches include `-d` (library path), `-s` (sources path), `-o` (output filename, default `go.s`), `-i` (additional include path), `-r` (language tag for conditional character replacement), `-S` (import symbols from an XA symbol file), `-B` (disable automatic inclusion of `header.s` / `tail.s`).

### Library — http://osdk.org/index.php?page=documentation&subpage=library
The OSDK ships a "decently complete" standard library plus Oric-specific functionality. `OSDK\INCLUDE` holds header files (declare new functions in `LIB.H`); `OSDK\LIB` holds assembly source files plus a `LIBRARY.NDX` index listing each source file and its exported functions. Only functions whose names start with an underscore (`_`) are accessible from C. Known issue: the libraries currently only work with the 1.1 ROM, so ROM-calling programs crash on Oric-1 or Telestrat.

### Samples — http://osdk.org/index.php?page=documentation&subpage=samples
Build a sample by running `OSDK_MAKEDATA.BAT` (if present) then `OSDK_BUILD.BAT`; run with `OSDK_EXECUTE.BAT` (F10 quits the emulator). Hello-World samples exist for BASIC (via Bas2Tap), C (single module, calls library `printf`), assembly (no library), mixed (C calling an assembly display routine), and advanced (passing parameters via the stack, XA advanced data tables). Complete project samples with released source code include the Space:1999 game (with intro and trailer) and Hnefatafl (a Viking chess game).

### FloppyBuilder — http://osdk.org/index.php?page=documentation&subpage=floppybuilder
FloppyBuilder is an alternative to a general-purpose DOS (Sedoric, TDOS, Randos) for games and demos. Because nearly all content is known at build time, FloppyBuilder stores files linearly rather than maintaining the complex sector-allocation and name-mapping structures a writable DOS needs. Advantages: faster access (linear storage), file references by integer index instead of name, significantly more usable disk space (no DOS or metadata), and almost all 16KB of overlay memory available to the user. Save games / high-score tables are handled with preallocated "save slots" reserved at build time.

### MemMap — http://osdk.org/index.php?page=documentation&subpage=memmap
MemMap reads the symbol list generated by the assembler and produces an HTML memory-usage report viewable in a browser. Invoked as `MemMap symbol_file output_html_file program_title css_file`; sample folders include `osdk_showmap.bat` wrappers.

### Other OSDK tools (from the documentation index)
Bas2Tap (BASIC source to Oric tape), Bin2Txt, FilePack (data packer/unpacker), Header (tape header manager), PictConv (image conversion for Oric and Atari ST), Tap2Wav & Tap2Cd (tape image to audio), Tap2Dsk (tape image to Sedoric/Stratsed disk image), WriteDsk, Ym2Mym (convert Atari ST / Amstrad music to the Oric MYM format), MacroSplitter. Bundled emulators: Euphoric and Oricutron (Oricutron 1.2.4 is the current default).
