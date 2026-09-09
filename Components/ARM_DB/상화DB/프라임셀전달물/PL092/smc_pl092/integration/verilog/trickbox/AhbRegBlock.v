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
// File Name              : AhbRegBlock.v.rca
// File Revision          : 1.6
//
// Release Information    : PrimeCell(TM)-PL092-REL1v1
//
// -----------------------------------------------------------------------------
// Purpose :
//           This module implements registers and memory arrays. 
//
// --=========================================================================--
 
`timescale 1ns/1ps
 
// -----------------------------------------------------------------------------

module AhbRegBlock (
                    HCLK,
                    HRESETn,
                    HWRITEdlyInt,
                    HREADYIn,
                    WrEn,
                    RdEn,
                    HSELdlyInt,
                    ARRAY1Sel,
                    ARRAY2Sel,
                    WSCReg1Sel,
                    WSCReg2Sel,
                    CRSel,
                    TMRegSel,
                    XRDlyRegSel,
                    BYTE0En,
                    BYTE1En,
                    BYTE2En,
                    BYTE3En,
                    BYTE4En,
                    BYTE5En,
                    BYTE6En,
                    BYTE7En,
                    HADDRdlyInt,
                    HSIZEdlyInt,
                    HWDATAdly,
                    WSCReg1,
                    WSCReg2,
                    CR,
                    TMReg,
                    XRDlyReg,
                    HRDATAOut
                   );

input          HCLK;            // AHB Clock Signal
input          HRESETn;         // AHB Reset Signal
input          HWRITEdlyInt;    // AHB Read/Write Signal
input          HREADYIn;        // AHB HREADY Signal 
input          WrEn;            // Write Enable Signal
input          RdEn;            // Read Enable Signal
input          HSELdlyInt;      // Device Select Signal 
input          ARRAY1Sel;       // ARRAY1 Select Signal
input          ARRAY2Sel;       // ARRAY2 Select Signal
input          WSCReg1Sel;      // Wait State Register 1 Select Signal
input          WSCReg2Sel;      // Wait State Register 2 Select Signal
input          CRSel;           // Control Register  Select Signal
input          TMRegSel;        // Timeout Register Select Signal
input          XRDlyRegSel;     // Transfer Delay Register Select Signal
input          BYTE0En;         // Enable signal for 0th Byte in a Double Word
input          BYTE1En;         // Enable signal for 1th Byte in a Double Word
input          BYTE2En;         // Enable signal for 2th Byte in a Double Word
input          BYTE3En;         // Enable signal for 3th Byte in a Double Word
input          BYTE4En;         // Enable signal for 4th Byte in a Double Word
input          BYTE5En;         // Enable signal for 5th Byte in a Double Word
input          BYTE6En;         // Enable signal for 6th Byte in a Double Word
input          BYTE7En;         // Enable signal for 7th Byte in a Double Word
input  [31:0]  HADDRdlyInt;     // Internal AHB Address Bus
input   [2:0]  HSIZEdlyInt;     // AHB Size 
input  [63:0]  HWDATAdly;       // AHB Write Data Bus
output [31:0]  WSCReg1;         // Wait State Register 1
output [31:0]  WSCReg2;         // Wait State Register 2
output [31:0]  CR;              // Control Register
output [31:0]  TMReg;           // Timeout Register
output [31:0]  XRDlyReg;        // Transfr Delay Register 
output [63:0]  HRDATAOut;       // AHB Read Data Bus
// -----------------------------------------------------------------------------
//
//                             AhbRegBlock
//                             ===========
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
// This module writes and reads DAta  into the registers and memory arrays, 
// depending upon the select signals, when HREADYIn is high. Depending upon the 
// endianness, the device has to access the data from the proper data bus lines.
// If the EndianEn bit is set, then data has to be driven only in the lines 
// which is intended to, according to the endianness. Otherwise, HRDATA is 
// driven such that, it is compatible for both endian systems. 
// 
 

// ----------------------------------------------------------------------------
// `define  declarations
// ----------------------------------------------------------------------------
`define DATABUSWIDTH   32 
// Data bus width size

//-----------------------------------------------------------------------------
// Signal Declarations
//-----------------------------------------------------------------------------
integer i; 
//array  MEMARRAY is array[255:0] of [7:0];
// Memory Array of 256 bytes

//-----------------------------------------------------------------------------
// reg  Declarations
//-----------------------------------------------------------------------------
reg [7:0]  ARRAY1A[255:0];
// Memory Block A in Array 1
 
reg [7:0]  ARRAY2A[255:0];
// Memory Block A in Array 2

reg [7:0]  ARRAY1B[255:0];
// Memory Block B in Array 1
 
reg [7:0]  ARRAY2B[255:0];
// Memory Block B in Array 2

reg [7:0]  ARRAY1C[255:0];
// Memory Block C in Array 1
 
reg [7:0]  ARRAY2C[255:0];
// Memory Block C in Array 2

reg  [7:0] ARRAY1D[255:0];
// Memory Block D in Array 1
 
reg  [7:0] ARRAY2D[255:0];
// Memory Block D in Array 2

reg  [7:0] ARRAY1E[255:0];
// Memory Block E in Array 1
 
reg  [7:0] ARRAY2E[255:0];
// Memory Block E in Array 2

reg  [7:0] ARRAY1F[255:0];
// Memory Block F in Array 1
 
reg  [7:0] ARRAY2F[255:0];
// Memory Block F in Array 2

reg  [7:0] ARRAY1G[255:0];
// Memory Block G in Array 1
 
reg  [7:0] ARRAY2G[255:0];
// Memory Block G in Array 2

reg  [7:0] ARRAY1H[255:0];
// Memory Block H in Array 1
 
reg  [7:0] ARRAY2H[255:0];
// Memory Block H in Array 2

reg [31:0] WSCReg1;
// Internal Wait State Counter Register 1
 
reg [31:0] WSCReg2;
// Internal Wait State Counter Register 2

reg [31:0] NextWSCReg1;
// D-input of Wait State Counter Register 1 flip-flop

reg [31:0] NextWSCReg2;
// D-input of Wait State Counter Register 2 flip-flop 

reg [31:0] TMReg;  
// Internal Timeout Register

reg [31:0] NextTMReg;
// D-input of TimeOut Register flip-flop

reg [31:0] XRDlyReg;
// Internal Transfer Delay Register

reg [31:0] NextXRDlyReg;
// D-input of Transfer Delay Register flip-flop
 
reg  [7:0] NextARRAY1A;
// D-input of Array 1A flip-flop

reg  [7:0] NextARRAY1B;
// D-input of Array 1B flip-flop

reg  [7:0] NextARRAY1C;
// D-input of Array 1C flip-flop
 
reg  [7:0] NextARRAY1D;
// D-input of Array 1D flip-flop
 
reg  [7:0] NextARRAY1E;
// D-input of Array 1E flip-flop
 
reg  [7:0] NextARRAY1F;
// D-input of Array 1F flip-flop
 
reg  [7:0] NextARRAY1G;
// D-input of Array 1G flip-flop
 
reg  [7:0] NextARRAY1H;
// D-input of Array 1H flip-flop
 
reg  [7:0] NextARRAY2A;
// D-input of Array 2A flip-flop
 
reg  [7:0] NextARRAY2B;
// D-input of Array 2B flip-flop
 
reg  [7:0] NextARRAY2C;
// D-input of Array 2C flip-flop
 
reg  [7:0] NextARRAY2D;
// D-input of Array 2D flip-flop
 
reg  [7:0] NextARRAY2E;
// D-input of Array 2E flip-flop
 
reg  [7:0] NextARRAY2F;
// D-input of Array 2F flip-flop
 
reg  [7:0] NextARRAY2G;
// D-input of Array 2G flip-flop
 
reg  [7:0] NextARRAY2H;
// D-input of Array 2H flip-flop

reg  [31:0] CR;
// Internal Control Register

reg  [31:0] NextCR;
// D-input to Control Register flip-flop
 
// ----------------------------------------------------------------------------
// Wire declaration
// ----------------------------------------------------------------------------
wire  [7:0] ByteOut;
// Actual Data byte read out in Byte Access mode
  
wire [15:0] HWordOut;
// Actual Half-word read out in Half Word Access mode
 
wire [31:0] WordOut;
// Actual Word read out in Word Access mode
 
wire [63:0] DWordOut; 
// Actual Double Word read out in Double Word Access mode

wire [63:0] ByteDataOut;
// Data read out in Byte Access mode if it is strong Endian System
   
wire [63:0] HWordDataOut;
// Data read out in Half-Word Access mode if it is strong Endian System
 
wire [63:0] WordDataOut;
// Data read out in Word Access mode if it is strong Endian System
 
wire [63:0] Data;
// Double Word Data present in the location being written
 
wire [63:0] NextData;
// Double Word Data input to the location being accessed

wire        BigEndian;
// Denoting BigEndian System

wire        EndianEn;
// Denotes Strong Endian System

wire [63:0] iHRDATAOut;
// Internal HRDATA Output signal

wire        ARRAY1RdEn;
// ARRAY1 Read Enable Signal
 
wire        ARRAY2RdEn;
// ARRAY2 Read Enable Signal
 
wire        ARRAY1WrEn;
// ARRAY1 Write Enable Signal
 
wire        ARRAY2WrEn;
// ARRAY2 Write Enable Signal
 
wire        WSCReg1RdEn;
// Wait State Register 1 Enable Signal
 
wire        WSCReg2RdEn;
// Wait State Register 2 Enable Signal
 
wire        CRRdEn;
// Control Register Read Enable Signal
 
wire        TMRegRdEn;
// TimeOut Reg Read Enable Signal
 
wire        XRDlyRegRdEn;
// Transfer Delay Reg Read Enable

// ----------------------------------------------------------------------------
// Main body of code
// =================
// ----------------------------------------------------------------------------
 
 
// ----------------------------------------------------------------------------
// Assigning the local copy to output
// ----------------------------------------------------------------------------

assign BigEndian    = CR[0];

assign EndianEn     = CR[1];

assign ARRAY1WrEn   = ARRAY1Sel & WrEn;
 
assign ARRAY2WrEn   = ARRAY2Sel &  WrEn;
 
assign ARRAY1RdEn   = ARRAY1Sel & RdEn;
 
assign ARRAY2RdEn   = ARRAY2Sel &  RdEn;
 
assign WSCReg1RdEn  = WSCReg1Sel &  RdEn;
 
assign WSCReg2RdEn  = WSCReg2Sel &  RdEn;
 
assign CRRdEn       = CRSel &  RdEn;
 
assign TMRegRdEn    = TMRegSel &  RdEn;
 
assign XRDlyRegRdEn = XRDlyRegSel &  RdEn;
 
// ----------------------------------------------------------------------------
// Generating HRDATA 
// Negated HRDATA is sent out if Forced Error bit for HRDATA is set
// Otherwise Internal HRDATA generated is fed out if any of the Device 
// address is selected for reading.
// ----------------------------------------------------------------------------
assign HRDATAOut = ((HREADYIn == 1'b1) & (CR[3] == 1'b1) &
                    (HSELdlyInt == 1'b1) & (RdEn == 1'b1)) ? ~(iHRDATAOut) :
                    ((HREADYIn == 1'b1) & (HSELdlyInt == 1'b1) & 
                    (RdEn == 1'b1)) ? iHRDATAOut : 64'h0000000000000000;
// ----------------------------------------------------------------------------
// Actual Byte being accessed 
// ----------------------------------------------------------------------------
assign  ByteOut = (BYTE0En == 1'b1) ? DWordOut[7:0]   :    
                  (BYTE1En == 1'b1) ? DWordOut[15:8]  :  
                  (BYTE2En == 1'b1) ? DWordOut[23:16] :
                  (BYTE3En == 1'b1) ? DWordOut[31:24] : 
                  (BYTE4En == 1'b1) ? DWordOut[39:32] : 
                  (BYTE5En == 1'b1) ? DWordOut[47:40] : 
                  (BYTE6En == 1'b1) ? DWordOut[55:48] : 
                  (BYTE7En == 1'b1) ? DWordOut[63:56] : 
                  1'b0;
// ----------------------------------------------------------------------------
// Actual Half-Word being accessed
// ----------------------------------------------------------------------------
assign  HWordOut = (BYTE0En == 1'b1) ? DWordOut[15:0]   : 
                   (BYTE2En == 1'b1) ? DWordOut[31:16]  :
                   (BYTE4En == 1'b1) ? DWordOut[47:32]  :
                   (BYTE6En == 1'b1) ? DWordOut[63:48]  :
                   1'b0;
// ----------------------------------------------------------------------------
// Actual Word being accessed
// ----------------------------------------------------------------------------
assign   WordOut = (BYTE4En == 1'b1) ? DWordOut[63:32] : 
                   (BYTE0En == 1'b1) ? DWordOut[31:0]  : 
                   1'b0;
// ----------------------------------------------------------------------------
// Actual ByteData being fed out in a strong Endian system 
// ----------------------------------------------------------------------------
assign ByteDataOut[7:0] = (((BigEndian == 1'b0) &
                          ((BYTE0En == 1'b1) || ((BYTE4En == 1'b1) & 
                          (`DATABUSWIDTH == 32)))) || 
                          ((BigEndian == 1'b1) &((BYTE7En == 1'b1) || 
                          ((`DATABUSWIDTH == 32) & 
                          (BYTE3En == 1'b1))))) ? ByteOut : 1'b0;
 
assign ByteDataOut[15:8] = (((BigEndian == 1'b0) &
                           ((BYTE1En == 1'b1) || ((BYTE5En == 1'b1) & 
                           (`DATABUSWIDTH == 32)))) || 
                           ((BigEndian == 1'b1)&((BYTE6En == 1'b1) || 
                           ((`DATABUSWIDTH == 32) & 
                           (BYTE2En == 1'b1))))) ? ByteOut : 1'b0;

assign ByteDataOut[23:16] = (((BigEndian == 1'b0) &
                            ((BYTE2En == 1'b1) || ((BYTE6En == 1'b1) & 
                            (`DATABUSWIDTH == 32)))) || 
                            ((BigEndian == 1'b1)&((BYTE5En == 1'b1) || 
                            ((`DATABUSWIDTH == 32) &
                            (BYTE1En == 1'b1))))) ? ByteOut : 1'b0;

assign  ByteDataOut[31:24] = (((BigEndian == 1'b0) &
                             ((BYTE3En == 1'b1) || ((BYTE7En == 1'b1) & 
                             (`DATABUSWIDTH == 32)))) || 
                             (((BigEndian == 1'b1) & 
                             ((BYTE4En == 1'b1) || 
                             ((`DATABUSWIDTH == 32) & 
                             (BYTE0En == 1'b1)))))) ? ByteOut : 1'b0;

assign  ByteDataOut[39:32] = ((`DATABUSWIDTH == 64) &
                             (((BYTE3En == 1'b1) & 
                             (BigEndian == 1'b1)) || ((BYTE4En == 1'b1)
                             & (BigEndian == 1'b0)))) ? ByteOut : 1'b0;

assign  ByteDataOut[47:40] = ((`DATABUSWIDTH == 64) &
                             (((BYTE2En == 1'b1) & 
                             (BigEndian == 1'b1)) || 
                             ((BYTE5En == 1'b1) & 
                             (BigEndian == 1'b0)))) ? ByteOut : 1'b0;

assign  ByteDataOut[55:48] = ((`DATABUSWIDTH == 64) &
                             (((BYTE1En == 1'b1) & 
                             (BigEndian == 1'b1)) || 
                             ((BYTE6En == 1'b1) & 
                             (BigEndian == 1'b0)))) ? ByteOut : 1'b0;

assign  ByteDataOut[63:56] = ((`DATABUSWIDTH == 64) &
                             (((BYTE0En == 1'b1) & 
                             (BigEndian == 1'b1))
                             || ((BYTE7En == 1'b1) & 
                             (BigEndian == 1'b0)))) ? ByteOut : 1'b0;

// ----------------------------------------------------------------------------
// Actual Half-Word Data being fed out in a strong Endian system
// ----------------------------------------------------------------------------
assign  HWordDataOut[15:0] = (((BigEndian == 1'b0) &
                             ((BYTE0En == 1'b1) || ((BYTE4En == 1'b1) & 
                             (`DATABUSWIDTH == 32)))) || 
                             ((BigEndian == 1'b1) &
                             ((BYTE6En == 1'b1) || ((BYTE2En == 1'b1) & 
                             (`DATABUSWIDTH == 32))))) ? HWordOut : 1'b0;

assign  HWordDataOut[31:16] = (((BigEndian == 1'b0) &
                              ((BYTE1En == 1'b1) || ((BYTE6En == 1'b1) & 
                              (`DATABUSWIDTH == 32)))) || 
                              ((BigEndian == 1'b1) &
                              ((BYTE4En == 1'b1) || ((BYTE0En == 1'b1) & 
                              (`DATABUSWIDTH == 32))))) ? HWordOut : 1'b0;

assign  HWordDataOut[47:32] = ((`DATABUSWIDTH == 64) &
                              (((BigEndian == 1'b1) &
                              (BYTE2En == 1'b1)) || 
                              ((BYTE4En == 1'b1) &
                              (BigEndian == 1'b0)))) ? HWordOut : 1'b0;

assign  HWordDataOut[63:48] = ((`DATABUSWIDTH == 64) &
                              (((BigEndian == 1'b1) &
                              (BYTE0En == 1'b1)) || 
                              ((BYTE6En == 1'b1) &
                              (BigEndian == 1'b0)))) ? HWordOut : 1'b0;
// ----------------------------------------------------------------------------
// Actual Word Data being fed out in a strong Endian system
// ----------------------------------------------------------------------------
assign  WordDataOut [63:32] = ((`DATABUSWIDTH == 64) &
                              (((BigEndian == 1'b1) &
                              (BYTE0En == 1'b1)) || 
                              ((BYTE4En == 1'b1) &
                              (BigEndian == 1'b0)))) ? WordOut : 1'b0;

assign  WordDataOut[31:0]  = (((BigEndian == 1'b0) &
                             ((BYTE0En == 1'b1) || ((BYTE4En == 1'b1) & 
                             (`DATABUSWIDTH == 32)))) || 
                             ((BigEndian == 1'b1) &
                             ((BYTE4En == 1'b1) || ((BYTE0En == 1'b1) & 
                             (`DATABUSWIDTH == 32))))) ? WordOut : 1'b0;
// ----------------------------------------------------------------------------
// Internal HRDATA being fed out depending upon HSIZE & Strong Endianness 
// ----------------------------------------------------------------------------
assign  iHRDATAOut = ((HSIZEdlyInt == 'b000) & (EndianEn == 1'b1)) ? 
                     ByteDataOut : 
                     ((HSIZEdlyInt == 'b000) & (EndianEn == 1'b0)) ?
                     {ByteOut,ByteOut, ByteOut, ByteOut, 
                      ByteOut,ByteOut, ByteOut, ByteOut} : 
                     ((HSIZEdlyInt == 'b001) & (EndianEn == 1'b1)) ? 
                     HWordDataOut :
                     ((HSIZEdlyInt == 'b001) & (EndianEn == 1'b0)) ? 
                     {HWordOut, HWordOut, HWordOut, HWordOut} :
                     ((HSIZEdlyInt == 'b010) & (EndianEn == 1'b1)) ? 
                     WordDataOut : 
                     ((HSIZEdlyInt == 'b010) & (EndianEn == 1'b0)) ?
                     {WordOut, WordOut} : 
                     (HSIZEdlyInt == 'b011) ? DWordOut : 1'b0;
// -----------------------------------------------------------------------------
// Data input for the location being written into 
// -----------------------------------------------------------------------------
assign  NextData[7:0] = ((BigEndian == 1'b0) &
                        (BYTE0En == 1'b1) & (HREADYIn == 1'b1)) ? 
                        HWDATAdly[7:0] : 
                        ((BYTE0En == 1'b1) &
                        (BigEndian == 1'b1) & (`DATABUSWIDTH == 32) &
                        (HSIZEdlyInt == 3'b001) & (HREADYIn == 1'b1)) ?
                        HWDATAdly[23:16] : 
                        ((BYTE0En == 1'b1) &
                        (BigEndian == 1'b1) & (`DATABUSWIDTH == 32)
                        & (HSIZEdlyInt == 3'b000) & (HREADYIn == 1'b1)) ?
                        HWDATAdly[31:24] : 
                        ((BYTE0En == 1'b1) &
                        (BigEndian == 1'b1) & (`DATABUSWIDTH == 64)
                        & (HSIZEdlyInt == 3'b000) & (HREADYIn == 1'b1))? 
                        HWDATAdly[63:56] : 
                        ((BYTE0En == 1'b1) &
                        (BigEndian == 1'b1) & (`DATABUSWIDTH == 64)
                        & (HSIZEdlyInt == 3'b001) & (HREADYIn == 1'b1))?
                        HWDATAdly[55:48] : 
                        ((BYTE0En == 1'b1) &
                        (BigEndian == 1'b1) & (`DATABUSWIDTH == 64)
                        & (HSIZEdlyInt == 3'b010) & (HREADYIn == 1'b1)) ?
                        HWDATAdly[39:32] : Data[7:0];

assign  NextData[15:8] = ((BigEndian == 1'b0) &
                         (BYTE1En == 1'b1) & (HREADYIn == 1'b1)) ? 
                         HWDATAdly[15:8] : 
                         ((BYTE1En == 1'b1) &
                         (BigEndian == 1'b1) & (`DATABUSWIDTH == 32) &
                         (HSIZEdlyInt == 3'b001) & (HREADYIn == 1'b1)) ? 
                         HWDATAdly[31:24] : 
                         ((BYTE1En == 1'b1) &
                         (BigEndian == 1'b1) & (`DATABUSWIDTH == 32)
                         & (HSIZEdlyInt == 3'b000) & (HREADYIn == 1'b1)) ? 
                         HWDATAdly[23:16] : 
                         ((BYTE1En == 1'b1) &
                         (BigEndian == 1'b1) & (`DATABUSWIDTH == 64)
                         & (HSIZEdlyInt == 3'b000) & (HREADYIn == 1'b1)) ? 
                         HWDATAdly[55:48] : 
                         ((BYTE1En == 1'b1) &
                         (BigEndian == 1'b1) & (`DATABUSWIDTH == 64)
                         & (HSIZEdlyInt == 3'b001) & (HREADYIn == 1'b1)) ? 
                         HWDATAdly[63:56] : 
                         ((BYTE1En == 1'b1) &
                         (BigEndian == 1'b1) & (`DATABUSWIDTH == 64)
                         & (HSIZEdlyInt == 3'b010) & (HREADYIn == 1'b1)) ? 
                         HWDATAdly[47:40] :  Data[15:8];

assign  NextData[23:16] = ((BigEndian == 1'b0) &
                          (BYTE2En == 1'b1) & (HREADYIn == 1'b1)) ? 
                          HWDATAdly[23:16]  :
                          ((BYTE2En == 1'b1) &
                          (BigEndian == 1'b1) & (`DATABUSWIDTH == 32) &
                          (HSIZEdlyInt == 'b001) & (HREADYIn == 1'b1)) ? 
                          HWDATAdly[7:0]  :
                          ((BYTE2En == 1'b1) &
                          (BigEndian == 1'b1) & (`DATABUSWIDTH == 32)
                          & (HSIZEdlyInt == 3'b000) & (HREADYIn == 1'b1)) ? 
                          HWDATAdly[15:8] : 
                          ((BYTE2En == 1'b1) &
                          (BigEndian == 1'b1) & (`DATABUSWIDTH == 64)
                          & (HSIZEdlyInt == 3'b000) & (HREADYIn == 1'b1)) ? 
                          HWDATAdly[47:40] : 
                          ((BYTE2En == 1'b1) &
                          (BigEndian == 1'b1) & (`DATABUSWIDTH == 64)
                          & (HSIZEdlyInt == 3'b001) & (HREADYIn == 1'b1)) ? 
                          HWDATAdly[39:32] : 
                          ((BYTE2En == 1'b1) &
                          (BigEndian == 1'b1) & (`DATABUSWIDTH == 64)
                          & (HSIZEdlyInt == 3'b010) & (HREADYIn == 1'b1)) ? 
                          HWDATAdly[55:48] : 
                          Data[23:16];

assign  NextData[31:24] = ((BigEndian == 1'b0) &
                          (BYTE3En == 1'b1) & (HREADYIn == 1'b1)) ? 
                          HWDATAdly[31:24] : 
                          ((BYTE3En == 1'b1) &
                          (BigEndian == 1'b1) & (`DATABUSWIDTH == 32) &
                          (HSIZEdlyInt == 3'b001) & (HREADYIn == 1'b1)) ? 
                          HWDATAdly[15:8] : 
                          ((BYTE3En == 1'b1) &
                          (BigEndian == 1'b1) & (`DATABUSWIDTH == 32)
                          & (HSIZEdlyInt == 3'b000) & (HREADYIn == 1'b1)) ? 
                          HWDATAdly[7:0] : 
                          ((BYTE3En == 1'b1) &
                          (BigEndian == 1'b1) & (`DATABUSWIDTH == 64)
                          & (HSIZEdlyInt == 3'b000) & (HREADYIn == 1'b1)) ? 
                          HWDATAdly[39:32] : 
                          ((BYTE3En == 1'b1) &
                          (BigEndian == 1'b1) & (`DATABUSWIDTH == 64)
                          & (HSIZEdlyInt == 3'b001) & (HREADYIn == 1'b1)) ? 
                          HWDATAdly[47:40]  :
                          ((BYTE3En == 1'b1) &
                          (BigEndian == 1'b1) & (`DATABUSWIDTH == 64)
                          & (HSIZEdlyInt == 3'b010) & (HREADYIn == 1'b1)) ? 
                          HWDATAdly[63:56] : Data[31:24];

assign  NextData[39:32] =  ((BigEndian == 1'b0) &
                           (BYTE4En == 1'b1) & (`DATABUSWIDTH == 64) & 
                           (HREADYIn == 1'b1)) ? HWDATAdly[39:32] : 
                            
                           ((((BigEndian == 1'b0) & (`DATABUSWIDTH == 32))
                           || ((BigEndian == 1'b1) & (`DATABUSWIDTH == 64)))
                           & (BYTE4En == 1'b1) & (HREADYIn == 1'b1)) ? 
                           HWDATAdly[7:0] : 
                         
                           ((BYTE4En == 1'b1) &
                           (BigEndian == 1'b1) & (HSIZEdlyInt == 3'b001) & 
                           (HREADYIn == 1'b1)) ? HWDATAdly[23:16] : 
                         
                           ((BYTE4En == 1'b1) &
                           (BigEndian == 1'b1) & (HSIZEdlyInt == 3'b000) & 
                           (HREADYIn == 1'b1)) ? HWDATAdly[31:24] : 
                           Data[39:32];

assign  NextData[47:40] =  ((BigEndian == 1'b0) &
                           (BYTE5En == 1'b1) & (`DATABUSWIDTH == 64) & 
                           (HREADYIn == 1'b1)) ? HWDATAdly[47:40] : 
                         
                           ((((BigEndian == 1'b0) & (`DATABUSWIDTH == 32))
                           || ((BigEndian == 1'b1) & (`DATABUSWIDTH == 64)))
                           & (BYTE5En == 1'b1) & (HREADYIn == 1'b1)) ? 
                           HWDATAdly[15:8] : 
                         
                           ((BYTE5En == 1'b1) &
                           (BigEndian == 1'b1) & (HSIZEdlyInt == 'b001) & 
                           (HREADYIn == 1'b1)) ? HWDATAdly[31:24] : 
                        
                           ((BYTE5En == 1'b1) &
                           (BigEndian == 1'b1) & (HSIZEdlyInt == 'b000) & 
                           (HREADYIn == 1'b1)) ? HWDATAdly[23:16] : 
                           Data[47:40];

assign  NextData[55:48] =  ((BigEndian == 1'b0) &
                           (BYTE6En == 1'b1) & (`DATABUSWIDTH == 64) & 
                           (HREADYIn == 1'b1)) ? HWDATAdly[55:48] : 
                         
                           ((((BigEndian == 1'b0) & (`DATABUSWIDTH == 32))
                           || ((BigEndian == 1'b1) & (`DATABUSWIDTH == 64)))
                           &  (BYTE6En == 1'b1) & (HREADYIn == 1'b1)) ? 
                           HWDATAdly[23:16] :
                         
                           ((BYTE6En == 1'b1) &
                           (BigEndian == 1'b1) & (HSIZEdlyInt == 'b001) & 
                           (HREADYIn == 1'b1)) ? HWDATAdly[31:24] : 
                         
                           ((BYTE6En == 1'b1) &
                           (BigEndian == 1'b1) & (HSIZEdlyInt == 'b000) & 
                           (HREADYIn == 1'b1)) ? HWDATAdly[23:16] : 
                           Data[55:48];

assign  NextData[63:56] =  ((BigEndian == 1'b0) &
                           (BYTE7En == 1'b1) & (`DATABUSWIDTH == 64) & 
                           (HREADYIn == 1'b1)) ? HWDATAdly[63:56] : 
                         
                           ((((BigEndian == 1'b0) & (`DATABUSWIDTH == 32))
                           || ((BigEndian == 1'b1) & (`DATABUSWIDTH == 64)))
                           & (BYTE7En == 1'b1) & (HREADYIn == 1'b1)) ? 
                           HWDATAdly[31:24] : 
                         
                           ((BYTE7En == 1'b1) &
                           (BigEndian == 1'b1) & (HSIZEdlyInt == 'b001) & 
                           (HREADYIn == 1'b1)) ?HWDATAdly[15:8] : 
                         
                           ((BYTE7En == 1'b1) &
                           (BigEndian == 1'b1) & (HSIZEdlyInt == 'b000) & 
                           (HREADYIn == 1'b1)) ? HWDATAdly[7:0] : 
                           Data[63:56];

 
// -------------------------------------------------------------------------
// Read data
// ------------------------------------------------------------------------
assign DWordOut =   (ARRAY1RdEn == 1'b1) ?
                    {ARRAY1H[HADDRdlyInt[10:3]],
                     ARRAY1G[HADDRdlyInt[10:3]],
                     ARRAY1F[HADDRdlyInt[10:3]],
                     ARRAY1E[HADDRdlyInt[10:3]],
                     ARRAY1D[HADDRdlyInt[10:3]],
                     ARRAY1C[HADDRdlyInt[10:3]],
                     ARRAY1B[HADDRdlyInt[10:3]],
                     ARRAY1A[HADDRdlyInt[10:3]]} : 
                     (ARRAY2RdEn == 1'b1) ?
                     {ARRAY2H[HADDRdlyInt[10:3]],
                     ARRAY2G[HADDRdlyInt[10:3]],
                     ARRAY2F[HADDRdlyInt[10:3]],
                     ARRAY2E[HADDRdlyInt[10:3]],
                     ARRAY2D[HADDRdlyInt[10:3]],
                     ARRAY2C[HADDRdlyInt[10:3]],
                     ARRAY2B[HADDRdlyInt[10:3]],
                     ARRAY2A[HADDRdlyInt[10:3]]} :
                     (WSCReg1RdEn == 1'b1) ?
                     {32'h00000000, WSCReg1} : 
                     (WSCReg2RdEn == 1'b1) ? 
                     {WSCReg2, 32'h00000000 } :
                     (CRRdEn == 1'b1) ?
                     {32'h00000000, CR } :
                     (TMRegRdEn == 1'b1) ?
                     {TMReg, 32'h00000000 }  : 
                     (XRDlyRegRdEn == 1'b1) ?
                     {32'h00000000, XRDlyReg }: 64'h0000000000000000;

assign      Data[63:0]   = (ARRAY1WrEn == 1'b1) ?
                           {ARRAY1H[HADDRdlyInt[10:3]],
                            ARRAY1G[HADDRdlyInt[10:3]],
                            ARRAY1F[HADDRdlyInt[10:3]],
                            ARRAY1E[HADDRdlyInt[10:3]],
                            ARRAY1D[HADDRdlyInt[10:3]],
                            ARRAY1C[HADDRdlyInt[10:3]],
                            ARRAY1B[HADDRdlyInt[10:3]],
                            ARRAY1A[HADDRdlyInt[10:3]] } :
                           (ARRAY2WrEn == 1'b1) ? 
                           {ARRAY2H[HADDRdlyInt[10:3]],
                            ARRAY2G[HADDRdlyInt[10:3]],
                            ARRAY2F[HADDRdlyInt[10:3]],
                            ARRAY2E[HADDRdlyInt[10:3]],
                            ARRAY2D[HADDRdlyInt[10:3]],
                            ARRAY2C[HADDRdlyInt[10:3]],
                            ARRAY2B[HADDRdlyInt[10:3]],
                            ARRAY2A[HADDRdlyInt[10:3]] } :
                            ((WSCReg1Sel == 1'b1) & (WrEn == 1'b1)) ? 
                            {32'h00000000, WSCReg1} : 
                            ((WSCReg2Sel == 1'b1) & (WrEn == 1'b1)) ? 
                            {32'h00000000, WSCReg2} :
                            ((CRSel == 1'b1) & (WrEn == 1'b1)) ?
                            {32'h00000000, CR} :
                            ((TMRegSel == 1'b1) & (WrEn == 1'b1)) ?
                            {32'h00000000, TMReg} :
                            ((XRDlyRegSel == 1'b1) & (WrEn == 1'b1)) ?
                            {32'h00000000, XRDlyReg} : 64'h0000000000000000;
  

// -----------------------------------------------------------------------------
// Latching Data into the Arrays & registers
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_WrSeq 
 
  if (HRESETn == 1'b0)
    begin
      WSCReg1  <= 32'h00000000;
      WSCReg2  <= 32'h00000000;
      CR       <= 32'h00000000;
      TMReg    <= 32'h00000000; 
      XRDlyReg <= 32'h00000000;
      for (i = 0; i<= 255; i = i + 1) 
      begin 
        ARRAY1A[i]  <= 8'b00000000;
        ARRAY2A[i]  <= 8'b00000000; 
        ARRAY1B[i]  <= 8'b00000000; 
        ARRAY2B[i]  <= 8'b00000000; 
        ARRAY1C[i]  <= 8'b00000000; 
        ARRAY2C[i]  <= 8'b00000000; 
        ARRAY1D[i]  <= 8'b00000000;
        ARRAY2D[i]  <= 8'b00000000; 
        ARRAY1E[i]  <= 8'b00000000; 
        ARRAY2E[i]  <= 8'b00000000; 
        ARRAY1F[i]  <= 8'b00000000; 
        ARRAY2F[i]  <= 8'b00000000; 
        ARRAY1G[i]  <= 8'b00000000; 
        ARRAY2G[i]  <= 8'b00000000; 
        ARRAY1H[i]  <= 8'b00000000; 
        ARRAY2H[i]  <= 8'b00000000; 
      end 
    end 
  else 
    begin
 
      if ((HREADYIn == 1'b1) & (ARRAY1WrEn == 1'b1))
        begin
          ARRAY1A[HADDRdlyInt[10:3]] <= NextData[7:0];
          ARRAY1B[HADDRdlyInt[10:3]] <= NextData[15:8];
          ARRAY1C[HADDRdlyInt[10:3]] <= NextData[23:16];
          ARRAY1D[HADDRdlyInt[10:3]] <= NextData[31:24];
          ARRAY1E[HADDRdlyInt[10:3]] <= NextData[39:32];
          ARRAY1F[HADDRdlyInt[10:3]] <= NextData[47:40];
          ARRAY1G[HADDRdlyInt[10:3]] <= NextData[55:48];
          ARRAY1H[HADDRdlyInt[10:3]] <= NextData[63:56];
        end
 
      if ((HREADYIn == 1'b1) & (ARRAY2WrEn == 1'b1))
        begin
          ARRAY2A[HADDRdlyInt[10:3]] <= NextData[7:0];
          ARRAY2B[HADDRdlyInt[10:3]] <= NextData[15:8];
          ARRAY2C[HADDRdlyInt[10:3]] <= NextData[23:16];
          ARRAY2D[HADDRdlyInt[10:3]] <= NextData[31:24];
          ARRAY2E[HADDRdlyInt[10:3]] <= NextData[39:32];
          ARRAY2F[HADDRdlyInt[10:3]] <= NextData[47:40];
          ARRAY2G[HADDRdlyInt[10:3]] <= NextData[55:48];
          ARRAY2H[HADDRdlyInt[10:3]] <= NextData[63:56];
        end
 
      if ((HREADYIn == 1'b1) & (WSCReg1Sel == 1'b1) & (WrEn == 1'b1))
        WSCReg1 <= NextData[31:0];
   
      if ((HREADYIn == 1'b1) & (WSCReg2Sel == 1'b1) & (WrEn == 1'b1))
        WSCReg2 <= NextData[63:32];
 
      if ((HREADYIn == 1'b1) & (CRSel == 1'b1) & (WrEn == 1'b1))
        CR <= NextData[31:0];
 
      if ((HREADYIn == 1'b1) & (TMRegSel == 1'b1) & (WrEn == 1'b1))
        TMReg <= NextData[63:32];
 
       if ((HREADYIn == 1'b1) & (XRDlyRegSel == 1'b1) & (WrEn == 1'b1))
        XRDlyReg <= NextData[31:0];
    end      
end // p_WrSeq;

endmodule
 
// --================================ END ====================================--
