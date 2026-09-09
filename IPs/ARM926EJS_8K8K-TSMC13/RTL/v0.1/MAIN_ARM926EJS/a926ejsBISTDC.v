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
// File Name           : a926ejsBISTDC.v,v
// File Revision       : 1.3
//
// Release Information : ARM926EJS_r0p5-00rel0
// -------------------------------------------------------------------------

// Performs 6N BIST operations on data cache Rams.
// The comparitors are placed in the BIST wrapper around the Ram.

`timescale 100 ns / 1 ns

module a926ejsBISTDC (/*AUTOARG*/
   // Outputs
   RunningDCData0, RunningDCData1, RunningDCData2, RunningDCData3, 
   RunningDCTag, RunningDCValid, RunningDCDirty, FailedDCData0, 
   FailedDCData1, FailedDCData2, FailedDCData3, FailedDCTag, 
   FailedDCValid, FailedDCDirty, DCBISTDATACS, DCBISTTAGCS, 
   DCBISTVALIDCS, DCBISTDIRTYCS, DCBISTA, DCBISTEN, DCBISTWE, 
   DCBISTWD, 
   // Inputs
   CLK, HRESETn, BISTStart, DCACHESIZE, EnableDCData0, EnableDCData1, 
   EnableDCData2, EnableDCData3, EnableDCTag, EnableDCValid, 
   EnableDCDirty, FailDCData0, FailDCData1, FailDCData2, FailDCData3, 
   FailDCTag, FailDCValid, FailDCDirty
   );

   input         CLK;
   input         HRESETn;
   input         BISTStart;
   input [ 3: 0] DCACHESIZE;

   // Enable inputs: indicate which Rams should be tested.
   input         EnableDCData0;
   input         EnableDCData1;
   input         EnableDCData2;
   input         EnableDCData3;
   input         EnableDCTag;
   input         EnableDCValid;
   input         EnableDCDirty;

   // Running outputs: indicate that the test is in progress.
   output        RunningDCData0;
   output        RunningDCData1;
   output        RunningDCData2;
   output        RunningDCData3;
   output        RunningDCTag;
   output        RunningDCValid;
   output        RunningDCDirty;

   // Failed outputs: indicates that the most recent test for that Ram failed.
   output        FailedDCData0;
   output        FailedDCData1;
   output        FailedDCData2;
   output        FailedDCData3;
   output        FailedDCTag;
   output        FailedDCValid;
   output        FailedDCDirty;

   // Fail inputs from the Ram BIST wrappers, indicates that a read error
   // occured.
   input         FailDCData0;
   input         FailDCData1;
   input         FailDCData2;
   input         FailDCData3;
   input         FailDCTag;
   input         FailDCValid;
   input         FailDCDirty;

   // Ram control signals:
   output [3:0]  DCBISTDATACS;
   output [3:0]  DCBISTTAGCS;
   output        DCBISTVALIDCS;
   output        DCBISTDIRTYCS;
   output [12:0] DCBISTA;
   output        DCBISTEN;
   output        DCBISTWE;
   output [31:0] DCBISTWD;

   // Used to generate DCBISTDATACS bus.
   wire          DCBISTDATACS0;
   wire          DCBISTDATACS1;
   wire          DCBISTDATACS2;
   wire          DCBISTDATACS3;

   reg           FailedDCData0;
   reg           FailedDCData1;
   reg           FailedDCData2;
   reg           FailedDCData3;
   reg           FailedDCTag;
   reg           FailedDCValid;
   reg           FailedDCDirty;

   reg           Running;
   wire          AddrEnd; // Indicates that the maximum wanted address has been
                        // reached, and that the test can move to the next pass.
   reg [12:0]    Addr;
   reg [12:0]    AddrMask; // Mask for the address to generate AddrEnd.
   reg [12:0]    TagAddrMask; // Mask for the tag Rams, used to deassert CS
                             // when the address is out of range.
   reg [12:0]    ValidAddrMask; // Mask for the Valid Ram.
   reg [12:0]    DirtyAddrMask; // Mask for the Dirty Ram.
   reg           CS; // Chip select.
   reg           Write; // Perform a Write rather than a read.
   reg [1:0]     Pattern; // The pattern to write or the pattern expected from
                         // the current read.
   // Registers to generate the Check signals. These indicate when the
   // Fail signals are valid.
   reg           PreChDCData0;
   reg           PreChDCData1;
   reg           PreChDCData2;
   reg           PreChDCData3;
   reg           PreChDCTag;
   reg           PreChDCValid;
   reg           PreChDCDirty;
   reg           CheckDCData0;
   reg           CheckDCData1;
   reg           CheckDCData2;
   reg           CheckDCData3;
   reg           CheckDCTag;
   reg           CheckDCValid;
   reg           CheckDCDirty;

   wire          IntStart; // Internal BIST start signal.
   reg           IncAddr; // Increment the address.

   wire          AnyEnable;
   
   // The state machine:
   reg [3:0]     State;
   reg [3:0]     NextState;

`define DCBIST_Idle   4'd0 // Doing nothing -- normal macrocell behaviour.
`define DCBIST_Start  4'd1 // Reset address pointer and failed flags
`define DCBIST_One    4'd2 // Pass 1, write pattern 1
`define DCBIST_Two    4'd3 // Pass 2, read pattern 1
`define DCBIST_Three  4'd4 // Pass 2, write pattern 2
`define DCBIST_Four   4'd5 // Pass 3, read pattern 2
`define DCBIST_Five   4'd6 // Pass 3, write pattern 1
`define DCBIST_Six    4'd7 // Pass 3, read pattern 1
`define DCBIST_End1   4'd8 // Wait for last pipelined read
`define DCBIST_End2   4'd9 // Last pipelined read avaliable now.

   assign #1 DCBISTDATACS = {DCBISTDATACS3, DCBISTDATACS2, DCBISTDATACS1,
                          DCBISTDATACS0};
   assign #1 DCBISTDATACS0 = EnableDCData0 & CS;
   assign #1 DCBISTDATACS1 = EnableDCData1 & CS;
   assign #1 DCBISTDATACS2 = EnableDCData2 & CS;
   assign #1 DCBISTDATACS3 = EnableDCData3 & CS;
   assign #1 DCBISTTAGCS   = {4{EnableDCTag   & CS & ~|(TagAddrMask & Addr)}};
   assign #1 DCBISTVALIDCS = EnableDCValid & CS & ~|(ValidAddrMask & Addr);
   assign #1 DCBISTDIRTYCS = EnableDCDirty & CS & ~|(DirtyAddrMask & Addr);
   assign #1 DCBISTWE = Write;
   assign #1 DCBISTA = ((State == `DCBIST_Four) |
                        (State == `DCBIST_Five) |
                        (State ==`DCBIST_Six)) ? ~Addr : Addr;
   assign AnyEnable = EnableDCData0 | EnableDCData1 | EnableDCData2 |
                      EnableDCData3 | EnableDCTag | EnableDCValid |
                      EnableDCDirty;
   // Switch the BIST Ram wrappers into BIST mode when any BIST is taking place.
   assign #1 DCBISTEN = Running;
   // We only use the bottom two bits of DCBISTWD:
   assign #1 DCBISTWD = {30'd0, Pattern};

   always @(/*AUTOSENSE*/AddrEnd or AnyEnable or BISTStart or State)
     begin
        case (State)
          `DCBIST_Idle:  NextState = (BISTStart & AnyEnable) ?
                                     `DCBIST_Start : `DCBIST_Idle;
          `DCBIST_Start: NextState = `DCBIST_One;
          `DCBIST_One:   NextState = AddrEnd ? `DCBIST_Two : `DCBIST_One;
          `DCBIST_Two:   NextState = `DCBIST_Three;
          `DCBIST_Three: NextState = AddrEnd ? `DCBIST_Four : `DCBIST_Two;
          `DCBIST_Four:  NextState = `DCBIST_Five;
          `DCBIST_Five:  NextState = `DCBIST_Six;
          `DCBIST_Six:   NextState = AddrEnd ? `DCBIST_End1 : `DCBIST_Four;
          `DCBIST_End1:  NextState = `DCBIST_End2;
          `DCBIST_End2:  NextState = `DCBIST_Idle;
          default : NextState = `DCBIST_Idle;
        endcase
     end

   always @(posedge CLK or negedge HRESETn)
     begin
        if (!HRESETn)
          State <= `DCBIST_Idle;
        else
          State <= NextState;
     end

   always @(/*AUTOSENSE*/State)
     begin
        case (State)
          `DCBIST_Start,
          `DCBIST_One,
          `DCBIST_Two,
          `DCBIST_Three,
          `DCBIST_Four,
          `DCBIST_Five,
          `DCBIST_Six,
          `DCBIST_End1,
          `DCBIST_End2: Running = 1'b1;
          default : Running = 1'b0;
        endcase
     end
   assign RunningDCData0 = Running & EnableDCData0;
   assign RunningDCData1 = Running & EnableDCData1;
   assign RunningDCData2 = Running & EnableDCData2;
   assign RunningDCData3 = Running & EnableDCData3;
   assign RunningDCTag   = Running & EnableDCTag;  
   assign RunningDCValid = Running & EnableDCValid;
   assign RunningDCDirty = Running & EnableDCDirty;

   always @(/*AUTOSENSE*/State)
     begin
        case (State)
          `DCBIST_One:
             begin CS = 1'b1; Write = 1'b1; Pattern = 2'b01; IncAddr = 1'b1; end
          `DCBIST_Two:
             begin CS = 1'b1; Write = 1'b0; Pattern = 2'b01; IncAddr = 1'b0; end
          `DCBIST_Three:
             begin CS = 1'b1; Write = 1'b1; Pattern = 2'b10; IncAddr = 1'b1; end
          `DCBIST_Four:
             begin CS = 1'b1; Write = 1'b0; Pattern = 2'b10; IncAddr = 1'b0; end
          `DCBIST_Five:
             begin CS = 1'b1; Write = 1'b1; Pattern = 2'b01; IncAddr = 1'b0; end
          `DCBIST_Six:
             begin CS = 1'b1; Write = 1'b0; Pattern = 2'b01; IncAddr = 1'b1; end
          default:
             begin CS = 1'b0; Write = 1'b0; Pattern = 2'b01; IncAddr = 1'b0; end
        endcase
     end

   // Registers to generate the Check signals. These indicate when the
   // Fail signals are valid.
   always @(posedge CLK or negedge HRESETn)
     begin
        if (!HRESETn)
          begin
             PreChDCData0 <= 1'b0;
             CheckDCData0 <= 1'b0;
             PreChDCData1 <= 1'b0;
             CheckDCData1 <= 1'b0;
             PreChDCData2 <= 1'b0;
             CheckDCData2 <= 1'b0;
             PreChDCData3 <= 1'b0;
             CheckDCData3 <= 1'b0;
             PreChDCTag   <= 1'b0;
             CheckDCTag   <= 1'b0;
             PreChDCValid <= 1'b0;
             CheckDCValid <= 1'b0;
             PreChDCDirty <= 1'b0;
             CheckDCDirty <= 1'b0;
          end
        else
          begin
             PreChDCData0 <= DCBISTDATACS0 & ~Write;
             CheckDCData0 <= PreChDCData0;
             PreChDCData1 <= DCBISTDATACS1 & ~Write;
             CheckDCData1 <= PreChDCData1;
             PreChDCData2 <= DCBISTDATACS2 & ~Write;
             CheckDCData2 <= PreChDCData2;
             PreChDCData3 <= DCBISTDATACS3 & ~Write;
             CheckDCData3 <= PreChDCData3;
             PreChDCTag   <= DCBISTTAGCS   & ~Write;
             CheckDCTag   <= PreChDCTag;
             PreChDCValid <= DCBISTVALIDCS & ~Write;
             CheckDCValid <= PreChDCValid;
             PreChDCDirty <= DCBISTDIRTYCS & ~Write;
             CheckDCDirty <= PreChDCDirty;
          end
     end

   assign IntStart = (State == `DCBIST_Start);

   always @(posedge CLK)
     begin
        if (IntStart | (AddrEnd & Running & IncAddr))
          Addr <= 13'd0;
        else if (Running & IncAddr)
          Addr <= Addr + 13'd01;
     end
   // The last address is when all the bits of Addr are one or are masked.
   assign AddrEnd = &(Addr | AddrMask);

   // AddrMask indicates what range of address we want to use. This depends
   // on the size of the cache and which cache Rams we want to test.
   always @(/*AUTOSENSE*/DCACHESIZE or DirtyAddrMask or EnableDCData0
            or EnableDCData1 or EnableDCData2 or EnableDCData3
            or EnableDCDirty or EnableDCTag or TagAddrMask
            or ValidAddrMask)
     begin
        if (EnableDCData0 | EnableDCData1 | EnableDCData2 | EnableDCData3)
          // This case statement is similar to the one in a926Cache.v.
          case (DCACHESIZE)
            4'b0000,
            4'b0001,
            4'b0010,
            4'b0011: AddrMask = 13'b1111100000000; //   4K
            4'b0100: AddrMask = 13'b1111000000000; //   8K
            4'b0101: AddrMask = 13'b1110000000000; //  16K
            4'b0110: AddrMask = 13'b1100000000000; //  32K
            4'b0111: AddrMask = 13'b1000000000000; //  64K
            default: AddrMask = 13'b0000000000000; // 128K
          endcase
        else if (EnableDCTag)
          AddrMask = TagAddrMask;
        else if (EnableDCDirty)
          AddrMask = DirtyAddrMask;
        else // if (EnableDCValid)
          AddrMask = ValidAddrMask;
     end
   // TagAddrMask indicates what address range we need to test the tag Ram.
   always @(/*AUTOSENSE*/DCACHESIZE)
     begin
        case (DCACHESIZE)
          4'b0000,
          4'b0001,
          4'b0010,
          4'b0011: TagAddrMask = 13'b1111111000000; //   4K
          4'b0100: TagAddrMask = 13'b1111110000000; //   8K
          4'b0101: TagAddrMask = 13'b1111100000000; //  16K
          4'b0110: TagAddrMask = 13'b1111000000000; //  32K
          4'b0111: TagAddrMask = 13'b1110000000000; //  64K
          default: TagAddrMask = 13'b1100000000000; // 128K
        endcase
     end
   // ValidAddrMask indicates what address range we need to test the valid
   // and dirty Rams.
   always @(/*AUTOSENSE*/DCACHESIZE)
     begin
        case (DCACHESIZE)
          4'b0000,
          4'b0001,
          4'b0010,
          4'b0011: ValidAddrMask = 13'b1111111111000; //   4K
          4'b0100: ValidAddrMask = 13'b1111111110000; //   8K
          4'b0101: ValidAddrMask = 13'b1111111100000; //  16K
          4'b0110: ValidAddrMask = 13'b1111111000000; //  32K
          4'b0111: ValidAddrMask = 13'b1111110000000; //  64K
          default: ValidAddrMask = 13'b1111100000000; // 128K
        endcase
     end
   // DirtyAddrMask indicates what address range we need to test the
   // dirty Ram.
   always @(/*AUTOSENSE*/DCACHESIZE)
     begin
        case (DCACHESIZE)
          4'b0000,
          4'b0001,
          4'b0010,
          4'b0011: DirtyAddrMask = 13'b1111111100000; //   4K
          4'b0100: DirtyAddrMask = 13'b1111111000000; //   8K
          4'b0101: DirtyAddrMask = 13'b1111110000000; //  16K
          4'b0110: DirtyAddrMask = 13'b1111100000000; //  32K
          4'b0111: DirtyAddrMask = 13'b1111000000000; //  64K
          default: DirtyAddrMask = 13'b1110000000000; // 128K
        endcase
     end

   // Reset each failed bit when BIST starts, set when a read error occurs.
   // The Check* signals indicate that the corresponding Fail* signal is
   // valid, ie a read was started two cycles ago.
   always @(posedge CLK or negedge HRESETn)
     begin
        if (!HRESETn)
          FailedDCData0 <= 1'b0;
        else if (IntStart)
          FailedDCData0 <= 1'b0;
        else if (CheckDCData0 & (FailDCData0 != 1'b0))
          FailedDCData0 <= 1'b1;
        //synopsys translate_off
        else if (CheckDCData0 & (FailDCData0 !== 1'b0))
          FailedDCData0 <= 1'b1;
        //synopsys translate_on
     end
   always @(posedge CLK or negedge HRESETn)
     begin
        if (!HRESETn)
          FailedDCData1 <= 1'b0;
        else if (IntStart)
          FailedDCData1 <= 1'b0;
        else if (CheckDCData1 & (FailDCData1 != 1'b0))
          FailedDCData1 <= 1'b1;
        //synopsys translate_off
        else if (CheckDCData1 & (FailDCData1 !== 1'b0))
          FailedDCData1 <= 1'b1;
        //synopsys translate_on
     end
   always @(posedge CLK or negedge HRESETn)
     begin
        if (!HRESETn)
          FailedDCData2 <= 1'b0;
        else if (IntStart)
          FailedDCData2 <= 1'b0;
        else if (CheckDCData2 & (FailDCData2 != 1'b0))
          FailedDCData2 <= 1'b1;
        //synopsys translate_off
        else if (CheckDCData2 & (FailDCData2 !== 1'b0))
          FailedDCData2 <= 1'b1;
        //synopsys translate_on
     end
   always @(posedge CLK or negedge HRESETn)
     begin
        if (!HRESETn)
          FailedDCData3 <= 1'b0;
        else if (IntStart)
          FailedDCData3 <= 1'b0;
        else if (CheckDCData3 & (FailDCData3 != 1'b0))
          FailedDCData3 <= 1'b1;
        //synopsys translate_off
        else if (CheckDCData3 & (FailDCData3 !== 1'b0))
          FailedDCData3 <= 1'b1;
        //synopsys translate_on
     end
   always @(posedge CLK or negedge HRESETn)
     begin
        if (!HRESETn)
          FailedDCTag <= 1'b0;
        else if (IntStart)
          FailedDCTag <= 1'b0;
        else if (CheckDCTag & (FailDCTag != 1'b0))
          FailedDCTag <= 1'b1;
        //synopsys translate_off
        else if (CheckDCTag & (FailDCTag !== 1'b0))
          FailedDCTag <= 1'b1;
        //synopsys translate_on
     end
   always @(posedge CLK or negedge HRESETn)
     begin
        if (!HRESETn)
          FailedDCValid <= 1'b0;
        else if (IntStart)
          FailedDCValid <= 1'b0;
        else if (CheckDCValid & (FailDCValid != 1'b0))
          FailedDCValid <= 1'b1;
        //synopsys translate_off
        else if (CheckDCValid & (FailDCValid !== 1'b0))
          FailedDCValid <= 1'b1;
        //synopsys translate_on
     end
   always @(posedge CLK or negedge HRESETn)
     begin
        if (!HRESETn)
          FailedDCDirty <= 1'b0;
        else if (IntStart)
          FailedDCDirty <= 1'b0;
        else if (CheckDCDirty & (FailDCDirty != 1'b0))
          FailedDCDirty <= 1'b1;
        //synopsys translate_off
        else if (CheckDCDirty & (FailDCDirty !== 1'b0))
          FailedDCDirty <= 1'b1;
        //synopsys translate_on
     end

endmodule
