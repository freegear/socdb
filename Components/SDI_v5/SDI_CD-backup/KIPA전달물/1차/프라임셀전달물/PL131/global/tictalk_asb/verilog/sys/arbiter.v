// --=================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2000 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// ---------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : arbiter.v.rca
// File Revision          : 1.1
//
// Release Information    : PrimeCell(TM)-GLOBAL-REL1v5
//
// ---------------------------------------------------------------------
// Purpose : Entity and architecture description for bus arbiter for
//           AMBA (rev D)
//           The arbiter processes requests for ownership of the ASB
//           and grants one ASB master according to the arbitration
//           scheme. The arbitration scheme of this implementation is
//           a simple priority encoded scheme where the highest
//           priority master requesting the ASB is granted. The
//           priority order is as follows:
//           1.) Async. Reset, TIC, Pause mode --> TIC granted
//           2.) ASB001
//           3.) ASB002
//           4.) ARM
//           5.) TIC (default bus master)
//
// --=================================================================--
 
`timescale 1ns/1ps

module arbiter (BCLK, BnRES, BWAIT, BLOK, AREQarm, AREQtic, AREQ001, 
                AREQ002, Pause, AGNTarm, AGNTtic, AGNT001, AGNT002);
 
  input  BCLK;
  input  BnRES;
  input  BWAIT;
  input  BLOK;
  input  AREQarm; // ARM request
  input  AREQtic; // Test Interface Controller request
  input  AREQ001; // ASB master 001 request
  input  AREQ002; // ASB master 002 request
  input  Pause;   // Pause mode entered
  output AGNTarm; // Grant ARM
  output AGNTtic; // Grant Test Interface Controller
  output AGNT001; // Grant ASB master 001
  output AGNT002; // Grant ASB master 002

// ---------------------------------------------------------------------
//  Signal declarations
// ---------------------------------------------------------------------
  wire iAGNTarm;     // Internal value of AGNT
  wire iAGNTtic;
  wire iAGNT001;
  wire iAGNT002;

  wire AGNTSelNext;  // AGNTSel register input
  wire AGNTChange;   // LOW when AGNTNew != AGNTPrev
  wire MaskBLOKNext; // MaskBLOK register input
 
  reg AGNTarmNew;    // New AGNT values based on AREQ inputs
  reg AGNTticNew;
  reg AGNT001New;
  reg AGNT002New;

  reg AGNTarmPrev;   // Previous AGNT values
  reg AGNTticPrev;
  reg AGNT001Prev;
  reg AGNT002Prev;

  reg AGNTSel;       // Select AGNTNew/AGNTPrev to drive output
  reg MaskBLOK;      // Set during handover cycle to ignore BLOK
 
// ---------------------------------------------------------------------
//  Beginning of main code
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
//  Arbitration Scheme
// ---------------------------------------------------------------------
//  TIC granted by default during reset and when no other AREQ inputs 
//  set TIC granted on pause
//  All others granted when AREQ set, in order of priority

  always @( negedge (BnRES) or negedge (BCLK) )
  begin
    if (!BnRES)
    begin
      AGNTarmNew <= 1'b0;
      AGNTticNew <= 1'b1;
      AGNT001New <= 1'b0;
      AGNT002New <= 1'b0;
    end
    else
      if (AREQtic)     // Test Interface Controller (highest priority)
      begin
        AGNTarmNew <= 1'b0;
        AGNTticNew <= 1'b1;
        AGNT001New <= 1'b0;
        AGNT002New <= 1'b0;
      end
      else if (Pause)       // Pause mode
      begin
        AGNTarmNew <= 1'b0;
        AGNTticNew <= 1'b1;
        AGNT001New <= 1'b0;
        AGNT002New <= 1'b0;
      end
      else if (AREQ001)     // Bus master #001
      begin
        AGNTarmNew <= 1'b0;
        AGNTticNew <= 1'b0;
        AGNT001New <= 1'b1;
        AGNT002New <= 1'b0;
      end
      else if (AREQ002)     // Bus master #002
      begin
        AGNTarmNew <= 1'b0;
        AGNTticNew <= 1'b0;
        AGNT001New <= 1'b0;
        AGNT002New <= 1'b1;
      end
      else if (AREQarm)     // ARM Core Wrapper (lowest priority)
      begin
        AGNTarmNew <= 1'b1;
        AGNTticNew <= 1'b0;
        AGNT001New <= 1'b0;
        AGNT002New <= 1'b0;
      end
      else                  // Default bus master
      begin
        AGNTarmNew <= 1'b0;
        AGNTticNew <= 1'b1;
        AGNT001New <= 1'b0;
        AGNT002New <= 1'b0;
      end
  end

// ---------------------------------------------------------------------
//  Stored Previous AGNT Outputs
// ---------------------------------------------------------------------
//  Registered version of AGNT outputs for comparison during bus master
//  handover

  always @( negedge (BnRES) or posedge (BCLK) )
  begin
    if (!BnRES)
    begin
      AGNTarmPrev <= 1'b0;
      AGNTticPrev <= 1'b1;
      AGNT001Prev <= 1'b0;
      AGNT002Prev <= 1'b0;
    end
    else
    begin
      AGNTarmPrev <= iAGNTarm;
      AGNTticPrev <= iAGNTtic;
      AGNT001Prev <= iAGNT001;
      AGNT002Prev <= iAGNT002;
    end
  end
 
// ---------------------------------------------------------------------
//  Previous / New AGNT Comparator
// ---------------------------------------------------------------------
//  Set HIGH when AGNTNew has changed due to change in BnRES/Pause/AREQ
//  inputs and handover about to occur - ie AGNTNew != AGNTPrev
//  Can be HIGH before handover when BLOK is set for current bus master

  assign AGNTChange = (((AGNTarmNew == AGNTarmPrev) &&
                        (AGNTticNew == AGNTticPrev) &&
                        (AGNT001New == AGNT001Prev) &&
                        (AGNT002New == AGNT002Prev)) ? 1'b0 : 1'b1);

// ---------------------------------------------------------------------
//  MaskBLOK generation and Register
// ---------------------------------------------------------------------
//  During handover the internal AGNT signals will have changed, and 
//  BWAIT and BLOK must be LOW (transfer is not waited or locked)

  assign MaskBLOKNext =
          ((AGNTChange == 1'b1 && BWAIT == 1'b0 && 
                                           BLOK == 1'b0) ? 1'b1 : 1'b0);

//  Masks out BLOK in AGNTSel generation during handover cycle so that 
//  AGNTNew will be driven onto the output even if BLOK goes HIGH

  always @( negedge (BnRES) or posedge (BCLK) )
  begin
    if (!BnRES)
      MaskBLOK <= 1'b0;
    else
      MaskBLOK <= MaskBLOKNext;
  end
 
// ---------------------------------------------------------------------
//  AGNT Output Selection Control
// ---------------------------------------------------------------------
//  When AGNTSel is set HIGH, the AGNT outputs change to their new 
//  values BLOK and BWAIT are set LOW during bus master handover, so 
//  BLOK should be ignored on the next cycle
//  MaskBLOK is used to mask out BLOK so that after the handover has 
//  started the current master can't set BLOK HIGH and stop the bus 
//  master change

  assign AGNTSelNext = (~ (BLOK & ~ (MaskBLOK))) | (~ BnRES);

//  This needs to be a latch due to BLOK changing after falling edge of
//  BCLK, and AGNT needing to be valid before the next rising edge of 
//  BCLK No reset needed as both AGNTNew and AGNTPrev are reset and 
//  this signal is used to select between them

  always @(BCLK or AGNTSelNext)
  begin
    if ((!BCLK))
      AGNTSel = AGNTSelNext;
  end
 
// ---------------------------------------------------------------------
//  AGNT Output Select
// ---------------------------------------------------------------------
//  Select AGNTNew or AGNTPrev (when BLOK high) to drive AGNT output

  assign iAGNTarm = ((AGNTSel == 1'b1) ? AGNTarmNew : AGNTarmPrev);
  assign iAGNTtic = ((AGNTSel == 1'b1) ? AGNTticNew : AGNTticPrev);
  assign iAGNT001 = ((AGNTSel == 1'b1) ? AGNT001New : AGNT001Prev);
  assign iAGNT002 = ((AGNTSel == 1'b1) ? AGNT002New : AGNT002Prev);

// ---------------------------------------------------------------------
//  AGNT Output Drivers
// ---------------------------------------------------------------------
//  Drive AGNT output ports with internal AGNTi signals
//  Internal signals used as output is fed back into system

  assign AGNTarm = iAGNTarm;
  assign AGNTtic = iAGNTtic;
  assign AGNT001 = iAGNT001;
  assign AGNT002 = iAGNT002;

endmodule

// --============================== End ==============================--
