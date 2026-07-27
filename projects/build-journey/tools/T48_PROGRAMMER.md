# XGecu T48 Universal USB Programmer (+ ADP_D42_EX-A adapter)

**Product**: XGecu T48 — Universal high-speed USB programmer (successor to the TL866II Plus; internal model TL866-3G)
**Price paid**: ~RSD 5,070 (T48 Standard, AliExpress; list ~RSD 6,338)
**Store**: https://www.aliexpress.com/item/1005002323911736.html
**Software**: XGpro (Windows) — https://www.xgecu.com/
**User manual**: PDF linked from the AliExpress listing
**Bundled accessory**: A45U / ADP_D42_EX-A adapter — ~RSD 2,208 — https://www.aliexpress.com/item/1005009730907956.html

---

## Overview

The XGecu T48 is a USB-connected universal device programmer for reading, writing, verifying, and erasing memory chips and microcontrollers. It is the modern successor to the widely used TL866II Plus. It connects to a Windows PC running the XGpro software.

- **Main socket**: 40-pin ZIF (zero-insertion-force), takes DIP packages up to 40 pins directly
- **Interface**: USB (high speed); review reports stable read/write at 30 MHz
- **Wider/odd packages**: handled via plug-in adapters (PLCC, SOIC, TSOP, DIP42, etc.)
- **First-run note**: the unit typically prompts a firmware reflash the first time XGpro connects — quick and automatic
- **Reviews**: 4.9 / 172 ratings on the AliExpress listing; "ease of use: great" 99%

The T48 supports a very large device library: 27Cxxx / 28Cxxx EPROM & EEPROM, 24/25-series serial EEPROM & flash, NAND, AVR/PIC/8051 microcontrollers, and logic-device readback. Always confirm a specific part number against the XGpro support list before relying on it.

---

## ADP_D42_EX-A adapter (the second item)

A black ZIF-socket adapter for **PLCC44 / DIP42** package chips — the large EPROMs: 27C800, 27C160, 27C322, 27V800/160/322, MX27C8100, MX27C1610.

- **T48-only.** The listing explicitly states it will *not* work on TL866CS / TL866A / TL866II / T56 — only the T48.
- It exists because those 16/32-Mbit EPROMs are physically larger than the T48's 40-pin main socket can take.

---

## Relevance to the Oric build

**The T48 is the tool that closes the only equipment gap in the Metaphoric build.** The BackBit Chip Tester ([[CHIP_TESTER]]) can *read/rip* ROMs but cannot *burn* standard EPROMs — the T48 does.

- **Burns the Oric ROM directly.** The Metaphoric ROM is a **27C512** (DIP28) holding the prebuilt dual Oric-1/Atmos image `DualROM27C512.bin`. A DIP28 chip drops straight into the T48's 40-pin main ZIF socket (bottom-justified, standard practice) — **no adapter required**.
- **Diagnostic ROM.** Use the T48 to burn Mike Brown's diagnostic ROM for first power-on testing of the assembled board.
- **Verification loop.** Burn with the T48, then optionally rip the chip back with the Chip Tester's SHA1 check to confirm the image.

**The ADP_D42_EX-A adapter is not needed for this build.** The Oric ROM is a small DIP28 part; the adapter is for DIP42/PLCC44 chips. Keep it for other projects.

See `build-journey/01-decision-bom-order.md` §6–§7 for how this fits the order plan — with the T48 already in hand, the build requires **no tool purchases**.

---

## Typical workflow (burning the Oric ROM)

1. Install XGpro on a Windows PC; connect the T48 via USB (allow the first-run firmware reflash).
2. In XGpro, select the exact device — e.g. `27C512` (pick the manufacturer variant matching the chip you bought).
3. Load `DualROM27C512.bin` from the Metaphoric repo.
4. Insert the 27C512 into the main ZIF socket, lever down.
5. Erase (if a windowed/UV-erasable EPROM and not blank) → Program → Verify.
6. Remove and fit to the Metaphoric main PCB's ROM socket.

---

## Notes and cautions

- **Genuine vs clone**: XGecu programmers are widely cloned. The "Original XGECU" listing and firmware-reflash-on-first-use behaviour are consistent with a genuine unit; genuine units update cleanly via XGpro.
- **OTP vs UV-erasable**: a 27C512 marked OTP cannot be erased — buy windowed (UV-erasable) parts, or simply buy enough OTP chips to absorb mistakes.
- **Pin 1 / orientation**: insert chips bottom-justified in the 40-pin socket as XGpro's on-screen diagram shows; wrong placement can damage the chip.
