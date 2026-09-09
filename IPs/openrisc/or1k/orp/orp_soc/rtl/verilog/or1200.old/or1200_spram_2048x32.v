//////////////////////////////////////////////////////////////////////
////                                                              ////
////  Generic Single-Port Synchronous RAM                         ////
////                                                              ////
////  This file is part of memory library available from          ////
////  http://www.opencores.org/cvsweb.shtml/generic_memories/     ////
////                                                              ////
////  Description                                                 ////
////  This block is a wrapper with common single-port             ////
////  synchronous memory interface for different                  ////
////  types of ASIC and FPGA RAMs. Beside universal memory        ////
////  interface it also provides behavioral model of generic      ////
////  single-port synchronous RAM.                                ////
////  It should be used in all OPENCORES designs that want to be  ////
////  portable accross different target technologies and          ////
////  independent of target memory.                               ////
////                                                              ////
////  Supported ASIC RAMs are:                                    ////
////  - Artisan Single-Port Sync RAM                              ////
////  - Avant! Two-Port Sync RAM (*)                              ////
////  - Virage Single-Port Sync RAM                               ////
////  - Virtual Silicon Single-Port Sync RAM                      ////
////                                                              ////
////  Supported FPGA RAMs are:                                    ////
////  - Xilinx Virtex RAMB4_S16                                   ////
////                                                              ////
////  To Do:                                                      ////
////   - xilinx rams need external tri-state logic                ////
////   - fix avant! two-port ram                                  ////
////   - add additional RAMs (Altera etc)                         ////
////                                                              ////
////  Author(s):                                                  ////
////      - Damjan Lampret, lampret@opencores.org                 ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright (C) 2000 Authors and OPENCORES.ORG                 ////
////                                                              ////
//// This source file may be used and distributed without         ////
//// restriction provided that this copyright statement is not    ////
//// removed from the file and that any derivative work contains  ////
//// the original copyright notice and the associated disclaimer. ////
////                                                              ////
//// This source file is free software; you can redistribute it   ////
//// and/or modify it under the terms of the GNU Lesser General   ////
//// Public License as published by the Free Software Foundation; ////
//// either version 2.1 of the License, or (at your option) any   ////
//// later version.                                               ////
////                                                              ////
//// This source is distributed in the hope that it will be       ////
//// useful, but WITHOUT ANY WARRANTY; without even the implied   ////
//// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      ////
//// PURPOSE.  See the GNU Lesser General Public License for more ////
//// details.                                                     ////
////                                                              ////
//// You should have received a copy of the GNU Lesser General    ////
//// Public License along with this source; if not, download it   ////
//// from http://www.opencores.org/lgpl.shtml                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS Revision History
//
// $Log: or1200_spram_2048x32.v,v $
// Revision 1.1.1.1  2002/03/21 16:55:45  lampret
// First import of the "new" XESS XSV environment.
//
//
// Revision 1.1  2002/01/03 08:16:15  lampret
// New prefixes for RTL files, prefixed module names. Updated cache controllers and MMUs.
//
// Revision 1.8  2001/11/02 18:57:14  lampret
// Modified virtual silicon instantiations.
//
// Revision 1.7  2001/10/21 17:57:16  lampret
// Removed params from generic_XX.v. Added translate_off/on in sprs.v and id.v. Removed spr_addr from dc.v and ic.v. Fixed CR+LF.
//
// Revision 1.6  2001/10/14 13:12:09  lampret
// MP3 version.
//
// Revision 1.1.1.1  2001/10/06 10:18:36  igorm
// no message
//
// Revision 1.1  2001/08/09 13:39:33  lampret
// Major clean-up.
//
// Revision 1.2  2001/07/30 05:38:02  lampret
// Adding empty directories required by HDL coding guidelines
//
//

// synopsys translate_off
`include "timescale.v"
// synopsys translate_on
`include "or1200_defines.v"

module or1200_spram_2048x32(
	// Generic synchronous single-port RAM interface
	clk, rst, ce, we, oe, addr, di, do
);

//
// Default address and data buses width
//
parameter aw = 11;
parameter dw = 32;

//
// Generic synchronous single-port RAM interface
//
input			clk;	// Clock
input			rst;	// Reset
input			ce;	// Chip enable input
input			we;	// Write enable input
input			oe;	// Output enable input
input 	[aw-1:0]	addr;	// address bus inputs
input	[dw-1:0]	di;	// input data bus
output	[dw-1:0]	do;	// output data bus

//
// Internal wires and registers
//


`ifdef OR1200_ARTISAN_SSP

//
// Instantiation of ASIC memory:
//
// Artisan Synchronous Single-Port RAM (ra1sh)
//
`ifdef UNUSED
art_hdsp_2048x32 #(dw, 1<<aw, aw) artisan_ssp(
`else
art_hdsp_2048x32 artisan_ssp(
`endif
	.clk(clk),
	.cen(~ce),
	.wen(~we),
	.a(addr),
	.d(di),
	.oen(~oe),
	.q(do)
);

`else

`ifdef OR1200_AVANT_ATP

//
// Instantiation of ASIC memory:
//
// Avant! Asynchronous Two-Port RAM
//
avant_atp avant_atp(
	.web(~we),
	.reb(),
	.oeb(~oe),
	.rcsb(),
	.wcsb(),
	.ra(addr),
	.wa(addr),
	.di(di),
	.do(do)
);

`else

`ifdef OR1200_VIRAGE_SSP

//
// Instantiation of ASIC memory:
//
// Virage Synchronous 1-port R/W RAM
//
virage_ssp virage_ssp(
	.clk(clk),
	.adr(addr),
	.d(di),
	.we(we),
	.oe(oe),
	.me(ce),
	.q(do)
);

`else

`ifdef OR1200_VIRTUALSILICON_SSP

//
// Instantiation of ASIC memory:
//
// Virtual Silicon Single-Port Synchronous SRAM
//
`ifdef UNUSED
vs_hdsp_2048x32 #(1<<aw, aw-1, dw-1) vs_ssp(
`else
vs_hdsp_2048x32 vs_ssp(
`endif
	.CK(clk),
	.ADR(addr),
	.DI(di),
	.WEN(~we),
	.CEN(~ce),
	.OEN(~oe),
	.DOUT(do)
);

`else

`ifdef OR1200_XILINX_RAMB4

//
// Instantiation of FPGA memory:
//
// Virtex/Spartan2
//

//
// Block 0
//
RAMB4_S2 ramb4_s2_0(
	.CLK(clk),
	.RST(rst),
	.ADDR(addr),
	.DI(di[1:0]),
	.EN(ce),
	.WE(we),
	.DO(do[1:0])
);

//
// Block 1
//
RAMB4_S2 ramb4_s2_1(
	.CLK(clk),
	.RST(rst),
	.ADDR(addr),
	.DI(di[3:2]),
	.EN(ce),
	.WE(we),
	.DO(do[3:2])
);

//
// Block 2
//
RAMB4_S2 ramb4_s2_2(
	.CLK(clk),
	.RST(rst),
	.ADDR(addr),
	.DI(di[5:4]),
	.EN(ce),
	.WE(we),
	.DO(do[5:4])
);

//
// Block 3
//
RAMB4_S2 ramb4_s2_3(
	.CLK(clk),
	.RST(rst),
	.ADDR(addr),
	.DI(di[7:6]),
	.EN(ce),
	.WE(we),
	.DO(do[7:6])
);

//
// Block 4
//
RAMB4_S2 ramb4_s2_4(
	.CLK(clk),
	.RST(rst),
	.ADDR(addr),
	.DI(di[9:8]),
	.EN(ce),
	.WE(we),
	.DO(do[9:8])
);

//
// Block 5
//
RAMB4_S2 ramb4_s2_5(
	.CLK(clk),
	.RST(rst),
	.ADDR(addr),
	.DI(di[11:10]),
	.EN(ce),
	.WE(we),
	.DO(do[11:10])
);

//
// Block 6
//
RAMB4_S2 ramb4_s2_6(
	.CLK(clk),
	.RST(rst),
	.ADDR(addr),
	.DI(di[13:12]),
	.EN(ce),
	.WE(we),
	.DO(do[13:12])
);

//
// Block 7
//
RAMB4_S2 ramb4_s2_7(
	.CLK(clk),
	.RST(rst),
	.ADDR(addr),
	.DI(di[15:14]),
	.EN(ce),
	.WE(we),
	.DO(do[15:14])
);

//
// Block 8
//
RAMB4_S2 ramb4_s2_8(
	.CLK(clk),
	.RST(rst),
	.ADDR(addr),
	.DI(di[17:16]),
	.EN(ce),
	.WE(we),
	.DO(do[17:16])
);

//
// Block 9
//
RAMB4_S2 ramb4_s2_9(
	.CLK(clk),
	.RST(rst),
	.ADDR(addr),
	.DI(di[19:18]),
	.EN(ce),
	.WE(we),
	.DO(do[19:18])
);

//
// Block 10
//
RAMB4_S2 ramb4_s2_10(
	.CLK(clk),
	.RST(rst),
	.ADDR(addr),
	.DI(di[21:20]),
	.EN(ce),
	.WE(we),
	.DO(do[21:20])
);

//
// Block 11
//
RAMB4_S2 ramb4_s2_11(
	.CLK(clk),
	.RST(rst),
	.ADDR(addr),
	.DI(di[23:22]),
	.EN(ce),
	.WE(we),
	.DO(do[23:22])
);

//
// Block 12
//
RAMB4_S2 ramb4_s2_12(
	.CLK(clk),
	.RST(rst),
	.ADDR(addr),
	.DI(di[25:24]),
	.EN(ce),
	.WE(we),
	.DO(do[25:24])
);

//
// Block 13
//
RAMB4_S2 ramb4_s2_13(
	.CLK(clk),
	.RST(rst),
	.ADDR(addr),
	.DI(di[27:26]),
	.EN(ce),
	.WE(we),
	.DO(do[27:26])
);

//
// Block 14
//
RAMB4_S2 ramb4_s2_14(
	.CLK(clk),
	.RST(rst),
	.ADDR(addr),
	.DI(di[29:28]),
	.EN(ce),
	.WE(we),
	.DO(do[29:28])
);

//
// Block 15
//
RAMB4_S2 ramb4_s2_15(
	.CLK(clk),
	.RST(rst),
	.ADDR(addr),
	.DI(di[31:30]),
	.EN(ce),
	.WE(we),
	.DO(do[31:30])
);

`else

//
// Generic single-port synchronous RAM model
//

//
// Generic RAM's registers and wires
//
reg	[dw-1:0]	mem [(1<<aw)-1:0];	// RAM content
reg	[dw-1:0]	do_reg;			// RAM data output register

//
// Data output drivers
//
assign do = (oe) ? do_reg : {dw{1'bz}};

//
// RAM read and write
//
always @(posedge clk)
	if (ce && !we)
		do_reg <= #1 mem[addr];
	else if (ce && we)
		mem[addr] <= #1 di;

`endif	// !OR1200_XILINX_RAMB4_S16
`endif	// !OR1200_VIRTUALSILICON_SSP
`endif	// !OR1200_VIRAGE_SSP
`endif  // !OR1200_AVANT_ATP
`endif	// !OR1200_ARTISAN_SSP

endmodule
