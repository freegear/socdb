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
// File Revision          : 1.4
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
// AHB Lite SM's state constants
// -----------------------------------------------------------------------------
`define ST_AHBM_INIT      4'b0001
`define ST_AHBM_STARTIDLE 4'b0010
`define ST_AHBM_ADDRXFR   4'b0100
`define ST_AHBM_ACTIVE    4'b1000

// -----------------------------------------------------------------------------
// AHB Slave SM's state constants
// -----------------------------------------------------------------------------
`define ST_DMAC_SLAVE_IDLE     4'b0001
`define ST_DMAC_SLAVE_WRITE    4'b0010
`define ST_DMAC_SLAVE_WRITE_TR 4'b0100
`define ST_DMAC_SLAVE_ERROR    4'b1000

// -----------------------------------------------------------------------------
// Channel SM's state constants
// -----------------------------------------------------------------------------
`define ST_IDLE           5'b00001
// SM's Idle state indicating no data transfer
 
`define ST_SRC_DMA_XFER   5'b00010
// SM"s source transfer state when peripheral is on same bus
 
`define ST_DMA_DST_XFER   5'b00100
// SM"s destination transfer state when peripheral is on same bus
 
`define ST_LLI_LOAD       5'b01000
// SM's LLILoading state
 
`define ST_PER_DUAL_BUS   5'b10000
// This state indicates that the peripheral are on different bus

// -----------------------------------------------------------------------------
// Constants used for Error SM in Channel Block
// -----------------------------------------------------------------------------
`define ST_ERROR_INIT     5'b00001
// SM's Idle state indicating no Error

`define ST_ERROR_SINGLE   5'b00010
// SM"s Error state indicating Error on Single Bus

`define ST_ERROR_DUAL     5'b00100
// SM"s Error state indicating Error on Dual Bus

`define ST_ERROR_SOURCE   5'b01000
// SM's Error state when Error happens on source bus but not on Destination bus

`define ST_ERROR_DEST     5'b10000
// SM's Error state when Error happens on destination bus but not on source bus

// -----------------------------------------------------------------------------
// Constants used for HWDATA Generation SM in Channel Block
// -----------------------------------------------------------------------------
`define ST_DST_HWDATA_IDLE       3'b001
// Destination SM's Initial state

`define ST_DST_ADDR_PHASE 3'b010
// Destination SM's Address Phase state

`define ST_DST_DATA_PHASE 3'b100
// Destination SM's Data state

// -----------------------------------------------------------------------------
// Constants used for Prediction Factor Generation SM in Channel Block
// -----------------------------------------------------------------------------
`define ST_SRC_PREDICT_IDLE       3'b001
// Source SM's Initial state

`define ST_SRC_ADDR_PHASE 3'b010
// Source SM's Address Phase state

`define ST_SRC_DATA_PHASE 3'b100
// Source SM's Data state

// -----------------------------------------------------------------------------
// Constants used for Generating 'NotValidData' signals for
// Source/Destination/LLI
// -----------------------------------------------------------------------------
`define ST_NOTVALIDSRC_IDLE    3'b001
// NotValidData for Source, SM's Initial state

`define ST_NOTVALIDSRC_1MREADY 3'b010
// NotValidData for Source, SM's 1 MREADY State

`define ST_NOTVALIDSRC_2MREADY 3'b100
// NotValidData for Source, SM's 2 MREADY State

`define ST_NOTVALIDDST_IDLE    3'b001
// NotValidData for Destination, SM's Initial state

`define ST_NOTVALIDDST_1MREADY 3'b010
// NotValidData for Destination, SM's 1 MREADY State

`define ST_NOTVALIDDST_2MREADY 3'b100
// NotValidData for Destination, SM"s 2 MREADY State

`define ST_NOTVALIDLLI_IDLE    3'b001
// NotValidData for LLI, SM's Initial state

`define ST_NOTVALIDLLI_1MREADY 3'b010
// NotValidData for LLI, SM's 1 MREADY State

`define ST_NOTVALIDLLI_2MREADY 3'b100
// NotValidData for LLI, SM's 2 MREADY State

// -----------------------------------------------------------------------------
// Constants used for Disable SM in Channel Block
// -----------------------------------------------------------------------------
`define ST_DISABLE_IDLE        4'b0001
// Disable SM's Initial state

`define ST_DISABLE_OCCRD       4'b0010
// Disable SM's Disabled state

`define ST_DISABLE_SRCACK_RXD  4'b0100
// Disable SM's Source Acknowledge received state

`define ST_DISABLE_DSTACK_RXD  4'b1000
// Disable SM's Destination Acknowledge received state

// -----------------------------------------------------------------------------
// Constants used in Channel Logic module
// -----------------------------------------------------------------------------
`define ZERO_30           30'b0
// 30 bit constant indicating all zero's
 
`define ZERO_14           14'b0
// 14 bit constant indicating all zero's
 
`define ALLONE_14         14'b11111111111111
// 14 bit constant indicating all One's
 
`define ONE_14            14'b00000000000001
// 14 bit constant indicating 1
 
`define TWO_14            14'b00000000000010
// 14 bit constant indicating 2
 
`define FOUR_14           14'b00000000000100
// 14 bit constant indicating 4
 
`define EIGHT_14          14'b00000000001000
// 14 bit constant indicating 8
 
`define SIXTEEN_14        14'b00000000010000
// 14 bit constant indicating 16
 
`define THIRTYTWO_14      14'b00000000100000
// 14 bit constant indicating 32
 
`define SIXTYFOUR_14      14'b00000001000000
// 14 bit constant indicating 64
 
`define ONETWOEIGHT_14    14'b00000010000000
// 14 bit constant indicating 128
 
`define TWOFIVESIX_14     14'b00000100000000
// 14 bit constant indicating 256

// -----------------------------------------------------------------------------
// Constants used in Grant generation module
// -----------------------------------------------------------------------------
`define GRANT_IDLE        3'b001
`define GRANT_ON          3'b010
`define GRANT_OFF         3'b100
 
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
// Memory and Peripheral Address range Definitions
// -----------------------------------------------------------------------------
`define M0LOWADDRRANGE   32'h08000000
`define M1LOWADDRRANGE   32'h10000000
`define P0LOWADDRRANGE   32'h18000000
`define P1LOWADDRRANGE   32'h20000000
`define P2LOWADDRRANGE   32'h28000000
`define P3LOWADDRRANGE   32'h30000000
`define P4LOWADDRRANGE   32'h38000000
`define P5LOWADDRRANGE   32'h40000000
`define P6LOWADDRRANGE   32'h48000000
`define P7LOWADDRRANGE   32'h50000000
`define P8LOWADDRRANGE   32'h58000000
`define P9LOWADDRRANGE   32'h60000000
`define P10LOWADDRRANGE  32'h68000000
`define P11LOWADDRRANGE  32'h70000000
`define P12LOWADDRRANGE  32'h78000000
`define P13LOWADDRRANGE  32'h80000000
`define P14LOWADDRRANGE  32'h88000000
`define P15LOWADDRRANGE  32'h90000000

`define M0HIGHADDRRANGE  32'h0FFFFFFF
`define M1HIGHADDRRANGE  32'h17FFFFFF
`define P0HIGHADDRRANGE  32'h1FFFFFFF
`define P1HIGHADDRRANGE  32'h27FFFFFF
`define P2HIGHADDRRANGE  32'h2FFFFFFF
`define P3HIGHADDRRANGE  32'h37FFFFFF
`define P4HIGHADDRRANGE  32'h3FFFFFFF
`define P5HIGHADDRRANGE  32'h47FFFFFF
`define P6HIGHADDRRANGE  32'h4FFFFFFF
`define P7HIGHADDRRANGE  32'h57FFFFFF
`define P8HIGHADDRRANGE  32'h5FFFFFFF
`define P9HIGHADDRRANGE  32'h67FFFFFF
`define P10HIGHADDRRANGE 32'h6FFFFFFF
`define P11HIGHADDRRANGE 32'h77FFFFFF
`define P12HIGHADDRRANGE 32'h7FFFFFFF
`define P13HIGHADDRRANGE 32'h87FFFFFF
`define P14HIGHADDRRANGE 32'h8FFFFFFF
`define P15HIGHADDRRANGE 32'hA7FFFFFF

// -----------------------------------------------------------------------------
// ADDRESS Definitions for peripheral register
// -----------------------------------------------------------------------------
`define ADDR_DMACTRREQREG 8'b00000010
// DMACTrReqReg at offset 0x004
`define ADDR_DMACTRCLRREG 8'b00000011
// DMACTrCLRReg at offset 0x008
`define ADDR_DMACTRTCREG  8'b00000100
// DMACTrTCReg at offset 0x00C

// -----------------------------------------------------------------------------
// The Address definitions for the registers in the DMA controller
// -----------------------------------------------------------------------------
`define ADDR_DMACTCCLR       10'b0000000010
// DMATCINTSTA at offset 0x008

`define ADDR_DMACERRCLR      10'b0000000100
// DMAERRINTSTAT at offset 0x010

`define ADDR_DMACSOFTBREQ    10'b0000001000
// DMASOFTBREQ at offset 0x020

`define ADDR_DMACSOFTSREQ    10'b0000001001
// DMASOFTSREQ at offset 0x024

`define ADDR_DMACSOFTLBREQ   10'b0000001010
// DMASOFTBREQ at offset 0x028

`define ADDR_DMACSOFTLSREQ   10'b0000001011
// DMASOFTSREQ at offset 0x02C

`define ADDR_DMACCONFIG      10'b0000001100
// DMACONFIG at offset 0x030

`define ADDR_DMACSYNC        10'b0000001101
// DMACONFIG at offset 0x034

`define ADDR_DMACC0SRCADDR   10'b0001000000
// DMAC0SRCADDR at offset 0x100

`define ADDR_DMACC0DSTADDR  10'b0001000001
// DMAC0DESTADDR at offset 0x104

`define ADDR_DMACC0LLIReg    10'b0001000010
// DMAC0LLIREG offset 0x108

`define ADDR_DMACC0CONTROL   10'b0001000011
// DMAC0CONTROL at offset 0x10C

`define ADDR_DMACC0CONFIG    10'b0001000100
// DMAC0CONFIG at offset 0x110

`define ADDR_DMACC1SRCADDR   10'b0001001000
// DMAC1SRCADDR at offset 0x120

`define ADDR_DMACC1DSTADDR  10'b0001001001
// DMAC1DESTADDR at offset 0x124

`define ADDR_DMACC1LLIReg    10'b0001001010
// DMAC1LLIREG offset 0x128

`define ADDR_DMACC1CONTROL   10'b0001001011
// DMAC1CONTROLat offset 0x12C

`define ADDR_DMACC1CONFIG    10'b0001001100
// DMAC1CONFIG at offset 0x130

`define ADDR_DMACC2SRCADDR   10'b0001010000
// DMAC2SRCADDR at offset 0x140

`define ADDR_DMACC2DSTADDR  10'b0001010001
// DMAC2DESTADDR at offset 0x144

`define ADDR_DMACC2LLIReg    10'b0001010010
// DMAC2LLIREG offset 0x148

`define ADDR_DMACC2CONTROL   10'b0001010011
// DMAC2CONTROLat offset 0x14C

`define ADDR_DMACC2CONFIG    10'b0001010100
// DMAC2CONFIG at offset 0x150

`define ADDR_DMACC3SRCADDR   10'b0001011000
// DMAC3SRCADDR at offset 0x160

`define ADDR_DMACC3DSTADDR  10'b0001011001
// DMAC3DESTADDR at offset 0x164

`define ADDR_DMACC3LLIReg    10'b0001011010
// DMAC3LLIREG offset 0x168

`define ADDR_DMACC3CONTROL   10'b0001011011
// DMAC3CONTROLat offset 0x16C

`define ADDR_DMACC3CONFIG    10'b0001011100
// DMAC3CONFIG at offset 0x170

`define ADDR_DMACC4SRCADDR   10'b0001100000
// DMAC4SRCADDR at offset 0x180

`define ADDR_DMACC4DSTADDR  10'b0001100001
// DMAC4DESTADDR at offset 0x184

`define ADDR_DMACC4LLIReg    10'b0001100010
// DMAC4LLIREG offset 0x188

`define ADDR_DMACC4CONTROL   10'b0001100011
// DMAC4CONTROLat offset 0x18C

`define ADDR_DMACC4CONFIG    10'b0001100100
// DMAC4CONFIG at offset 0x190

`define ADDR_DMACC5SRCADDR   10'b0001101000
// DMAC5SRCADDR at offset 0x1A0

`define ADDR_DMACC5DSTADDR  10'b0001101001
// DMAC5DESTADDR at offset 0x1A4

`define ADDR_DMACC5LLIReg    10'b0001101010
// DMAC5LLIREG offset 0x1A8

`define ADDR_DMACC5CONTROL   10'b0001101011
// DMAC5CONTROLat offset 0x1AC

`define ADDR_DMACC5CONFIG    10'b0001101100
// DMAC5CONFIG at offset 0x1B0

`define ADDR_DMACC6SRCADDR   10'b0001110000
// DMAC6SRCADDR at offset 0x1C0

`define ADDR_DMACC6DSTADDR  10'b0001110001
// DMAC6DESTADDR at offset 0x1C4

`define ADDR_DMACC6LLIReg    10'b0001110010
// DMAC6LLIREG offset 0x1C8

`define ADDR_DMACC6CONTROL   10'b0001110011
// DMAC6CONTROLat offset 0x1CC

`define ADDR_DMACC6CONFIG    10'b0001110100
// DMAC6CONFIG at offset 0x1D0

`define ADDR_DMACC7SRCADDR   10'b0001111000
// DMAC7SRCADDR at offset 0x1E0

`define ADDR_DMACC7DSTADDR  10'b0001111001
// DMAC7DESTADDR at offset 0x1E4

`define ADDR_DMACC7LLIReg    10'b0001111010
// DMAC7LLIREG offset 0x1E8

`define ADDR_DMACC7CONTROL   10'b0001111011
// DMAC7CONTROLat offset 0x1E8

`define ADDR_DMACC7CONFIG    10'b0001111100
// DMAC7CONFIG at offset 0x1EC

`define ADDR_DMACTCR         10'b0101000000
// DMACTCR at offset 0x500

// -----------------------------------------------------------------------------
// Address declaration for Grant control, Trickbox enable, and Requestors
// -----------------------------------------------------------------------------
`define ADDR_DMACTRREQCFG    19'b0000000000000000000
// DMACTRREQCFG at offset 0x00

`define ADDR_DMACTRGRANTCNT0 19'b0000000000000000001
// DMACTRGNTCNT at offset 0x04

`define ADDR_DMACTRGRANTCNT1 19'b0000000000000000010
// DMACTRGNTCNT at offset 0x08

`define ADDR_DMACTRENB       19'b0000000000000000011
// DMACTRENB at offset 0x0C

`define max_string_len       256
// Max length of string that can be handled by the To_String function 

`define max_token_len      32
// Max length of token that can be handled by the To_String function

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
