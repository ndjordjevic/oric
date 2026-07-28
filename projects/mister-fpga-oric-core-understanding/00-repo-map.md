# 00 — Repo map (`core/`)

**Day 0.** Lookup table only. Path = pristine upstream clone (gitignored sibling of `annotated/`).

**Structural fact:** Quartus top entity is **`sys_top`** (`sys/sys_top.v`), not `Oric.sv`. Confirmed in `Oric.qsf`: `TOP_LEVEL_ENTITY = sys_top`. Framework instantiates your `module emu` (defined in `Oric.sv`).

---

## Top-level files

| Item | What | Open? |
|---|---|---|
| `Oric.qpf` | Quartus project (version + revision name) | No |
| `Oric.qsf` | Settings / pins. Care about: `TOP_LEVEL_ENTITY = sys_top`, `source files.qip` | Rarely |
| `files.qip` | **Build manifest** — every RTL file in the bitstream. Missing ⇒ not in the core | Yes (reference) |
| `Oric.srf` | Suppressed Quartus warnings | No |
| `build_id.v` | Generated `` `define BUILD_DATE `` (etc.); stub here for lint | No |
| `Oric.sv` | Your core plug-in (`module emu`) | Yes — already studied |
| `README.md` | Upstream overview | Skim once |
| `clean.bat` | Windows Quartus cleanup | No |
| `.gitignore` | Upstream ignores | No |

## Top-level folders

| Folder | What | Open? |
|---|---|---|
| `rtl/` | **The Oric.** Subdirs: `T65/` (6502), `rom/`, `pll/`, `apple2_disk/` (WD1793) | Yes — Days 1–6 |
| `sys/` | MiSTer framework (~52 files). Identical across cores. **Never edit.** | Only the 5 below |
| `tools/` | `oric-build` (Docker/Quartus) + TAP/SNA helpers + `tool.md` | Later (formats / build) |
| `releases/` | 11 prebuilt `.rbf` bitstreams | No (that's the *output*) |
| `dsk/` | 6 sample disks: SEDORIC 4.0, Pravetz DOS, games (Oricium, 1337, Space 1999, B7es) | Day 6 / Ideas #5–#6 |
| `img/` | 4 README screenshots | No |
| `docs/` | Maintainer technical notes (tape, SNA, memory map, …). Start at `docs/docs.md` | Yes — reference |
| `games/` | Sample TAP + `.sna` under MiSTer games layout | Optional |
| `_Games/` | Sample MGL launchers for TAP/snapshots | Optional |

> **`docs/`, `games/`, `_Games/` are not in official `MiSTer-devel/Oric_MiSTer`.**
> README mentions them, but they live on the maintainer fork
> ([nikiiv/Oric_MiSTer](https://github.com/nikiiv/Oric_MiSTer)).
> Copied locally from that fork on Day 0 — local-only extras, not from `git pull` upstream.

### `tools/` detail

| File | Job |
|---|---|
| `oric-build` | Build in `raetro/quartus:mister` Docker; optional deploy to MiSTer |
| `tape-inspect.py` / `sna-inspect.py` | Inspect `.tap` / snapshots |
| `ss-convert.py` | Savestate/snapshot convert |
| `merger.py` / `splitter.py` | Merge/split related files |
| `tool.md` | Docs for the above |

### `dsk/` detail

| Image | What |
|---|---|
| `SEDO40u_DSK.dsk` | SEDORIC 4.0 DOS master |
| `dos8d_231.dsk` | Pravetz 8D DOS |
| `Oricium12_edsk.dsk` | Game: Oricium |
| `1337_dsk.dsk` | Game: 1337 |
| `space1999-en_dsk.dsk` | Game: Space 1999 (EN) |
| `B7es_dsk.dsk` | Game: B7es |

(Mostly CPC extended / EDSK `.dsk`.)

---

## `sys/` triage — open these; ignore the rest

| File | Role for Oric |
|---|---|
| `emu_ports.vh` | Shared `module emu` port list (``.vh`` = Verilog header, `` `include`` paste) |
| `hps_io.sv` | ARM/Linux bridge: OSD `status[]`, `ioctl_*` file download, joysticks, `ps2_key`, disk mount |
| `video_mixer.sv` | Core RGB/sync → framework VGA (scandoubler / HQ2x / gamma) |
| `video_freak.sv` | Aspect / integer scale / crop → `VIDEO_ARX`/`ARY` |
| `ltc2308.sv` | ADC chip driver + `ltc2308_tape` (real cassette in via `ADC_BUS`) |

**Ignore permanently:** `sys_top.v` (except knowing it exists), `ascal.vhd`, `sd_card.sv`, `spdif.v`, `yc_out.sv`, `osd.v`, `scandoubler.v`, audio helpers, all `pll_*` / `.qip` / `.tcl` / `.sdc` build plumbing.

---

## `files.qip` — live RTL (33 entries)

If it isn't here, it isn't in the build.

| Entry | Notes |
|---|---|
| `rtl/T65/T65.qip` | 6502 CPU package |
| `rtl/psg.v` | AY-3-8912 |
| `rtl/spram.v` | Block-RAM template |
| `rtl/cassette.v`, `rtl/cas_sig_gen.v` | Real tape path |
| `rtl/snap_loader.v`, `rtl/snap_ss.v`, `rtl/savestate_hotkeys.v` | Snapshots / savestates — **out of sprint scope** |
| `rtl/ddram.sv` | DDRAM helper (savestate buffer) — out of sprint |
| `rtl/cload_patch_rom.v`, `tap_segment_loader.v`, `tap_byte_streamer.v`, `tap_autorun_keys.v` | Tape speed-loader — **out of sprint** |
| `rtl/wd1793.sv` + `rtl/apple2_disk/*` | Floppy FDC stack — Day 6 stretch |
| `rtl/keyboard.sv`, `rtl/joystick.sv` | Input |
| `rtl/microdisc.vhd`, `rtl/pravetz8d_fdc.vhd` | Disk interfaces — Day 6 stretch |
| `rtl/rom/MICRODIS.vhd`, `BASIC10.vhd`, `BASIC11A.vhdl`, `PRAVETZ8D.vhd`, `PRAVETZ8D_FDC.vhd` | **Only these 5 ROMs are built** (8 others in `rom/` are leftovers) |
| `rtl/ula.vhd`, `rtl/m6522.vhd`, `rtl/video.vhd` | ULA / VIA / video |
| `rtl/oricatmos.vhd` | Machine glue |
| `Oric.sv` | Top plug-in |

---

## Self-check

Point at any top-level name → say what it does + whether you'll open it this week.
