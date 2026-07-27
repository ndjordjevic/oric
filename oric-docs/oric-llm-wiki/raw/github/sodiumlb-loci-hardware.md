# sodiumlb/loci-hardware

## Metadata
- Stars: 13
- Primary language: (none)
- Default branch: main
- Latest release: (none)
- License: (none)
- Homepage: (none)
- Fetched: 2026-05-17
- Final URL: https://github.com/sodiumlb/loci-hardware

## Description
Hardware design files and documentation for the Oric LOCI

## README

## Users
For information on how to use a LOCI device, please refer to the [LOCI User Manual](https://github.com/sodiumlb/loci-hardware/wiki/LOCI-User-Manual)

## Docs

### Wiki: LOCI User Manual

[Version française](https://github.com/sodiumlb/loci-hardware/wiki/LOCI-Mode-d'emploi)

_LOCI - Lovely Oric Computer Interface_

#### LOCI Device Overview
LOCI is an Oric BUS Expansion port peripheral for Oric-1/Atmos computers, providing ROM and Storage emulation of floppy and cassette devices, as well as USB peripheral support for simple HID (e.g. mouse, keyboard, game controllers) and CDC (serial, serial modem) devices.

LOCI provides a way to use modern peripherals with the 40+-year old Oric-1/Atmos computers.

##### LOCI Hardware Version
This User Manual describes the general use of LOCI hardware revision 1.3, firmware v0.2.3 and ROM v0.2.5

##### Feature Details

LOCI currently supports:
* Microdrive emulation (WD179x FDC) - emulates four floppy drives for read and write of Oric .DSK files
* Cassette (tape drive) emulation - reads .TAP files at bits and bytes level by patching of Basic 1.0 and 1.1 ROM tape routines
* ROM emulation - virtually replace Oric ROM. Supports custom .ROM files. LOCI ROM, Oric Basic1.0, Oric Basic1.1 and Mike Brown's diagnostic ROM have special support
* USB storage - access USB storage devices (thumb drives) and use as Oric disk storage
* Internal storage - 15MB of internal flash storage for user files
* ACIA emulation - exposes USB CDC modem devices to Oric as an ACIA serial port (for example [PicoWifiModemUSB](https://github.com/sodiumlb/PicoWiFiModemUSB))
* HID access - USB mouse and other HID devices can be accessed from Oric with new APIs
* Timing tuning - adjustments for the physical interface between LOCI and Oric (such as RV1)

##### Compatibility
Oric computers known to work with LOCI:
* Oric-1 48k
* Atmos
* Nova 64
* Oric-1 16k (no .DSK emulation)

Oric computers that should work with LOCI but have not been tested:
* Pravetz 8D
> Pravetz 8D connectors are upside-down compared to other Oric computers.

Oric computers not supported by LOCI:
* Telestrat
* Dual ROM chip Oric-1
* Orics with EPROMs that do not support the ROMDIS signal

> Disclaimer: Oric computers are famously quirky and individually temperamental. Most of them are, after all, 40 years old. While LOCI aims to work on as many working Orics as possible, it may not be able to work on all systems.

##### Connecting LOCI with Oric, and other USB devices
LOCI comes with two physical user connectors: a 34p IDC connector for connecting to the Oric expansion port, and a USB-C port for connecting USB devices. The USB-C port functions as a USB Hub for the Oric, and is not intended for connecting to other USB host devices, such as computers, laptops, etc. The USB-C port can be used with, for example a USB thumb drive, or it may be used with an additional powered USB Hub in order to provide multiple USB devices to the Oric, for example with multiple thumb drives, a mouse, a USB-Wifi adapter, etc.

##### Buttons
The LOCI board and the standard case expose three buttons:
1. Action - a software defined button for the user to interact with LOCI. This is the red or white button on the case, depending on style.
2. Reset - a hardware reset button for the Oric and LOCI. This is the black button.
3. Firmware - this hidden button is for upgrading the LOCI firmware.

#### Providing Power to LOCI
LOCI uses integrated power and does not have an independent power source, so it must be powered by either the Oric expansion port, or by the USB-C port.

> To power LOCI over USB-C, care must be taken to power up the USB side before powering up Oric.

When LOCI is provided power by the Oric expansion port, LOCI's USB-C port is also powered by Oric.

In this case, avoid using power-hungry USB devices, as it may cause overheating and damage to the Oric power regulator.

The original Oric power adapter is only rated for powering the 600mA used by Oric itself. It may not work with LOCI or any other expansion device needing more than maybe 50mA.

A modern 9V/1A-rated power adapter is recommended for powering an Oric with LOCI intended for use with a few reasonable USB devices powered by the Oric BUS Expansion port.

When a USB Hub is connected to LOCI's USB-C port, LOCI will draw additional power — it is therefore important to use a powered USB Hub with LOCI. When LOCI is powered over the USB-C port (e.g. with a powered USB hub), it will digitally disconnect power to the Oric Expansion port for safety reasons. This means Oric will not be powered from the LOCI/USB Hub, and therefore always needs its own power supply. In this case the original Oric power adaptor should work fine.

#### Connecting to Oric
LOCI connects to the Oric BUS Expansion port with a straight 34p IDC cable. A short cable is highly recommended for best stability. Take care matching pin 1 on LOCI to pin 1 on the Oric.

#### Getting files on LOCI
Files need to be on a USB device for LOCI to access them.
1. Get a USB drive for use with LOCI. USB-C thumb drives can be connected directly. USB-A drives need USB-C to USB-A adapter or a USB hub.
2. Copy Oric floppy (.DSK), cassette (.TAP) or ROM (.ROM) files from a computer onto the USB drive
3. Connect USB drive to LOCI

LOCI can use the files on the USB drive directly or they can be installed from USB onto the internal flash (see Using the LOCI UI).

#### Connecting USB devices
LOCI exposes one USB-C connector with USB 2.0 Full Speed host mode, intended primarily to connect USB storage devices such as thumb drives, containing the Users .TAP and .DSK files, which will be accessible to the Oric. To connect more than one USB device to Oric/LOCI, a small, powered USB hub may be used.

> USB storage device filesystem format must be FAT/exFAT and a version supported by FatFS.

> Power Use by USB devices differs greatly. Be careful when powering LOCI and USB devices over the Oric expansion port.

> Most modern multi-port USB hubs tested do not work with USB 2.0 hosts. Older/simpler hubs tend to work best.

Some additional verified-working and non-working USB devices are recorded on the [LOCI USB device status](https://github.com/sodiumlb/loci-hardware/wiki/USB-device-status) wiki page.

#### Operational model
When LOCI is powered on, it is in a passive mode in which the Oric computer is not affected or controlled by LOCI. The Orics internal BASIC ROM should boot, and classic physical tape-loading should be used.

Pushing the LOCI Action button shortly once will boot the Oric into the LOCI UI (User Interface), putting Oric under control of LOCI.

When the user exits the LOCI UI, LOCI will be actively managing the memory map, ROMs and emulated devices for the Oric, as configured.

Pushing the LOCI Action button shortly while an Oric application is running will suspend the application (if possible) and display the LOCI UI with the option to resume the suspended application.

#### Using the LOCI UI

The LOCI UI allows for the configuration of the LOCI emulation functions by keyboard navigation.

Basic keyboard navigation:
| Key | Action |
|:----|:-------|
| Arrows `up` `down` | Move between menu items |
| `Space` | Select file or toggle current menu item |
| `Esc`   | Exit current popup, or boot if at the top menu |

Top menu keyboard shortcuts:
| Key | Action |
|:----|:-------|
| `A` `B` `C` `D` | Navigate to virtual floppy drive ABCD |
| `T`    | Navigate to virtual tape drive |
| `K`    | Navigate to tape counter |
| `M`    | Navigate to mouse on/off |
| `O`    | Navigate to ROM select |
| `R`    | Navigate to RV1 adjust |
| `+` `-`  | Increase/decrease value (when RV1 highlighted) |
| `S`    | Auto-tune physical interface timing (tior) |
| `Return`| Return to suspended application if possible |

File navigator keyboard shortcuts:
| Key | Action |
|:----|:-------|
| Arrows `left` `right` | Navigate to next directory listing page (if possible) |
| `/`   | Navigate to parent directory |
| `F`   | Navigate to filter |
| `I`   | Install highlighted file to internal flash (if navigating on USB device) |
| `Del` | Delete highlighted file from internal flash (if navigating on internal flash) |

##### Navigating files
When a file or path is needed, a file browsing window will pop up. It will list items at the current level of hierarchy. The first level will show all devices connected and recognized by LOCI. Devices are numbered from 0. Device 0 is the internal flash storage area. USB storage devices are shown as "MSC".

##### Filter
Directory listings have a short case-insensitive filename filter applied. Automatically set to ".DSK" when selecting for floppy emulation and ".TAP" when selecting for cassette emulation. To clear the filter or edit it, navigate to the filter field, or press the `F` keyboard shortcut.

##### Setting up floppy emulation
LOCI emulates the Oric Microdisc floppy interface. It supports four virtual floppy drives A, B, C and D. The act of inserting a floppy is emulated by selecting a .DSK file from USB or internal storage, and assigning it to one of the virtual drive letters in the LOCI UI. Only the newer MFM_DSK format is supported.

The Microdisc On/Off switch determines whether the emulated Microdisc device takes precedence over the Basic ROM when booting. It is automatically set to On when a .DSK file is selected for a virtual floppy device.

> Write protection of .DSK files is currently not implemented. Do not use LOCI with the only copy of your files!

##### Setting up cassette emulation
LOCI emulates cassettes by patching the Basic ROM routines for tape-reading. Basic 1.0 and Basic 1.1 ROM patching is supported. Insertion of a cassette is emulated by selecting a .TAP file from USB or internal storage.

The Cassette On/Off switch determines whether the ROM patches are applied or not. When Off, normal physical cassette drives can be connected and used with the Oric.

The CLOAD/Auto switch selects whether autoload patches are applied. Autoloading works when booting cold, effectively jumping to running `CLOAD"` once BASIC has been initialised.

Tape emulation includes a tape counter showing current position of the .TAP file in bytes. .TAP files can contain multiple Oric memory dumps stored in sequence. To jump to a particular location inside the .TAP, navigate to the tape counter (`K` keyboard shortcut).

##### Setting up Oric ROM emulation
LOCI supports booting in Oric-1 (Basic 1.0) or Atmos (Basic 1.1) mode. Additionally, a custom .ROM file can be selected. This supports up to 16kB raw .ROM files mapped in at the top of the Oric address space.

##### Setting up USB mouse support
> USB mouse support in the ROM is currently only provided as a proof of concept. It does not emulate any existing mouse interfaces which may have previously been available for Oric systems, so only new or patched old programs can make use of it.

##### Timing tuning
LOCI has settings for tuning delay constants used in the interface between LOCI and Oric (the Oric expansion bus).

###### Adjusting RV1 aka MAP delay
If the message "RV1 adjustment required" appears when booting floppies, the RV1 delay needs adjusting. A RV1 value of 10 is the most common so far.

###### Auto-tuning IO Read delay
The _tior_ timing for IO reads adjusts the delay for Oric sending commands to LOCI. This is done by automatic tuning using the `S` keyboard shortcut in the main LOCI UI.

##### Booting and Returning
After setting up a session in the LOCI UI, boot it by selecting the Boot button or pressing `Esc`. When the action button is hit during a running session, it will attempt to suspend the session in a resumable state, allowing changing .DSK or .TAP files while a program is running.

#### Using the diagnostic ROM
Courtesy of Mike Brown, the LOCI firmware comes with the Oric diagnostics ROM. To boot the Oric with this ROM, long-press (~3s) the LOCI action button. Full documentation: https://oric.signal11.org.uk/html/diagrom.htm

#### LOCI Firmware Update
LOCI Firmware is provided as a .UF2 file. No special tools or software are needed to update the LOCI Firmware:
1. Disconnect LOCI from Oric and USB devices
2. Connect the USB-C cable to the computer first
3. Hold down the LOCI Firmware button
4. Connect LOCI to the USB-C cable
5. Release the LOCI Firmware button — LOCI LED should be off
6. LOCI shows as a USB storage device on the computer
7. Copy the .UF2 file to the mounted storage device — LOCI LED on = completed
8. Disconnect the cable, re-connect LOCI to the Oric

Project released firmwares with LOCI ROM embedded can be downloaded from https://github.com/sodiumlb/loci-firmware/releases

#### LOCI ROM Update
The firmware contains an embedded LOCI-Oric ROM. The LOCI-Oric ROM comes in an RP6502 format file and can be upgraded independently from the main LOCI Firmware.

ROM priorities (when user presses LOCI Action button):
1. "locirom.rp6502" on a USB storage device
2. "LOCIROM" on the internal flash storage
3. Embedded in the firmware

#### Disclaimer and Acknowledgements
LOCI is an open source project by and for Oric users, provided AS-IS. Developed by @sodiumlb and tested by the Oric hacking community at https://forum.defence-force.org/

### Wiki: USB Device Status

A registry of USB devices known working and not-working with LOCI.

| Works? | Type | Brand | Model | USB Id | LOCI FW | Reporter | Date | Notes |
|---------|------|-------|-------|--------|---------|-------|------|---|
| No | Hub | Satechi | Type-C MultiPort Adapter 4K V2 ||| Dbug | 2024-07-17 ||
| Yes | Hub | Deltaco | USBC-HUB201 | 0bda:5423+0423 | 0.1.0 | Sodiumlightbaby | 2024-07-18 ||
| Yes | Hub | Clas Ohlson | 39-1272 | 05e3:0610+0626 | 0.1.0 | Sodiumlightbaby | 2024-07-18 ||
| Yes | Hub | Logik | L4HUB17 | 05e3:0610+0626 | 0.1.0 | Sodiumlightbaby | 2024-07-18 ||
| No | Hub | Mobility Lab | ML309880 | 05e3:0610+0616 | 0.1.0 | Sodiumlightbaby | 2024-07-18 | Does work sometimes with uSD adapter |
| No | Hub | Plexgear | 65310 | 0bda:5411+0411 | 0.1.0 | Sodiumlightbaby | 2024-07-18 ||
| Yes | Flash | SanDisk | SDDDC2-064G-G46 | 0781:5595 | 0.1.0 | Sodiumlightbaby | 2024-07-18 ||
| Yes | Flash | Corsair | Flash Voyager GT | 1b1c:1a90 | 0.1.0 | Sodiumlightbaby | 2024-07-18 ||
| Yes | uSD adapt | Samsung | N/A | 0bda:0153 | 0.1.0 | Sodiumlightbaby | 2024-07-18 ||
| Yes | Flash | Samsung | MUF-64DA | 090c:1000 | 0.1.0 | Sodiumlightbaby | 2024-07-18 ||

### Wiki: MAP Timing Test

| Reporter | Device ID | Working RV1 range | Notes |
|--------|---------|-----------------|-----|
| MrExample | Atmos #1 | 10-25 ||

## Top-level structure

```
README.md          — short user pointer to the GitHub wiki
case/              — FreeCAD source files for the 3D-printed LOCI enclosure
  loci-rev1-3-case-ver5.FCStd  — FreeCAD case design v5 for PCB rev 1.3
  loci-rev1-3-case-ver6.FCStd  — FreeCAD case design v6 for PCB rev 1.3
docs/              — documentation assets
  images/          — photograph and diagram assets referenced by the wiki pages
pcb/               — EasyEDA/JLCPCB PCB production files for LOCI rev 1.3
  BOM_loci-1.3.csv             — bill of materials (35 line items, LCSC part numbers)
  Gerber_loci-1.3_PCB_loci_1.3.zip  — Gerber files for PCB fabrication at JLCPCB
  PCB_PCB_loci_1.3.json        — EasyEDA PCB layout source (JSON)
  PickAndPlace_PCB_loci_1.3.csv — pick-and-place file for SMT assembly
  SCH_loci-1.3.json            — EasyEDA schematic source (JSON)
```

### BOM summary (pcb/BOM_loci-1.3.csv) — key components

| Component | Designator | Qty | Part | Note |
|---|---|---|---|---|
| RP2040 | U1 | 1 | Raspberry Pi RP2040 | Main MCU |
| W25Q128JVSIQTR | U4 | 1 | 128Mb SPI flash | Internal 15MB user storage |
| 74LVC4245APW | U3 | 1 | 8-bit bidirectional level shifter | Bus interface |
| TUSB321RWBR | U21 | 1 | USB Type-C controller | USB-C CC detection |
| MT9700 | U10,U20,U22 | 3 | Load switch | Power management |
| SN74LVC2G17DBVR | U11–U19 | 9 | Dual Schmitt-trigger buffer | Bus signal conditioning |
| BSS123 | Q1–Q5 | 5 | N-channel MOSFET | Level-shift / switch |
| 34p IDC connector | CN1 | 1 | X9555WR-2x17E-PTSN | Oric expansion bus |
| USB-C receptacle | USB1 | 1 | TYPEC-304-ACP16 | USB host port |
| 12 MHz crystal | X1 | 1 | X322512MSB4SI | RP2040 clock |
| Tactile switches | SW1–SW3 | 3 | TS-1187A-B-A-B | Action, Reset, Firmware buttons |
