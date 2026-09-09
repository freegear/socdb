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
//  File Name           : Watchdog.v,v
//  File Revision       : 1.13
//  
//  Release Information : ADK_REL1v1
//  
//  ----------------------------------------------------------------------------
//  Purpose            : Watchdog module containing 32-bit downcounter.
//                        
//  --========================================================================--

`timescale 1ns/1ps

  module Watchdog
    (PCLK,
     PRESETn,
     PENABLE,
     PSEL,
     PADDR,
     PWRITE,
     PWDATA,
     PRDATA,
     WDOGCLK,      // Watchdog clock
     WDOGCLKEN,    // Watchdog clock enable 
     WDOGRESn,     // Watchdog clock reset  
     WDOGINT,      // Watchdog interrupt    
     WDOGRES,      // Watchdog timeout reset

     // Scan test dummy signals; not connected until scan insertion 
     SCANENABLE,   // Scan Test Mode Enbl
     SCANINPCLK,   // Scan Chain Input   
     SCANOUTPCLK); // Scan Chain Output  

`include "WdogPackage.v"

  input         PCLK;
  input         PRESETn;
  input         PENABLE;
  input         PSEL;
  input [11:2]  PADDR;
  input         PWRITE;
  input [31:0]  PWDATA;
  input         WDOGCLK;
  input         WDOGCLKEN;
  input         WDOGRESn;
  input         SCANENABLE;
  input         SCANINPCLK;
  output [31:0] PRDATA;
  output        WDOGINT;
  output        WDOGRES;
  output        SCANOUTPCLK;

  //----------------------------------------------------------------------------
  // Signal declarations
  //----------------------------------------------------------------------------

  // Input/Output Signals
  wire          PCLK;
  wire          PRESETn;
  wire          PENABLE;
  wire          PSEL;
  wire [11:2]   PADDR;
  wire          PWRITE;
  wire [31:0]   PWDATA;
  wire          WDOGCLK;
  wire          WDOGCLKEN;
  wire          WDOGRESn;
  wire [31:0]   PRDATA;
  wire          WDOGINT;
  wire          WDOGRES;
  wire          SCANOUTPCLK;
  
  // Internal Signals
  wire          FrcSel;        //  Frc select (address decoding) 
  wire [31:0]   FrcData;       //  Frc data out 
  reg [7:0]     WdogPData;     //  Peripheral/PrimeCell data out 
  reg [31:0]    PrdataNext;    //  Internal PRDATA 
  reg [31:0]    iPRDATA;       //  Regd PrdataNext 
  wire          PrdataNextEn;  //  PRDATAEn register input 
  wire          WdogITCRwrEn;  //  Write enable for Integration Test 
                               // Control Register
  reg           WdogITCR;      //  Integration Test Control Register 
  wire          WdogITOPwrEn;  //  Write enable for Integration Test 
                               // Output Set Register
  reg [1:0]     WdogITOP;      //  Integration Test Output Set 
                               // Register
  wire          WdogLockWrEn;  //  Watchdog lock register write enable 
  wire          WdogLockWrVal; //  Next Watchdog lock register value 
  reg           WdogLock;      //  Watchdog lock register 
  wire [7:0]    WdogPeriphID0; //  Peripheral ID registers 
  wire [7:0]    WdogPeriphID1;
  wire [3:0]    WdogPeriphID2;
  wire [7:0]    WdogPeriphID3;
  wire [7:0]    WdogPCellID0;  //  PrimeCell ID registers 
  wire [7:0]    WdogPCellID1;
  wire [7:0]    WdogPCellID2;
  wire [7:0]    WdogPCellID3;
  wire          iWdogInt;      //  Counter interrupt 
  wire          iWdogRes;      //  Counter reset 
  wire [3:0]    TieOff1;       //  RevAnd input 1 
  wire [3:0]    TieOff2;       //  RevAnd input 2 
  wire [3:0]    Revision;      //  RevAnd output 

  //----------------------------------------------------------------------------
  // Beginning of main code
  //----------------------------------------------------------------------------

  //----------------------------------------------------------------------------
  // Address Decoder for the Frc Register
  //----------------------------------------------------------------------------
  // Generates select line to the Watchdog free-running counter.

  assign FrcSel  = (PSEL & (PADDR [11:5] == `WDOG1A)) ? 1'b1 : 1'b0;


  //----------------------------------------------------------------------------
  // Watchdog Lock Register
  //----------------------------------------------------------------------------
  assign WdogLockWrEn = PADDR == {`WDOGLA,`WDOGLOCKA} ?
                        ((PSEL & PWRITE) & (~PENABLE)) : 1'b0;

  assign WdogLockWrVal =
  // 0x1ACCE551 - unlock
         PWDATA == 32'h1ACCE551 ? 1'b0 :
  // any other value - lock
         1'b1;

  always @ (posedge PCLK or negedge PRESETn)
    begin : p_LockSeq
      // process p_LockSeq
      if (PRESETn == 1'b0)
        // asynchronous reset (active low)
        WdogLock <= 1'b0;
      else
        // rising clock edge
        if (WdogLockWrEn)
          WdogLock <= WdogLockWrVal;
    end 

  //----------------------------------------------------------------------------
  // Integration Test Registers
  //----------------------------------------------------------------------------
  assign WdogITCRwrEn = PADDR == {`WDOGIA,`WDOGTCRA} ?
                        (PSEL & PWRITE & ~PENABLE & ~WdogLock) : 1'b0;
  
  assign WdogITOPwrEn = PADDR == {`WDOGIA,`WDOGTOPA} ?
                        (PSEL & PWRITE & ~PENABLE & ~WdogLock) : 1'b0;

  always @ (posedge PCLK or negedge PRESETn)
    begin : p_TcrSeq
      // process p_TcrSeq
      if (PRESETn == 1'b0)
        // asynchronous reset (active low)
        WdogITCR <= 1'b0;
      else
        // rising clock edge
        if (WdogITCRwrEn)
          WdogITCR <= PWDATA[0];
    end 

  always @ (posedge PCLK or negedge PRESETn)
    begin : p_TopSeq
      // process p_TopSeq
      if (PRESETn == 1'b0)
        // asynchronous reset (active low)
        WdogITOP <= 2'b00;
      else
        // rising clock edge
          if (WdogITOPwrEn)
            WdogITOP <= PWDATA[1:0];
    end 

  //----------------------------------------------------------------------------
  // Output data generation
  //----------------------------------------------------------------------------

  // Address decoding for register reads.
  assign PrdataNextEn = PSEL & ~PWRITE & ~PENABLE;

  // Selects output data from address bus.
  always @ (PrdataNextEn or PADDR or FrcData or WdogPData or WdogLock
            or WdogITCR)
    begin : p_PrdataNextComb
      
      PrdataNext = {32{1'b0}};
      
      if (PrdataNextEn)

          case (PADDR[11:5])
            `WDOG1A : 
              PrdataNext = FrcData;

            `WDOGLA : 
              PrdataNext[0] = WdogLock;

            `WDOGIA : 
              PrdataNext[0] = WdogITCR;

            `WDOGPA : 
              PrdataNext[7:0] = WdogPData;

            default: 
              PrdataNext = {32{1'b0}};

          endcase // case(PADDR[11:5])
      
    end 

  // Selection of read data from Peripheral and PrimeCell ID
  // registers is separated from the PrdataNext mux to reduce the
  // depth of mux needed for Frc register data
  always @ (PrdataNextEn or PADDR or WdogPeriphID0 or WdogPeriphID1 or
            WdogPeriphID2 or Revision or WdogPeriphID3 or WdogPCellID0
            or WdogPCellID1 or WdogPCellID2 or WdogPCellID3)
    begin : p_WdogPDataComb
      WdogPData = {8{1'b0}};
      if (PrdataNextEn)

        case (PADDR[4:2])
          `WPERIPHID0A :
            WdogPData = WdogPeriphID0;

          `WPERIPHID1A : 
            WdogPData = WdogPeriphID1;

          `WPERIPHID2A : 
            WdogPData = {Revision,WdogPeriphID2};

          `WPERIPHID3A : 
            WdogPData = WdogPeriphID3;

          `WPCELLID0A : 
            WdogPData = WdogPCellID0;

          `WPCELLID1A : 
            WdogPData = WdogPCellID1;

          `WPCELLID2A : 
            WdogPData = WdogPCellID2;

          `WPCELLID3A : 
            WdogPData = WdogPCellID3;

          default: 
            WdogPData = {8{1'b0}};

        endcase
    end // block: p_WdogPDataComb
  
  // Register used to reduce output delay during reads.
  always @ (negedge PRESETn or posedge PCLK)
    begin : p_iPRDATASeq
      if (PRESETn == 1'b0)
        iPRDATA <= {32{1'b0}};
      else
        iPRDATA <= PrdataNext;
    end 

  // Drive output with internal version.
  assign PRDATA = iPRDATA;

  //----------------------------------------------------------------------------
  // Free running counter block
  //----------------------------------------------------------------------------

  WdogFrc  uWdogFrc 
    (.PCLK      (PCLK),
     .PRESETn   (PRESETn),
     .PADDR     (PADDR[4:2]),
     .PWRITE    (PWRITE),
     .PWDATA    (PWDATA),
     .PENABLE   (PENABLE),
     .FrcSel    (FrcSel),
     .WdogLock  (WdogLock),
     .WDOGCLK   (WDOGCLK),
     .WDOGCLKEN (WDOGCLKEN),
     .WDOGRESn  (WDOGRESn),
     .WDOGINT   (iWdogInt),
     .WDOGRES   (iWdogRes),
     .FrcData   (FrcData)
    );
  // Drive interrupt and reset outputs
  assign WDOGINT = WdogITCR == 1'b0 ? iWdogInt : WdogITOP[1];
  assign WDOGRES = WdogITCR == 1'b0 ? iWdogRes : WdogITOP[0];

  //----------------------------------------------------------------------------
  // Assign the Watchdog Peripheral ID
  //
  // The Watchdog Peripheral ID is a 32-bit value composed of the
  // following 4 fields:
  // Bits[11:0] -> Part Number used to identify the peripheral
  //                For the Watchdog this is 0x805
  // Bits[19:12] -> Designer ID (ARM)
  //                ARM is designated 0x41
  // Bits[23:20] -> Peripheral Revision Number
  //                For the Watchdog this is 0x0 
  // Bits[31:24] -> Peripheral Configuration Options
  //                For the Watchdog this is 0x00
  //
  // The 32-bits are readable via 4 separate address locations with
  // each location returning 8 valid bits at positions[7:0]. The
  // values returned by the 4 Peripheral ID registers are given below:
  //
  // WdogPeriphID0 = 0x05
  // WdogPeriphID1 = 0x18
  // WdogPeriphID2 = 0x04
  // WdogPeriphID3 = 0x00
  //----------------------------------------------------------------------------

  assign WdogPeriphID0 = 8'b00000101;
  assign WdogPeriphID1 = 8'b00011000;
  assign WdogPeriphID2 = 4'b0100;
  assign WdogPeriphID3 = 8'b00000000;

  //----------------------------------------------------------------------------
  // Assign the Watchdog PrimeCell ID
  //
  // WdogPCellID0 = 0x0D
  // WdogPCellID1 = 0xF0
  // WdogPCellID2 = 0x05
  // WdogPCellID3 = 0xB1
  // These PrimeCell ID values should not be changed.
  //----------------------------------------------------------------------------
  assign  WdogPCellID0 = 8'b00001101;
  assign  WdogPCellID1 = 8'b11110000;
  assign  WdogPCellID2 = 8'b00000101;
  assign  WdogPCellID3 = 8'b10110001;

  //----------------------------------------------------------------------------
  // Assign values to inputs of RevAnd
  //----------------------------------------------------------------------------
  assign TieOff1 = 4'b0000;
  assign TieOff2 = 4'b0000;

  //----------------------------------------------------------------------------
  // Instantiation of RevAnd for bit 0 of Revision
  //----------------------------------------------------------------------------
  RevAnd  u0RevAnd 
    (.TieOff1(TieOff1[0]),
     .TieOff2(TieOff2[0]),
     .Revision(Revision[0])
    );

  //----------------------------------------------------------------------------
  // Instantiation of RevAnd for bit 1 of Revision
  //----------------------------------------------------------------------------
  RevAnd  u1RevAnd 
    (.TieOff1(TieOff1[1]),
     .TieOff2(TieOff2[1]),
     .Revision(Revision[1])
    );

  //----------------------------------------------------------------------------
  // Instantiation of RevAnd for bit 2 of Revision
  //----------------------------------------------------------------------------
  RevAnd  u2RevAnd 
    (.TieOff1(TieOff1[2]),
     .TieOff2(TieOff2[2]),
     .Revision(Revision[2])
    );

  //----------------------------------------------------------------------------
  // Instantiation of RevAnd for bit 3 of Revision
  //----------------------------------------------------------------------------
  RevAnd  u3RevAnd 
    (.TieOff1(TieOff1[3]),
     .TieOff2(TieOff2[3]),
     .Revision(Revision[3])
    );

endmodule
