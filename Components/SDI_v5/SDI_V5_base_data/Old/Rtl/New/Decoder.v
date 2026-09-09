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

/*
 - AHB Chip Select Generation
                                            
   HSELS0      ,   // Internal FLASH			: 0x0000_0000 ~ 0x0003_FFFF(BootMode==0)
   																				: 0x0010_0000 ~ 0x0013_FFFF(BootMode==1)
   																				: 0x01F0_0000 ~ 0x01F3FFFF(Flash Mirror)
   HSELS1      ,   // External SRAM       : 0x0000_0000 ~ 0x000F_FFFF, 0x0020_0000 ~ 0x004F_FFFF(BootMode==0)
                                          : 0x0010_0000 ~ 0x004F_FFFF(BootMode==1)
   HSELS2      ,   // Internal 24KB SRAM  : 0x01FF_0000 ~ 0x01FF_5FFF
   HSELS3      ,   // APB                 : 0x01FF_8000 ~ 0x01FF_8D0C
*/
   
`timescale 1ns/1ps

module Decoder
  (
   // Upper order bits of the address bus for the decode function
   HADDR,

   // Status of the system re-map
   BootMode,

   // Select lines produced by the decode logic
   HSELS0,    // IFMC, 256K
   HSELS1,    // ESMC, 4M
   HSELS1_0,
   HSELS1_1,
   HSELS1_2,
   HSELS1_3,
   HSELS2,    // ISMC, 24K
   HSELS3,    // APB
   HSELSR,
);

  input [31:0]  HADDR;
  input         BootMode;
  output        HSELS0;
  output        HSELS1;
  output        HSELS1_0;
  output        HSELS1_1;
  output        HSELS1_2;
  output        HSELS1_3;
  output        HSELS2;
  output        HSELS3;
  output        HSELSR;

//--------------------------------------------------------------------
// Signal declarations
//--------------------------------------------------------------------

wire HAHigh0 = ~|HADDR[31:23]; // 0x00xx_xxxx
wire HA01F   = ~|HADDR[31:25] & (&HADDR[24:20]); // 0x01Fx_xxxx

wire Bank0 = HAHigh0 & ~HADDR[22] & ~HADDR[21] & ~HADDR[20]; // 0x000x_xxxx
wire Bank1 = HAHigh0 & ~HADDR[22] & ~HADDR[21] &  HADDR[20]; // 0x001x_xxxx
wire Bank2 = HAHigh0 & ~HADDR[22] &  HADDR[21] & ~HADDR[20]; // 0x002x_xxxx
wire Bank3 = HAHigh0 & ~HADDR[22] &  HADDR[21] &  HADDR[20]; // 0x003x_xxxx
wire Bank4 = HAHigh0 &  HADDR[22] & ~HADDR[21] & ~HADDR[20]; // 0x004x_xxxx

wire BankFM = HA01F & ~HADDR[19] & ~HADDR[18];
wire BankP  = HA01F & &HADDR[19:15] & ~|HADDR[14:12] & (HADDR[31:8] < 24'h01FF_8E); // 0x01FF_8xxx
wire BankR  = HA01F & &HADDR[19:15] & ~|HADDR[14:13] & HADDR[12];

assign HSELS1_0 = BootMode ? Bank1 : Bank0;
assign HSELS1_1 = Bank2;
assign HSELS1_2 = Bank3;
assign HSELS1_3 = Bank4;

wire BankR1 = (HADDR[31:20] >= 12'h005) &  (HADDR[31:20] < 12'h01F);
wire BankR2 = (HADDR[31:16] >= 16'h01F4) & (HADDR[31:16] < 16'h01FF);  
wire BankR3 = (HADDR[31:8]  >= 24'h01FF_8E);

assign HSELS0 = BootMode ? Bank1 | BankFM : Bank0 & BankFM;
assign HSELS1 = HSELS1_0 | HSELS1_1 | HSELS1_2 | HSELS1_3;
assign HSELS2 = (BankFM);
assign HSELS3 = (BankP);
assign HSELSR = BankR1 | BankR2 | BankR3;

endmodule
