// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : SSRAM32bit.v
// File Revision       : 0.1
//  -----------------------------------------------------------------------------
//  Purpose            : Synchronous SRAM
//                     : This module is for test purpose only.
//  =============================================================================

`timescale 1ns/10ps

module    DROM 
  (
   CLK     , 
   ADDR_a    ,
   CEn_a     ,
   OEn_a     ,
   RDATA_a   ,

   ADDR_b    ,
   CEn_b     ,
   OEn_b     ,
   RDATA_b   
   );
   
   //
   // module parameter
   //
   parameter ADDR_WIDTH = 12;	// Memory Address Width : should be at least 12(4KB)
   parameter DATA_WIDTH = 32;
   parameter BYTE_NUM = (DATA_WIDTH/8);
   
   input 	 CLK;
   input [ADDR_WIDTH-1:0] ADDR_a;
   input 				  CEn_a;
   input 				  OEn_a;
   output [DATA_WIDTH-1:0] RDATA_a;
   
   input [ADDR_WIDTH-1:0] ADDR_b;
   input 				  CEn_b;
   input 				  OEn_b;
   output [DATA_WIDTH-1:0] RDATA_b;

   //------------------------------------------------------------
   reg [DATA_WIDTH-1:0]    memory[{ADDR_WIDTH{1'b1}}:0];
   
   reg [DATA_WIDTH-1:0]    RDATA_a;
   reg [DATA_WIDTH-1:0]    RDATA_b;
   
   integer 				   i;

   initial begin
	  RDATA_a = 0;
	  RDATA_b = 0;
	  $readmemh("./rom.dat", memory);
   end // initial
   
   
   always @(CEn_a or OEn_a or ADDR_a)
	 begin
		if(CEn_a == 1'b0)
		  begin
			 if(OEn_a == 1'b0)
			   RDATA_a = memory[ADDR_a];
 		  end
	 end


   always @(CEn_b or OEn_b or ADDR_b)
	 begin
		if(CEn_b == 1'b0)
		  begin
			 if(OEn_b == 1'b0)
			   RDATA_b = memory[ADDR_b];
 		  end
	 end
   
endmodule // ROM
