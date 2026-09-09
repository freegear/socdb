//  --========================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 1998-2001 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//  
//  ----------------------------------------------------------------------------
//  Version and Release Control Information:
//  
//  File Name          : SmiDBI.v,v
//  File Revision      : 1.3
//
//  Release Information : ADK_REL1v1
//
//  ----------------------------------------------------------------------------
//  Purpose            : External data bus multiplexer between Smi and TIC.
//  --========================================================================--

`timescale 1ns/1ps

module SmiDBI(
    nSMCDATAEN, TICREAD, SMCDATAOUT, HRDATATIC, nSMDATAEN, SMDATAOUT);
  
  input [3:0]   nSMCDATAEN;
  input         TICREAD;
  input [31:0]  SMCDATAOUT;
  input [31:0]  HRDATATIC;
  
  output [3:0]  nSMDATAEN;
  output [31:0] SMDATAOUT;


//------------------------------------------------------------------------------
// Signal declarations
//------------------------------------------------------------------------------
  
// Input/Output Signals
  wire [3:0]    nSMCDATAEN;
  wire          TICREAD;
  wire [31:0]   SMCDATAOUT;
  wire [31:0]   HRDATATIC;
  wire [3:0]    nSMDATAEN;
  wire [31:0]   SMDATAOUT;

//------------------------------------------------------------------------------
// Beginning of main code
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
// Data bus multiplexing
//------------------------------------------------------------------------------
// The data bus and data bus enable outputs are switched between the TIC and
//  SmiCore values according to the status of the TIC. When the TIC is granted
//  control of the AHB data bus, the TIC outputs are driven onto the external
//  bus, and the SmiCore outputs are used at all other times.
  assign nSMDATAEN = ((TICREAD) ? 4'b0000 : (nSMCDATAEN));
  
  assign SMDATAOUT = ((TICREAD) ? HRDATATIC : (SMCDATAOUT));
  
endmodule
