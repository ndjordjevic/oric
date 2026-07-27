---
type: journey-note
title: "LOCI — the Oric storage peripheral"
created: 2026-05-18
status: reference — buy finished product; confirmed working on Metaphoric
related_wiki:
  - "[[sodiumlb-loci-hardware]]"
  - "[[sodiumlb-loci-firmware]]"
  - "[[raxiss.com]]"
  - "[[forum.defence-force.org]]"
---

# LOCI — the Oric storage peripheral

> **Role in this build:** LOCI is how the Metaphoric loads software. It replaces physical floppy disks and cassette tapes, provides ROM switching (including the diagnostic ROM for first power-on), and adds USB peripheral support. Buy it as a finished product — ~$52 from RaxIss.
>
> **Confirmed:** LOCI works correctly on the Metaphoric clone (forum `t=2672`, `t=2862`). The Metaphoric's ROMDIS/UVPROM line is auto-disabled when LOCI is fitted — no jumper needed (OldWer, `t=2733`).

---

## 1. What LOCI is

LOCI is a compact PCB peripheral by **sodiumlb / RaxIss** that plugs into the Oric's **34-pin IDC expansion bus port** via a short straight ribbon cable. It runs on an **RP2040** (Raspberry Pi Pico chip) acting as a MIA (Media Interface Adapter) — a bus-bridge between the RP2040 and the Oric's 6502 expansion bus.

It emulates:
- **4 Microdisc floppy drives** (A–D) from `.DSK` files, using the WD179x FDC protocol
- **Cassette tape** from `.TAP` files via BASIC ROM patching
- **ROM images** — boot the Oric from `.ROM` files instead of (or alongside) the physical ROM

It also provides:
- **15 MB internal flash** (LittleFS) for storing image files
- **USB-C host port** for USB storage drives, HID devices (keyboard, mouse, game controllers), and CDC serial modems

**Firmware licence:** BSD 3-Clause (open source). Hardware repo has no declared licence — this is why you buy LOCI as a finished product rather than fabricating the PCB yourself. See [[10-decision-bom-order]] §4 for the nuance.

---

## 2. Where to buy

| Region | Store | Price |
|---|---|---|
| EU | Lectronz (RaxIss): `lectronz.com/products/loci-...` | ~$52 / ~€50 |
| Worldwide | Tindie (8BitClub): `tindie.com/products/8bitclub/loci-...` | ~$52 |

The firmware source and pre-built releases are also at `raxiss.com/article/id/38-LOCI`.

---

## 3. Hardware layout

| Element | Function |
|---|---|
| **Action button** (red, upper corner) | Short press: open LOCI UI. Long press: boot Mike Brown's diagnostic ROM (`test108k`). Use this for normal LOCI operation. |
| **Reset button** (black, mid-right) | Resets the **Oric only** — does NOT reset LOCI state. Pressing Reset and power-cycling are different things. |
| **Firmware button** | Hold while connecting USB-C to a computer → LOCI appears as a USB mass storage device for `.uf2` firmware drag-and-drop. |
| **34-pin IDC cable** | Straight (not crossed). Validated length: **~15 cm** — shorter cables look cleaner but 15 cm is the tested-stable length. Match pin 1. |
| **USB-C port** | Host port for USB peripherals. LOCI and Oric cannot both be powered at once from USB-C and the expansion port — load switches handle this automatically. |

> When LOCI is used with USB peripherals (especially a powered USB drive), the **Oric needs a 9V/1A supply** — not the bare minimum 5V USB brick. Plan accordingly.

---

## 4. Built-in ROMs

LOCI firmware ships with these ROMs compiled in — no files needed on the USB drive:

| ROM | Purpose |
|---|---|
| `locirom` | The LOCI configuration/UI ROM (default boot target) |
| `basic10.rom` | Oric-1 BASIC 1.0 |
| `basic11b.rom` | Oric Atmos BASIC 1.1b |
| `pravetz11a.rom` | Pravetz 11a variant |
| `test108k.rom` | **Mike Brown's Oric Diagnostic ROM v1.08k** — long-press Action to boot; runs CPU/ULA/DRAM/VIA/PSG tests. Use this on first power-on. |
| `microdis.rom` | Microdisc ROM |

---

## 5. UI operation

Press Action (short) to enter the LOCI UI at any time.

### Navigation keys

| Key | Action |
|---|---|
| `A` | Navigate to virtual floppy drive A |
| `T` | Navigate to tape drive |
| `Space` | Open file browser / mount selected file |
| `Esc` | **Cold-boot the Oric** from the current LOCI state |
| `Return` | **Resume a suspended Oric session** (the opposite of what the label suggests — Esc boots, Return resumes) |
| `F` | Open filename filter; delete filter text + Return to clear |
| `s` (lowercase) | Scan / auto-detect `tior` timing in main menu |

### Mounting a disk image

1. Press Action → LOCI UI.
2. Navigate to drive `A`, press `Space` → file browser.
3. Select `.DSK` file (device `0` = internal flash; `MSC` = USB drive), press `Space` to mount.
4. Press `Esc` → Oric cold-boots into the emulated Microdisc environment.

### Mounting a tape

1. Navigate to `T`, mount a `.TAP` file.
2. Press `Esc` → boots with BASIC ROM patching active for cassette loading.

### Filesystem notes

- Both **FAT32 and exFAT** work. Both upper and lower case names work.
- Subdirectories are supported — navigate into them normally.
- If directories are not visible: press `F`, delete the filter text with Del, press Return to clear the filter.

---

## 6. Session suspend and resume

During any running Oric program, pressing Action **suspends** the program and re-enters the LOCI UI. Pressing Return resumes the suspended session exactly where it left off. This is useful for swapping disk images mid-game without rebooting.

> Some demos (e.g. Barbatoric) leave the Oric+LOCI in a state where Reset alone is not enough — a full power cycle of **both units** is required.

---

## 7. Timing tuning

If LOCI misbehaves on a particular Oric hardware combination, two timing parameters can be adjusted:

| Parameter | Default | What it does | Adjustment |
|---|---|---|---|
| `RV1` / `tmap` | ~10 | MAP signal delay — controls how long LOCI holds the bus after asserting MAP | Raise to ~12 if floppy emulation is unreliable. **Set to 5 if running with OCULA** (its MAP timing differs). |
| `tior` | ~8 | IO read delay | Press `s` in main menu to auto-scan. Value ~8 is normal. A value of 0 or very high indicates a comms/bus problem, not just timing. |

Timing is documented in the LOCI User Manual at `github.com/sodiumlb/loci-hardware/wiki/LOCI-User-Manual#timing-tuning`.

---

## 8. Firmware updates and recovery

### Updating firmware

1. Download the latest `.uf2` from `github.com/sodiumlb/loci-firmware/releases` or `raxiss.com`.
2. Hold the Firmware button, connect LOCI via USB-C to any computer, release the button.
3. LOCI appears as a USB mass storage device. Drag the `.uf2` onto it.
4. LOCI reboots with new firmware. ROMs are updated independently from firmware.

### Recovery — `!ROM` error

A `!ROM` error in the upper-right corner means ROM files are missing from flash (e.g. after a `nuke flash` or a bad firmware update).

**Fix:** reflash using the **Raxiss bootstrap firmware** from `raxiss.com`. Subsequent firmware updates will not lose ROMs once bootstrapped.

---

## 9. Custom ROMs

You can run any 16 kB `.ROM` image without modifying or rebuilding LOCI firmware:

1. Rename the ROM file to `locirom.rp502`.
2. Copy it to the LOCI USB drive.
3. On boot, LOCI picks up the file from the USB drive instead of its built-in ROM.

This is how you'd run e.g. a modified BASIC ROM or a custom launcher without touching the firmware. The Raxiss bootstrap + the USB-drop method means you never need to build firmware from source for normal use.

> **Building loci-rom from source (if you ever need it):** on Ubuntu 24 LTS, the apt-installed `cc65` is too old — build cc65 from source first. There is also a known RAM overflow in the loci-firmware build; the fix is in the loci-firmware GitHub issues tracker (forum `t=2854`).

---

## 10. USB peripherals

LOCI's USB-C host port supports:

| Device type | Support level |
|---|---|
| **USB thumb drive** (FAT32/exFAT) | Full — appears as `MSC` in the file browser |
| **HID keyboard** | Partial — works in the LOCI UI and LOCI-aware software; does **not** inject into the VIA keyboard matrix, so legacy software is unaware |
| **HID mouse / game controller** | Accessible via new LOCI APIs from LOCI-aware software |
| **USB CDC modem** (e.g. PicoWiFiModemUSB) | Full — LOCI emulates a 6551 ACIA at `0x380`–`0x383` for the modem; Oricomms at 1200 8N1 confirmed working (see [[07-serial-link-minicom]] §3 for the WiFi-BBS path) |

---

## 11. Software — what runs

Anything distributed as `.DSK`, `.TAP`, or `.ROM` from the Oric software archives works. Key sources:
- `oric.org` / `oric.free.fr/DISKS/` — floppy disk images
- `defence-force.org` library — demos, games, tools

LOCI supports **PT3 chiptune playback** from within LOCI-aware software (forum `t=2685`): the PT3 decoder runs inside a 50 Hz interrupt alongside LOCI operation, with ~25% CPU overhead. PT3 song files are roughly half the size of the equivalent AKY format.

**Known compatibility issue:** the game **Space 1999** does not work with newer LOCI firmware versions.

---

## 12. First-use checklist (Metaphoric build context)

- [ ] Order LOCI from Lectronz (EU) or Tindie (worldwide) — ~$52.
- [ ] Connect with the **~15 cm straight 34-pin IDC cable** that ships with it; verify pin 1 alignment.
- [ ] Power the Oric from a 9V/1A supply when using USB peripherals.
- [ ] **First power-on: long-press Action** to boot the diagnostic ROM (`test108k`) — confirms CPU, ULA, DRAM, VIA, PSG before loading any software.
- [ ] No jumpers to set on Metaphoric — ROMDIS is auto-disabled.
- [ ] If floppy emulation misfires: raise `RV1` from 10 to 12.
- [ ] If internal storage `0:` disappears from listings: `nuke flash` → reflash with Raxiss bootstrap → `!ROM` error disappears.
- [ ] Later (after OCULA experiment): set `RV1` to 5 if running LOCI + OCULA together.

---

## 13. Decision log

- **2026-05-18.** LOCI reference doc created. Sources: [[sodiumlb-loci-hardware]], [[sodiumlb-loci-firmware]], [[raxiss.com]], forum digests `t=2672` (first impressions), `t=2773` (USB modem/ACIA), `t=2854` (loci-rom build), `t=2685` (PT3 playback).
