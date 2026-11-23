# Plan — understand the MiSTer Oric core

## Goal

When you open the core repo, you know:

1. **Where to start** — which files matter, and which to ignore.
2. **How the files connect** — which file uses which.
3. **What each code section does** — in plain English, from comments next to the code.

You do **not** need to understand every line of VHDL or Verilog. No dates, no time limits.

## How we work

For each file:

1. I copy the file from `core/` to `annotated/`.
2. I add a short plain-English comment above each code section: what it does and why.
3. You read the file with the comments.
4. We chat about it. You ask, I answer.
5. We tick the box below and move on.

Code is never changed — only comments are added. `core/` stays clean (the original upstream code).

## End of each phase — phase notes

When we finish chatting and you understand the phase, I write a short notes file:
`notes/phase-N-<name>.md`. It is for future you, coming back after a long break.

Each notes file is one page, plain English:

1. **What this phase covered** — 2–3 sentences.
2. **Key ideas** — 5–10 bullets: the things worth remembering.
3. **Your questions** — what you asked in the chat, with the short answer.
4. **Where to look** — the files and `★ SECTION`s to open again.
5. **Still open** — anything we left unclear.

It does not repeat the code comments or the other docs. It links to them.

---

## Phase 1 — The map: find your way around

**Question:** "What is in this repo, and where do I start?"

- [x] One-page map `MAP.md`:
  - The 4 layers, top to bottom:
    `sys/` (MiSTer framework) → `Oric.sv` (glue) → `rtl/oricatmos.vhd` (the Oric) → chip files
  - Which files are the Oric, which are MiSTer extras, which to ignore
  - A "where to look for X" table (video → `ula.vhd`, sound → `psg.v`, …)
  - One simple diagram of how the files connect
- [x] Chat: walk the map together.
- [x] Notes: `notes/phase-1-map.md`

## Phase 2 — The real Oric, in short

**Question:** "What machine is this code copying?"

- [x] The chips and their jobs: 6502 CPU, ULA (video + memory), VIA 6522 (I/O), AY-3-8912 (sound),
      RAM, ROM.
- [x] The memory map: what lives at which address.
- [ ] Chat.
- [ ] Notes: `notes/phase-2-real-oric.md`

Doc: [`oric-hardware.md`](oric-hardware.md).

## Phase 3 — The two top files

**Question:** "How is the whole machine wired together?"

Both files already have plain-English `★` section comments.

- [ ] `annotated/Oric.sv` — MiSTer glue: menu, files, RAM, video and sound out.
- [ ] `annotated/rtl/oricatmos.vhd` — the Oric itself: connects CPU, ULA, VIA, sound, ROM.
- [ ] Chat.
- [ ] Notes: `notes/phase-3-top-files.md`

## Phase 4 — The chips, one at a time

**Question:** "What does each part of the Oric do?" Suggested order (simple first):

| ✓ | File | What it is | Lines |
|---|---|---|---|
| [ ] | `rtl/spram.v` | RAM block (already annotated) | 47 |
| [ ] | `rtl/rom/` | ROM images (already annotated, `rom/README.md`) | — |
| [ ] | `rtl/T65/T65.vhd` | 6502 CPU — the outside pins only (already annotated) | — |
| [ ] | `rtl/ula.vhd` | ULA — clocks, memory sharing, and the whole screen (pixels, colours). **The most important file** | 569 |
| [ ] | `rtl/m6522.vhd` | VIA — keyboard, sound control, tape, printer, timers | 1123 |
| [ ] | `rtl/psg.v` | AY-3-8912 sound chip | 355 |
| [ ] | `rtl/keyboard.sv` | Keyboard matrix | 251 |
| [ ] | `rtl/joystick.sv` | Joystick | 66 |
| [ ] | `rtl/cassette.v` + `rtl/cas_sig_gen.v` | Tape in/out | 184 + 85 |

For big files (`m6522.vhd`), parts the Oric does not really use get one short comment, not detail.

- [ ] Notes: `notes/phase-4-chips.md` (one section per chip, added as each chip is done)

## Phase 5 — Optional extras

Only if you want them. Not needed to understand the Oric.

- [ ] Disk drive: `microdisc.vhd`, `wd1793.sv`, `pravetz8d_fdc.vhd`
- [ ] MiSTer-only features: fast tape loading (`tap_*.v`, `cload_patch_rom.v`),
      snapshots and savestates (`snap_*.v`, `savestate_hotkeys.v`)
- [ ] Notes: `notes/phase-5-extras.md` (only for the parts we do)

## Phase 6 — Put it together

- [ ] `how-the-oric-works.md`: one short story from power-on to a key press showing on screen,
      with links to the files.
- [ ] Optional: run one module in a simulator (GHDL / Verilator are installed — see
      `dev-env.md`) and watch it work.
- [ ] Notes: `notes/phase-6-put-together.md`

---

## Where things are

| Path | What |
|---|---|
| `core/` | Original upstream code (not in git). Never edit. |
| `annotated/` | Copies with our comments (`★ SECTION n`) |
| `notes/` | One short notes file per finished phase — read these first when you come back |
| `MAP.md` | Where to start, how files connect |
| `dev-env.md` | Tools and commands |
