// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2000-2001 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : DmacTrGntGen.v.rca
// File Revision          : 1.4
//
// Release Information    : PrimeCell(TM)-PL081-REL1v0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This block is responsible for generating HGRANT to AHB Master
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module DmacTrGntGen (
// Inputs
                     HCLK,
                     HRESETn,
                     HBUSREQDMAC,
                     HREADYINM,
                     HBURSTM,
                     GrantCount,
// Outputs
                     HGRANTDMACM
                     );

// Inputs
input         HCLK;        // AHB clock
input         HRESETn;     // AHB reset
input         HBUSREQDMAC; // Bus request signal from AHB
input         HREADYINM;   // Transfer done response on AHB
input   [2:0] HBURSTM;     // Burst length on AHB
input  [31:0] GrantCount;  // Burst length on AHB

// Outputs
output        HGRANTDMACM; // AHB bus grant for master




// Inputs
  wire        HCLK;        // AHB clock
  wire        HRESETn;     // AHB reset
  wire        HBUSREQDMAC; // Bus request signal from AHB
  wire        HREADYINM;   // Transfer done response on AHB
  wire  [2:0] HBURSTM;     // Burst length on AHB
  wire [31:0] GrantCount;  // Burst length on AHB

// Outputs
  wire        HGRANTDMACM; // AHB bus grant for master

// -----------------------------------------------------------------------------
//
//                              DmacTrGntGen
//                              ============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//   This block is responsible for driving out HGRANT for Master module.
//   The different Schemes used to generate the Grants are
//   a) Default Granted method.
//   b) Toggle method.
//   c) Request based method without count dependent.
//   d) Request based method with count dependent.
//   e) Break in the Middle of burst for fixed number of clock.
//   f) Break in the middle of the burst for 1HCLK
//
// -----------------------------------------------------------------------------


// ---------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// ---------------------------------------------------------------------
wire       ToggleMode;
// This mode is used to toggle the Grant as programmed in GrantCount reg

wire       DefGranted;
// In this mode the Grant is always high

wire       ReqBased;
// In this mode the Grant is given after sampling the request

wire       ReqBasedDel;
// In this mode the Grant is given after sampling the request and count is 0

wire       BreakMid;
// In this mode the Grant is deasserted at the middle of the Burst

wire       OneClkBreak;
// In this mode the Grant is deasserted for 1HCLK in the middle of burst

wire       iHGRANTDMACM;
// Internal version of HGRANTDMACM

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg  [2:0] ToggleST;
// States for toggle mode

reg  [2:0] NextToggleST;
// D-Input of ToggleST

reg  [3:0] OnCountValue;
// Counter for counting number of Clocks HGRANT should be asserted

reg  [3:0] NextOnCount;
// D-Input of OnCountValue

reg  [3:0] OffCountValue;
// Counter for counting number of Clocks HGRANT should be de-asserted

reg  [3:0] NextOffCount;
// D-Input of OffCountValue

reg  [1:0] Count4;
// Burst4 Counter

reg  [1:0] NextCount4;
// D-Input of Count4

reg  [2:0] Count8;
// Burst4 Counter

reg  [2:0] NextCount8;
// D-Input of Count8

reg  [3:0] Count16;
// Burst16 Counter

reg  [3:0] NextCount16;
// D-Input of Count16

reg  [1:0] ReqCount;
// Counter to indicate as to how many clocks the HGRANT should be low

reg  [1:0] NextReqCount;
// D-Input of ReqCount

reg        HgrantReg;
// Clocked HGRANT

reg        NextHgrantReg;
// D-Input of HgrantReg

reg        HgrantTog;
// Toggle HGRANT

reg        RemGrant;
// Indication to deassert the grant

reg        GrantAfterXClk;
// Clocked HGRANT when the grant has to be set after X Clocks

reg        NextGrantXClk;
// D-Input of GrantAfterXClk

reg  [3:0] Count16Down;
// Burst16 Down Counter

reg  [3:0] NextCount16Down;
// D-Input of Count16Down

// -----------------------------------------------------------------------------
// Package insertion
// -----------------------------------------------------------------------------
`include "DmacTrParams.v"

// -----------------------------------------------------------------------------
// Function declarations
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------


assign ToggleMode       = GrantCount[4];
assign DefGranted       = GrantCount[5];
assign ReqBased         = GrantCount[6];
assign BreakMid         = GrantCount[7];
assign OneClkBreak      = GrantCount[8];
assign ReqBasedDel      = GrantCount[11];

// -----------------------------------------------------------------------------
// This process is responsible for generating the grant for Toggle mode
// Here the grant remains set till the Count value goes to 0. This is coded as
// a small SM where the GRANT_ON and GRANT_OFF state controls the toggling of
// grant.
// -----------------------------------------------------------------------------
always @(ToggleST or OnCountValue or OffCountValue or GrantCount)
begin : p_CountComb
  NextToggleST     = ToggleST;
  NextOnCount      = OnCountValue;
  NextOffCount     = OffCountValue;
  case (ToggleST)
    `GRANT_IDLE :
      if (GrantCount[3:0] != 4'b0000)
        begin
          NextToggleST     = `GRANT_ON;
          NextOnCount      = GrantCount[3:0];
        end

    `GRANT_ON :
      begin
        NextOnCount      = OnCountValue - 4'b0001;
        if (OnCountValue == 4'b0001)
          begin
            if (GrantCount[3:0] != 4'b0000)
              begin
                NextToggleST     = `GRANT_OFF;
                NextOffCount     = GrantCount[3:0];
              end
            else
              begin
                NextToggleST     = `GRANT_IDLE;
                NextOffCount     = ('d0);
                NextOnCount      = ('d0);
              end
          end
      end

    `GRANT_OFF :
      begin
        NextOffCount     = OffCountValue - 4'b0001;
        if (OffCountValue == 4'b0001)
          begin
            if (GrantCount[3:0] != 4'b0000)
              begin
                NextToggleST     = `GRANT_ON;
                NextOnCount      = GrantCount[3:0];
              end
            else
              begin
                NextToggleST     = `GRANT_IDLE;
                NextOffCount     = ('d0);
                NextOnCount      = ('d0);
              end
          end
      end

    default :
      begin
        NextToggleST     = ToggleST;
        NextOnCount      = OnCountValue;
        NextOffCount     = OffCountValue;
      end
  endcase
end // p_CountComb

// -----------------------------------------------------------------------------
// This process gives an indication as to from where the Grant has to be
// removed(which is from the middle of burst) till the count value programmed.
// But for OneClkBreak the Grant is removed for only one clock in the middle of
// the burst.
// -----------------------------------------------------------------------------
always @(Count4 or Count8 or Count16 or ReqCount or HBURSTM or HREADYINM or
         iHGRANTDMACM or BreakMid or OneClkBreak or GrantCount)
begin : p_BurstMidComb
  NextCount4       = Count4;
  NextCount8       = Count8;
  NextCount16      = Count16;
  NextReqCount     = ReqCount;
  case (HBURSTM)
    `INCR4 :
      begin
        if ((HREADYINM == 1'b1) && (iHGRANTDMACM == 1'b1))
          begin
            if (Count4 == 2'b00)
              NextReqCount     = GrantCount[10:9];
            NextCount4       = Count4 + 2'b01;
            if ((Count4 == 2'b01) && (BreakMid == 1'b1) && (ReqCount != 2'b00))
              RemGrant         = 1'b1;
            else if ((Count4 == 2'b01) && (OneClkBreak == 1'b1))
              RemGrant         = 1'b1;
          end
        else if (HREADYINM == 1'b1)
          begin
            NextReqCount     = ReqCount - 2'b01;
            if ((Count4 == 2'b01) && (BreakMid == 1'b1) && (ReqCount == 2'b00))
              RemGrant         = 1'b0;
            else if ((Count4 == 2'b01) && (OneClkBreak == 1'b1))
              RemGrant         = 1'b0;
          end
      end

    `INCR8 :
      begin
        if ((HREADYINM == 1'b1) && (iHGRANTDMACM == 1'b1))
          begin
            if (Count8 == 3'b000)
              NextReqCount     = GrantCount[10:9];
            NextCount8       = Count8 + 3'b001;
            if ((Count8 == 3'b011) && (BreakMid == 1'b1) && (ReqCount != 2'b00))
              RemGrant         = 1'b1;
            else if ((Count8 == 3'b011) && (OneClkBreak == 1'b1))
              RemGrant         = 1'b1;
          end
        else if (HREADYINM == 1'b1)
          begin
            NextReqCount     = ReqCount - 2'b01;
            if ((Count8 == 3'b011) && (BreakMid == 1'b1) && (ReqCount == 2'b00))
              RemGrant         = 1'b0;
            else if ((Count8 == 3'b011) && (OneClkBreak == 1'b1))
              RemGrant         = 1'b0;
          end
      end

    `INCR16 :
      begin
        if ((HREADYINM == 1'b1) && (iHGRANTDMACM == 1'b1))
          begin
            if (Count16 == 4'b0000)
              NextReqCount     = GrantCount[10:9];
            NextCount16      = Count16 + 4'b0001;
            if ((Count16 == 4'b0111) && (BreakMid == 1'b1) &&
                (ReqCount != 2'b00))
              RemGrant         = 1'b1;
            else if ((Count16 == 4'b0111) && (OneClkBreak == 1'b1))
              RemGrant         = 1'b1;
          end
        else if (HREADYINM == 1'b1)
          begin
            NextReqCount     = ReqCount - 2'b01;
            if ((Count16 == 4'b0111) && (BreakMid == 1'b1) &&
                (ReqCount == 2'b00))
              RemGrant         = 1'b0;
            else if ((Count16 == 4'b0111) && (OneClkBreak == 1'b1))
              RemGrant         = 1'b0;
          end
      end

    default :
      begin
        NextCount4       = Count4;
        NextCount8       = Count8;
        NextCount16      = Count16;
        NextReqCount     = ReqCount;
        RemGrant         = 1'b0;
      end
  endcase
end // p_BurstMidComb

// -----------------------------------------------------------------------------
// HGRANT generation block. Here except for Toggle mode HGRANT is clocked out.
// -----------------------------------------------------------------------------
always @(ToggleMode or ToggleST or DefGranted or ReqBased or HBUSREQDMAC or
         BreakMid or RemGrant or OneClkBreak or HgrantReg or Count16Down or
         GrantAfterXClk or ReqBasedDel or GrantCount)
begin : p_GrantComb
  NextHgrantReg    = HgrantReg;
  NextCount16Down  = Count16Down;
  NextGrantXClk    = GrantAfterXClk;
  if (ToggleMode == 1'b1)
    begin
      if (ToggleST == `GRANT_ON)
        HgrantTog        = 1'b1;
      else if (ToggleST == `GRANT_OFF)
        HgrantTog        = 1'b0;
      else
        HgrantTog        = 1'b0;
    end
  else if (DefGranted == 1'b1)
    NextHgrantReg    = 1'b1;
  else if (ReqBased == 1'b1)
    begin
      if (HBUSREQDMAC == 1'b1)
        begin
          NextHgrantReg    = 1'b1;
          if (BreakMid == 1'b1)
            begin
              if (RemGrant == 1'b1)
                NextHgrantReg    = 1'b0;
              else
                NextHgrantReg    = 1'b1;
            end
          else if (OneClkBreak == 1'b1)
            begin
              if (RemGrant == 1'b1)
                NextHgrantReg    = 1'b0;
              else
                NextHgrantReg    = 1'b1;
            end
        end
      else
        NextHgrantReg    = 1'b0;
    end
  else if (ReqBasedDel == 1'b1)
    begin
      if ((Count16Down == 4'b0000) && (GrantAfterXClk == 1'b0))
        NextCount16Down  = GrantCount[3:0];
      else if (GrantAfterXClk == 1'b0)
        NextCount16Down  = Count16Down - 4'b0001;
      else
        NextCount16Down  = ('d0);
  
      if (HBUSREQDMAC == 1'b1)
        begin
          if ((Count16Down == 4'b0000) && (GrantAfterXClk == 1'b0))
            NextGrantXClk    = 1'b1;
        end
      else
        NextGrantXClk    = 1'b0;
    end
end // p_GrantComb

assign iHGRANTDMACM     = (ToggleMode == 1'b1) ? HgrantTog :
                           (((DefGranted == 1'b1) || (ReqBased == 1'b1)) ?
                           HgrantReg : ((ReqBasedDel == 1'b1) ?
                           GrantAfterXClk    : 1'b1));

assign HGRANTDMACM      = iHGRANTDMACM;
// -----------------------------------------------------------------------------
// Registering all the next state signals
// -----------------------------------------------------------------------------
always @(negedge HRESETn or posedge HCLK)
begin : p_GrantSeq
  if (HRESETn == 1'b0)
    begin
      ToggleST         <= `GRANT_IDLE;
      OnCountValue     <= ('d0);
      OffCountValue    <= ('d0);
      Count4           <= ('d0);
      Count8           <= ('d0);
      Count16          <= ('d0);
      ReqCount         <= ('d0);
      HgrantReg        <= 1'b0;
      GrantAfterXClk   <= 1'b0;
      Count16Down      <= ('d0);
    end
  else
    begin
      ToggleST         <= NextToggleST;
      OnCountValue     <= NextOnCount;
      OffCountValue    <= NextOffCount;
      Count4           <= NextCount4;
      Count8           <= NextCount8;
      Count16          <= NextCount16;
      ReqCount         <= NextReqCount;
      HgrantReg        <= NextHgrantReg;
      GrantAfterXClk   <= NextGrantXClk;
      Count16Down      <= NextCount16Down;
    end
end // p_GrantSeq

endmodule
// --================================== End ==================================--
