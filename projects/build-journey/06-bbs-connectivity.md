---
type: journey-note
title: "BBS connectivity — LOCI + PicoWiFiModemUSB"
created: 2026-05-18
status: research note — hardware not yet in hand
related_wiki:
  - "[[sodiumlb-loci-hardware]]"
  - "[[sodiumlb-loci-firmware]]"
  - "[[raxiss.com]]"
  - "[[forum.defence-force.org]]"
---

# BBS connectivity — LOCI + PicoWiFiModemUSB

> **Question:** Is there a way to connect the Oric to a BBS?
>
> **Answer:** Yes — and with LOCI already on the build list, the hardware path requires only one additional ~£10 component.

---

## 1. How it works

The Oric-1/Atmos has **no built-in serial port**. A serial connection requires a 6551 ACIA chip at `$031C`–`$031F` on the expansion bus — the address the Telestrat uses and what any ACIA expansion card provides ([[oric.free.fr]]).

LOCI sidesteps the need for a separate expansion card: its **ACIA emulation** feature exposes any USB CDC (Communications Device Class) device plugged into the LOCI USB-C port as a virtual 6551 ACIA serial port to the Oric. The designed-for-purpose CDC device is **[sodiumlb/PicoWiFiModemUSB](https://github.com/sodiumlb/PicoWiFiModemUSB)** — a Raspberry Pi Pico W running Hayes AT modem firmware that connects outbound over WiFi.

```
Oric ←34p IDC→ LOCI ←USB-C→ PicoWiFiModemUSB ←WiFi→ Internet → Telnet BBS
                  (ACIA emulation)  (USB CDC)
```

The Oric sees a 6551 ACIA at `$031C`. Terminal software on the Oric sends Hayes AT commands down the ACIA; the modem dials a Telnet BBS; data flows both ways.

---

## 2. The modem hardware

**PicoWiFiModemUSB** is a bare Raspberry Pi Pico W — no custom PCB or special hardware required; the firmware is flashed onto a stock Pico W. It presents over USB as a CDC serial device and speaks Hayes AT commands.

Key specs:
- Default speed: **9600 baud, 8N1** (configurable 110–115200 baud via `AT$SB=`)
- Default Telnet port: **23** (use `ATDT hostname:port` to override)
- Stores up to 10 speed-dial slots in NVRAM (`AT&Z0=particlesbbs.dyndns.org:6400,particles`)
- Telnet protocol: `ATNET1` (real telnet) or `ATNET2` (fake telnet — needed for some BBSes that don't strip the CR+NUL sequence; Particles! BBS is a known example)
- Terminal type negotiation: `AT$TTY=ansi`, window size `AT$TTS=40x28`
- **TCP server mode**: `AT$SP=2323` — the modem listens for incoming Telnet connections on that port. This is the key to doc 07.

---

## 3. Setup sequence

### One-time modem config (type AT commands via any terminal at 9600 baud):

```
AT$SSID=YourWiFiNetworkName
AT$PASS=YourWiFiPassword
ATC1                          ← connect to WiFi
AT$TTY=ansi                   ← tell BBS your terminal type
AT$TTS=40x28                  ← Oric screen is 40×28 chars (text mode)
ATNET1                        ← real Telnet protocol (try ATNET2 if garbage)
AT&W                          ← save to NVRAM
```

### Dialling a BBS from the Oric:

```
ATDT telnet.bbshosting.com:23
```

Or store a slot and speed-dial:
```
AT&Z0=particlesbbs.dyndns.org:6400,particles
ATDS0                         ← dial slot 0
```

---

## 4. Oric terminal software

The Oric needs **terminal software** — a program that reads the ACIA serial port and echoes the stream to screen. This is the open question at the time of writing.

The Defence Force forum has an active thread **"Oric BBS: testing in the emulator, tools to draw screens etc"** (Software sub-forum) where community members are building/porting BBS client software for the Oric. The forum also has **"LOCI + USB Modem"** (Hardware Hacks sub-forum) covering the LOCI+PicoWiFiModemUSB integration specifically.

Before the Metaphoric is built, you can test terminal software in the **Oricutron** emulator on the Mac (see Oricutron's ACIA emulation if it supports it, or test via the emulator + a null-modem).

---

## 5. Public Telnet BBSes still running (2025)

A starting list — use `ATDT hostname:port`:

| BBS | Address | Port |
|-----|---------|------|
| Particles! BBS | `particlesbbs.dyndns.org` | `6400` |
| Telnet BBS Guide | `bbs.fozztexx.com` | `23` |
| Various | `telnetbbsguide.com` — curated list | — |

> For Particles!, use `ATNET2` (fake telnet) as it doesn't correctly strip CR+NUL.

---

## 6. Component list

| Item | Notes |
|------|-------|
| LOCI rev 1.3 | Already in build — provides ACIA emulation over USB |
| Raspberry Pi Pico W | ~£7–10; flash PicoWiFiModemUSB firmware |
| USB-A to USB-C adapter or short cable | To plug Pico W's USB-A port into LOCI's USB-C |
| Oric terminal software | Watch Defence Force forum threads above |

---

## 7. Decision log

- **2026-05-18.** Researched LOCI ACIA emulation + PicoWiFiModemUSB. Path confirmed viable; requires Pico W (~£8) + firmware + Oric terminal software. No additional expansion board needed. Active forum support exists.
