//////////////////////////////////////////////////////////////////////
////                                                              ////
////  OR1200's DC RAMs                                            ////
////                                                              ////
////  This file is part of the OpenRISC 1200 project              ////
////  http://www.opencores.org/cores/or1k/                        ////
////                                                              ////
////  Description                                                 ////
////  Instatiation of DC RAM blocks.                              ////
////                                                              ////
////  To Do:                                                      ////
////   - make it smaller and faster                               ////
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
// $Log: or1200_dc_ram.v,v $
// Revision 1.1.1.1  2002/03/21 16:55:45  lampret
// First import of the "new" XESS XSV environment.
//
//
// Revision 1.1  2002/01/03 08:16:15  lampret
// New prefixes for RTL files, prefixed module names. Updated cache controllers and MMUs.
//
// Revision 1.8  2001/10/21 17:57:16  lampret
// Removed params from generic_XX.v. Added translate_off/on in sprs.v and id.v. Removed spr_addr from dc.v and ic.v. Fixed CR+LF.
//
// Revision 1.7  2001/10/14 13:12:09  lampret
// MP3 version.
//
// Revision 1.1.1.1  2001/10/06 10:18:36  igorm
// no message
//
// Revision 1.2  2001/08/09 13:39:33  lampret
// Major clean-up.
//
// Revision 1.1  2001/07/20 00:46:03  lampret
// Development version of RTL. Libraries are missing.
//
//

// synopsys translate_off
`include "timescale.v"
// synopsys translate_on
`include "or1200_defines.v"

module or1200_dc_ram(
	// Reset and clock
	clk, rst,

	// Internal i/f
	addr, en, we, datain, dataout
);

parameter dw = `OR1200_OPERAND_WIDTH;
parameter aw = `OR1200_DCINDX;

//
// I/O
//
input				clk;
input				rst;
input	[aw-1:0]		addr;
input				en;
input	[3:0]			we;
input	[dw-1:0]		datain;
output	[dw-1:0]		dataout;

`ifdef OR1200_NO_DC

//
// Data cache not implemented
//

assign dataout = {dw{1'b0}};

`else

//
// Instantiation of RAM block 0
//
`ifdef OR1200_DC_1W_4KB
or1200_spram_1024x8 dc_ram0(
`endif
`ifdef OR1200_DC_1W_8KB
or1200_spram_2048x8 dc_ram0(
`endif
	.clk(clk),
	.rst(rst),
	.ce(en),
	.we(we[0]),
	.oe(1'b1),
	.addr(addr),
	.di(datain[7:0]),
	.do(dataout[7:0])
);

//
// Instantiation of RAM block 1
//
`ifdef OR1200_DC_1W_4KB
or1200_spram_1024x8 dc_ram1(
`endif
`ifdef OR1200_DC_1W_8KB
or1200_spram_2048x8 dc_ram1(
`endif
	.clk(clk),
	.rst(rst),
	.ce(en),
	.we(we[1]),
	.oe(1'b1),
	.addr(addr),
	.di(datain[15:8]),
	.do(dataout[15:8])
);

//
// Instantiation of RAM block 2
//
`ifdef OR1200_DC_1W_4KB
or1200_spram_1024x8 dc_ram2(
`endif
`ifdef OR1200_DC_1W_8KB
or1200_spram_2048x8 dc_ram2(
`endif
	.clk(clk),
	.rst(rst),
	.ce(en),
	.we(we[2]),
	.oe(1'b1),
	.addr(addr),
	.di(datain[23:16]),
	.do(dataout[23:16])
);

//
// Instantiation of RAM block 3
//
`ifdef OR1200_DC_1W_4KB
or1200_spram_1024x8 dc_ram3(
`endif
`ifdef OR1200_DC_1W_8KB
or1200_spram_2048x8 dc_ram3(
`endif
	.clk(clk),
	.rst(rst),
	.ce(en),
	.we(we[3]),
	.oe(1'b1),
	.addr(addr),
	.di(datain[31:24]),
	.do(dataout[31:24])
);

`endif

endmodule
