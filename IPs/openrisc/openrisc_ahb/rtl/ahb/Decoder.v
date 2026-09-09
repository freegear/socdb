//  --==============================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 2001 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//  
//  ------------------------------------------------------------------
//  Version and Release Control Information:
//  
//  File Name          : Decoder.v,v
//  File Revision      : 1.6
//  
//  Release Information : ADK_REL1v1
//  
//  ------------------------------------------------------------------
//  Purpose            : Provides the HSELx module select outputs to
//                        the AHB system slaves, and controls the read
//                        data multiplexer.
//  --==============================================================--

`timescale 1ns/1ps

module Decoder
  (
   // Upper order bits of the address bus for the decode function
   HADDR,

   // Select lines produced by the decode logic
   HSELS0,    // IFMC, 256K
   HSELS1,    // ESMC, 4M
   HSELS2,    // ISMC, 24K
   HSELS3,    // APB
   HSELSR
);

  input [31:0]  HADDR;
  output        HSELS0;
  output        HSELS1;
  output        HSELS2;
  output        HSELS3;
  output        HSELSR;

//--------------------------------------------------------------------
// Signal declarations
//--------------------------------------------------------------------

wire Bank0 = (HADDR[31:23] == 8'h00); // 0x00xx_xxxx
wire Bank1 = (HADDR[31:23] == 8'h04); // 0x04xx_xxxx
wire Bank2 = ~(Bank0 | Bank1); // other range
wire Bank3 = 1'b0;

assign HSELS0 = Bank0;
assign HSELS1 = Bank1;
assign HSELS2 = Bank2;
assign HSELS3 = Bank3;
assign HSELSR = ~(Bank0 | Bank1 | Bank2 | Bank3);

endmodule
