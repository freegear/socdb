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
// File Name           : a926ejsBIST.v,v
// File Revision       : 1.1
//
// Release Information : ARM926EJS_r0p5-00rel0
// -------------------------------------------------------------------------

module a926ejsBIST (/*AUTOARG*/
   // Outputs
   BISTStatus, DCBISTDATACS, DCBISTTAGCS, DCBISTVALIDCS, 
   DCBISTDIRTYCS, DCBISTA, DCBISTEN, DCBISTWE, DCBISTWD, 
   ICBISTDATACS, ICBISTTAGCS, ICBISTVALIDCS, ICBISTA, ICBISTEN, 
   ICBISTWE, ICBISTWD, MMUBISTCS, MMUBISTA, MMUBISTEN, MMUBISTWE, 
   MMUBISTWD, 
   // Inputs
   CLK, HRESETn, BISTEnable, BISTStart, DCACHESIZE, ICACHESIZE, 
   FailDCData0, FailDCData1, FailDCData2, FailDCData3, FailDCTag0, 
   FailDCTag1, FailDCTag2, FailDCTag3, FailDCValid, FailDCDirty, 
   FailICData0, FailICData1, FailICData2, FailICData3, FailICTag0, 
   FailICTag1, FailICTag2, FailICTag3, FailICValid, FailMMU
   );

   input         CLK;
   input         HRESETn;
   input [13:0]  BISTEnable;
   output [27:0] BISTStatus;
   input         BISTStart;

   // Cache size inputs
   input [ 3: 0] DCACHESIZE;
   input [ 3: 0] ICACHESIZE;

   // Failed signals. These are only valid two cycles after a read.
   input         FailDCData0;
   input         FailDCData1;
   input         FailDCData2;
   input         FailDCData3;
   input         FailDCTag0;
   input         FailDCTag1;
   input         FailDCTag2;
   input         FailDCTag3;
   input         FailDCValid;
   input         FailDCDirty;
   input         FailICData0;
   input         FailICData1;
   input         FailICData2;
   input         FailICData3;
   input         FailICTag0;
   input         FailICTag1;
   input         FailICTag2;
   input         FailICTag3;
   input         FailICValid;
   input         FailMMU;

   // BIST signals
   output [3:0]  DCBISTDATACS; // Via core.
   output [3:0]  DCBISTTAGCS;  // Via core.
   output        DCBISTVALIDCS; // Via core.
   output        DCBISTDIRTYCS; // Via core.
   output [12:0] DCBISTA; // Via core.
   output        DCBISTEN; // Enable.
   output        DCBISTWE; // Via BIST wrapper.
   output [31:0] DCBISTWD; // Via BIST wrapper.

   output [3:0]  ICBISTDATACS; // Via core.
   output [3:0]  ICBISTTAGCS;  // Via core.
   output        ICBISTVALIDCS; // Via core.
   output [12:0] ICBISTA; // Via core.
   output        ICBISTEN; // Enable.
   output        ICBISTWE; // Via BIST wrapper.
   output [31:0] ICBISTWD; // Via BIST wrapper.

   output        MMUBISTCS; // Via core.
   output [4:0]  MMUBISTA; // Via core.
   output        MMUBISTEN; // Enable.
   output        MMUBISTWE; // Via BIST wrapper.
   output [31:0] MMUBISTWD; // Via BIST wrapper.

   wire          FailDCTag;
   wire          FailICTag;
   
   // The MMU is controlled by the same BIST controller as the I Cache.
   assign MMUBISTA[4:0] = ICBISTA[4:0];
   assign MMUBISTEN = ICBISTEN;
   assign MMUBISTWE = ICBISTWE;
   assign MMUBISTWD = ICBISTWD;

   assign FailDCTag = FailDCTag0 | FailDCTag1 | FailDCTag2 | FailDCTag3;
   assign FailICTag = FailICTag0 | FailICTag1 | FailICTag2 | FailICTag3;
   
   // Order of bits in BISTEnable:
   // bit 0: DCache data bank 0
   //     1: DCache data bank 1
   //     2: DCache data bank 2
   //     3: DCache data bank 3
   //     4: DCache tag banks 0 to 3
   //     5: DCache valid
   //     6: DCache dirty
   //     7: ICache data bank 0
   //     8: ICache data bank 1
   //     9: ICache data bank 2
   //    10: ICache data bank 3
   //    11: ICache tag banks 0 to 3
   //    12: ICache valid
   //    13: MMU

   // The same order for BISTStatus but each Ram has two status bits:
   // bit 0: DCache data bank 0 BIST Running
   //     1: DCache data bank 0 BIST Failed
   //     2: DCache data bank 1 BIST Running
   //     3: DCache data bank 1 BIST Failed
   // ... etc upto ...
   //    26: MMU BIST Running
   //    27: MMU BIST Failed
   
   a926ejsBISTDC uBISTDCache (// Outputs
                   .RunningDCData0      (BISTStatus[0]),
                   .RunningDCData1      (BISTStatus[2]),
                   .RunningDCData2      (BISTStatus[4]),
                   .RunningDCData3      (BISTStatus[6]),
                   .RunningDCTag        (BISTStatus[8]),
                   .RunningDCValid      (BISTStatus[10]),
                   .RunningDCDirty      (BISTStatus[12]),
                   .FailedDCData0       (BISTStatus[1]),
                   .FailedDCData1       (BISTStatus[3]),
                   .FailedDCData2       (BISTStatus[5]),
                   .FailedDCData3       (BISTStatus[7]),
                   .FailedDCTag         (BISTStatus[9]),
                   .FailedDCValid       (BISTStatus[11]),
                   .FailedDCDirty       (BISTStatus[13]),
                   .DCBISTDATACS        (DCBISTDATACS[3:0]),
                   .DCBISTTAGCS         (DCBISTTAGCS),
                   .DCBISTVALIDCS       (DCBISTVALIDCS),
                   .DCBISTDIRTYCS       (DCBISTDIRTYCS),
                   .DCBISTA             (DCBISTA[12:0]),
                   .DCBISTEN            (DCBISTEN),
                   .DCBISTWE            (DCBISTWE),
                   .DCBISTWD            (DCBISTWD[31:0]),
                   // Inputs
                   .CLK                 (CLK),
                   .HRESETn             (HRESETn),
                   .BISTStart           (BISTStart),
                   .DCACHESIZE          (DCACHESIZE[3:0]),
                   .EnableDCData0       (BISTEnable[0]),
                   .EnableDCData1       (BISTEnable[1]),
                   .EnableDCData2       (BISTEnable[2]),
                   .EnableDCData3       (BISTEnable[3]),
                   .EnableDCTag         (BISTEnable[4]),
                   .EnableDCValid       (BISTEnable[5]),
                   .EnableDCDirty       (BISTEnable[6]),
                   .FailDCData0         (FailDCData0),
                   .FailDCData1         (FailDCData1),
                   .FailDCData2         (FailDCData2),
                   .FailDCData3         (FailDCData3),
                   .FailDCTag           (FailDCTag),
                   .FailDCValid         (FailDCValid),
                   .FailDCDirty         (FailDCDirty));

   a926ejsBISTIC uBISTICache (// Outputs
                 .RunningICData0        (BISTStatus[14]),
                 .RunningICData1        (BISTStatus[16]),
                 .RunningICData2        (BISTStatus[18]),
                 .RunningICData3        (BISTStatus[20]),
                 .RunningICTag          (BISTStatus[22]),
                 .RunningICValid        (BISTStatus[24]),
                 .RunningMMU            (BISTStatus[26]),
                 .FailedICData0         (BISTStatus[15]),
                 .FailedICData1         (BISTStatus[17]),
                 .FailedICData2         (BISTStatus[19]),
                 .FailedICData3         (BISTStatus[21]),
                 .FailedICTag           (BISTStatus[23]),
                 .FailedICValid         (BISTStatus[25]),
                 .FailedMMU             (BISTStatus[27]),
                 .ICBISTDATACS          (ICBISTDATACS[3:0]),
                 .ICBISTTAGCS           (ICBISTTAGCS),
                 .ICBISTVALIDCS         (ICBISTVALIDCS),
                 .MMUBISTCS             (MMUBISTCS),
                 .ICBISTA               (ICBISTA[12:0]),
                 .ICBISTEN              (ICBISTEN),
                 .ICBISTWE              (ICBISTWE),
                 .ICBISTWD              (ICBISTWD[31:0]),
                 // Inputs
                 .CLK                   (CLK),
                 .HRESETn               (HRESETn),
                 .BISTStart             (BISTStart),
                 .ICACHESIZE            (ICACHESIZE[3:0]),
                 .EnableICData0         (BISTEnable[7]),
                 .EnableICData1         (BISTEnable[8]),
                 .EnableICData2         (BISTEnable[9]),
                 .EnableICData3         (BISTEnable[10]),
                 .EnableICTag           (BISTEnable[11]),
                 .EnableICValid         (BISTEnable[12]),
                 .EnableMMU             (BISTEnable[13]),
                 .FailICData0           (FailICData0),
                 .FailICData1           (FailICData1),
                 .FailICData2           (FailICData2),
                 .FailICData3           (FailICData3),
                 .FailICTag             (FailICTag),
                 .FailICValid           (FailICValid),
                 .FailMMU               (FailMMU));

endmodule
