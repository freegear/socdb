// -------------------------------------------------------------------------
// This confidential and proprietary software may be used only as authorised
// by a licensing agreement from ARM Limited
//                (c) COPYRIGHT 2003 ARM Limited
//                ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised copies and
// copies may only be made to the extent permitted by a licensing agreement
// from ARM Limited.
// -------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name           : a926ejsBISTComp.v,v
// File Revision       : 1.1
//
// Release Information : ARM926EJS_r0p5-00rel0
// -------------------------------------------------------------------------

// Bist comparators:

module a926ejsBISTComp(/*AUTOARG*/
   // Outputs
   FailDCData0, FailDCData1, FailDCData2, FailDCData3, FailDCDirty, 
   FailDCTag0, FailDCTag1, FailDCTag2, FailDCTag3, FailDCValid, 
   FailICData0, FailICData1, FailICData2, FailICData3, FailICTag0, 
   FailICTag1, FailICTag2, FailICTag3, FailICValid, FailMMU, 
   // Inputs
   CLK, HRESETn, MMUxRD, ICDATARD0, ICDATARD1, ICDATARD2, ICDATARD3, 
   ICTAGRD0, ICTAGRD1, ICTAGRD2, ICTAGRD3, ICVALIDRD, DCDATARD0, 
   DCDATARD1, DCDATARD2, DCDATARD3, DCTAGRD0, DCTAGRD1, DCTAGRD2, 
   DCTAGRD3, DCVALIDRD, DCDIRTYRD, DCBISTWD, ICBISTWD, MMUBISTWD, 
   DCBISTEN, ICBISTEN, MMUBISTEN, ICNoRRgen, DCNoRRgen
   );

   input             CLK;
   input             HRESETn;
   output            FailDCData0;
   output            FailDCData1;
   output            FailDCData2;
   output            FailDCData3;
   output            FailDCDirty;
   output            FailDCTag0;
   output            FailDCTag1;
   output            FailDCTag2;
   output            FailDCTag3;
   output            FailDCValid;
   output            FailICData0;
   output            FailICData1;
   output            FailICData2;
   output            FailICData3;
   output            FailICTag0;
   output            FailICTag1;
   output            FailICTag2;
   output            FailICTag3;
   output            FailICValid;
   output            FailMMU;

   input [111:0]     MMUxRD;
   input [31:0]      ICDATARD0;    // read data bus from I$ data RAM
   input [31:0]      ICDATARD1;    //
   input [31:0]      ICDATARD2;    //
   input [31:0]      ICDATARD3;    //
   input [21:0]      ICTAGRD0;     // read data bus from I$ tag RAM
   input [21:0]      ICTAGRD1;     //
   input [21:0]      ICTAGRD2;     //
   input [21:0]      ICTAGRD3;     //
   input [23:0]      ICVALIDRD;    // read data bus from I$ valid RAM
   input [31:0]      DCDATARD0;    // D$ data RAM read data bus
   input [31:0]      DCDATARD1;    //
   input [31:0]      DCDATARD2;    //
   input [31:0]      DCDATARD3;    //
   input [21:0]      DCTAGRD0;     // D$ tag RAM read data bus
   input [21:0]      DCTAGRD1;     //
   input [21:0]      DCTAGRD2;     //
   input [21:0]      DCTAGRD3;     //
   input [23:0]      DCVALIDRD;    // D$ valid RAM read data bus
   input [7:0]       DCDIRTYRD;    // D$ dirty RAM read data bus

   input [31:0]      DCBISTWD; // Via BIST wrapper.
   input [31:0]      ICBISTWD; // Via BIST wrapper.
   input [31:0]      MMUBISTWD; // Via BIST wrapper.

   input             DCBISTEN;
   input             ICBISTEN;
   input             MMUBISTEN;

   input             ICNoRRgen;
   input             DCNoRRgen;

   reg               FailDCData0;
   reg               FailDCData1;
   reg               FailDCData2;
   reg               FailDCData3;
   reg               FailDCDirty;
   reg               FailDCTag0;
   reg               FailDCTag1;
   reg               FailDCTag2;
   reg               FailDCTag3;
   reg               FailDCValid;
   reg               FailICData0;
   reg               FailICData1;
   reg               FailICData2;
   reg               FailICData3;
   reg               FailICTag0;
   reg               FailICTag1;
   reg               FailICTag2;
   reg               FailICTag3;
   reg               FailICValid;
   reg               FailMMU;
   wire              CompDCData0;
   wire              CompDCData1;
   wire              CompDCData2;
   wire              CompDCData3;
   wire              CompDCDirty;
   wire              CompDCTag0;
   wire              CompDCTag1;
   wire              CompDCTag2;
   wire              CompDCTag3;
   wire              CompDCValid;
   wire              CompICData0;
   wire              CompICData1;
   wire              CompICData2;
   wire              CompICData3;
   wire              CompICTag0;
   wire              CompICTag1;
   wire              CompICTag2;
   wire              CompICTag3;
   wire              CompICValid;
   wire              CompMMU;
   reg [1:0]         DCBISTWDPipe;
   reg [1:0]         ICBISTWDPipe;
   reg [1:0]         MMUBISTWDPipe;

   // Comparators for DCache read data:
   assign CompDCData0 = ( {16{DCBISTWDPipe[1:0]}} != DCDATARD0 );
   assign CompDCData1 = ( {16{DCBISTWDPipe[1:0]}} != DCDATARD1 );
   assign CompDCData2 = ( {16{DCBISTWDPipe[1:0]}} != DCDATARD2 );
   assign CompDCData3 = ( {16{DCBISTWDPipe[1:0]}} != DCDATARD3 );
   assign CompDCTag0 = ( {11{DCBISTWDPipe[1:0]}} != DCTAGRD0 );
   assign CompDCTag1 = ( {11{DCBISTWDPipe[1:0]}} != DCTAGRD1 );
   assign CompDCTag2 = ( {11{DCBISTWDPipe[1:0]}} != DCTAGRD2 );
   assign CompDCTag3 = ( {11{DCBISTWDPipe[1:0]}} != DCTAGRD3 );
   assign CompDCValid = DCNoRRgen ? ({8{DCBISTWDPipe[1:0]}} != DCVALIDRD[15:0])
                                : ({12{DCBISTWDPipe[1:0]}} != DCVALIDRD[23:0]);
   assign CompDCDirty = ( {4{DCBISTWDPipe[1:0]}} != DCDIRTYRD );
   // Pipeline the Fail signal:
   always @(posedge CLK or negedge HRESETn)
     begin
        if (!HRESETn)
          begin
             FailDCData0 <= 1'b0;
             FailDCData1 <= 1'b0;
             FailDCData2 <= 1'b0;
             FailDCData3 <= 1'b0;
             FailDCTag0 <= 1'b0;
             FailDCTag1 <= 1'b0;
             FailDCTag2 <= 1'b0;
             FailDCTag3 <= 1'b0;
             FailDCValid <= 1'b0;
             FailDCDirty <= 1'b0;
          end
        else if (DCBISTEN)
          begin
             FailDCData0 <= CompDCData0;
             FailDCData1 <= CompDCData1;
             FailDCData2 <= CompDCData2;
             FailDCData3 <= CompDCData3;
             FailDCTag0 <= CompDCTag0;
             FailDCTag1 <= CompDCTag1;
             FailDCTag2 <= CompDCTag2;
             FailDCTag3 <= CompDCTag3;
             FailDCValid <= CompDCValid;
             FailDCDirty <= CompDCDirty;
          end
     end
   // Pipeline the data for comparison.
   always @(posedge CLK)
     begin
        if (DCBISTEN)
          DCBISTWDPipe[1:0] <= DCBISTWD[1:0];
     end

   // Comparators for ICache read data:
   assign CompICData0 = ( {16{ICBISTWDPipe[1:0]}} != ICDATARD0 );
   assign CompICData1 = ( {16{ICBISTWDPipe[1:0]}} != ICDATARD1 );
   assign CompICData2 = ( {16{ICBISTWDPipe[1:0]}} != ICDATARD2 );
   assign CompICData3 = ( {16{ICBISTWDPipe[1:0]}} != ICDATARD3 );
   assign CompICTag0 = ( {11{ICBISTWDPipe[1:0]}} != ICTAGRD0 );
   assign CompICTag1 = ( {11{ICBISTWDPipe[1:0]}} != ICTAGRD1 );
   assign CompICTag2 = ( {11{ICBISTWDPipe[1:0]}} != ICTAGRD2 );
   assign CompICTag3 = ( {11{ICBISTWDPipe[1:0]}} != ICTAGRD3 );
   assign CompICValid = ICNoRRgen ? ({8{ICBISTWDPipe[1:0]}} != ICVALIDRD[15:0])
                                : ({12{ICBISTWDPipe[1:0]}} != ICVALIDRD[23:0]);
   // Pipeline the Fail signal:
   always @(posedge CLK or negedge HRESETn)
     begin
        if (!HRESETn)
          begin
             FailICData0 <= 1'b0;
             FailICData1 <= 1'b0;
             FailICData2 <= 1'b0;
             FailICData3 <= 1'b0;
             FailICTag0 <= 1'b0;
             FailICTag1 <= 1'b0;
             FailICTag2 <= 1'b0;
             FailICTag3 <= 1'b0;
             FailICValid <= 1'b0;
          end
        else if (ICBISTEN)
          begin
             FailICData0 <= CompICData0;
             FailICData1 <= CompICData1;
             FailICData2 <= CompICData2;
             FailICData3 <= CompICData3;
             FailICTag0 <= CompICTag0;
             FailICTag1 <= CompICTag1;
             FailICTag2 <= CompICTag2;
             FailICTag3 <= CompICTag3;
             FailICValid <= CompICValid;
          end
     end
   // Pipeline the data for comparison.
   always @(posedge CLK)
     begin
        if (ICBISTEN)
          ICBISTWDPipe[1:0] <= ICBISTWD[1:0];
     end

   // Comparators for MMU read data:
   assign CompMMU = ( {56{MMUBISTWDPipe[1:0]}} != MMUxRD );
   // Pipeline the Fail signal:
   always @(posedge CLK or negedge HRESETn)
     begin
        if (!HRESETn)
          FailMMU <= 1'b0;
        else if (MMUBISTEN)
          FailMMU <= CompMMU;
     end
   // Pipeline the data for comparison.
   always @(posedge CLK)
     begin
        if (MMUBISTEN)
          MMUBISTWDPipe[1:0] <= MMUBISTWD[1:0];
     end

endmodule
