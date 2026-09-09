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
//  File Name           : Timers.v,v
//  File Revision       : 1.17
//  
//  Release Information : ADK_REL1v1
//  
//  ----------------------------------------------------------------------------
//  Purpose             : Timers module containing two 32-bit downcounters. 
//                        Controls the generation of the timer read data.
//  --========================================================================--

`timescale 1ns/1ps

module Timers 
  (
   // Inputs
   PCLK, 
   PRESETn, 
   PENABLE, 
   PSEL, 
   PADDR, 
   PWRITE, 
   PWDATA,
   
   TIMCLK, 
   TIMCLKEN1, 
   TIMCLKEN2,
   
   SCANENABLE, 
   SCANINPCLK, 

   // Outputs
   PRDATA,
   
   TIMINT1, 
   TIMINT2, 
   TIMINTC,
   
   SCANOUTPCLK
);

`include "TimersPackage.v"

// -----------------------------------------------------------------------------
// Pin Declarations
// -----------------------------------------------------------------------------
  input             PCLK;
  input             PRESETn;
  input             PENABLE;
  input             PSEL;
  input [11:2]      PADDR;
  input             PWRITE;
  input [31:0]      PWDATA;
  input             TIMCLK;      //  Timer clock                
  input             TIMCLKEN1;   //  Timer clock enable 1       
  input             TIMCLKEN2;   //  Timer clock enable 2       

  // Scan test dummy signals, not connected until scan insertion 
  input             SCANENABLE;  // Scan Test Mode Enbl
  input             SCANINPCLK;  // Scan Chain Input
  
  output [31:0]     PRDATA;     
  output            TIMINT1;     //  Counter 1 interrupt       
  output            TIMINT2;     //  Counter 2 interrupt       
  output            TIMINTC;     //  Counter combined interrupt
  output            SCANOUTPCLK; // Scan Chain Output  

//------------------------------------------------------------------------------
// Signal declarations
//------------------------------------------------------------------------------

// Input/Output Signals
  wire              PCLK;
  wire              PRESETn;
  wire              PENABLE;
  wire              PSEL;
  wire [11:2]       PADDR;
  wire              PWRITE;
  wire [31:0]       PWDATA;
  wire              TIMCLK;
  wire              TIMCLKEN1;
  wire              TIMCLKEN2;
  wire              SCANENABLE;
  wire              SCANINPCLK;
  wire [31:0]       PRDATA;
  wire              TIMINT1;
  wire              TIMINT2;
  wire              TIMINTC;
  wire              SCANOUTPCLK;

// Internal Signals
  wire              FrcSel1;        //  Frc1 select (address decoding) 
  wire              FrcSel2;        //  Frc2 select (address decoding) 
  wire [31:0]       FRC1Data;       //  Frc1 data out 
  wire [31:0]       FRC2Data;       //  Frc2 data out 
  reg  [7:0]        TimerPData;     //  Peripheral/PrimeCell data out 
  reg  [31:0]       PrdataNext;     //  Internal PRDATA 
  reg  [31:0]       iPRDATA;        //  Regd PrdataNext 
  wire              PrdataNextEn;   //  PRDATAEn register input 
  wire              TimerITCRwrEn;  //  Write enable for Integration Test 
                                    //  Control Register
  reg               TimerITCR;      //  Integration Test Control Register 
  wire              TimerITOPwrEn;  //  Write enable for Integration Test 
                                    //  Output Set Register
  reg  [1:0]        TimerITOP;      //  Integration Test Output Set 
                                    //  Register
  wire [7:0]        TimerPeriphID0; //  Peripheral ID registers 
  wire [7:0]        TimerPeriphID1;
  wire [3:0]        TimerPeriphID2;
  wire [7:0]        TimerPeriphID3;
  wire [7:0]        TimerPCellID0;  //  PrimeCell ID registers 
  wire [7:0]        TimerPCellID1;
  wire [7:0]        TimerPCellID2;
  wire [7:0]        TimerPCellID3;
  wire              iTimInt1;       //  Counter 1 interrupt 
  wire              iTimIntMux1;    //  Counter 1 interrupt 
  wire              iTimInt2;       //  Counter 2 interrupt 
  wire              iTimIntMux2;    //  Counter 2 interrupt 
  wire [3:0]        TieOff1;        //  RevAnd input 1 
  wire [3:0]        TieOff2;        //  RevAnd input 2 
  wire [3:0]        Revision;       //  RevAnd output 

//------------------------------------------------------------------------------
// Beginning of main code
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Address Decoder For Frc1/2 Registers
//------------------------------------------------------------------------------

  // Generates select lines to the 2 free running counters.

  assign FrcSel1 = (PSEL & (PADDR [11:5] == `TIMER1A)) ? 1'b1 : 1'b0;

  assign FrcSel2 = (PSEL & (PADDR [11:5] == `TIMER2A)) ? 1'b1 : 1'b0;


//------------------------------------------------------------------------------
// Integration Test Registers
//------------------------------------------------------------------------------
  assign TimerITCRwrEn = (PADDR == {`TIMERIA,`TIMERTCRA}) ?
                          (PSEL & PWRITE & ~PENABLE) : 1'b0;

  assign TimerITOPwrEn = (PADDR == {`TIMERIA,`TIMERTOPA}) ?
                          (PSEL & PWRITE & ~PENABLE) : 1'b0;

  always @ (posedge PCLK or negedge PRESETn)
    begin : p_TcrSeq
      if (!PRESETn)
        TimerITCR <= 1'b0;
      else
        if (TimerITCRwrEn)
          TimerITCR <= PWDATA[0];
    end 

  always @ (posedge PCLK or negedge PRESETn)
    begin : p_TopSeq
      if (!PRESETn)
        TimerITOP <= 2'b00;
      else
        if (TimerITOPwrEn)
          TimerITOP <= PWDATA[1:0];
    end 

//------------------------------------------------------------------------------
// Output data generation
//------------------------------------------------------------------------------
// Address decoding for register reads.

  // Selects output data from address bus.
  assign PrdataNextEn = (PSEL & (~PWRITE) & (~PENABLE));

  always @ (FRC1Data or FRC2Data or PADDR or PrdataNextEn or TimerITCR or 
            TimerPData)
  begin : p_PrdataNextComb
    PrdataNext = {32{1'b0}};
    if (PrdataNextEn)
      case (PADDR[11:5])
        `TIMER1A : PrdataNext      = FRC1Data;
        `TIMER2A : PrdataNext      = FRC2Data;
        `TIMERIA : PrdataNext[0]   = TimerITCR;
        `TIMERPA : PrdataNext[7:0] = TimerPData;
        default  : PrdataNext      = {32{1'b0}};
      endcase
  end 

  // Selection of read data from Peripheral and PrimeCell ID
  //  registers is separated from the PrdataNext mux to reduce the
  //  depth of mux needed for Frc register data
  always @ (PADDR or PrdataNextEn or Revision or TimerPCellID0 or 
            TimerPCellID1 or TimerPCellID2 or TimerPCellID3 or TimerPeriphID0 or
            TimerPeriphID1 or TimerPeriphID2 or TimerPeriphID3)
  begin : p_TimerPDataComb
    TimerPData = {8{1'b0}};
    if (PrdataNextEn)
      case (PADDR[4:2])
        `TPERIPHID0A : TimerPData = TimerPeriphID0;
        `TPERIPHID1A : TimerPData = TimerPeriphID1;
        `TPERIPHID2A : TimerPData = {Revision,TimerPeriphID2 };
        `TPERIPHID3A : TimerPData = TimerPeriphID3;
        `TPCELLID0A  : TimerPData = TimerPCellID0;
        `TPCELLID1A  : TimerPData = TimerPCellID1;
        `TPCELLID2A  : TimerPData = TimerPCellID2;
        `TPCELLID3A  : TimerPData = TimerPCellID3;
        default      : TimerPData = {8{1'b0}};
      endcase
  end 

  // Register used to reduce output delay during reads.
  always @ (negedge PRESETn or posedge PCLK)
  begin : p_iPRDATASeq
    if (!PRESETn)
      iPRDATA <= {32{1'b0}};
    else
      iPRDATA <= PrdataNext;
  end 

  // Drive output with internal version.
  assign PRDATA = iPRDATA;

  // Drive Interrupt outputs
  // TIMINT1 and TIMINT2 can be forced directly from the Test Integration
  //  registers.
  assign iTimIntMux1 = ((TimerITCR == 1'b0) ? iTimInt1 : TimerITOP[0]);

  assign TIMINT1 = iTimIntMux1;

  assign iTimIntMux2 = ((TimerITCR == 1'b0) ? iTimInt2 : TimerITOP[1]);

  assign TIMINT2 = iTimIntMux2;

  // TIMINTC is the logical OR of the final interrupts from each individual 
  //  counter.
  assign TIMINTC = (iTimIntMux1 | iTimIntMux2);

//------------------------------------------------------------------------------
// Free running counter blocks
//------------------------------------------------------------------------------
  TimersFrc  uTimersFrc1 
    (.PCLK     (PCLK),
     .PRESETn  (PRESETn),
     .PENABLE  (PENABLE),
     .PADDR    (PADDR[4:2]),
     .PWRITE   (PWRITE),
     .PWDATA   (PWDATA),
     .FrcSel   (FrcSel1),
     .TIMCLK   (TIMCLK),
     .TIMCLKEN (TIMCLKEN1),
     .IntFrc   (iTimInt1),
     .DataOut  (FRC1Data)
    );

  TimersFrc  uTimersFrc2 
    (.PCLK     (PCLK),
     .PRESETn  (PRESETn),
     .PENABLE  (PENABLE),
     .PADDR    (PADDR[4:2]),
     .PWRITE   (PWRITE),
     .PWDATA   (PWDATA),
     .FrcSel   (FrcSel2),
     .TIMCLK   (TIMCLK),
     .TIMCLKEN (TIMCLKEN2),
     .IntFrc   (iTimInt2),
     .DataOut  (FRC2Data)
    );

//------------------------------------------------------------------------------
// Assign the Timer Peripheral ID
//
// The Timer Peripheral ID is a 32-bit value composed of the
// following 4 fields:
// Bits[11:0] -> Part Number used to identify the peripheral
//                For the Timer this is 0x804
// Bits[19:12] -> Designer ID (ARM)
//                ARM is designated 0x41
// Bits[23:20] -> Peripheral Revision Number
//                For the Timer this is 0x0
// Bits[31:24] -> Peripheral Configuration Options
//                For the Timer this is 0x00
//
// The 32-bits are readable via 4 separate address locations with
// each location returning 8 valid bits at positions[7:0]. The
// values returned by the 4 Peripheral ID registers are given below:
//
// TimerPeriphID0 = 0x04
// TimerPeriphID1 = 0x18
// TimerPeriphID2 = 0x04
// TimerPeriphID3 = 0x00
//------------------------------------------------------------------------------
  assign TimerPeriphID0 = 8'b00000100;
  assign TimerPeriphID1 = 8'b00011000;
  assign TimerPeriphID2 = 4'b0100;
  assign TimerPeriphID3 = 8'b00000000;

//------------------------------------------------------------------------------
// Assign the Timer PrimeCell ID
//
// TimerPCellID0 = 0x0D
// TimerPCellID1 = 0xF0
// TimerPCellID2 = 0x05
// TimerPCellID3 = 0xB1
// These PrimeCell ID values should not be changed.
//------------------------------------------------------------------------------
  assign TimerPCellID0 = 8'b00001101;
  assign TimerPCellID1 = 8'b11110000;
  assign TimerPCellID2 = 8'b00000101;
  assign TimerPCellID3 = 8'b10110001;

//------------------------------------------------------------------------------
// Assign values to inputs of RevAnd
//------------------------------------------------------------------------------
assign TieOff1 = 4'b0000;
assign TieOff2 = 4'b0000;

//------------------------------------------------------------------------------
// Instantiation of RevAnd for bit 0 of Revision
//------------------------------------------------------------------------------
  RevAnd  u0RevAnd 
    (.TieOff1  (TieOff1[0]),
     .TieOff2  (TieOff2[0]),
     .Revision (Revision[0])
    );

//------------------------------------------------------------------------------
// Instantiation of RevAnd for bit 1 of Revision
//------------------------------------------------------------------------------
  RevAnd  u1RevAnd 
    (.TieOff1  (TieOff1[1]),
     .TieOff2  (TieOff2[1]),
     .Revision (Revision[1])
    );

//------------------------------------------------------------------------------
// Instantiation of RevAnd for bit 2 of Revision
//------------------------------------------------------------------------------
  RevAnd  u2RevAnd 
    (.TieOff1  (TieOff1[2]),
     .TieOff2  (TieOff2[2]),
     .Revision (Revision[2])
    );

//------------------------------------------------------------------------------
// Instantiation of RevAnd for bit 3 of Revision
//------------------------------------------------------------------------------
  RevAnd  u3RevAnd 
    (.TieOff1  (TieOff1[3]),
     .TieOff2  (TieOff2[3]),
     .Revision (Revision[3])
    );


endmodule

// --============================ End ========================================--

