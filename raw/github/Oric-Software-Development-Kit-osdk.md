# Oric-Software-Development-Kit/osdk

## Metadata
- Stars: 9
- Primary language: C
- Default branch: master
- Latest release: (none)
- License: (none)
- Homepage: (none)
- Fetched: 2026-05-17
- Final URL: https://github.com/Oric-Software-Development-Kit/osdk

## Description
Testing OSDK migration from SVN to GIT

## README
# Welcome to Defence-Force ~~SVN~~ GIT repository

## Please behave

If you don't know anything about ~~Subversion~~ GIT, you can learn more about it here:

Here is the structure of the whole repository at the moment:

```
\---pc
    +---shared_libraries
    |   \---freeimage
    +---euphoric_tools
    |   +---4k8
    |   +---Bin2Tap
    |   +---dsk
    |   +---old2mfm
    |   +---tap2dsk
    |   \---txt2bas
    \---osdk
        +---main
            +---bas2tap
            +---bin2txt
            +---common
            +---compiler
            +---DskTool
            +---filepack
            +---header
            +---link65
            +---macrosplitter
            +---makedisk
            +---MemMap
            +---old2mfm
            +---opt65
            +---pictconv
            +---SampleTweaker
            +---tap2cd
            +---tap2dsk
            +---TapTool
            +---xa
            \---Ym2Mym
```

## Top-level structure
- `.gitignore` — git ignore rules
- `Makefile` — top-level build entry point
- `euphoric_tools/` — source for legacy Euphoric-era tools: Bin2Tap, dsk, tap2dsk, txt2bas, old2mfm, 4k8
- `osdk/main/` — source of all current OSDK tools: bas2tap, bin2txt, common (shared code), compiler (RCC16), DskTool, filepack, header, link65 (linker), macrosplitter, makedisk, MemMap, old2mfm, opt65, pictconv, SampleTweaker, tap2cd, tap2dsk, TapTool, xa (assembler), Ym2Mym
- `readme.md` — repository overview and structure diagram
- `rules.mk` — shared Makefile rules for building all OSDK tools from source on Linux/Mac
- `shared_libraries/freeimage/` — FreeImage library used by PictConv for image format support
