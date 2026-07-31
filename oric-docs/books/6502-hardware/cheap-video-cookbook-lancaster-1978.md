# The Cheap Video Cookbook

**Author:** Don Lancaster
**Year:** 1978 (Howard W. Sams & Co.)
**Category:** TTL-logic video generation — the discrete-logic analog of what a ULA does
**Source:** `/Users/nenaddjordjevic/pCloud Drive/iCloud-Migration/Programming/Retro/Electornics/Cheap_Video_Cookbook_Don_Lancaster 1978.pdf`

Not Oric-specific. A period how-to for generating a character/graphics video signal from a
microprocessor using a minimum of dedicated TTL hardware — the discrete-chip version of the job
the Oric's ULA does in one custom part.

## Table of Contents

- **Ch. 1 Some Basics** — p.9 — the rules of the game, some architecture, a commercial example,
  "secret formulas," good/bad things about microprocessor-based video displays, which
  microprocessor, a design plan
- **Ch. 2 Software Design** — p.31 — bus definitions, the SCAN microinstruction, SCAN programs,
  graphics SCAN programs, cursor software, a graphics loader, transparency, volatility, RAM vs. ROM
- **Ch. 3 Hardware Design** — p.107 — interface-card hardware design, computer interface, KIM-1
  interface, television interface
- **Ch. 4 Building the TVT 6% ⁄ ²** — p.155 — how it works, construction details, data-to-video
  modules, step-by-step assembly, module construction, debug and checkout, modifications
- **Ch. 5 Transparency** — p.200 — transparency principles (ignore it / time it / lock it / paint
  it black / integrate it / fill in the sync pulses / "use a sledgehammer")
- **Appendix** — p.227
- **Index** — p.253

---

**Why relevant to the Oric:** this is the "how do you actually get pixels onto a TV from a
microcomputer" problem worked from first principles with discrete TTL — the same problem the
Oric's ULA solves in one custom chip via serial attributes and per-line address recomputation
(Days 2–3, `ula.vhd`/`video.vhd`). Useful background for *why* the constraints exist (bandwidth,
sync generation, RAM contention) before reading the ULA's answer to them. Pair with
[`tv-typewriter-cookbook-lancaster.md`](tv-typewriter-cookbook-lancaster.md), Lancaster's earlier,
more character-display-focused book on the same topic.
