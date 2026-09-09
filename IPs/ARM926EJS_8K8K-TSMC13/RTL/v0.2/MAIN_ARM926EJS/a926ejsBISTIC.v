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
// File Name           : a926ejsBISTIC.v,v
// File Revision       : 1.5
//
// Release Information : ARM926EJS_r0p5-00rel0
// -------------------------------------------------------------------------

// Performs 6N BIST operations on data cache Rams.
// The comparitors are placed in the BIST wrapper around the Ram.

`timescale 100 ns / 1 ns

module a926ejsBISTIC (/*AUTOARG*/
   // Outputs
   RunningICData0, RunningICData1, RunningICData2, RunningICData3, 
   RunningICTag, RunningICValid, RunningMMU, FailedICData0, 
   FailedICData1, FailedICData2, FailedICData3, FailedICTag, 
   FailedICValid, FailedMMU, ICBISTDATACS, ICBISTTAGCS, 
   ICBISTVALIDCS, MMUBISTCS, ICBISTA, ICBISTEN, ICBISTWE, ICBISTWD, 
   // Inputs
   CLK, HRESETn, BISTStart, ICACHESIZE, EnableICData0, EnableICData1, 
   EnableICData2, EnableICData3, EnableICTag, EnableICValid, 
   EnableMMU, FailICData0, FailICData1, FailICData2, FailICData3, 
   FailICTag, FailICValid, FailMMU
   );

   input         CLK;
   input         HRESETn;
   input         BISTStart;
   input [ 3: 0] ICACHESIZE;

   // Enable inputs: indicate which Rams should be tested.
   input         EnableICData0;
   input         EnableICData1;
   input         EnableICData2;
   input         EnableICData3;
   input         EnableICTag;
   input         EnableICValid;
   input         EnableMMU;

   // Running outputs: indicate that the test is in progress.
   output        RunningICData0;
   output        RunningICData1;
   output        RunningICData2;
   output        RunningICData3;
   output        RunningICTag;
   output        RunningICValid;
   output        RunningMMU;

   // Failed outputs: indicates that the most recent test for that Ram failed.
   output        FailedICData0;
   output        FailedICData1;
   output        FailedICData2;
   output        FailedICData3;
   output        FailedICTag;
   output        FailedICValid;
   output        FailedMMU;

   // Fail inputs from the Ram BIST wrappers, indicates that a read error
   // occured.
   input         FailICData0;
   input         FailICData1;
   input         FailICData2;
   input         FailICData3;
   input         FailICTag;
   input         FailICValid;
   input         FailMMU;

   // Ram control signals:
   output [3:0]  ICBISTDATACS;
   output [3:0]  ICBISTTAGCS;
   output        ICBISTVALIDCS;
   output        MMUBISTCS;
   output [12:0] ICBISTA;
   output        ICBISTEN;
   output        ICBISTWE;
   output [31:0] ICBISTWD;

   // Used to generate ICBISTDATACS bus.
   wire          ICBISTDATACS0;
   wire          ICBISTDATACS1;
   wire          ICBISTDATACS2;
   wire          ICBISTDATACS3;

   reg           FailedICData0;
   reg           FailedICData1;
   reg           FailedICData2;
   reg           FailedICData3;
   reg           FailedICTag;
   reg           FailedICValid;
   reg           FailedMMU;

   reg           Running;
   wire          AddrEnd; // Indicates that the maximum wanted address has been
                        // reached, and that the test can move to the next pass.
   reg [12:0]    Addr;
   reg [12:0]    AddrMask; // Mask for the address to generate AddrEnd.
   reg [12:0]    TagAddrMask; // Mask for the tag Rams, used to deassert CS
                             // when the address is out of range.
   reg [12:0]    VDAddrMask; // Mask for the Valid and Dirty Rams.
   wire [12:0]   MMUAddrMask;
   reg           CS; // Chip select.
   reg           Write; // Perform a Write rather than a read.
   reg [1:0]     Pattern; // The pattern to write or the pattern expected from
                         // the current read.
   // Registers to generate the Check signals. These indicate when the
   // Fail signals are valid.
   reg           PreChICData0;
   reg           PreChICData1;
   reg           PreChICData2;
   reg           PreChICData3;
   reg           PreChICTag;
   reg           PreChICValid;
   reg           PreChMMU;
   reg           CheckICData0;
   reg           CheckICData1;
   reg           CheckICData2;
   reg           CheckICData3;
   reg           CheckICTag;
   reg           CheckICValid;
   reg           CheckMMU;

   wire          IntStart; // Internal BIST start signal.
   reg           IncAddr; // Increment the address.

   wire          AnyEnable;

   // The state machine:
   reg [3:0]     State;
   reg [3:0]     NextState;

`define ICBIST_Idle   4'd0 // Doing nothing -- normal macrocell behaviour.
`define ICBIST_Start  4'd1 // Reset address pointer and failed flags
`define ICBIST_One    4'd2 // Pass 1, write pattern 1
`define ICBIST_Two    4'd3 // Pass 2, read pattern 1
`define ICBIST_Three  4'd4 // Pass 2, write pattern 2
`define ICBIST_Four   4'd5 // Pass 3, read pattern 2
`define ICBIST_Five   4'd6 // Pass 3, write pattern 1
`define ICBIST_Six    4'd7 // Pass 3, read pattern 1
`define ICBIST_End1   4'd8 // Wait for last pipelined read
`define ICBIST_End2   4'd9 // Last pipelined read avaliable now.

   assign #1 ICBISTDATACS = {ICBISTDATACS3, ICBISTDATACS2, ICBISTDATACS1,
                          ICBISTDATACS0};
   assign #1 ICBISTDATACS0 = EnableICData0 & CS;
   assign #1 ICBISTDATACS1 = EnableICData1 & CS;
   assign #1 ICBISTDATACS2 = EnableICData2 & CS;
   assign #1 ICBISTDATACS3 = EnableICData3 & CS;
   assign #1 ICBISTTAGCS   = {4{EnableICTag   & CS & ~|(TagAddrMask & Addr)}};
   assign #1 ICBISTVALIDCS = EnableICValid & CS & ~|(VDAddrMask & Addr);
   assign #1 MMUBISTCS = EnableMMU & CS & ~|(MMUAddrMask & Addr);
   assign #1 ICBISTWE = Write;
   assign #1 ICBISTA = ((State == `ICBIST_Four) |
                        (State == `ICBIST_Five) |
                        (State ==`ICBIST_Six)) ? ~Addr : Addr;
   assign AnyEnable = EnableICData0 | EnableICData1 | EnableICData2 |
                      EnableICData3 | EnableICTag | EnableICValid |
                      EnableMMU;
   // Switch the BIST Ram wrappers into BIST mode when any BIST is taking place.
   assign #1 ICBISTEN = Running;
   // We only use the bottom two bits of ICBISTWD:
   assign #1 ICBISTWD = {30'd0, Pattern};

   always @(/*AUTOSENSE*/AddrEnd or AnyEnable or BISTStart or State)
     begin
        case (State)
          `ICBIST_Idle:  NextState = (BISTStart & AnyEnable) ?
                                     `ICBIST_Start : `ICBIST_Idle;
          `ICBIST_Start: NextState = `ICBIST_One;
          `ICBIST_One:   NextState = AddrEnd ? `ICBIST_Two : `ICBIST_One;
          `ICBIST_Two:   NextState = `ICBIST_Three;
          `ICBIST_Three: NextState = AddrEnd ? `ICBIST_Four : `ICBIST_Two;
          `ICBIST_Four:  NextState = `ICBIST_Five;
          `ICBIST_Five:  NextState = `ICBIST_Six;
          `ICBIST_Six:   NextState = AddrEnd ? `ICBIST_End1 : `ICBIST_Four;
          `ICBIST_End1:  NextState = `ICBIST_End2;
          `ICBIST_End2:  NextState = `ICBIST_Idle;
          default : NextState = `ICBIST_Idle;
        endcase
     end

   always @(posedge CLK or negedge HRESETn)
     begin
        if (!HRESETn)
          State <= `ICBIST_Idle;
        else
          State <= NextState;
     end

   always @(/*AUTOSENSE*/State)
     begin
        case (State)
          `ICBIST_Start,
          `ICBIST_One,
          `ICBIST_Two,
          `ICBIST_Three,
          `ICBIST_Four,
          `ICBIST_Five,
          `ICBIST_Six,
          `ICBIST_End1,
          `ICBIST_End2: Running = 1'b1;
          default : Running = 1'b0;
        endcase
     end
   assign RunningICData0 = Running & EnableICData0;
   assign RunningICData1 = Running & EnableICData1;
   assign RunningICData2 = Running & EnableICData2;
   assign RunningICData3 = Running & EnableICData3;
   assign RunningICTag   = Running & EnableICTag;  
   assign RunningICValid = Running & EnableICValid;
   assign RunningMMU = Running & EnableMMU;

   always @(/*AUTOSENSE*/State)
     begin
        case (State)
          `ICBIST_One:
             begin CS = 1'b1; Write = 1'b1; Pattern = 2'b01; IncAddr = 1'b1; end
          `ICBIST_Two:
             begin CS = 1'b1; Write = 1'b0; Pattern = 2'b01; IncAddr = 1'b0; end
          `ICBIST_Three:
             begin CS = 1'b1; Write = 1'b1; Pattern = 2'b10; IncAddr = 1'b1; end
          `ICBIST_Four:
             begin CS = 1'b1; Write = 1'b0; Pattern = 2'b10; IncAddr = 1'b0; end
          `ICBIST_Five:
             begin CS = 1'b1; Write = 1'b1; Pattern = 2'b01; IncAddr = 1'b0; end
          `ICBIST_Six:
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
             PreChICData0 <= 1'b0;
             CheckICData0 <= 1'b0;
             PreChICData1 <= 1'b0;
             CheckICData1 <= 1'b0;
             PreChICData2 <= 1'b0;
             CheckICData2 <= 1'b0;
             PreChICData3 <= 1'b0;
             CheckICData3 <= 1'b0;
             PreChICTag   <= 1'b0;
             CheckICTag   <= 1'b0;
             PreChICValid <= 1'b0;
             CheckICValid <= 1'b0;
             PreChMMU <= 1'b0;
             CheckMMU <= 1'b0;
          end
        else
          begin
             PreChICData0 <= ICBISTDATACS0 & ~Write;
             CheckICData0 <= PreChICData0;
             PreChICData1 <= ICBISTDATACS1 & ~Write;
             CheckICData1 <= PreChICData1;
             PreChICData2 <= ICBISTDATACS2 & ~Write;
             CheckICData2 <= PreChICData2;
             PreChICData3 <= ICBISTDATACS3 & ~Write;
             CheckICData3 <= PreChICData3;
             PreChICTag   <= ICBISTTAGCS   & ~Write;
             CheckICTag   <= PreChICTag;
             PreChICValid <= ICBISTVALIDCS & ~Write;
             CheckICValid <= PreChICValid;
             PreChMMU <= MMUBISTCS & ~Write;
             CheckMMU <= PreChMMU;
          end
     end

   assign IntStart = (State == `ICBIST_Start);

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
   always @(/*AUTOSENSE*/EnableICData0 or EnableICData1
            or EnableICData2 or EnableICData3 or EnableICTag
            or EnableICValid or EnableMMU or ICACHESIZE or MMUAddrMask
            or TagAddrMask or VDAddrMask)
     begin
        if (EnableICData0 | EnableICData1 | EnableICData2 | EnableICData3)
          // This case statement is similar to the one in a926Cache.v.
          case (ICACHESIZE)
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
        else if (EnableICTag)
          AddrMask = TagAddrMask;
        else if (EnableICValid & EnableMMU)
          AddrMask = VDAddrMask & MMUAddrMask;
        else if (EnableICValid)
          AddrMask = VDAddrMask;
        else // if ( EnableMMU)
          AddrMask = MMUAddrMask;
     end
   // TagAddrMask indicates what address range we need to test the tag Ram.
   always @(/*AUTOSENSE*/ICACHESIZE)
     begin
        case (ICACHESIZE)
          4'b0000,
          4'b0001,
          4'b0010,
          4'b0011: TagAddrMask = 13'b1111111100000; //   4K
          4'b0100: TagAddrMask = 13'b1111111000000; //   8K
          4'b0101: TagAddrMask = 13'b1111110000000; //  16K
          4'b0110: TagAddrMask = 13'b1111100000000; //  32K
          4'b0111: TagAddrMask = 13'b1111000000000; //  64K
          default: TagAddrMask = 13'b1110000000000; // 128K
        endcase
     end
   // VDAddrMask indicates what address range we need to test the valid
   // and dirty Rams.
   always @(/*AUTOSENSE*/ICACHESIZE)
     begin
        case (ICACHESIZE)
          4'b0000,
          4'b0001,
          4'b0010,
          4'b0011: VDAddrMask = 13'b1111111111000; //   4K
          4'b0100: VDAddrMask = 13'b1111111110000; //   8K
          4'b0101: VDAddrMask = 13'b1111111100000; //  16K
          4'b0110: VDAddrMask = 13'b1111111000000; //  32K
          4'b0111: VDAddrMask = 13'b1111110000000; //  64K
          default: VDAddrMask = 13'b1111100000000; // 128K
        endcase
     end
   // The MMU always has 32 entries -- 5 bits of address.
   assign MMUAddrMask = 13'b1111111100000;

   // Reset each failed bit when BIST starts, set when a read error occurs.
   // The Check* signals indicate that the corresponding Fail* signal is
   // valid, ie a read was started two cycles ago.
   always @(posedge CLK or negedge HRESETn)
     begin
        if (!HRESETn)
          FailedICData0 <= 1'b0;
        else if (IntStart)
          FailedICData0 <= 1'b0;
        else if (CheckICData0 & (FailICData0 != 1'b0))
          FailedICData0 <= 1'b1;
        //synopsys translate_off
        else if (CheckICData0 & (FailICData0 !== 1'b0))
          FailedICData0 <= 1'b1;
        //synopsys translate_on
     end
   always @(posedge CLK or negedge HRESETn)
     begin
        if (!HRESETn)
          FailedICData1 <= 1'b0;
        else if (IntStart)
          FailedICData1 <= 1'b0;
        else if (CheckICData1 & (FailICData1 != 1'b0))
          FailedICData1 <= 1'b1;
        //synopsys translate_off
        else if (CheckICData1 & (FailICData1 !== 1'b0))
          FailedICData1 <= 1'b1;
        //synopsys translate_on
     end
   always @(posedge CLK or negedge HRESETn)
     begin
        if (!HRESETn)
          FailedICData2 <= 1'b0;
        else if (IntStart)
          FailedICData2 <= 1'b0;
        else if (CheckICData2 & (FailICData2 != 1'b0))
          FailedICData2 <= 1'b1;
        //synopsys translate_off
        else if (CheckICData2 & (FailICData2 !== 1'b0))
          FailedICData2 <= 1'b1;
        //synopsys translate_on
     end
   always @(posedge CLK or negedge HRESETn)
     begin
        if (!HRESETn)
          FailedICData3 <= 1'b0;
        else if (IntStart)
          FailedICData3 <= 1'b0;
        else if (CheckICData3 & (FailICData3 != 1'b0))
          FailedICData3 <= 1'b1;
        //synopsys translate_off
        else if (CheckICData3 & (FailICData3 !== 1'b0))
          FailedICData3 <= 1'b1;
        //synopsys translate_on
     end
   always @(posedge CLK or negedge HRESETn)
     begin
        if (!HRESETn)
          FailedICTag <= 1'b0;
        else if (IntStart)
          FailedICTag <= 1'b0;
        else if (CheckICTag & (FailICTag != 1'b0))
          FailedICTag <= 1'b1;
        //synopsys translate_off
        else if (CheckICTag & (FailICTag !== 1'b0))
          FailedICTag <= 1'b1;
        //synopsys translate_on
     end
   always @(posedge CLK or negedge HRESETn)
     begin
        if (!HRESETn)
          FailedICValid <= 1'b0;
        else if (IntStart)
          FailedICValid <= 1'b0;
        else if (CheckICValid & (FailICValid != 1'b0))
          FailedICValid <= 1'b1;
        //synopsys translate_off
        else if (CheckICValid & (FailICValid !== 1'b0))
          FailedICValid <= 1'b1;
        //synopsys translate_on
     end
   always @(posedge CLK or negedge HRESETn)
     begin
        if (!HRESETn)
          FailedMMU <= 1'b0;
        else if (IntStart)
          FailedMMU <= 1'b0;
        else if (CheckMMU & (FailMMU != 1'b0))
          FailedMMU <= 1'b1;
        //synopsys translate_off
        else if (CheckMMU & (FailMMU !== 1'b0))
          FailedMMU <= 1'b1;
        //synopsys translate_on
     end

endmodule
