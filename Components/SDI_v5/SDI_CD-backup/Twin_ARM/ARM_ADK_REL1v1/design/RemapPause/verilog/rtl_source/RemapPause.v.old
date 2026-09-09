//  --========================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 2001 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//  
//  ----------------------------------------------------------------------------
//  Version and Release Control Information:
//  
//  File Name          : RemapPause.v,v
//  File Revision      : 1.9
//  
//  Release Information : ADK_REL1v1
//  
//  ----------------------------------------------------------------------------
//  Purpose            : Remap and Pause controller module for APB.
//  --========================================================================--

`timescale 1ns/1ps

module RemapPause (PCLK, PRESETn, PENABLE, PSELRPC, PADDR, PWRITE, PWDATA, 
                 PRDATA, nFIQ, nIRQ, Pause, Remap, SCANENABLE, SCANINPCLK,
                 SCANOUTPCLK);
     input         PCLK;
     input         PRESETn;
     input         PENABLE;
     input         PSELRPC;
     input  [5:2]  PADDR;
     input         PWRITE;
     input  [7:0]  PWDATA;
     output [7:0]  PRDATA;
  
     input         nFIQ;      // FIQ interrupt input
     input         nIRQ;      // IRQ interrupt input
     output        Pause;     // Pause mode active
     output        Remap;     // Low when reset memory map in use

     // Scan test dummy signals; not connected until scan insertion
     input         SCANENABLE;
     input         SCANINPCLK;
     output        SCANOUTPCLK;

//----------------------------------------------------------------------
//
//                       Remap / Pause Controller
//                      ======================== 
//
//----------------------------------------------------------------------
//
// Overview
// ======== 
//
// The remap and pause controller provides control of the system boot 
// behaviour and low-power "wait for interrupt" mode.
//
// The module RevAnd is used as a place-holder cell to mark the
// Revision of the block. It contains a 2 input AND gate. The 2 input
// pins are tied-off at the top level of the hierarchy. These "TieOffs"
// can be identified during layout and re-wired to "VDD" or "VSS"
// if needed.
//----------------------------------------------------------------------
//                   RemapPause Register Map 
//----------------------------------------------------------------------
// Offset  Read (8bit)          Write (8bit)       Description
//----------------------------------------------------------------------
// 0x000   ----                 RPCPause           Pause control
// 0x004   RPCRemap             RPCRemapClr        Remap register (bit 0)
// 0x008   RPCResetStatus       RPCResetStatusSet  Reset status (set)
// 0x00C   ----                 RPCResetStatusClr  Reset status clear
// 0xFE0   RPCPeriphID0         ----               Peripheral ID 0
// 0xFE4   RPCPeriphID1         ----               Peripheral ID 1
// 0xFE8   RPCPeriphID2         ----               Peripheral ID 2
// 0xFEC   RPCPeriphID3         ----               Peripheral ID 3
// 0xFF0   RPCPCellID0(8-bit)   ----               PrimeCell ID 0
// 0xFF4   RPCPCellID1(8-bit)   ----               PrimeCell ID 1
// 0xFF8   RPCPCellID2(8-bit)   ----               PrimeCell ID 2
// 0xFFC   RPCPCellID3(8-bit)   ----               PrimeCell ID 3
//----------------------------------------------------------------------

//------------------------------------------------------------------------------
// Constant declarations
//------------------------------------------------------------------------------
// Register Addresses
// Note that to reduce address decode logic, the register map is aliased
//   throughout the RemapPause memory map.
  
`define RPCPAUSEA          4'b0000
`define RPCREMAPCLRA       4'b0001
`define RPCRESETSTATUSA    4'b0010
`define RPCRESETSTATUSCLRA 4'b0011
`define RPCPERIPHID0A      4'b1000
`define RPCPERIPHID1A      4'b1001
`define RPCPERIPHID2A      4'b1010
`define RPCPERIPHID3A      4'b1011
`define RPCPCELLID0        4'b1100
`define RPCPCELLID1        4'b1101
`define RPCPCELLID2        4'b1110
`define RPCPCELLID3        4'b1111

//------------------------------------------------------------------------
//-- Peripheral Identification registers' contents
//------------------------------------------------------------------------
//-- PartNumber    = 0x809 (full block ID is SP809)
//-- Designer      = 0x41 (ARM)
//-- Configuration = 0x00  
`define PARTNUMBER         12'h809
`define DESIGNERID         8'h41
`define CONFIG             8'h00
  
`define PCELLID            32'hB105F00D
// BIOS ID : 0xB105F00D = 1011 0001 0000 0101 1111 0000 0000 1101
  
//------------------------------------------------------------------------------
//-- Signal declarations
//------------------------------------------------------------------------------

// Input/Output Signals
  wire        PCLK;
  wire        PRESETn;
  wire        PENABLE;
  wire        PSELRPC;
  wire  [5:2] PADDR;
  wire        PWRITE;
  wire  [7:0] PWDATA;
  wire  [7:0] PRDATA;
  wire        nFIQ;     
  wire        nIRQ;     
  wire        Remap;    
  wire        SCANENABLE;
  wire        SCANINPCLK;
  wire        SCANOUTPCLK;

  reg         Pause;            //  Pause mode active 

// Internal Signals
  wire        ResetStatusEn;    //  Reset Status write enable 
  reg  [7:0]  NxtResetStatus;
  reg  [7:0]  ResetStatus;
  wire        PauseEn;          //  Pause write enable 
  wire        PauseRes;         //  Reset term for Pause register 
  wire        RemapEn;          //  Remap write enable 
  reg         iRemap;           //  internal version of Remap output 
  reg  [7:0]  NxtPrdata;
  wire        NxtPrdataEn;      //  valid RPC read 
  reg  [7:0]  iPRDATA;  
  wire [3:0]  TieOff1;          //  RevAnd input 1 
  wire [3:0]  TieOff2;          //  RevAnd input 2 
  wire [3:0]  Revision;         //  RevAnd output
  wire [31:0] PeripheralID;     //  full 32 bit block ID
  wire [31:0] PCellIdRP;
  
//------------------------------------------------------------------------------
// Beginning of main code
//------------------------------------------------------------------------------
  
//------------------------------------------------------------------------------
// ResetStatus register
//------------------------------------------------------------------------------
// Mux and registers are enabled when the set or clear addresses are written to.
  
  assign ResetStatusEn = (PSELRPC && PWRITE && !PENABLE &&
                          (PADDR == `RPCRESETSTATUSA ||
                           PADDR == `RPCRESETSTATUSCLRA)) ? 1'b1
                         : 1'b0;
  
// Bit zero of the ResetStatus register is set HIGH on reset, LOW when cleared.
//  It cannot be set HIGH by software.
// All other bits of the ResetStatus register may be set and cleared through the
//  two address locations.
  always @ (PADDR or PWDATA or ResetStatus or ResetStatusEn)
    begin : p_ResetStatusComb
      if (ResetStatusEn)
        case (PADDR)
          `RPCRESETSTATUSA : 
            begin
              NxtResetStatus[0] = ResetStatus[0];
              NxtResetStatus[7:1] = (PWDATA[7:1] | ResetStatus[7:1]);
            end
          `RPCRESETSTATUSCLRA : NxtResetStatus = (~PWDATA & ResetStatus);
          default             : NxtResetStatus = {8{1'b0}};  // illegal case
        endcase
      else
        NxtResetStatus = {8{1'b0}};
    end // block: p_ResetStatusComb
  
// On reset, bit 0 is set HIGH, indicating power on reset condition.
  always @ (negedge PRESETn or posedge PCLK)
    begin : p_ResetStatusSeq
      if (!PRESETn)
        ResetStatus <= 8'h01;
      else
        if (ResetStatusEn)
          ResetStatus <= NxtResetStatus;
    end // block: p_ResetStatusSeq
  
//------------------------------------------------------------------------------
// Pause output register
//------------------------------------------------------------------------------
// The Pause output causes the system to enter a "wait for interrupt" state.
// Set LOW on reset or interrupt, set HIGH on write.
  
// Asynchronous nIRQ and nFIQ inputs are needed so that system can function
//  asynchronously when in low power mode.
  assign PauseEn = (PSELRPC && PWRITE && !PENABLE &&
                    (PADDR == `RPCPAUSEA)) ? 1'b1
                   
                   : 1'b0;


  // Combined to give single reset term
  assign PauseRes = PRESETn & nIRQ & nFIQ;

  
  always @ (posedge PCLK or negedge PauseRes)
    begin : p_PauseSeq
      if (!PauseRes)
        Pause <= 1'b0;
      else
        if (PauseEn)
          Pause <= 1'b1;
    end // block: p_PauseSeq
 
//------------------------------------------------------------------------------
// Remap output register
//------------------------------------------------------------------------------
// The Remap output selects the memory map to be used by the system.
// Set LOW on reset (reset memory map), HIGH on write (normal memory map).
// Once set HIGH, can only be set LOW with reset.
  assign RemapEn = (PSELRPC && PWRITE && !PENABLE && 
                    (PADDR == `RPCREMAPCLRA)) ? 1'b1
                   
                   : 1'b0;
  
// Remap output register
  always @ (posedge PCLK or negedge PRESETn)
    begin : p_RemapSeq
      if (!PRESETn)
        iRemap <= 1'b0;
      else
        if (RemapEn)
          iRemap <= 1'b1;
    end // block: p_RemapSeq
 
// Drive output with internal version.
  assign Remap = iRemap;
  
//------------------------------------------------------------------------------
// Output data generation
//------------------------------------------------------------------------------
// Address decoding for register reads.
  assign NxtPrdataEn = (PSELRPC & ~PWRITE & ~PENABLE);
  
  always @ (PADDR or PeripheralID or NxtPrdataEn or ResetStatus or iPRDATA or 
            iRemap or PCellIdRP)
    begin : p_NxtPrdataComb
      if (NxtPrdataEn)
        case (PADDR)
          `RPCREMAPCLRA    : NxtPrdata = {iPRDATA[7:1], iRemap};
          `RPCRESETSTATUSA : NxtPrdata = ResetStatus;
          `RPCPERIPHID0A   : NxtPrdata = PeripheralID[7:0];
          `RPCPERIPHID1A   : NxtPrdata = PeripheralID[15:8];
          `RPCPERIPHID2A   : NxtPrdata = PeripheralID[23:16];
          `RPCPERIPHID3A   : NxtPrdata = PeripheralID[31:24];
          `RPCPCELLID0     : NxtPrdata = PCellIdRP[7:0];
          `RPCPCELLID1     : NxtPrdata = PCellIdRP[15:8];
          `RPCPCELLID2     : NxtPrdata = PCellIdRP[23:16];
          `RPCPCELLID3     : NxtPrdata = PCellIdRP[31:24];
           default         : NxtPrdata = iPRDATA;
        endcase
      else
        NxtPrdata = iPRDATA;
    end // block: p_NxtPrdataComb
  
// PRDATA output register
  always @ (posedge PCLK or negedge PRESETn)
    begin : p_iPRDATASeq
      if (!PRESETn)
        iPRDATA <= {8{1'b0}};
      else
        iPRDATA <= NxtPrdata;
    end // block: p_iPRDATASeq
  
// Drive output with internal version.
  assign PRDATA = iPRDATA;
  
//------------------------------------------------------------------------------
// Peripheral Identification
//------------------------------------------------------------------------------
  assign PeripheralID = {`CONFIG, Revision, `DESIGNERID, `PARTNUMBER};

  assign PCellIdRP = `PCELLID;
  
//------------------------------------------------------------------------------
// Assign values to inputs of RevAnd
//------------------------------------------------------------------------------
  assign TieOff1 = 4'b0000;
  assign TieOff2 = 4'b0000;
  
//------------------------------------------------------------------------------
// Instantiation of RevAnd for bit 0 of Revision
//------------------------------------------------------------------------------
   RevAnd  u0RevAnd 
   (
    .TieOff1  (TieOff1[0]),
    .TieOff2  (TieOff2[0]),
    .Revision (Revision[0])
	);
  
//------------------------------------------------------------------------------
// Instantiation of RevAnd for bit 1 of Revision
//------------------------------------------------------------------------------
   RevAnd  u1RevAnd 
   (
    .TieOff1  (TieOff1[1]),
    .TieOff2  (TieOff2[1]),
    .Revision (Revision[1])
	);
  
//------------------------------------------------------------------------------
// Instantiation of RevAnd for bit 2 of Revision
//------------------------------------------------------------------------------
   RevAnd  u2RevAnd 
	(
    .TieOff1  (TieOff1[2]),
    .TieOff2  (TieOff2[2]),
    .Revision (Revision[2])
  );
  
//------------------------------------------------------------------------------
// Instantiation of RevAnd for bit 3 of Revision
//------------------------------------------------------------------------------
   RevAnd  u3RevAnd 
   (
    .TieOff1  (TieOff1[3]),
    .TieOff2  (TieOff2[3]),
    .Revision (Revision[3])
  );
  
endmodule
