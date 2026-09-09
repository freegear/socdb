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
// File Name              : RemPause.v.rca
// File Revision          : 1.1
//
// Release Information    : PrimeCell(TM)-GLOBAL-REL1v3
//
// ---------------------------------------------------------------------
// Purpose :
//           Remap and Pause controller module for APB.
//
// --=================================================================--

`timescale 1ns/1ps

module RemPause (PCLK, PRESETn, PENABLE, PSELRPC, PADDR, PWRITE,
                 PWDATA, PRDATA, nFIQ, nIRQ, Pause, Remap);

  input        PCLK;
  input        PRESETn;
  input        PENABLE;
  input        PSELRPC;
  input  [5:2] PADDR;
  input        PWRITE;
  input  [7:0] PWDATA;
  output [7:0] PRDATA;

  input        nFIQ;  // FIQ interrupt input
  input        nIRQ;  // IRQ interrupt input
  output       Pause; // PRDATAEn register input
  output       Remap; // Reset memory map in use

// ---------------------------------------------------------------------
// Constant declarations
// ---------------------------------------------------------------------
// Identification is the value read from the Identification register
// address. Unused bits should be set LOW.

  `define IDENTIFICATION    8'b0000_0000

  `define PAUSEA            6'b000000
  `define IDENTIFICATIONA   6'b010000
  `define CLEARRESETMAPA    6'b100000
  `define RESETSTATUSA      6'b110000
  `define RESETSTATUSSETA   6'b110000
  `define RESETSTATUSCLEARA 6'b110100

// ---------------------------------------------------------------------
// Signal declarations
// ---------------------------------------------------------------------
// If the above addresses are altered then the sections of code that
// assign Addr and ResetStatus may also have to be changed.

  wire [5:0] Addr;            // Altered copy of PADDR
  wire       ResetStatusEn;   // Reset Status write enable
  reg  [7:0] ResetStatusNext; // ResetStatus register input
  reg  [7:0] ResetStatus;     // Reset Status register
  wire       PauseEn;         // Pause write enable
  wire       PauseRes;        // Reset term for Pause register
  wire       RemapEn;         // Remap write enable
  reg  [7:0] PrdataNext;      // Internal PRDATA
  wire       PrdataNextEn;    // PrdataNext enable
  reg  [7:0] iPRDATA;         // Registered PrdataNext

  reg        Pause;           // Registered output signal
  reg        Remap;           // Registered output signal

// ---------------------------------------------------------------------
// Beginning of main code
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// General signals
// ---------------------------------------------------------------------
// Addr is used as alternative to PADDR - unused address bits are set
// LOW to simplify synthesised address checking logic.
// May have to be changed if address map of interrupt controller
// internal registers is changed.

  assign Addr = {PADDR[5:4], 1'b0, PADDR[2], 2'b00};

// ---------------------------------------------------------------------
// ResetStatus register
// ---------------------------------------------------------------------
// Mux and registers are enabled when the set or clear addresses are
// written to.

  assign ResetStatusEn = ((PSELRPC == 1'b1 && PWRITE == 1'b1 &&
                           PENABLE == 1'b0 &&
                          (Addr == `RESETSTATUSSETA ||
                           Addr == `RESETSTATUSCLEARA)) ?
                         1'b1 : 1'b0);

// Bit zero of the ResetStatus register is set HIGH on reset, LOW when
// cleared.
// It cannot be set HIGH by software.
// All other bits of the ResetStatus register may be set and cleared
// through the two address locations.

  always @(ResetStatusEn or Addr or ResetStatus or PWDATA)
  begin
    if (ResetStatusEn)
      case (Addr)

        `RESETSTATUSSETA :
        begin
          ResetStatusNext[0]   = ResetStatus[0];
          ResetStatusNext[7:1] = PWDATA[7:1] | ResetStatus[7:1];
        end

        default : // If enabled and not set, must be clear address
          ResetStatusNext = ((~PWDATA) & ResetStatus);

      endcase
    else
      ResetStatusNext = 8'h00;
  end


// On reset, bit 0 is set HIGH, indicating power on reset condition.
  always @( negedge (PRESETn) or posedge (PCLK) )
  begin
    if ((!PRESETn))
      ResetStatus <= {4'b0000 , 4'b0001};
    else
    begin
      if ((ResetStatusEn))
        ResetStatus <= ResetStatusNext;
    end
  end

// ---------------------------------------------------------------------
// Pause output register
// ---------------------------------------------------------------------
// The Pause output causes the system to enter a "wait for interrupt"
// state.
// Set LOW on reset or interrupt, set HIGH on write.
// Asynchronous nIRQ and nFIQ inputs are needed so that system can
// function asynchronously when in low power mode.

  assign PauseEn = ((PSELRPC == 1'b1 && PWRITE == 1'b1 &&
                     PENABLE == 1'b0 &&
                     Addr == `PAUSEA) ? 1'b1 : 1'b0);

  assign PauseRes = PRESETn & nIRQ & nFIQ; // Combined to give single
                                           // reset term

  always @( negedge (PauseRes) or posedge (PCLK) )
  begin
    if ((!PauseRes))
      Pause <= 1'b0;
    else
    begin
      if ((PauseEn))
        Pause <= 1'b1;
    end
  end

// ---------------------------------------------------------------------
// Remap output register
// ---------------------------------------------------------------------
// The Remap output selects the memory map to be used by the system.
// Set LOW on reset (reset memory map), HIGH on write (normal memory
// map). Once set HIGH, can only be set LOW with reset.

  assign RemapEn = ((PSELRPC == 1'b1 && PWRITE == 1'b1 &&
                     PENABLE == 1'b0 &&
                     Addr == `CLEARRESETMAPA) ? 1'b1 : 1'b0);

  always @( negedge (PRESETn) or posedge (PCLK) )
  begin
    if ((!PRESETn))
      Remap <= 1'b0;
    else
    begin
      if ((RemapEn))
        Remap <= 1'b1;
    end
  end

// ---------------------------------------------------------------------
// Output data generation
// ---------------------------------------------------------------------
// Address decoding for register reads.

  assign PrdataNextEn = PSELRPC & ( (~ PWRITE) ) & ( (~ PENABLE) );

  always @(PrdataNextEn or Addr or ResetStatus or iPRDATA)
  begin
    PrdataNext = 8'h00;
    if (PrdataNextEn)
      case (Addr)
        `IDENTIFICATIONA :
          PrdataNext = `IDENTIFICATION;
        `RESETSTATUSA :
          PrdataNext = ResetStatus;
        default  :
          PrdataNext = 8'h00;
      endcase
    else
      PrdataNext = iPRDATA;
  end

// Register used to reduce output delay during reads.

  always @( negedge (PRESETn) or posedge (PCLK) )
  begin
    if (!PRESETn)
      iPRDATA <= 8'h00;
    else
      iPRDATA <= PrdataNext;
  end

// Drive output with internal version.

  assign PRDATA = iPRDATA;


endmodule

// --============================== End ==============================--
