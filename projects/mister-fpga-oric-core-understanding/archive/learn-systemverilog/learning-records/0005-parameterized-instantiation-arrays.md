# Learning record — SV Lesson 0005: Parameterized instantiation & unpacked arrays

**Date:** 2026-07-14
**Status:** Done.

## Self-check (per MISSION.md's success criteria — can you explain this without the lesson open?)

- [x] Tying a literal directly into a port (`.rst(0)`), and leaving a port deliberately unconnected (`.outclk_2()`)
- [x] Compile-time parameters `#(.PARAM(value), ...)` vs. runtime ports `(.port(signal), ...)` — same syntax, different meaning/timing
- [x] What HPS is and why `hps_io` exists as the FPGA-side link to it
- [x] Array-of-buses declaration `wire [31:0] sd_lba[4];` — two independent bracket dimensions (element width vs. array length)
- [x] Quiz Q1–Q2 — answer from memory, then check



## Notes / what actually clicked

- Asked what HPS stands for while reading the `hps_io` instantiation — added a short note to the lesson: Hard Processor System, the ARM cores on the DE10-Nano's Cyclone V SoC (separate from the FPGA fabric), running Linux and driving the OSD/ROM-loading/USB-input, talking to the FPGA core over `HPS_BUS`. Same "out of scope, shared framework" treatment as `video_freak` in Lesson 2.



## Next

- [x] Lesson 0006 — edge-detection idioms