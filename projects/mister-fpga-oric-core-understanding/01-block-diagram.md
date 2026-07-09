# 01 — Core block diagram

**Date:** 2026-07-09  
**Covers:** [`Oric.sv`](01a-Oric-sv-understanding.md) (MiSTer glue) + [`rtl/oricatmos.vhd`](01b-oricatmos-vhd-understanding.md) (the machine itself).

**Format note:** Mermaid, chosen over plain ASCII or a separate HTML file because it renders as a real diagram directly in Obsidian (this repo is a vault) and on GitHub — no extra tooling, and it stays diffable/git-trackable like the rest of the notes.

---

## Diagram A — Data path

Solid arrows = data/control buses that move every cycle. Dashed arrows = MiSTer-only side-channels (snapshot, tape-speed patching) that don't exist on real hardware.

```mermaid
flowchart TB
    subgraph HOST["MiSTer host (ARM Linux)"]
        HPS["hps_io<br/>(OSD, files, SD sectors, PS/2 keys)"]
    end

    subgraph TOP["Oric.sv — MiSTer glue"]
        PLL["pll"]
        RAM[("spram 64KB<br/>Main RAM")]
        FCACHE[("spram 192KB<br/>File cache<br/>(TAP/SNA)")]
        ALTBIOS[("spram 16KB<br/>Alt BIOS")]
        TAPE["cassette /<br/>tap_segment_loader /<br/>tap_byte_streamer"]
        ADC["ltc2308_tape<br/>(physical cassette ADC)"]
        SNAPENG["snap_loader /<br/>snap_ss /<br/>savestate_hotkeys"]
        DDRAM[("ddram<br/>DDR3, save-state slots")]
        VMIX["video_mixer"]
    end

    subgraph CORE["oricatmos.vhd — the Oric machine"]
        MUX["CPU data-in mux<br/>(priority decoder)"]
        CPU["T65<br/>6502 CPU"]
        ULA["ULA"]
        VIA["M6522 VIA"]
        PSG["AY-3-8912 PSG"]
        KBD["keyboard"]
        JOY["joystick"]
        ROMS["ROMs:<br/>Atmos / Oric-1 /<br/>Pravetz-8D / Microdisc"]
        MD["Microdisc FDC"]
        PFDC["Pravetz-8D FDC"]
    end

    HPS <-->|"PS/2 keys, joystick,<br/>ROM select, disk_enable"| CORE
    HPS <-->|"SD sectors, img_mounted/wp/size"| MD
    HPS <-->|"SD sectors (drives 0-1)"| PFDC
    HPS <-->|"TAP/SNA file bytes"| FCACHE
    HPS <-->|"custom ROM bytes"| ALTBIOS

    PLL -->|"clk_sys, CLK_VIDEO"| CORE
    PLL -->|"clk_sys"| TOP

    CPU <-->|"address/data/RW bus"| MUX
    MUX -->|"cpu_di (winning source)"| CPU
    ROMS --> MUX
    MD -->|"expansion port DO"| MUX
    PFDC -->|"FDC softswitch DO"| MUX
    VIA -->|"VIA DO"| MUX
    ULA <-->|"ram_ad/ram_d/ram_q,<br/>phi2 timeshare"| RAM
    ULA -->|"R/G/B, HSYNC/VSYNC,<br/>HBLANK/VBLANK"| VMIX
    VMIX -->|"HDMI"| HOST

    VIA <-->|"BDIR/BC1, Port A data"| PSG
    VIA <-->|"col select / row mask"| KBD
    VIA <-->|"Port A joystick bits"| JOY
    VIA <-->|"CB1 tape-in, PB7 tape-out"| TAPE
    ADC --> TAPE
    TAPE <--> FCACHE

    ALTBIOS -.->|"patch_active / patch_data<br/>(ROM override)"| MUX
    CORE -.->|"c000_we/data (LED mailbox),<br/>named_cload_we,<br/>tap_sync_request/tap_byte_consume"| TAPE

    SNAPENG -.->|"cpu_halt, save_halt/save_halted,<br/>cpu_regs_set/q"| CPU
    SNAPENG -.->|"via_snap_*"| VIA
    SNAPENG -.->|"ay_snap_*"| PSG
    SNAPENG -.->|"ula_snap_mode*"| ULA
    SNAPENG <--> DDRAM
    SNAPENG <--> FCACHE
```

---

## Diagram B — Clock & reset distribution

```mermaid
flowchart TB
    OSC["50 MHz board oscillator"]
    OSC --> PLL["pll<br/>(Oric.sv)"]
    PLL -->|"clk_sys"| CLKIN["CLK_IN<br/>(oricatmos.vhd master clock)"]
    PLL -->|"CLK_VIDEO"| HDMIPATH["HDMI video path"]

    CLKIN --> ULA["ULA"]
    ULA -->|"ENA_1MHZ<br/>(1 MHz CPU/VIA/PSG enable)"| CPU["T65 CPU"]
    ULA -->|"ENA_1MHZ"| VIA["VIA"]
    ULA -->|"ENA_1MHZ (ce)"| PSG["PSG"]
    ULA -->|"CLK_4 / CLK_4_EN"| VIA

    ULA -->|"PHI2<br/>(0=video half, 1=CPU half)"| RAMBUS["RAM address mux<br/>(§8) &amp; CPU data-in mux (§19)"]

    subgraph RESET["Reset sources"]
        MRESET["MiSTer framework reset"]
        OSDRESET["OSD 'Reset &amp; Apply'"]
        BTNRESET["Physical board button"]
    end
    RESET -->|"RESET"| ORICRESET["Oric.sv reset logic<br/>+ RAM-clear counter"]
    ORICRESET -->|"RESET port"| RESETN["RESETn =<br/>NOT RESET AND KEYB_RESETn"]
    KBDRST["keyboard swrst<br/>(soft reset key)"] -->|"KEYB_RESETn"| RESETN
    RESETN --> CONTRESETN["cont_RESETn"]
    CONTRESETN -->|"Res_n"| CPU
    RESETN -->|"RESET_L"| VIA

    KBDNMI["keyboard swnmi<br/>(F1 NMI key)"] -->|"KEYB_NMIn"| CPU2["T65 NMI_n"]
```

---

## Reading notes

- **Buses vs. side-channels:** the solid-arrow paths in Diagram A are what a real Oric-1/Atmos would have — CPU↔ROM/RAM↔ULA↔VIA↔PSG↔keyboard/joystick, plus the Microdisc/Pravetz-8D floppy interfaces. The dashed paths (ROM patch intercept, `$C000` mailbox, snapshot save/restore) are MiSTer-only additions with no hardware equivalent — see [`01b`](01b-oricatmos-vhd-understanding.md) §17–19 and [`01a`](01a-Oric-sv-understanding.md) §14, §17–18.
- **Memory contention:** `PHI2` (Diagram B) is the single signal that ties video timing and CPU timing together — the ULA alternates the RAM address bus between its own video fetch and the CPU every cycle, which is why the emulated CPU effectively runs at 1 MHz despite a 4 MHz+ master clock. See [`01b`](01b-oricatmos-vhd-understanding.md) §8.
- **Why every ROM is "always on":** Diagram A shows all four ROMs feeding the same mux rather than being individually enabled — this mirrors the real approach in [`01b`](01b-oricatmos-vhd-understanding.md) §9/§19: every ROM lookup table runs in parallel every cycle, and a priority decoder picks a winner. Simpler than gating each ROM's clock/output individually.
- **Split disk paths:** Microdisc and Pravetz-8D FDC are fully separate controllers sharing the same SD-card bridge, switched by `rom = "10"` — see [`01b`](01b-oricatmos-vhd-understanding.md) §6, §14–15.

## Still open (future phases)

This diagram covers Phase 1's data/clock path at the module level. It intentionally does **not** yet show:
- Internal state machines within `ula.vhd`, `m6522.vhd`, `wd1793.sv` (Phase 4 per-module notes).
- Bit-level timing/waveforms (Phase 5 simulation).
