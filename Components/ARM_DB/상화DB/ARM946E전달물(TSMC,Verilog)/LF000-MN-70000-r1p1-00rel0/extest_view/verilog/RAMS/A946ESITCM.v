// --=================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (c) COPYRIGHT 2000-2002 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// ---------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name           : $RCSfile: A946ESITCM.v,v $
// File Revision       : $Revision: 1.2 $
//
// Release Information : $State: Rel $
//-----------------------------------------------------------------------------
// Example A946ESITCM.v file to instantiate the ITCM Ram(s).

module A946ESITCM (CLK, ADDR, DI, WE, En, DO);

  parameter ADR_WIDTH  = 16;           // default to 64K RAM
  
  input                   CLK;       
  input  [ADR_WIDTH-1:0]  ADDR;   
  input           [31:0]  DI; 
  input            [3:0]  WE;        
  input                   En;    
  output          [31:0]  DO; 
 
  wire                    EnBar;
  wire [3:0]              BWEBar;
  wire                    WEBar;

  assign EnBar = ~En;
  assign BWEBar = ~WE;
  assign WEBar  = ~|WE;
  
  ByteRAM_256RA1SH uITCM
    (
     // Outputs
     .Q                              (DO[31:0]),
     // Inputs
     .CLK                               (CLK),
     .CEN                               (EnBar),
     .WEN                               (BWEBar[3:0]),
     .A                                 (ADDR[7:0]),
     .D                                 (DI[31:0]),
     .OEN                               (1'b0));
 
endmodule

// --================================= End ===================================--
