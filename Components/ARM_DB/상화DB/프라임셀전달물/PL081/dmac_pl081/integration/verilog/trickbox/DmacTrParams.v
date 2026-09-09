// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2000-2001 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : DmacTrParams.v.rca
// File Revision          : 1.3
//
// Release Information    : PrimeCell(TM)-PL081-REL1v0
//
// -----------------------------------------------------------------------------
// Purpose :
//           DMAC Trickbox Parameter definitions
//
// --=========================================================================--

// -----------------------------------------------------------------------------
// Constants declarations
// -----------------------------------------------------------------------------
`define NO_OF_REG         64
// Number of register in memory or peripheral module.

`define MEMORYDEPTH       16
// To define depth of LLI memory block

`define SLAVEADDRLB       2
// Lower bit of Slave address used by memory or peripheral module.

`define SLAVEADDRHB       9
// Higher bit of Slave address used by memory or peripheral module.

`define MASTERADDRLB      0
// Lower bit of Slave address used by memory or peripheral module.

`define MASTERADDRHB      26
// Higher bit of Slave address used by memory or peripheral module.

// -----------------------------------------------------------------------------
// Definitions for AHB slave reponses
// -----------------------------------------------------------------------------
`define OKAY_RESP         2'b00
`define ERROR_RESP        2'b01
`define RETRY_RESP        2'b10
`define SPLIT_RESP        2'b11

// -----------------------------------------------------------------------------
// Definitions for different AHB HTRANS transactions
// -----------------------------------------------------------------------------
`define IDLE              2'b00
`define BUSY              2'b01
`define NSEQ              2'b10
`define SEQ               2'b11

// -----------------------------------------------------------------------------
// Definitions for different size AHB accesses on HSIZE line
// -----------------------------------------------------------------------------
`define BYTE              3'b000
`define HWORD             3'b001
`define WORD              3'b010

// -----------------------------------------------------------------------------
// Definitions for different AHB Burst accesses on HBURST lines
// -----------------------------------------------------------------------------
`define UINCR             3'b001
`define WRAP4             3'b010
`define INCR4             3'b011
`define WRAP8             3'b100
`define INCR8             3'b101
`define WRAP16            3'b110
`define INCR16            3'b111
 
// -----------------------------------------------------------------------------
// Definitions for generation of data from address pattern
// -----------------------------------------------------------------------------
`define INCREMENT         2'b00
`define DECREMENT         2'b01
`define ONESCOMP          2'b10
`define TWOSCOMP          2'b11

// -----------------------------------------------------------------------------
// Definitions for different data patterns
// -----------------------------------------------------------------------------
`define RANDOM            2'b00
`define GRAYCODE          2'b01
`define ADDRESSBASED      2'b10
`define DATABASED         2'b11

// -----------------------------------------------------------------------------
// Function Definition
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Function to generate address based data. 
// -----------------------------------------------------------------------------
function [7:0] AddrBasedGen;
input  [7:0] Address;          // Address for the transfer
input  [3:0] Diff;             // Offset to be added
input  [1:0] method;           // Methos of data generation

reg    [7:0] Result;

begin
  case (method)
    `INCREMENT :
       Result = Address + Diff;
    `DECREMENT :
       Result = Address - Diff;
    `ONESCOMP :
       Result = (~Address);
    `TWOSCOMP :
       Result = ((~Address)+1);
    default :
       Result = 8'b0;
  endcase
  AddrBasedGen = Result;
end
endfunction
  
// -----------------------------------------------------------------------------
// Function to generate data using input data passed to function. 
// -----------------------------------------------------------------------------
function [7:0] DataBasedGen;
input  [7:0] Data;             // Data for the transfer
input  [3:0] Diff;             // Offset to be added
input  [1:0] method;           // Methos of data generation

reg    [7:0] Result;

begin
  case (method)
    `INCREMENT :
          Result = Data + Diff;
    `DECREMENT :
          Result = Data - Diff;
    default :
          Result = 8'b0;
  endcase
  DataBasedGen = Result;
end
endfunction

// -----------------------------------------------------------------------------
// function to generate gray code data. 
// -----------------------------------------------------------------------------
function [7:0] GrayDataGen;

input  [7:0] PreviousData;
// Data for the transfer

//integer width = 8;
`define width 8

integer i;
// integer signal to hold the count of the intermediate bit in the loop

reg [7:0] TempResult;
reg [7:0] Hold;
begin
  TempResult       = PreviousData;
  Hold[`width - 1] = TempResult[`width -1]; 
  for (i = 0; i < `width - 1; i = i + 1)
    begin
      GrayDataGen[i] = TempResult[i+1] ^ TempResult[i];
    end
end

endfunction

// -----------------------------------------------------------------------------
// function to generate PRBS data. 
// -----------------------------------------------------------------------------
function [7:0] PRBSDataGen;

input  [7:0] PRBSData;         // Data for the transfer

reg       RndBit;
// Random data holding register

begin
  RndBit            = PRBSData[7] ^ PRBSData[4] ^ PRBSData[1];
  PRBSDataGen       = {PRBSData[6:0], RndBit};
end

endfunction

// --================================== End ==================================--
