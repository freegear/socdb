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
// File Name              : rem_pause.v.rca
// File Revision          : 1.1
//
// Release Information    : PrimeCell(TM)-GLOBAL-REL1v4
//
// ---------------------------------------------------------------------
// Purpose : RMC Reset and pause registers (APB peripheral) See RMC
//           spec for details A microcontroller peripheral based on
//           the APB bus.
//
// --=================================================================--

`timescale 1ns/1ps

module rem_pause (BCLK, BnRES, PENABLE, PSELRPC, PADDR, PWRITE, PWDATA,
                  PRDATA, nFIQ, nIRQ, Pause, Remap);
 
  input        BCLK;
  input        BnRES;
  input        PENABLE;
  input        PSELRPC;
  input  [5:2] PADDR;
  input        PWRITE;
  input  [0:0] PWDATA;
  output [7:0] PRDATA;

  input        nFIQ;   // FIQ interrupt input
  input        nIRQ;   // IRQ interrupt input
  output       Pause;  // Pause mode entered
  output       Remap;  // Reset memory map in use

// ---------------------------------------------------------------------
//  Constant declarations
// ---------------------------------------------------------------------
//  REGSIZE is used to set the maximum size of the registers used in 
//  the system and should be equal to the greater of the Identification
//  and ResetStatus registers

  `define REGSIZE           32'd1

//  Identification is the value read from the Identification register 
//  address For systems where the ResetStatus register is greater than 
//  the Identification register, the unused bits should be set LOW.

  `define IDENTIFICATION    1'b0
 
  `define PAUSEA            6'b000000
  `define IDENTIFICATIONA   6'b010000
  `define CLEARRESETMAPA    6'b100000
  `define RESETSTATUSA      6'b110000
  `define RESETSTATUSSETA   6'b110000
  `define RESETSTATUSCLEARA 6'b110100
 
// ---------------------------------------------------------------------
//  Signal declarations
// ---------------------------------------------------------------------
//  The ResetStatusSet register has no function in this minimal example
//  system If the above addresses are altered then the sections of code
//  that assign Addr and ResetStatus may also have to be changed

  wire [5:0] Addr;                         // Altered copy of PADDR
  wire ResetStatusEn;                      // Reset Status write enable
  wire [(`REGSIZE - 1):0] ResetStatusNext; // ResetStatus register input
  wire RemapEn;                            // Remap write enable
  wire PauseEn;                            // Pause write enable
  wire PRDATAEnNext;                       // PRDATAEn register input
  wire PauseRes;                           // Reset term for Pause 
                                           // register
  wire [7:0] PRDATA;                       // Output read data bus

  reg [(`REGSIZE - 1):0] ResetStatus;      // Reset Status register
  reg [(`REGSIZE - 1):0] PRDATAInt;        // Internal PRDATA
  reg [(`REGSIZE - 1):0] PRDATAIntReg;     // Registered PRDATAInt
  reg Remap;
  reg Pause;
 
// ---------------------------------------------------------------------
//  Beginning of main code
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
//  General signals
// ---------------------------------------------------------------------
//  Addr is used as alternative to PADDR - unused address bits are set 
//  LOW to simplify synthesised address checking logic May have to be 
//  changed if address map of interrupt controller internal
//  registers is changed

  assign Addr = {PADDR[5:4] , 1'b0 , PADDR[2] , 2'b00};

// ---------------------------------------------------------------------
//  ResetStatus register
// ---------------------------------------------------------------------
//  Default system shows power on reset status in bit 0
//  Set HIGH on reset, LOW when cleared - cannot be set HIGH by software
//  Extra statements should be added to this process if the system 
//  requires the register to be set as well as cleared

  assign ResetStatusEn = ((PSELRPC == 1'b1 && PWRITE == 1'b1 &&
          PENABLE == 1'b0 && Addr == `RESETSTATUSCLEARA) ? 1'b1 : 1'b0);

  assign ResetStatusNext = (ResetStatus & (~ PWDATA[(`REGSIZE - 1):0]));

// For systems where the IDENTIFICATION register is larger than the 
// ResetStatus register, the unused ResetStatus bits should be set LOW

  always @( negedge (BnRES) or posedge (BCLK) )
  begin
    if ((!BnRES))
      ResetStatus <= 1'b1;
    else
      if ((ResetStatusEn))
        ResetStatus <= ResetStatusNext;
  end
 
// ---------------------------------------------------------------------
//  Remap output register
// ---------------------------------------------------------------------
//  The Remap output sets the memory map to be used by the system
//  Set LOW on reset (reset memory map), HIGH on write (normal memory 
//  map) Once set HIGH, can only be set LOW with reset

  assign RemapEn = ((PSELRPC == 1'b1 && PWRITE == 1'b1 && 
                     PENABLE == 1'b0 && Addr == `CLEARRESETMAPA) 
                                                         ? 1'b1 : 1'b0);

  always @( negedge (BnRES) or posedge (BCLK) )
  begin
    if ((!BnRES))
      Remap <= 1'b0;
    else
      if ((RemapEn))
        Remap <= 1'b1;
  end
 
// ---------------------------------------------------------------------
//  Pause output register
// ---------------------------------------------------------------------
//  The Pause output causes the system to enter a "wait for interrupt" 
//  state Set LOW on reset or interrupt, set HIGH on write
//  Asynchronous nIRQ and nFIQ inputs are needed so that system can 
//  function asynchronously when in low power mode

  assign PauseEn = ((PSELRPC == 1'b1 && PWRITE == 1'b1 && 
                     PENABLE == 1'b0 && Addr == `PAUSEA) 
                                                         ? 1'b1 : 1'b0);

  assign PauseRes = BnRES & nIRQ & nFIQ;

  always @( negedge (PauseRes) or posedge (BCLK) )
  begin
    if ((!PauseRes))
      Pause <= 1'b0;
    else
      if ((PauseEn))
        Pause <= 1'b1;
  end
 
//  Address decoding for register reads

  assign PRDATAEnNext = PSELRPC & (~ PWRITE) & (~ PENABLE);

  always @(PRDATAEnNext or Addr or ResetStatus)
  begin
    PRDATAInt = {1'b0};
    if (PRDATAEnNext)
      case (Addr)
        `IDENTIFICATIONA :
          PRDATAInt = `IDENTIFICATION;
        `RESETSTATUSA :
          PRDATAInt = ResetStatus;
        default  : ;
      endcase
    else;
  end
 
// Register used to reduce output delay during reads

  always @( negedge (BnRES) or posedge (BCLK) )
  begin
    if (!BnRES)
      PRDATAIntReg <= {1'b0};
    else
      PRDATAIntReg <= PRDATAInt;
  end
 
  assign PRDATA = {7'b0000000, PRDATAIntReg};

endmodule

// --============================== End ==============================--
