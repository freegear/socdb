// =================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology
// -----------------------------------------------------------------
// Version and Release information: 
// File Name           : Romconv.v
// File Revision       : 0.1 
//  ----------------------------------------------------------------
//  Purpose            : Rom 16 -> 8 bit converter
//  ----------------------------------------------------------------
`timescale 1 ns/ 10ps

module Romconv (addr0, datain, datao );
input addr0;
input [15:0]	datain;

output	[7:0]	datao;

assign datao = addr0 ? datain[15:8]: datain [7:0] ;

endmodule


