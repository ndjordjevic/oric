# osdk.org

## Fetch log
- Inbox URL: https://osdk.org/
- Final URL: https://osdk.org/
- Fetched: 2026-05-17
- Pages: 10
- Mode: standard

## Landing page — https://osdk.org/

# OSDK - The Oric Software Development Kit

## Navigation
- Main
- Download
- Documentation
- Articles
- Issues

## Overview
The OSDK is a cross-development system for creating software on the Oric range of computers, including the Oric 1, Oric Atmos, Oric Nova 64, Pravetz 8D, and Oric Telestrat.

## System Requirements
The OSDK runs on Windows and is compatible with Wine for Linux use.

## License Model
Key permissions and restrictions:

- Users may freely use the SDK to build anything, including commercial products
- Source code modification, forking, and extension are permitted
- Reselling the SDK source code is prohibited
- Taking credit for the original work is not allowed
- Crediting original authors in documentation is appreciated

The underlying philosophy emphasizes that while volunteers created this tool freely, users may leverage it for their own projects without restrictions on commercialization, provided they respect authorship.

## Notable Project
"Born in 1983" — a demo released in 2013 celebrating thirty years of the Oric 1, created by Defence Force.

*OSDK © 2001-2026 by the OSDK Authors*

## Download page — https://osdk.org/index.php?page=download

# OSDK Downloads

## Latest Release
**OSDK Version 1.23** (April 20, 2026) includes upgrades to XA assembler 2.3.1, Linker 1.4, PictConv 1.3, Compiler 1.40, and MacroSplitter 0.2. Notable improvements include "many bug fixes: defined() in #if, 0x prefix parsing, division by zero, macro expansion" and new directives for symbol handling.

## Key Information

**System Requirements:** The prebuilt archives contain Windows executables that work with Wine on Linux. Users needing native Linux versions can build from source code available on GitHub.

**Source Code:** The complete source resides at https://github.com/Oric-Software-Development-Kit/osdk/tree/master/osdk/main, with a forum thread discussing Linux compilation details.

## Historical Context
The toolkit evolved from a basic 0.1 release in 2001 to a comprehensive development platform. Major milestones include integrating the Euphoric emulator (version 0.3, 2002), adding graphical tool support like PictConv and FilePack (version 0.4), and transitioning to Oricutron as the default emulator (version 1.0, 2014).

**Quality Assurance:** The project undergoes Coverity static analysis scanning for code quality.

## Docs — https://osdk.org/index.php?page=documentation

# OSDK Documentation

The documentation is organized into several categories:

**General Information** covers foundational topics including "Introduction," "Installation," and "Creating project," along with samples, known issues, glossary, and copyright information.

**Compilation tools:**
- Compiler (RCC16 — LCC-based ANSI C compiler)
- Assembler (XA — 6502 assembler)
- Linker
- Bas2Tap — converts BASIC programs to tape images
- MacroSplitter — preprocessor utility
- MemMap — symbol/memory-map HTML report generator

**Utilities:**
- Bin2Txt, FilePack, FloppyBuilder, Header, PictConv, Tap2Wav & Tap2Cd, Tap2Dsk, WriteDsk, Ym2Mym

**Emulators:** Euphoric, Oricutron

**Technical Information:** Zero page, Libraries, Memory map, Instruction Set

*No known problem — please signal any issue on the Cross development tools forum.*

## Installation — https://osdk.org/index.php?page=documentation&subpage=installation

The OSDK requires configuration of an environment variable. Users must set `OSDK` to point to their installation directory, such as `C:\OSDK`.

On Windows 2000 and later, this can be done through System Properties advanced settings rather than modifying AUTOEXEC.BAT. An optional second variable, `OSDKDOSBOX`, enables running Euphoric through DOSBox with sound support.

### Testing the Installation

After setup, users can verify functionality by navigating to the sample directory and executing `OSDK_BUILD.BAT`. A successful build generates several files in a BUILD folder, including the compiled binary and tape file.

### Linux Alternative

Wine users on Linux can install and run OSDK similarly to Windows. The process involves extracting the archive to the Wine C: drive location and setting environment variables through Wine's registry editor. However, the Euphoric emulator doesn't function under Wine, though generated programs remain compatible with other Oric emulators like Oricutron.

Users encountering "out of environment space" errors may need to modify their `config.sys` file to increase available memory for the command shell.

## Compiler — https://osdk.org/index.php?page=documentation&subpage=compiler

# RCC16 — OSDK C Compiler

**RCC16** is an Oric-targeted version of the LCC Compiler that aims for ANSI compliance while supporting C++ comments.

### Data Types for 6502 Architecture
- Pointers: 16 bits
- char/shorts: 8 bits
- int: 16 bits

**Optimization:** The compiler supports configurable optimization levels via the `OSDKCOMP` variable, defaulting to `-O2` with `-O3` available for aggressive optimization.

### Library Support

Some standard functions (memcpy, printf, ...) are implemented, but most of the standard library is not available. Functions calling ROM operations work only on ATMOS due to ROM version differences.

### Version History / Notable Issues
- **Active Known Issue (#37):** Parsing errors cause internal compiler crashes when encountering malformed preprocessor directives like `0xif 0`.
- **v1.40 fix:** The compiler now properly reports errors when expressions exceed the 8-register temporary limit, rather than silently generating invalid assembly code.
- Version history from 1.35 through 1.40 documents improvements to assembler directives, data table encoding, and optimization handling.

## Assembler — https://osdk.org/index.php?page=documentation&subpage=assembler

# XA — OSDK 6502 Assembler

The OSDK assembler is called **XA** and supports standard 6502 opcodes and CMOS versions (Rockwell 65c02). It originated from a fork of XA around 1998, with selective integration of features from the official branch.

### Basic Usage

```
xa [options] Source1 [Source2 ...]
```

### Key Command-Line Options
- `-C`: Error codes for CMOS opcodes
- `-w`: Enable 65816 opcodes
- `-c`: Produce object files with undefined references
- `-cc`: CC65-compatible object files
- `-v`: Verbose mode
- `-R`: Relocatable code with relocation table
- `-o filename`: Set output file
- `-e filename`: Set error log
- `-l filename`: Set label list
- `-E filename`: Export global symbols as equates
- `-a`: Allow unnamed labels (`:`, `:+`, `:-`)
- `-b? adr`: Set segment start address
- `-D`: Define preprocessor replacement

### Supported Data Types
- `.byt`/`.asc`: Byte values or text strings
- `.word`: 16-bit words
- `.dsb`: Fill memory block
- `.align`: Align to byte boundary
- `.bin`: Include raw binary file data
- `.assert`: Conditional assembly check
- `.asserteq`: Equality assertion

### Label Features
Labels support global prefixes (`+`), block-level prefixes (`&`), redefinition with dash (`-`), cheap local labels (`@`-prefixed, scoped to preceding standard label), and unnamed labels with `-a` flag.

### Preprocessor Directives
Supports C-like preprocessing including `#include`, `#define`, `#ifdef`, `#if`, `#else`, `#endif`, `#error`, and `#print`. Supports nested comments (`/* */`) and continuation lines ending with backslash.

## Linker — https://osdk.org/index.php?page=documentation&subpage=linker

# OSDK Linker

The Linker solves the referencement of labels, and eventually appends library source codes to the build process.

### Key Command-Line Switches
- `-d`: Specifies library file locations
- `-s`: Defines source file paths
- `-o`: Sets output filename (default: 'go.s')
- `-l`: Prints defined labels
- `-v`: Activates verbose mode
- `-q`: Enables quiet mode
- `-b`: Disables automatic inclusion of header/tail files
- `-i`: Defines additional include file search paths
- `-r`: Sets language tag for conditional replacements
- `-S`: Imports symbols from XA symbol files
- `-t`: Injects text origin from imported symbols
- `-g`: Filters symbol imports using equates files

### Pragma Directives
Embedded in source:
1. **`#pragma osdk replace_characters`** — performs search/replace pairs for text localization
2. **`#pragma osdk replace_characters_if LANGUAGE_TAG`** — applies replacements conditionally based on language tags
3. **`#pragma osdk import`** — forces inclusion of specific library symbols

*No known problem. Two issues were previously resolved in versions 1.8 and 1.9.*

## Samples — https://osdk.org/index.php?page=documentation&subpage=samples

# OSDK Samples

Getting Started: run `OSDK_MAKEDATA.BAT` if available, then `OSDK_BUILD.BAT` to compile, and `OSDK_EXECUTE.BAT` to test using the emulator (exit with F10).

### Hello World Examples
Five Hello World implementations demonstrating different approaches:
- BASIC version
- Simple C program using printf library function
- Pure assembly code without library dependencies
- Mixed C and assembly integration
- Advanced C with assembly routines showing parameter passing

### Complete Projects (with released source code)
- Space: 1999 game with intro and trailer
- Hnefatafl (Viking Chess)
- Pushing The Envelope demo
- 4K Kong and Cyclotron games (assembly-based with FilePack compression)

Additional samples covering compression and image display features available in the repository.

## FloppyBuilder — https://osdk.org/index.php?page=documentation&subpage=floppybuilder

# FloppyBuilder

FloppyBuilder generates optimized DSK (disk) files without relying on a traditional disk operating system like Sedoric.

### Key Advantages
- "Storing files linearly ensures faster access time"
- "Referring to files by index (integer) is much more efficient than using names"
- Significantly increased available disk space by eliminating DOS overhead
- "Almost all of the 16KB of overlay memory are available to the user"

### How It Works
FloppyBuilder operates through a two-mode process:

1. **Initialization mode** — generates a header file even with missing files
2. **Building mode** — creates the final DSK when all files are present

The tool reads a description file containing commands like `AddFile`, `DefineDisk`, and `SetCompressionMode`, then outputs both a DSK image file and a header file with file location metadata.

### API Functions
- `LoadFileAt()` — loads a file and returns control
- `InitializeFileAt()` — loads and executes a file

Both functions work with file indices rather than filenames. The loader occupies approximately 0.5 kilobytes at the end of addressable memory.

## MemMap — https://osdk.org/index.php?page=documentation&subpage=memmap

# MemMap

MemMap "simply reads the list of symbol that is generated by the assembler, and generates an HTML page that can then be displayed by any web browser."

### Usage
```
%OSDK%\bin\MemMap symbol_file output_html_file program_title css_file
```

Sample batch files in project folders automate this process.

### Key Features (by version history)
- HTML report generation with CSS styling support
- Function size estimation by detecting "master blocks" based on external linking markers
- Filtering of empty sections from output
- Support for Atari symbol files from Devpac/GenST
- A `-s` flag to display the largest data offenders sorted by size

*No known problem — please signal any issue on the Cross development tools forum.*
