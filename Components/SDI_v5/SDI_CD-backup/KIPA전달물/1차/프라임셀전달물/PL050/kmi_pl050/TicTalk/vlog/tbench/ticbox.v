//  --========================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 1998 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//
//  ----------------------------------------------------------------------------
//  Version and Release Control Information:
//
//  File Name           : ticbox.v,v
//  File Revision       : 1.1
//
//  Release Information : PL050-REL1v1
//
//  ----------------------------------------------------------------------------
//  Purpose             : External AMBA TIC testbox
//                        Reads data from input file and ouptuts AMBA test
//                        interface signals TREQA, TREQB and the data bus TBUS.
//                        When performing reads, a comparison is made between
//                        the read value and the expected value (both previously
//                        masked by a mask value) and a result message is
//                        broadcast.
//                        Use the signal MaskOut to view the current value of
//                        the mask during simulation
//  --========================================================================--

`timescale 1ns / 1ps

//-----------------------------------------------------------------------------
//  INPUT FILE FORMAT
//
// ; at beginning of line implies a comment
// Vector Type    Data    Mask
//
// Vector Type
//    A   - Address
//    W   - Write (also used for burst writes)
//    R   - Read
//    L   - Loop 
//    E   - Exit test mode
// 
// Data (In hex, integer for Loop)
// 
// Mask (In hex) - only used in read cycles
// 
//-----------------------------------------------------------------------------

module ticbox (
// Inputs
        START,
        TCLK,
        TACK,

// Inouts
        TBUS,

// Outputs
        TREQA,
        TREQB
        );

`include "../common/Defs.v"

// Inputs
input           START; // Test access request
input           TCLK;  // Test mode clock input
input           TACK;  // Test acknowledge

// Inouts
inout  [31:0]   TBUS;  // Bidirectional test port

// Outputs
output          TREQA; // Test bus request A
output          TREQB; // Test bus request B

//-----------------------------------------------------------------------------
// HaltOnMismatch setting
//-----------------------------------------------------------------------------
// Uncomment the following line if the simulator should be stopped when a read
// value is different from the expected value
// When commented will only generate a warning on read vector error

// `define HaltOnMismatch

// Uncomment this parameter to turn on more run-time messages.
// With Verbosity set to 0 (default), only messages associated with
// errors are flagged in the simulator window.
 parameter Verbosity = 0;

//-----------------------------------------------------------------------------
// Signal declarations
//-----------------------------------------------------------------------------
reg             TREQA;
reg             TREQB;
reg    [31:0]   TBUS_reg;

reg             reqa;         // Used to generate TREQA
reg             reqb;         // Used to generate TREQB
reg    [31:0]   data;         // Read or write data, or address value
reg    [31:0]   mask;         // Mask from read command
reg             compare;      // Set for read command
reg             loopon;       // Indicates end of loop command

// Registered values for read vector checking, as there is a delay between
// starting a read transfer (when 'R' command in TIF file is reached) and 
// checking the read value (when the slave has driven out the read data)
reg    [31:0]   dataD1;
reg    [31:0]   maskD1;
reg    [31:0]   readD1;
reg    [31:0]   readD2;
reg             compareD1;
reg             compareD2;

reg    [31:0]   MaskOut;      // MaskOut is used to check read data values

reg             address_flag; // Used to control printing of address message

event           readline;     // Events to trigger reading of line
event           done_readline;
 
//-----------------------------------------------------------------------------
// Internal tasks
//-----------------------------------------------------------------------------
// The .sim input file (converted from .tif file) contains calls to the
// following tasks, and is read in a line at a time

task A;
input [31:0] address;
begin
  @(readline);
  if ((~address_flag) & (address !== 32'hzzzzzzzz) & (Verbosity == 1))
    begin
      $display("\nAddressing location %h", address);
      address_flag = 1;
    end
  reqa    = 1;
  reqb    = 1;
  compare = 0;
  data    = address;
  -> done_readline;
end
endtask

task W;
input [31:0] write_data;
begin
  @(readline);
  if (Verbosity == 1)
    $display("Writing data %h", write_data);
  address_flag = 0;
  reqa = 1;
  reqb = 0;
  compare = 0;
  data = write_data;
  -> done_readline;
end
endtask

task R;
input [31:0] read_data;
input [31:0] mask_data;
begin
  @(readline);
  if (Verbosity == 1)
    $display("Reading. Expected: %h. Mask %h", read_data, mask_data);
  address_flag = 0;
  reqa    = 0;
  reqb    = 1;
  compare = 1;
  data    = read_data;
  mask    = mask_data;
  -> done_readline;
end
endtask

task L;
input [31:0] loop_count;
integer count;
begin
  @(readline);
  count = loop_count;
  if (Verbosity == 1)
    $display("Looping for %d cycles", loop_count);
  address_flag = 0;
  count = count - 1; 
  while (count != 0)
    begin
      @(negedge TCLK);
      if (TACK)
        count = count - 1; 
    end
  -> done_readline;
end
endtask
        
task E;
input [31:0] end_data;
begin
  @(readline);
  $display("Exiting Test Mode");
  reqa    = 0;
  reqb    = 0;
  compare = 0;
  data    = end_data;
  -> done_readline;
end
endtask

//-----------------------------------------------------------------------------
// Beginning of main code
//-----------------------------------------------------------------------------
// Main process of module - reads in the input file, drives TBUS with the
// address and write data, and perfoms the read value checking, displaying an
// error on failure

always @(posedge TCLK)
begin
// Sets the TREQA/B lines at the start of the system test after reset
  if (~TACK & START & ~(reqa | reqb))
    begin
      TREQA <= 1;
      TREQB <= 0;
    end

  if (compareD2)
    begin
// Compare read value with expected value
      if ((TBUS & MaskOut) !== (readD2 & MaskOut))
        begin
          $display("TBUS & MaskOut = %b, readD2 & MaskOut = %b", 
                    TBUS & MaskOut, readD2 & MaskOut);
          $display(
         "Error on vector read at time %t. Expected: %h Actual : %h Mask : %h",
                    $time, readD2, TBUS, MaskOut);
// If HaltOnMismatch is set then the simulation will end
`ifdef HaltOnMismatch
          $stop;
`endif
        end
      else
      compareD2 <= 0;
    end
end

assign TBUS = TBUS_reg;

// Moves the read vector registered data into the next register
always @(negedge TCLK)
begin
  if (TACK)
    begin
      readD2    <= readD1;
      MaskOut   <= maskD1;
      compareD2 <= compareD1;
      compareD1 <= compare;
      if (compare)                 // Read cycle, latch info in other buses
        begin
          readD1 <= data;
          maskD1 <= mask;
          TBUS_reg <= 32'hzzzzzzzz;
        end
      else if (compareD1)          // Still waiting for read data
        TBUS_reg <= 32'hzzzzzzzz;
      else                         // Address or write vector, so output data
        TBUS_reg <= data;

// Set readline event to load in next line of .sim file
      -> readline;
      @(done_readline);
// Delays needed to avoid hold delay violations on synthesised TIC registers
//  SyncTREQA and SyncTREQB
      TREQA <= #1 reqa;
      TREQB <= #1 reqb;

// End the test when HaltOnMismatch is set and the 'E' command is reached in
//  the input file, otherwise TBTic will end the simulation when TRQA/B and
//  TACK are LOW
      if (~(reqa | reqb))
        begin
          `ifdef HaltOnMismatch
            $display ("Vector run completed : halting simulation");
            $finish;
          `endif
        end
    end
  else if (~TACK)
    compareD2 <= 1'b0;
end

//-----------------------------------------------------------------------------
// Initialization
//-----------------------------------------------------------------------------
initial
begin
  address_flag = 0;
  reqa     = 0;
  reqb     = 0;
  data     = 32'hzzzzzzzz;
  mask     = 32'hffffffff;
  TBUS_reg = 32'hzzzzzzzz;
  compare  = 0;
  loopon   = 0;

// Read in the simulation test file - this is a converted TIF file
  `include "infile.sim"

// At end of the simulation, drive reqa and reqb low
   reqa = 0;
   reqb = 0;
   data = 32'hzzzzzzzz;
end

endmodule

// --================================ End ====================================--
