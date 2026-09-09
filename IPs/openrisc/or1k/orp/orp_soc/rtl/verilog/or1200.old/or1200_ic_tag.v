//////////////////////////////////////////////////////////////////////
////                                                              ////
////  OR1200's IC TAGs                                            ////
////                                                              ////
////  This file is part of the OpenRISC 1200 project              ////
////  http://www.opencores.org/cores/or1k/                        ////
////                                                              ////
////  Description                                                 ////
////  Instatiation of instruction cache tag rams                  ////
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
// $Log: or1200_ic_tag.v,v $
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

module or1200_ic_tag(
	// Clock and reset
	clk, rst,

	// Internal i/f
	addr, en, we, datain, tag_v, tag
);

parameter dw = `OR1200_ICTAG_W;
parameter aw = `OR1200_ICTAG;

//
// I/O
//

//
// Clock and reset
//
input				clk;
input				rst;

//
// Internal i/f
//
input	[aw-1:0]		addr;
input				en;
input				we;
input	[dw-1:0]		datain;
output				tag_v;
output	[dw-2:0]		tag;

`ifdef OR1200_NO_IC

//
// Insn cache not implemented
//
assign tag = {dw-1{1'b0}};
assign tag_v = 1'b0;
`else

//
// Instantiation of TAG RAM block
//
`ifdef OR1200_IC_1W_4KB
or1200_spram_256x21 ic_tag0(
`endif
`ifdef OR1200_IC_1W_8KB
or1200_spram_512x20 ic_tag0(
`endif
	.clk(clk),
	.rst(rst),
	.ce(en),
	.we(we),
	.oe(1'b1),
	.addr(addr),
	.di(datain),
	.do({tag, tag_v})
);

`endif

endmodule
