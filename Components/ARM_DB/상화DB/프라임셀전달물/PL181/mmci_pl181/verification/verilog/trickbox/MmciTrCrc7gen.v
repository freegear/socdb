// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2000 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : MmciTrCrc7gen.v.rca
// File Revision          : 1.2
//
// Release Information    : PrimeCell(TM)-PL181-REL1v0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This module is used for computing the CRC7 value while
//           transmitting a response and also for verification of the
//           received CRC7 in case of command reception
//
// --=========================================================================--

`timescale 1ns/1ps

// ----------------------------------------------------------------------------

module MmciTrCrc7gen (
// Inputs
                     MMCICLK,
                     nMMCIRST,
                     Crc7En,
                     SendResponse,
                     MMCICMD,
// Outputs
                     CRC7,
                     CrcBufferBit
                     );

// Inputs
input        MMCICLK;      // MMCI Bus clock
input        nMMCIRST;     // MMCI Bus reset
input        Crc7En;       // Crc7 Enable bit
input        SendResponse; // Qualifies response bits
input        MMCICMD;      // MMCI Command line

// Outputs
output [6:0] CRC7;         // Crc value computed
output       CrcBufferBit; // Used to makeup the 2 clk latency b/w
                           // CmdCnt & CRC7
// Inputs
wire       MMCICLK;        // MMCI Bus clock
wire       nMMCIRST;       // MMCI Bus reset
wire       Crc7En;         // Crc7 Enable bit
wire       SendResponse;   // Qualifies response bits
wire       MMCICMD;        // MMCI Command line

// Outputs
wire [6:0] CRC7;           // Crc value computed
wire       CrcBufferBit;   // Used to makeup the 2 clk latency b/w
                           // CmdCnt & CRC7


// -----------------------------------------------------------------------------
//
//                                MmciTrCrc7gen
//                                =============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//   This module is used in generation of CRC7 required in command
// transmission.It uses seven flops and two xor gates to generate the
// 7 bit CRC on the incoming command bits.
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg  [6:0] iCRC7;
// Local copy of the CRC7 output

reg  [6:0] DelCRC7;
// Delayed iCRC7

// -----------------------------------------------------------------------------
// Function declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Connect local copies to output ports.When this module is used for
// calculation of CRC for response to be sent, then there exists a two
// clk latency between the transmission of a bit and computation of CRC
// inclusive the transmitted bit.Since the transmission of CRC has to
// commence immediately after the last bit of response a CrcBufferBit is
// used, which will hold the first bit of crc during the clock the last
// bit of response is being transmitted.When this module is used to
// compute crc for the command being recieved, which will be used only
// in verification, the delayed version of computed crc is given out for
// verification to tackle the one clk latency between the recd bit and
// computation of crc including this bit
// -----------------------------------------------------------------------------
assign CRC7             = SendResponse == 1'b1 ? iCRC7 : DelCRC7;

assign CrcBufferBit     = iCRC7[5];

// -----------------------------------------------------------------------------
// Computing the Input value to the CRC7 generation logic
// -----------------------------------------------------------------------------
//assign ShiftIn         = (MMCICMD == 1'b1 || MMCICMD == 1'b0) ? MMCICMD ^
//                          iCRC7[6] : 1'b0;

// -----------------------------------------------------------------------------
// CRC7 generation process.For incoming bits the crc computation is
// enabled from the start bit till the last bit of crc is received.If
// the computed crc results to zero then the command received is not
// garbled anywhere.For bits, outgoing from the TB, crc computation
// is enabled for those bits of response, which excludes the crc field
// crc field and the end bit and at the point where the crc is to be
// transmitted the computed value is transmitted.
// -----------------------------------------------------------------------------
always @(posedge MMCICLK or negedge nMMCIRST)
begin : p_Crc7gen
  if (nMMCIRST ==  1'b0)
    iCRC7        <= 7'b0000000;
  else
  begin
    if (Crc7En ==  1'b1)
    begin
      iCRC7[0]   <= iCRC7[6] ^ MMCICMD;
      iCRC7[2:1] <= iCRC7[1:0];
      iCRC7[3]   <= iCRC7[2] ^ (iCRC7[6] ^ MMCICMD);
      iCRC7[6:4] <= iCRC7[5:3];
    end
    else
      iCRC7      <= 7'b0000000;
  end
end // p_Crc7gen

// -----------------------------------------------------------------------------
// Sequential process for CRC7 generation
// -----------------------------------------------------------------------------
always @(posedge MMCICLK or negedge nMMCIRST)
begin : p_DelCrc7
  if (nMMCIRST ==  1'b0)
    DelCRC7 <= 7'b0000000;
  else
  begin
   if (Crc7En ==  1'b1)
     DelCRC7 <= iCRC7;
   else
     DelCRC7 <= 7'b0000000;
  end
end // p_DelCrc7

endmodule
// --================================== End ==================================--
