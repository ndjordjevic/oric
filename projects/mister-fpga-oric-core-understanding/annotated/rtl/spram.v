/*============================================================================
	Generic single-port RAM module

	Author: Jim Gregory - https://github.com/JimmyStones/
	Version: 1.0
	Date: 2021-07-03

	This program is free software; you can redistribute it and/or modify it
	under the terms of the GNU General Public License as published by the Free
	Software Foundation; either version 3 of the License, or (at your option)
	any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along
	with this program. If not, see <http://www.gnu.org/licenses/>.
===========================================================================*/

/* ★ WHAT THIS FILE IS ─────────────────────────────────────────────────────
 *
 * A generic, reusable single-port RAM. It models no real Oric chip at all —
 * it is a *template* for "a block of memory", instantiated wherever the core
 * needs one. On the real Oric these would be physical DRAM chips on the PCB;
 * here one small parameterised module stands in for all of them.
 *
 * WHERE IT'S USED — three instantiations, all in Oric.sv, all different sizes:
 *   1. Main RAM      — 64 KB  (address_width 16) ... the Oric's actual RAM
 *   2. File cache    — 192 KB (address_width 18) ... holds a loaded TAP/SNA
 *   3. Alt BIOS      — 16 KB  (address_width 14) ... a user-supplied ROM
 * Only #1 is "the Oric"; #2 and #3 are MiSTer conveniences.
 *
 * "SINGLE-PORT" IS THE KEY PROPERTY, and it has a consequence worth
 * understanding before you read anything else in this core: there is exactly
 * ONE address input, so exactly ONE party can touch the memory per clock
 * cycle. A dual-port RAM would allow two. That single-port restriction is
 * precisely *why* Oric.sv needs a RAM arbiter (★ RAM ARBITER, Oric.sv:346) to
 * decide each cycle who gets the bus: reset-wipe, snapshot restore,
 * save-state, tape loader, or the CPU. The arbiter exists because of this
 * module's shape.
 *
 * WHAT IT IS NOT: not asynchronous (reads are clocked, see SECTION 4), not
 * dual-port, not byte-enabled, and not initialised from a file — it powers up
 * undefined. That is why the core explicitly walks the whole address space on
 * reset and writes every location before letting the CPU run.
 *
 *   >> AND IT FILLS WITH 0x01, NOT 0x00. Oric.sv:349 is `spram_d <= 1;`.
 *      Worth knowing because "the RAM starts zeroed" is a natural assumption
 *      and it is false here. (The ★ comment at Oric.sv:150 said "zeroing it
 *      out" — corrected 2026-07-27.) The clearing counter `clr_addr` is also
 *      17 bits wide while the address bus takes only its low 16, so the wipe
 *      actually sweeps the 64 KB twice. OPEN QUESTION for the hardware notes:
 *      whether 0x01 mimics real Oric DRAM power-up state, is needed by the
 *      ROM's RAM-sizing routine, or is simply arbitrary.
 * ─────────────────────────────────────────────────────────────────────────*/

`timescale 1ps / 1ps

/* ★ SECTION 1 — Module interface: the three size parameters
 *
 * Parameters are compile-time constants: they fix the *shape* of the memory
 * when the FPGA is built, not while it runs. This is what lets one file serve
 * as all three memories above — each instantiation passes different numbers.
 *
 *   address_width — how many address bits, and so how many locations exist.
 *                   The default 10 is never used by this core; every real
 *                   instantiation overrides it (16 / 18 / 14).
 *   data_width    — bits per location. Always 8 here: the Oric is an 8-bit
 *                   machine, so one location = one byte.
 *   numwords      — the location count. By default DERIVED rather than passed
 *                   in: 2**address_width. With address_width=16 that is
 *                   65536, i.e. the Oric's 64 KB, and the address bus and the
 *                   array can never disagree about the size.
 *
 *                   >> But it CAN be overridden, and one instantiation does:
 *                      the file cache (Oric.sv:632) passes both address_width
 *                      (18) and numwords (196608) explicitly, because 192 KB
 *                      is NOT a power of two. 2**18 would be 262144 — more
 *                      than needed. Overriding numwords allocates only the
 *                      192 KB actually wanted while keeping an 18-bit address
 *                      bus wide enough to reach it. This is why the parameter
 *                      exists separately at all instead of always being 2**n.
 */
module spram #(
	parameter address_width = 10,
	parameter data_width = 8,
	parameter numwords = (2**address_width)
)
(
	/* ★ SECTION 2 — Ports: the wires a memory needs
	 *
	 * This is the minimal, classic RAM interface — five signals:
	 *
	 *   clock   — everything happens on its rising edge (SECTION 4)
	 *   wren    — "write enable": 1 = store `data`, 0 = read only
	 *   address — which location. Its width follows address_width, so the
	 *             bus is exactly wide enough to reach every location
	 *   data    — the byte going IN (only consulted when wren is 1)
	 *   q       — the byte coming OUT
	 *
	 * Note `data` and `q` are separate one-way buses, not one shared
	 * bidirectional bus. Real 1980s RAM chips had a single bidirectional data
	 * bus that had to be turned around between reads and writes; inside an
	 * FPGA it is simpler and faster to keep the two directions apart.
	 *
	 * `q` is declared `reg` (not `wire`) because it is assigned inside the
	 * clocked block below — it holds its value between clock edges.
	 */
	input	wire									clock,
	input	wire									wren,
	input	wire	[address_width-1:0]		address,
	input	wire	[data_width-1:0]			data,
	output	reg		[data_width-1:0]	q
);

/* ★ SECTION 3 — The storage itself
 *
 * One line, and it is the entire memory: an array of `numwords` locations,
 * each `data_width` bits wide. For main RAM that is 65536 entries of 8 bits.
 *
 * WHERE THIS PHYSICALLY LIVES: the FPGA synthesis tool recognises this
 * "array of registers, read and written synchronously" shape and maps it onto
 * the chip's dedicated BLOCK RAM (BRAM) — purpose-built memory blocks built
 * into the FPGA fabric. It does NOT build 65536 individual flip-flops (which
 * would exhaust the chip) and it does not go off-chip to the DE10-Nano's
 * external SDRAM/DDR3. Writing the array in exactly this idiom is what makes
 * that inference work; a subtly different shape would synthesise far worse.
 */
reg [data_width-1:0] mem [numwords-1:0];

/* ★ SECTION 4 — The one and only process: a synchronous read/write port
 *
 * Everything this module does happens here, once per rising clock edge.
 *
 * READ (unconditional, every cycle): the byte at `address` is fetched into
 * `q`. Note this happens whether or not you asked for a read — a single-port
 * synchronous RAM always presents *something* on its output.
 *
 *   >> CONSEQUENCE: reads have ONE CLOCK CYCLE OF LATENCY. You place an
 *      address this cycle; the data appears on `q` on the *next* cycle, not
 *      immediately. Every consumer of this RAM has to account for that delay,
 *      and it is a common source of off-by-one-cycle bugs when reading FPGA
 *      code that talks to memory.
 *
 *   >> AND IN PRACTICE IT IS TWO, not one, for main RAM. Oric.sv's RAM
 *      arbiter registers the address (spram_addr is assigned inside a clocked
 *      block, Oric.sv:346-373), which costs a cycle before this module even
 *      sees it. So end-to-end it is: 1 cycle through the arbiter mux + 1
 *      cycle here = ram_q valid 2 cycles after a consumer requests it. The
 *      core's own source says so where it matters — see snap_ss.v:63 and
 *      :454, and tap_segment_loader.v:194, which all explicitly drain this
 *      2-cycle pipeline. Worth internalising: the module's latency and the
 *      *system's* latency are different numbers.
 *
 * WRITE (only when wren is 1): `data` is stored into `mem[address]`.
 *
 * READ-DURING-WRITE — the subtle part. When you read and write the SAME
 * address in the SAME cycle, which value comes out on `q`? Both assignments
 * here are non-blocking (`<=`), so both right-hand sides are evaluated
 * against the memory's state *before* this edge. `q` therefore receives the
 * OLD contents of the location, and the new byte lands only afterwards. This
 * is called "read-before-write" (or "old data") behaviour.
 *
 * That is also what the commented-out line is about: `//q <= data;` would
 * have forced the NEW byte onto `q` instead ("write-through" / "new data"
 * behaviour). The author deliberately left it disabled — it is not dead code
 * so much as the other half of a choice, kept visible to document which mode
 * this RAM implements.
 */
always @(posedge clock) begin
	q <= mem[address];
	if(wren) begin
		//q <= data;
		mem[address] <= data;
	end
end

endmodule
