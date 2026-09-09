// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 1998 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
// 
// -----------------------------------------------------------------------------
// Version and Release Control Information:
// 
// File Name           : busline_drivers.v,v 
// File Revision       : 1.1 
// 
// Release Information : PL050-REL1v1 
// 
// -----------------------------------------------------------------------------
// Purpose             : AMBA signal drivers
// --=========================================================================--

`timescale 1ns/1ps

module BUSLINE_DRIVERS (BCLK, BNRES, PADDR_SEL, PWDATA_SEL, PSEL_SEL,
                        PWRITE_SEL, PENABLE_SEL, APB_PACKET_SEL, 
                        APB_PACKET_WRITE, APB_PACKET_ADDR, APB_PACKET_DATA,
                        APB_PACKET_MASK, APB_PACKET_EXP, APB_PACKET_LIMIT,
                        APB_PACKET_NUM_CYC, APB_PACKET_TAG, POSTATI, POSTATO,
                        CYC_SEL, PADDR, PWDATA, PRDATA, PSEL, PSELT, PWRITE,
                        PENABLE);
   
   parameter 
      Tclkh  = 50,
      Tclkl  = 50,
      Tispaddr  = 5,
      Tihpaddr  = 2,
      Tispw  = 5,
      Tihpw  = 2,
      Tispsel  = 5,
      Tihpsel  = 2,
      Tispen  = 5,
      Tihpen  = 2,
      Tispdw = 5,
      Tihpdw = 2,
      Verbosity = 0,
      HaltOnMismatch = 0;

  `include "../common/defs.v"
 
  input BCLK;
  input BNRES;
  input PADDR_SEL;
  input [2:0] PWDATA_SEL;
  input PSEL_SEL;
  input PWRITE_SEL;
  input [1:0] PENABLE_SEL;
  input APB_PACKET_SEL;
  input APB_PACKET_WRITE;
  input [31:0] APB_PACKET_ADDR;
  input [31:0] APB_PACKET_DATA;
  input [31:0] APB_PACKET_MASK;
  input [31:0] APB_PACKET_EXP;
  input [7:0] APB_PACKET_NUM_CYC;
  input [31:0] APB_PACKET_LIMIT;
  input [159:0] APB_PACKET_TAG;
  input POSTATI;
  output POSTATO;
  input [3:0] CYC_SEL;
  output [31:0] PADDR;
  input  [31:0] PRDATA;
  output [31:0] PWDATA;
  output PSEL;
  output PSELT;
  output PWRITE;
  output PENABLE;

  wire I_PSEL;
  wire TRICKBOXSEL;

  wire INPSEL;

  assign INPSEL      = (POSTATI === 1 && (PWDATA_SEL === `T_D_DRV_SEL_D_IDLE)) ?
                       1'b0 : APB_PACKET_SEL;
 
  assign TRICKBOXSEL = (APB_PACKET_ADDR[31:8] == `TRICKBOX_ADDR) ? 1'b1 
                       : 1'b0; 

  assign PSEL = ((I_PSEL === 1'b1) && TRICKBOXSEL == 1'b0) ? 1'b1 :(
                (((I_PSEL === 1'b1) || (I_PSEL === 1'b0)) &&
                 TRICKBOXSEL == 1'b1) ? 1'b0 :(
                (I_PSEL == 1'bx) ? 1'bx :(
                PSEL)));

  assign PSELT = ((I_PSEL === 1'b1) && TRICKBOXSEL == 1'b1) ? 1'b1 :(
                (((I_PSEL === 1'b1) || (I_PSEL === 1'b0)) &&
                 TRICKBOXSEL == 1'b0) ? 1'b0 :(
                (I_PSEL === 1'bx) ? 1'bx :(
                PSELT)));   
 
  DATA_DRIVER  #(Tclkh, Tispdw, Tihpdw, Verbosity, 
                 HaltOnMismatch) U_PWDATA_DRIVER
    (.BCLK(BCLK),
     .DATA_SEL(PWDATA_SEL),
     .APB_PACKET_SEL(APB_PACKET_SEL),
     .APB_PACKET_WRITE(APB_PACKET_WRITE),
     .APB_PACKET_ADDR(APB_PACKET_ADDR),
     .APB_PACKET_DATA(APB_PACKET_DATA),
     .APB_PACKET_MASK(APB_PACKET_MASK),
     .APB_PACKET_EXP(APB_PACKET_EXP),
     .APB_PACKET_LIMIT(APB_PACKET_LIMIT),
     .APB_PACKET_NUM_CYC(APB_PACKET_NUM_CYC),
     .APB_PACKET_TAG(APB_PACKET_TAG),
     .POSTATI(POSTATI),
     .POSTATO(POSTATO),
     .PENABLE(PENABLE),
     .RDATA_BUS(PRDATA),
     .WDATA_BUS(PWDATA));
 
  ADDRCTL_DRIVER #(32, Tclkh, Tispaddr, Tihpaddr )  U_PADDR_DRIVER
    (.BNRES(BNRES),
     .ADDRCTL_SEL(PADDR_SEL),
     .IN_SIG(APB_PACKET_ADDR),
     .OUT_SIG(PADDR));
 
  ADDRCTL_DRIVER #(1, Tclkh, Tispw, Tihpw )  U_PWRITE_DRIVER
    (.BNRES(BNRES),
     .ADDRCTL_SEL(PWRITE_SEL),
     .IN_SIG(APB_PACKET_WRITE),
     .OUT_SIG(PWRITE));
 
  ADDRCTL_DRIVER #(1, Tclkh, Tispsel, Tihpsel )  U_PSEL_DRIVER
    (.BNRES(BNRES),
     .ADDRCTL_SEL(PSEL_SEL),
     .IN_SIG(INPSEL),
     .OUT_SIG(I_PSEL));
 
  PENABLE_DRIVER #( Tclkl, Tispen, Tihpen)  U_PENABLE_DRIVER
    (.PENABLE_SEL(PENABLE_SEL),
     .OUT_SIG(PENABLE));

endmodule

// --================================= End ===================================--
