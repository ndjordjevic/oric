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

// ★ WHAT THIS FILE IS
// A general-purpose block of RAM. It is not a real Oric chip. It is a template
// that Oric.sv uses 3 times, each with a different size:
//   - main RAM, 64 KB (Oric.sv:403) — the Oric's real RAM
//   - alt BIOS, 16 KB (Oric.sv:596) — a ROM you load from the SD card
//   - file cache, 192 KB (Oric.sv:678) — holds a loaded tape or snapshot file
// Key point: it has ONE address input, so only one user can access it per
// clock. That is why Oric.sv needs a "RAM arbiter" to choose who goes next.
`timescale 1ps / 1ps

// ★ SIZE SETTINGS: how many address bits and how many bits per location.
// Each user of this file sets its own size here.
module spram #(
	parameter address_width = 10,
	parameter data_width = 8,
	parameter numwords = (2**address_width)
) 
// ★ THE PINS: clock, write-enable, address, data in, data out.
(
	input	wire									clock,
	input	wire									wren,
	input	wire	[address_width-1:0]		address,
	input	wire	[data_width-1:0]			data,
	output	reg		[data_width-1:0]	q
);
 
// ★ THE MEMORY ITSELF: an array of bytes. The FPGA tool turns this into
// its built-in block RAM.
reg [data_width-1:0] mem [numwords-1:0];

// ★ READ AND WRITE: on every clock tick, read the byte at `address` to `q`.
// If write-enable is on, also store `data` there. The read data appears one
// clock tick after you give the address.
always @(posedge clock) begin
	q <= mem[address];
	if(wren) begin
		//q <= data;
		mem[address] <= data;
	end
end

endmodule
