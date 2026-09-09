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
// File Name              : MmciTrCrc16gen.v.rca
// File Revision          : 1.2
//
// Release Information    : PrimeCell(TM)-PL181-REL1v0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This module is used for computing the CRC16 value
//           while transmitting data and also for verification of the
//           received CRC16 in case of data reception.
//
// --=========================================================================--

`timescale 1ns/1ps

// ----------------------------------------------------------------------------

module MmciTrCrc16gen (
// Inputs
                      MMCICLK,
                      nMMCIRST,
                      CRC16En,
                      DataDirection,
                      MMCIDAT,
// Outputs
                      CRC16,
                      DCrcBufferBit
                      );

// Inputs
input         MMCICLK;        // MMCI Bus Clock
input         nMMCIRST;       // MMCI bus reset
input         CRC16En;        // Data Crc enable
input         DataDirection;  // Data direction bit
input         MMCIDAT;        // MMCI data serial input

// Outputs
output [15:0] CRC16;          // CRC16 computed value
output        DCrcBufferBit;  // Crc buffer bit to counter 1 clk
                              // latency in CRC16 calculation

// Inputs
wire        MMCICLK;          // MMCI Bus Clock
wire        nMMCIRST;         // MMCI bus reset
wire        CRC16En;          // Data Crc enable
wire        DataDirection;    // Data direction bit
wire        MMCIDAT;          // MMCI data serial input

// Outputs
wire [15:0] CRC16;            // CRC16 computed value
wire        DCrcBufferBit;    // Crc buffer bit to counter 1 clk
                              // latency in CRC16 calculation

// -----------------------------------------------------------------------------
//
//                               MmciTrCrc16gen
//                               ==============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//  This module is used in generation of CRC16 required in data
// transmission and reception.This module uses 16 flops and three xor
// gates to generate a 16 bit Crc on the incoming data bits.
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire        DataBit;
// Data bit obtained serially on Data line

wire        ShiftIn;
// Input to the CRC generation logic

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg  [15:0] iCRC16;
// Local copy of the CRC16 output

reg  [15:0] DelCRC16;
// Delayed iCRC16

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
// calculation of CRC for data to be sent, then there exists a two clk
// latency between the transmission of a bit and computation of CRC
// inclusive the transmitted bit.Since the transmission of CRC has to
// commence immediately after the last bit of response a DCrcBufferBit
// is used, which will hold the first bit of crc during the clock the
// last bit of data is being transmitted.When this module is used to
// compute crc for the data being recieved, which will be used only in
// verification, the delayed version of computed crc is given out for
// verification to tackle the one clk latency between the recd bit and
// computation of crc including this bit.
// -----------------------------------------------------------------------------
assign CRC16            = DataDirection == 1'b0 ? DelCRC16 : iCRC16;

// -----------------------------------------------------------------------------
// Computing the Input value to the CRC16 generation logic
// -----------------------------------------------------------------------------
assign DataBit          = MMCIDAT;
assign ShiftIn          = (DataBit == 1'b1 | DataBit == 1'b0) ?
                           DataBit ^ iCRC16[15] : 1'b0;
assign DCrcBufferBit    = iCRC16[14];

// -----------------------------------------------------------------------------
// CRC16 generation process.For incoming bits the crc computation is
// enabled from the start bit till the last bit of crc is received.If
// the computed crc results to zero then the data received is not
// garbled anywhere.For bits, outgoing from the trickbox, crc
// computation is enabled for those bits of response, which excludes
// the crc field and the end bit and at the point where the crc is to be
// transmitted the computed value is transmitted.
// -----------------------------------------------------------------------------
always @(posedge MMCICLK or negedge nMMCIRST)
begin : p_Crc16gen
  if (nMMCIRST ==  1'b0)
     iCRC16           <= 16'h0000;
  else
  begin
    if (CRC16En ==  1'b1)
      begin
        iCRC16[0]        <= ShiftIn;
        iCRC16[4:1]      <= iCRC16[3:0];
        iCRC16[5]        <= ShiftIn ^ iCRC16[4];
        iCRC16[11:6]     <= iCRC16[10:5];
        iCRC16[12]       <= ShiftIn ^ iCRC16[11];
        iCRC16[15:13]    <= iCRC16[14:12];
      end
    else
      iCRC16           <= 16'h0000;
  end
end // p_Crc16gen

// -----------------------------------------------------------------------------
// Sequential process for Delayed CRC16 generation
// -----------------------------------------------------------------------------
always @(posedge MMCICLK or negedge nMMCIRST)
begin : p_DelCrc16
  if (nMMCIRST ==  1'b0)
     DelCRC16         <= 16'h0000;
  else
    begin
      if (CRC16En ==  1'b1)
        DelCRC16         <= iCRC16;
      else
        DelCRC16         <= 16'h0000;
    end
end // p_DelCrc16
endmodule
// --================================== End ==================================--
