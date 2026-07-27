# ★ `rtl/rom/` — the ROM images (Day 1)

**Why there are no annotated copies of the ROM files in here.** Each ROM is ~1,046 lines, of which
about **20 are code and the rest are raw hex data**. Thirteen of them would add ~13,700 lines of hex
to this repo to carry two comments. So this page annotates *the pattern* — every ROM file is
structurally identical — and the hex stays in the gitignored `core/`.

Read this once and you can open any file in `core/rtl/rom/` and know exactly what you're looking at.

---

## 1. What a ROM file actually is

A ROM here is not a binary blob loaded at runtime — it is **the ROM contents compiled into the FPGA
bitstream as a VHDL lookup table**. The whole of `BASIC11A.vhdl` is this, with 1,024 lines of hex
elided:

```vhdl
entity BASIC11A is
port (
    clk  : in  std_logic;                          -- ★ same clocked-read shape as spram.v
    addr : in  std_logic_vector(13 downto 0);      -- ★ 14 bits -> 16384 addresses = 16 KB
    data : out std_logic_vector(7 downto 0)        -- ★ one byte out
);
end entity;

architecture prom of BASIC11A is
    type rom is array(0 to 16383) of std_logic_vector(7 downto 0);
    signal rom_data: rom := (
        X"4C",X"CC",X"EC",X"4C",X"71",X"C4", ...    -- ★ 16384 bytes of 6502 machine code
        ... 1024 more lines ...
        X"8F",X"F8",X"44",X"02");
begin

-- ★ THE ONLY LOGIC IN THE FILE — a clocked read, no write port.
--   Identical to spram.v's read half (1 cycle of latency: address now, data
--   next cycle), minus `wren` and the write. That missing write is the entire
--   difference between RAM and ROM in FPGA terms — same block-RAM hardware,
--   just initialised at build time and never written.
process(clk)
begin
    if rising_edge(clk) then
        data <= rom_data(to_integer(unsigned(addr)));
    end if;
end process;
end architecture;
```

**Where it lands physically:** same answer as `spram.v` — the synthesis tool maps this array into
the FPGA's **block RAM**, pre-loaded with these bytes at configuration time. On the real Oric this
was a mask-programmed 16 KB ROM chip on the PCB.

**The address maths:** 14 address bits → 16,384 bytes → the Oric's ROM window at **`$C000`–`$FFFF`**
(64 KB address space minus 16 KB = `$C000`). That is why `oricatmos.vhd` feeds these ROMs
`cpu_ad(13 DOWNTO 0)` — the low 14 bits of the CPU address bus, with the top 2 bits used by the
decode logic to decide the ROM is being addressed at all.

---

## 2. Which ROMs are real — and which 8 files are dead weight

**`files.qip` is the authority** (see Day 0). Only **5** ROM files are in the build:

| File | Entity | Size | What it is |
|---|---|---|---|
| `BASIC11A.vhdl` | `BASIC11A` | 16 KB | **Atmos** BASIC 1.1 — the default ROM |
| `BASIC10.vhd` | `BASIC10` | 16 KB | **Oric-1** BASIC 1.0 |
| `PRAVETZ8D.vhd` | `PRAVETZ8D` | 16 KB | Pravetz-8D (Bulgarian Oric clone) |
| `PRAVETZ8D_FDC.vhd` | `PRAVETZ8D_FDC` | 256 B | Pravetz FDC bank ROM — tiny boot stub |
| `MICRODIS.vhd` | **`ORICDOS06`** ⚠ | 8 KB | Microdisc floppy controller ROM |

> ⚠ **Filename ≠ entity name.** `MICRODIS.vhd` declares `entity ORICDOS06`. Grepping the codebase
> for "MICRODIS" finds the file but *not* its instantiation — `oricatmos.vhd:532` says
> `ENTITY work.ORICDOS06`. This is the kind of thing that costs twenty confused minutes if nobody
> warns you.

**Present in the folder but NOT listed in `files.qip`** — so not compiled into the core:
`BASIC11.vhd`, `BASIC11B.vhdl`, `BASIC22.vhd`, `DIAG10.vhd`, `TEST108J.vhdl`, `ORIC1SDCARD.vhd`,
`test109.vhd`, `testsector.vhd`. (That they aren't built is verified. *Why* each is still in the
repo — superseded alternates, work in progress, upstream history — is not something the manifest
tells you; don't assume.)

Two consequences worth internalising:

1. **Don't study a file before checking it's in `files.qip`.** Eight of thirteen ROM files here are
   not part of the core. `plan.md`'s "Ground truth" tree lists several of them (BASIC11/22, DIAG10,
   TEST108J, ORIC1SDCARD) as if they were live — they are present in the repo, but not built.
2. `DIAG10` / `TEST108J` are **Mike Brown's diagnostic ROM** ([[oric.signal11.org.uk]]) — genuinely
   interesting for Day 2's ULA work and for hardware testing, just not compiled into this core.

---

## 3. Which ROM the machine actually uses

Selection is made **at reset only** (no hot-swap) and comes from the OSD menu, via the 2-bit `rom`
signal. `Oric.sv`'s `rom_sel` chain remaps menu order onto internal numbering — see SV Lesson 8,
which uses that exact code as its worked example — and `oricatmos.vhd` ★ SECTION 19 is the priority
mux that decides, per CPU read, whether the byte comes from a ROM, RAM, the VIA, or a disk
controller.

There is also a **user-supplied ROM** path that bypasses all of these: `Oric.sv`'s `altbios` is a
16 KB `spram` (not a ROM table) that the ARM side can fill from an SD-card file at runtime — the
same 16 KB shape, but writable because it is loaded rather than compiled in.

---

## 4. Going further

The ROM *contents* — as opposed to this wrapper — are the Oric's operating system and BASIC
interpreter, and they are well documented elsewhere in this repo:

- `books/oric/oric-advanced-user-guide-rom-disassembly.md` — commented `$C000`–`$FFFF` listing
- `books/oric/oric-advanced-user-guide.md` — hardware + ROM reference
- `books/oric/machine-code-for-the-atmos-and-oric-1.md` — Oric-flavoured 6502
- [[oric.free.fr]] — register-level Hardware Programming How-To

Relevant later: Idea #3/#4's tape speed-loaders work by **patching ROM reads on the fly**
(`cload_patch_rom.v`), which only makes sense once you know the ROM is a fixed lookup table that
cannot itself be modified.
