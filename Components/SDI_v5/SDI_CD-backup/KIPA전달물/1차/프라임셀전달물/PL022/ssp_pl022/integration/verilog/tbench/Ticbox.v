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
// File Name              : Ticbox.v.rca
// File Revision          : 1.1
//
// Release Information    : PrimeCell(TM)-PL022-REL1v2
//
// ---------------------------------------------------------------------
// Purpose :
//           External AMBA TIC testbox
//           Reads data from input file and ouptuts AMBA test
//           interface signals TESTREQA, TESTREQB and the data bus
//           TESTBUS.
//           When performing reads, a comparison is made between
//           the read value and the expected value (both previously
//           masked by a mask value) and a result message is
//           broadcast.
//
// --=================================================================--

`timescale 1ns / 1ps

// ---------------------------------------------------------------------
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
// ---------------------------------------------------------------------

module Ticbox (
               nReset,
               TESTCLK,
               TESTACK,
               TESTBUS,
               TESTREQA,
               TESTREQB
              );

input         nReset;   // System reset
input         TESTCLK;  // Test mode clock input
input         TESTACK;  // Test acknowledge

inout  [31:0] TESTBUS;  // Bidirectional test port

output        TESTREQA; // Test bus request A
output        TESTREQB; // Test bus request B

// ---------------------------------------------------------------------
// Ticbox module settings
// ---------------------------------------------------------------------
// Two module settings are used with this model:
//  HaltOnMismatch is used to make the simulation end when a read error
//  is detected. The default is to just display a warning for a read
//  error.
//  Verbosity is used to turn off the displaying of the TIF input vector
//   comments. The default is to display all TIF vector comments.
//
// The default values set in this module are the same as those in the
//  TBTic module. Changes to the values should be made in the TBTic
//  module.

  parameter HaltOnMismatch = 0; // Default is disabled
  parameter Verbosity      = 1; // Default is enabled

// ---------------------------------------------------------------------
// Signal declarations
// ---------------------------------------------------------------------
reg        Start;        // Used to initialise the system test

reg        iTESTREQA;    // Used to generate the TESTREQA/B outputs
reg        iTESTREQB;
reg        REQA;
reg        REQB;
reg  [1:0] TestreqPrev;
reg        TestackPrev;

wire       LastRead;     // Indicates turnaround at end of read cycle

reg        AddressFlag;  // Used to control printing of address
                         // message

event      ReadLine;     // Events to trigger reading of line
event      DoneReadLine;

reg [31:0] TESTBUSTri;   // Tristate register for inout test bus

// Registered values for read vector checking, as there is a delay
// between starting a read transfer (when reach 'R' command in TIF
// file) and checking the read value (when the slave has driven out the
// read data).
reg        Compare;      // Set during read cycle to compare data values
reg        CompReg0;
reg        CompReg1;
reg        CompReg2;
reg [31:0] Mask;         // Mask from read command
reg [31:0] MaskReg1;
reg [31:0] MaskReg2;
reg [31:0] MaskReg3;
reg [31:0] ReadReg1;     // Expected read data registers
reg [31:0] ReadReg2;
reg [31:0] ReadReg3;

reg [31:0] Data;         // Expected read or write data, or
                         // address value
reg [31:0] DataReg1;     // Write data or address value registers
reg [31:0] DataReg2;

// ---------------------------------------------------------------------
// Internal tasks
// ---------------------------------------------------------------------
// The .sim input file (converted from VHDL TIF file) contains calls to
// the following tasks, and is read in a line at a time, using the
// ReadLine and DoneReadLine events to control the system operation.

task A;  // Address vector
input [31:0] Address;
begin
  @(ReadLine);
  if ((~AddressFlag) & (Address !== 32'hzzzz_zzzz))
    begin
      if (Verbosity == 1)
        begin
          $display("\nAddressing location %h", Address);
          AddressFlag = 1;
        end
    end
    REQA    = 1;
    REQB    = 1;
    Compare = 0;
    Data    = Address;
    -> DoneReadLine;
end
endtask

task W;  // Write vector
input [31:0] WriteData;
begin
  @(ReadLine);
  if (Verbosity == 1)
    $display("Writing data %h", WriteData);
  AddressFlag = 0;
  REQA    = 1;
  REQB    = 0;
  Compare = 0;
  Data    = WriteData;
  -> DoneReadLine;
end
endtask

task R;  // Read vector
input [31:0] ReadData;
input [31:0] MaskData;
begin
  @(ReadLine);
  if (Verbosity == 1)
    $display("Reading. Expected: %h. Mask %h", ReadData, MaskData);
  AddressFlag = 0;
  REQA    = 0;
  REQB    = 1;
  Compare = 1;
  Data    = ReadData;
  Mask    = MaskData;
  -> DoneReadLine;
end
endtask

task L;  // Loop vector
input [31:0] LoopCount;
integer Count;
begin
  @(ReadLine);
  Count = LoopCount;
  if (Verbosity == 1)
    $display("Looping for %d cycles", LoopCount);
  AddressFlag = 0;
  Count = Count - 1;
  while (Count != 0)
    begin
      @(negedge TESTCLK);
      if (TESTACK)
        Count = Count - 1;
    end
  -> DoneReadLine;
end
endtask

task E;  // End of test
input [31:0] EndData; // End data not used, but need to read it in
begin
  @(ReadLine);
  if (Verbosity == 1)
    $display("Exiting Test Mode");
  REQA    = 0;
  REQB    = 0;
  Compare = 0;
  -> DoneReadLine;
end
endtask

// ---------------------------------------------------------------------
//
// Main body of code
// =================
//
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Initialisation
// ---------------------------------------------------------------------
// Initialiase default values for all registers and wires.

initial
  begin
    AddressFlag = 0;
    REQA        = 0;
    REQB        = 0;
    iTESTREQA   = 0;
    iTESTREQB   = 0;
    TestreqPrev = 0;
    Data        = 32'hzzzz_zzzz;
    Mask        = 32'hffff_ffff;
    TESTBUSTri  = 32'hzzzz_zzzz;
    Compare     = 0;
    CompReg0    = 0;
    CompReg1    = 0;
    CompReg2    = 0;
    MaskReg1    = 0;
    MaskReg2    = 0;
    MaskReg3    = 0;
    ReadReg1    = 0;
    ReadReg2    = 0;
    ReadReg3    = 0;
    DataReg1    = 0;
    DataReg2    = 0;

// Read in the simulation test file - this is a converted TIF file.
    `include "../../bustest/invec/tif.sim"

// Wait until last test vector has completed.
    wait (TestackPrev & !LastRead)
      @(negedge TESTCLK)

// At end of the test, drive REQA and REQB LOW.
    REQA = 0;
    REQB = 0;
    Data = 32'hzzzz_zzzz;
end

// ---------------------------------------------------------------------
// Start signal generation
// ---------------------------------------------------------------------
// Start is initially set LOW, and is used to set the TESTREQA/B
// outputs to indicate that test mode is being requested.
// It is then set HIGH when TESTACK is first set HIGH, indicating that
// test mode has been entered.

always
begin
  Start = 0;
  wait (TESTACK)
    @(posedge TESTCLK)
  Start = #1 1;   // Delay added to ensure is only valid on next
                  // clock edge
  wait (!nReset); // Will loop back if system is reset
end

// ---------------------------------------------------------------------
// TESTREQA/B output generation
// ---------------------------------------------------------------------
// Sets the TESTREQA/AB outputs to indicate the start of system
// testing, or to REQA/B at all other times.

always @(posedge TESTCLK)
begin
  if (!Start)
    begin
      iTESTREQA <= 1;
      iTESTREQB <= 0;
    end
  else if (TESTACK & ~LastRead)
    begin
      iTESTREQA <= REQA;
      iTESTREQB <= REQB;
      CompReg0  <= Compare;

// End the test when HaltOnMismatch is set and the 'E' command is
// reached in the input file, otherwise TBTic will end the simulation
// when TESTREQA/B and TESTACK are LOW.
      if (REQA == 0 && REQB == 0 && HaltOnMismatch == 1)
        begin
          $display ("Vector run completed : halting simulation");
          $finish;
        end
    end
end

// ---------------------------------------------------------------------
// TESTREQA/B previous value
// ---------------------------------------------------------------------
// Previous value of TESTREQA/B used during a burst of reads.

always @(posedge TESTCLK)
begin
  if (TESTACK)
    TestreqPrev <= {iTESTREQA, iTESTREQB};
end

// ---------------------------------------------------------------------
// TESTACK previous value
// ---------------------------------------------------------------------
// Previous value of TESTACK used to control the reading of the input
// data file.

always @(posedge TESTCLK)
begin
  TestackPrev <= TESTACK;
end

// ---------------------------------------------------------------------
// End of read cycle turnaround detection
// ---------------------------------------------------------------------
// Set HIGH when TESTREQA/B change after a read vector, either after a
// single read or at the end of a burst of reads. Used to stop the
// input file from being read and the TESTREQ outputs from changing
// until after the turnaround cycle needed after a read.

assign LastRead = (TestreqPrev == 2'b01 && iTESTREQA == 1'b1 &&
                   iTESTREQB == 1'b1) ? 1'b1 :
                  1'b0;

// ---------------------------------------------------------------------
// Read input TIF file
// ---------------------------------------------------------------------
// This runs from the falling edge of the clock so that the data from
// the input file is valid 1/2 a cycle before it is needed. This
// simplifies the module as less register stages are needed than if the
// input data was read on the rising edge during the previous transfer.

always @(negedge TESTCLK)
begin
  if (TESTACK & ~LastRead & Start)
    begin
      -> ReadLine;     // Set ReadLine event to load in next line
                       // of .sim file
      @(DoneReadLine);
    end
end

// ---------------------------------------------------------------------
// Read cycle registers
// ---------------------------------------------------------------------
// Registers to hold the Compare signal (to indicate that TESTBUS
// should be compared with the data in the read register), and the read
// and mask data.

always @(posedge TESTCLK)
begin
  if (TESTACK)
    begin
      CompReg2 <= CompReg1;
      CompReg1 <= CompReg0;
    end
end

always @(posedge TESTCLK)
begin
  if (TESTACK)
    begin
      ReadReg3 <= ReadReg2;
      ReadReg2 <= ReadReg1;
      MaskReg3 <= MaskReg2;
      MaskReg2 <= MaskReg1;
      if (Compare)
        begin
          ReadReg1 <= Data;
          MaskReg1 <= Mask;
        end
    end
end

// ---------------------------------------------------------------------
// TIF address/write data register
// ---------------------------------------------------------------------
// A register is used to hold the address/write data value from the
// input test file.

always @(posedge TESTCLK)
begin
  if (TESTACK)
    begin
      DataReg2 <= DataReg1;
      DataReg1 <= Data;
    end
end

// ---------------------------------------------------------------------
// Compare read data
// ---------------------------------------------------------------------
// When the read data is ready, check the masked actual value against
// the masked expected value.

always @(posedge TESTCLK)
begin
  if (TESTACK == 1 && CompReg2 == 1 &&
      ((TESTBUS & MaskReg3) !== (ReadReg3 & MaskReg3)))
    begin
      $display(
        "Error on vector read at time %t. Expected: %h Actual : %h Mask : %h",
         $time, ReadReg3, TESTBUS, MaskReg3);

// If HaltOnMismatch is set then the simulation will end.
      if (HaltOnMismatch == 1)
        $stop;
    end
end

// ---------------------------------------------------------------------
// TESTBUS driver
// ---------------------------------------------------------------------
// Drives TESTBUS to high impedance during a read cycle, and to DataReg
// at all other times (during address or write cycles).

always @(CompReg2 or TestreqPrev or DataReg2)
begin
  if (CompReg2 | TestreqPrev == 2'b01) // Waiting for read data
    TESTBUSTri <= 32'hzzzz_zzzz;
  else                                 // Address or write vector
    TESTBUSTri <= DataReg2;
end

assign TESTBUS          = TESTBUSTri;

// ---------------------------------------------------------------------
// Output drivers
// ---------------------------------------------------------------------
// Delay needed to avoid hold delay violations on synthesised TIC
// register SyncTestreqA.

assign #1 TESTREQA         = iTESTREQA;
assign    TESTREQB         = iTESTREQB;

endmodule

// --============================== End ==============================--
