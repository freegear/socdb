// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2001-2002 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : EbiTrReqIndctr.v.rca
// File Revision          : 1.2
//
// Release Information    : PrimeCell(TM)-PL220-r0p0-00ltd0
//
// -----------------------------------------------------------------------------
// Purpose :
//           Gives details of the assertion of the signals EBIREQ1, EBIREQ2
//           and EBIREQ3
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module EbiTrReqIndctr (
// Inputs
                       EBICLK,
                       nPOR,
                       ClkFlag,
                       EventFlag,
                       EBIREQ1,
                       EBIREQ2,
                       EBIREQ3
                      );

// Inputs
input      EBICLK;    // Bus Clock
input      nPOR;      // Power on reset
input      ClkFlag;   // Clk by Clk status indicator
input      EventFlag; // Event status indicator
input      EBIREQ1;   // Ebi Request from Port1
input      EBIREQ2;   // Ebi Request from Port2
input      EBIREQ3;   // Ebi Request from Port3

// Inputs
wire     EBICLK;    // Bus Clock
wire     nPOR;      // Power on reset 
wire     ClkFlag;   // Clk by Clk status indicator
wire     EventFlag; // Event status indicator
wire     EBIREQ1;   // Ebi Request from Port1
wire     EBIREQ2;   // Ebi Request from Port2
wire     EBIREQ3;   // Ebi Request from Port3

// -----------------------------------------------------------------------------
//
//                               EbiTrReqIndctr
//                               ==============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
// This block gives details of the assertion of the signals EBIREQ1, EBIREQ2
// and EBIREQ3 with respect to EBICLK and Request event. It helps to identify 
// the required test condition hit or not
//
// -----------------------------------------------------------------------------

// ---------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// ---------------------------------------------------------------------
// Register declarations
// ---------------------------------------------------------------------
reg      EBIREQ1Q;
// Clocked EBIREQ1

reg      EBIREQ2Q;
// Clocked EBIREQ2

reg      EBIREQ3Q;
// Clocked EBIREQ3

// ---------------------------------------------------------------------
// Function declarations
// -----------------------------------------------------------------------------

// synopsys translate_off

// -----------------------------------------------------------------------------
// Type declarations
// -----------------------------------------------------------------------------

// synopsys translate_on

// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// This block gives details of the assertion of the signals EBIREQ1, EBIREQ2
// and EBIREQ3 with respect to EBICLK. It helps to identify the required test
// condition hit or not
// -----------------------------------------------------------------------------
always @(posedge EBICLK or ClkFlag)
begin : p_ClkStatus
  if (ClkFlag == 1'b1)
    begin
      if (EBICLK == 1'b1)
        begin
          if (EBIREQ1Q == EBIREQ1)
            $display("Notes : Time %t : ClkFlag : No change in the value of EBIREQ1 since last clock", $time);
          else if (EBIREQ1 == 1'b1 & EBIREQ1Q == 1'b0)
            $display("Notes : Time %t : ClkFlag : EBIREQ1 changed to high from low", $time);
          else if (EBIREQ1 == 1'b0 & EBIREQ1Q == 1'b1)
            $display("Notes : Time %t : ClkFlag : EBIREQ1 changed to low from high", $time);
          if (EBIREQ2Q == EBIREQ2)
            $display("Notes : Time %t : ClkFlag : No change in the value of EBIREQ2 since last clock", $time);
          else if (EBIREQ2 == 1'b1 & EBIREQ2Q == 1'b0)
            $display("Notes : Time %t : ClkFlag : EBIREQ2 changed to high from low", $time);
          else if (EBIREQ2 == 1'b0 & EBIREQ2Q == 1'b1)
            $display("Notes : Time %t : ClkFlag : EBIREQ2 changed to low from high", $time);
          if (EBIREQ3Q == EBIREQ3)
            $display("Notes : Time %t : ClkFlag : No change in the value of EBIREQ3 since last clock", $time);
          else if (EBIREQ3 == 1'b1 & EBIREQ3Q == 1'b0)
            $display("Notes : Time %t : ClkFlag : EBIREQ3 changed to high from low", $time);
          else if (EBIREQ3 == 1'b0 & EBIREQ3Q == 1'b1)
             $display("Notes : Time %t : ClkFlag : EBIREQ3 changed to low from high", $time);
        end
   end
end // p_ClkStatus

// -----------------------------------------------------------------------------
// This block gives details of the assertion of the signals EBIREQ1 with
// respect to request event. It helps to identify the required test condition
// hit or not
// -----------------------------------------------------------------------------
always @(EBIREQ1)
begin : p_Req1Event
  if (EventFlag == 1'b1)
    begin
      if (EBIREQ1 == 1'b1)
        $display("Notes : Time %t : EventFlag : EBIREQ1 changed to high from low", $time);
      else if (EBIREQ1 == 1'b0)
        $display("Notes : Time %t : EventFlag : EBIREQ1 changed to low from high", $time);
    end
end // p_Req1Event

// -----------------------------------------------------------------------------
// This block gives details of the assertion of the signals EBIREQ2 with
// respect to request event. It helps to identify the required test condition
// hit or not
// -----------------------------------------------------------------------------
always @(EBIREQ2)
begin : p_Req2Event
  if (EventFlag == 1'b1)
    begin
      if (EBIREQ2 == 1'b1)
        $display("Notes : Time %t : EventFlag : EBIREQ2 changed to high from low", $time);
      else if (EBIREQ2 == 1'b0)
        $display("Notes : Time %t : EventFlag : EBIREQ2 changed to low from high", $time);
    end
end // p_Req2Event

// -----------------------------------------------------------------------------
// This block gives details of the assertion of the signals EBIREQ3 with
// respect to request event. It helps to identify the required test condition
// hit or not
// -----------------------------------------------------------------------------
always @(EBIREQ3)
begin : p_Req3Event
  if (EventFlag == 1'b1)
    begin
      if (EBIREQ3 == 1'b1)
        $display("Notes : Time %t : EventFlag : EBIREQ3 changed to high from low", $time);
      else if (EBIREQ3 == 1'b0)
        $display("Notes : Time %t : EventFlag : EBIREQ3 changed to low from high", $time);
    end
end // p_Req3Event

// -----------------------------------------------------------------------------
// Sequential process for the EBIREQ1Q, EBIREQ2Q and EBIREQ3Q
// -----------------------------------------------------------------------------
always @(posedge EBICLK or negedge nPOR)
begin : p_EbiReqSeq
  if (nPOR == 1'b0)
    begin
      EBIREQ1Q         <= 1'b0;
      EBIREQ2Q         <= 1'b0;
      EBIREQ3Q         <= 1'b0;
    end
  else
    begin
      EBIREQ1Q         <= EBIREQ1;
      EBIREQ2Q         <= EBIREQ2;
      EBIREQ3Q         <= EBIREQ3;
    end
end // p_EbiReqSeq

// synopsys translate_off
// -----------------------------------------------------------------------------
// START OF PROTOCOL CHECKERS
// -----------------------------------------------------------------------------

// Protocol checkers can be used for debugging purposes.

// -----------------------------------------------------------------------------
// END OF PROTOCOL CHECKERS
// -----------------------------------------------------------------------------
// synopsys translate_on

endmodule
// --================================== End ==================================--
