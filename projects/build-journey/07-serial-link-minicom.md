---
type: journey-note
title: "Mac as terminal — minicom over a wired serial link to the Oric"
created: 2026-05-18
status: research note — hardware ACIA path is the recommended answer; not yet built/tested
related_wiki:
  - "[[sodiumlb-loci-hardware]]"
  - "[[sodiumlb-loci-firmware]]"
  - "[[forum.defence-force.org]]"
  - "[[oric.free.fr]]"
---

# Mac as terminal — minicom over a wired serial link to the Oric

> **Question:** Can I run `minicom` (or `screen`) on the MacBook and connect to the Oric over a serial / UART / FTDI link — typing on the Mac instead of the Oric keyboard?
>
> **Short answer:** Yes, but not by plugging a cable into a port that already exists. **The Oric Atmos — and the Metaphoric clone — have no built-in UART or serial port.** A serial link has to be *added* via the 1 MHz expansion bus or bit-banged on the printer port. Once added, `minicom` on the Mac talks to it through an ordinary FTDI/USB-serial cable. This doc ranks the three real ways to get there.

---

## 0. The headline fact

The Oric Atmos has **no RS-232 / UART hardware**. Forum thread `t=2675`/`t=1205` is explicit: *"The Oric Atmos has no built-in serial port; one must be added via the 1 MHz expansion bus."* Metaphoric inherits this — its connectors are composite RCA, TRRS audio/video, tape, the printer port, and the 1 MHz expansion bus. **No serial port.**

So "connect via serial/UART/FTDI" is really "**add** a serial interface, then connect an FTDI cable to *that*." Everything below is about which interface to add.

---

## 1. Two goals — keep them separate

| Goal | What it means | Reachable? |
|---|---|---|
| **A — Mac as a terminal session** | The Mac is the keyboard+screen for *terminal software running on the Oric* (BBS client, serial monitor) | ✅ Yes — via any of the three paths in §2 |
| **B — Mac fully replaces the Oric keyboard** | The Mac drives BASIC, games, everything | ❌ No off-the-shelf path — see §4 |

The reason B fails is the same for every option: **BASIC and legacy software read the VIA keyboard matrix, not a serial port.** A serial link only feeds software that explicitly reads the serial endpoint. Plan around goal A.

---

## 2. The three wired serial paths (ranked)

### Path 1 — Hardware 6551 ACIA expansion card  *(recommended)*

A small DIY card on the **1 MHz expansion bus** giving the Oric a *real* hardware UART.

- **Design:** ~3–4 chips — a **6551 ACIA** + a `74HC138` address decoder + a `74HC09` gate (forum `t=2807`). The 6551 is the serial port; the others map it into the Oric address space.
- **Mac side:** the 6551's TTL TX/RX pins wire straight to an **FTDI / USB-serial TTL cable** (FT232, CP2102, CH340 — any). On the Mac: `minicom -D /dev/cu.usbserial-XXXX -b 1200` (or `screen /dev/cu.usbserial-XXXX 1200`).
- **Why it's the best answer:** it is a *true* serial port — off-the-shelf Oric comms software (Oricomms, modem.dsk) reads it with no modification, and it doesn't steal CPU time.
- **Catch:** it's a card you build *after* the Metaphoric is working. Reference register addresses for an Oric serial interface are in the French write-up at `oric.free.fr/oric_serial.txt` (forum `t=1205` — there's an English translation attached to that thread).

### Path 2 — Soft-serial bit-banged on the printer port  *(no extra chips)*

Fabrice (Euphoric author) demonstrated **software serial at 38400 baud** over the Oric printer port, with a USB-to-Serial-TTL adapter on the PC end (forum `t=1232`).

- **How:** TX on a printer-port data line, RX on the printer-port **ACK input** (VIA CB1). No UART chip — the CPU bit-bangs the protocol. Metaphoric carries the standard Oric printer port, so the lines exist.
- **Mac side:** same as Path 1 — a USB-serial TTL cable into `minicom`.
- **Catch:** at 38400 baud there are only ~26 CPU cycles per bit — the bit-banging consumes nearly the whole CPU during a transfer, so it's fine for a dedicated terminal/transfer mode but not for background serial. And the **software is the problem**: Fabrice's source was never clearly published (`t=1232` — a request for it went unanswered). You'd likely be writing or porting the bit-bang routine yourself.

### Path 3 — LOCI's emulated ACIA  *(works, but not as a plain FTDI cable)*

LOCI emulates a 6551-style ACIA at addresses **`0x380`–`0x383`** and exposes it over its **USB-C host port** as a USB CDC device (forum `t=2773`; [[sodiumlb-loci-hardware]]).

- **The intuition that fails:** you cannot run an FTDI cable from the Mac into LOCI's USB-C. **Both LOCI and the Mac are USB *hosts*.** Two hosts cannot talk to each other over a USB cable — one side must be a USB *device*. An FTDI cable is a device, but it expects a host on *both* logical ends and provides no host-to-host bridging.
- **What actually works:** LOCI's ACIA talks to a USB CDC *device* — the `PicoWiFiModemUSB` (a Pico W flashed as a USB-CDC AT-modem) is the supported one, and it's WiFi, not wired (see §3). A *wired* equivalent would need a custom USB-CDC-to-UART bridge device (e.g. a second Pico flashed for that role) sitting between LOCI and the Mac. Nothing off-the-shelf does this today.
- **Confirmed config when it does run:** Oricomms at **1200 baud, 8N1**.

---

## 3. The WiFi-modem option (still valid, just not "serial")

If the goal is specifically **getting the Oric onto a BBS** and a wired link isn't the point, the cleanest path needs no expansion card:

- Flash a **Raspberry Pi Pico W** with `PicoWiFiModemUSB` firmware → it becomes a USB-CDC WiFi modem.
- Plug it into LOCI's USB-C; LOCI's ACIA emulation (`0x380`–`0x383`) bridges it to the Oric.
- Run Oricomms on the Oric at 1200/8N1.
- The modem has a **TCP server mode** (`AT$SP=2323`): from the Mac, `telnet <pico-ip> 2323` and the Mac keyboard drives the Oric terminal session over WiFi.
- Known quirk (`t=2773`): the Oric font shows `_` as `£` in COMMS.COM — fixed by patching the disk image directly.

This is goal A over WiFi instead of a wire. It works today; it just isn't the `minicom`-over-FTDI link asked for.

---

## 4. What is *not* possible

| Approach | Why it fails |
|---|---|
| FTDI cable Mac ↔ LOCI USB-C | Both are USB hosts — no device on either side (§2 Path 3) |
| `minicom` driving Oric **BASIC** interactively | BASIC reads the VIA keyboard matrix, not a serial port |
| Screen sharing / video-over-IP for the Oric | No network stack, no video-over-network hardware on the Oric |
| Mac presenting itself as the Oric's USB keyboard via LOCI | Mac is a USB host, not a USB HID device |

---

## 5. Recommendation

1. **Build the Metaphoric first.** Serial is a later add-on, not part of the core build.
2. For a genuine `minicom`-over-FTDI link, **build the 6551 ACIA expansion card (Path 1).** It is the only path that gives a real serial port that existing Oric software already understands, and the Mac side is a plain USB-serial cable into `minicom`/`screen`.
3. If you just want the Oric on a BBS sooner, the **PicoWiFiModemUSB + LOCI** route (§3) needs zero soldering and works today — accept that it's WiFi, not a wire.
4. Treat **soft-serial (Path 2)** as a fallback only if you want to avoid the expansion card *and* are willing to write/port the bit-bang code.

In all cases the Mac is the keyboard for a **terminal session**, not a drop-in replacement for the Oric keyboard. The Metaphoric MX keyboard PCB remains the answer for general use.

---

## 6. Decision log

- **2026-05-18.** Initial research framed around a WiFi modem (`PicoWiFiModemUSB` + LOCI ACIA + `telnet`).
- **2026-05-18.** Reframed around the actual question — `minicom` over a wired serial/FTDI link — after checking the `forum.defence-force.org` digest (threads `t=1205`, `t=2807`, `t=1232`, `t=2773`). Key finding: the Oric/Metaphoric has **no built-in UART**; a serial port must be added. Three paths ranked — **6551 ACIA expansion card (recommended)**, printer-port soft-serial, LOCI ACIA emulation. Established why an FTDI cable cannot go straight into LOCI (two USB hosts). WiFi modem demoted to one option among several.
