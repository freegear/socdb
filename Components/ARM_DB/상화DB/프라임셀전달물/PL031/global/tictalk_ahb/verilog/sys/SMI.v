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
// File Name              : SMI.v.rca
// File Revision          : 1.1
//
// Release Information    : PrimeCell(TM)-GLOBAL-REL1v2
//
// ---------------------------------------------------------------------
// Purpose :
//           Synthesizable demonstration of an AMBA static memory
//           interface with configurable wait states (at least 2
//           write wait and up to three read or write waits).
//
// --=================================================================--

`timescale 1ns/1ps

module SMI (HCLK, HRESETn, HADDR, HTRANS, HWRITE, HSIZE, HWDATAin,
            HSELExtMem, HRDATAin, HREADYin, HRDATAout, HREADYout,
            HRESP, Remap, TicRead, XD, XA, XCSN, XOEN, XWEN);

  input HCLK;
  input HRESETn;
  input [31:0] HADDR;
  input [1:0] HTRANS;
  input HWRITE;
  input [2:0] HSIZE;
  input [31:0] HWDATAin;
  input HSELExtMem;
  input [31:0] HRDATAin;
  input HREADYin;

  output [31:0] HRDATAout;
  output HREADYout;
  output [1:0] HRESP;

  input Remap;       // Reset memory map in use
  input TicRead;     // Drive AHB read data onto XD

  inout [31:0] XD;   // External data bus

  output [30:0] XA;  // External address bus
  output [3:0] XCSN; // External chip select
  output XOEN;       // External output enable
  output [3:0] XWEN; // External write enable

// ---------------------------------------------------------------------
// Constant declarations
// ---------------------------------------------------------------------
// Used to set the number of wait states that are inserted for reads
// and writes Writes must have at least 2 wait states to avoid the use
// of a falling edge register to generate the XWEN outputs.
  `define READWAIT  2'b00 // Range 0-3
  `define WRITEWAIT 2'b10 // Range 2-3
  `define ZERO      2'b00

// HTRANS transfer type signal encoding
  `define TRN_IDLE   2'b00
  `define TRN_BUSY   2'b01
  `define TRN_NONSEQ 2'b10
  `define TRN_SEQ    2'b11

// HSIZE transfer type signal encoding
  `define SZ_BYTE 3'b000
  `define SZ_HALF 3'b001
  `define SZ_WORD 3'b010

// HRESP transfer response signal encoding
  `define RSP_OKAY  2'b00
  `define RSP_ERROR 2'b01
  `define RSP_RETRY 2'b10
  `define RSP_SPLIT 2'b11

// XWEN output signal encoding
  `define NONE  4'b1111
  `define WORD  4'b0000
  `define HALF1 4'b0011
  `define HALF0 4'b1100
  `define BYTE3 4'b0111
  `define BYTE2 4'b1011
  `define BYTE1 4'b1101
  `define BYTE0 4'b1110

// ---------------------------------------------------------------------
// Signal declarations
// ---------------------------------------------------------------------
  reg         HselReg;     // HSELExtMem register
  wire        Valid;       // Module currently selected and valid
  wire        ValidReg;    // Module was selected with valid transfer

  wire        ACRegEn;     // Enable for holding registers
  reg  [31:0] HaddrReg;
  reg   [1:0] HtransReg;
  reg         HwriteReg;
  reg   [2:0] HsizeReg;

  wire  [1:0] NextWait;    // Wait counter
  reg   [1:0] CurrentWait;

  wire        HreadyNext;  // HREADYout register input
  reg         iHREADYout;
  wire        XwenEn;      // Enable for XwenNext
  wire  [3:0] XwenNext;    // XWEN register input
  wire [31:0] XdInt;       // Data out latch
  wire        iXOEN;       // Output enable
  wire        XdEn;        // Data out enable
  reg   [3:0] XcsnNext;    // XCSN register input

  reg   [3:0] XWEN;        // Registered output signal
  reg   [3:0] XCSN;        // Registered output signal

// ---------------------------------------------------------------------
// Beginning of main code
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Valid transfer detection
// ---------------------------------------------------------------------
// The slave must only respond to a valid transfer, so this must be
// detected.

  always @( negedge (HRESETn) or posedge (HCLK) )
  begin
    if ((!HRESETn))
      HselReg <= 1'b0;
    else
    begin
      if (HREADYin)
        HselReg <= HSELExtMem;
    end
  end

// Valid AHB transfers only take place when a non-sequential or
// sequential transfer is shown on HTRANS - an idle or busy transfer
// should be ignored.

  assign Valid = ((HSELExtMem == 1'b1 && HREADYin == 1'b1 &&
                   (HTRANS == `TRN_NONSEQ || HTRANS == `TRN_SEQ)) ?
                 1'b1 : 1'b0);

  assign ValidReg = (HselReg == 1'b1 && (HtransReg == `TRN_NONSEQ ||
                                         HtransReg == `TRN_SEQ) ?
                    1'b1 : 1'b0);

// ---------------------------------------------------------------------
// Address and control registers
// ---------------------------------------------------------------------
// Registers are used to store the address and control signals from the
// address phase for use in the data phase of the transfer.
// Only enabled when the HREADYin input is HIGH and the module is
// addressed.

  assign ACRegEn = HSELExtMem & HREADYin;

  always @( negedge (HRESETn) or posedge (HCLK) )
  begin
    if ((!HRESETn))
    begin
      HaddrReg <= 32'h0000_0000;
      HtransReg <= 2'b00;
      HwriteReg <= 1'b0;
      HsizeReg <= 3'b000;
    end
    else
    begin
      if (ACRegEn)
      begin
        HaddrReg <= HADDR;
        HtransReg <= HTRANS;
        HwriteReg <= HWRITE;
        HsizeReg <= HSIZE;
      end
    end
  end

// ---------------------------------------------------------------------
// Wait state counter
// ---------------------------------------------------------------------
// Generates count signal depending on the values set in the constants
//  READWAIT and WRITEWAIT, which are decremented to zero.
// Wait states are inserted when CurrentWait is not equal to ZERO.

  assign NextWait = (iHREADYout == 1'b1 && Valid == 1'b1 &&
                     HWRITE == 1'b0 ? `READWAIT :
                    (iHREADYout == 1'b1 && Valid == 1'b1 &&
                     HWRITE == 1'b1 ? `WRITEWAIT :
                    (CurrentWait == `ZERO ? `ZERO :
                    CurrentWait - 1'b1)));

  always @( negedge (HRESETn) or posedge (HCLK) )
  begin
    if (!HRESETn)
      CurrentWait <= `ZERO;
    else
      CurrentWait <= NextWait;
  end

// ---------------------------------------------------------------------
// Output data bus generation
// ---------------------------------------------------------------------
// HRDATAout driven to XD during a read transfer, and to zero at all
// other times

  assign HRDATAout = (iXOEN == 1'b0 ? XD : 32'h0000_0000);

// ---------------------------------------------------------------------
// iHREADYout generation
// ---------------------------------------------------------------------
// HREADYout is generated from the value of NextWait, and is stored in
// a register to improve the output timing.

  assign HreadyNext = (NextWait == `ZERO ? 1'b1 : 1'b0);

  always @( negedge (HRESETn) or posedge (HCLK) )
  begin
    if ((!HRESETn))
      iHREADYout <= 1'b0;
    else
      iHREADYout <= HreadyNext;
  end

// ---------------------------------------------------------------------
// XdInt generation
// ---------------------------------------------------------------------
// Directly driven by HWDATAin during a normal write transfer, or by
// HRDATAin during TIC testing when TicRead is set HIGH.

  assign XdInt = ((HwriteReg == 1'b1 && TicRead == 1'b0) ? HWDATAin :
                 (TicRead == 1'b1 ? HRDATAin :
                 32'h0000_0000));

// ---------------------------------------------------------------------
// XcsnNext generation
// ---------------------------------------------------------------------
// Decodes the chip enable signals from the current transfer address.
// Before the system memory is remapped, the boot ROM (at address
// 0x30000000) is also mapped at address 0x00000000. RAM is accessed as
// normal.
// Extra banks of memory can be added by increasing the size of the
// XCSN output and altering the address decoding to select the new
// memory.

  always @(Valid or Remap or HADDR)
  begin
    if ((Valid && !Remap))
      case (HADDR[29:28])
        2'b00   : XcsnNext = 4'b0111; // 0x30000000
        2'b01   : XcsnNext = 4'b1101; // 0x10000000
        2'b10   : XcsnNext = 4'b1011; // 0x20000000
        2'b11   : XcsnNext = 4'b0111; // 0x30000000
        default : XcsnNext = 4'b1111;
      endcase
    else if (Valid)
      case (HADDR[29:28])
        2'b00   : XcsnNext = 4'b1110; // 0x00000000
        2'b01   : XcsnNext = 4'b1101; // 0x10000000
        2'b10   : XcsnNext = 4'b1011; // 0x20000000
        2'b11   : XcsnNext = 4'b0111; // 0x30000000
        default : XcsnNext = 4'b1111;
      endcase
    else
      XcsnNext = 4'b1111;
  end

// ---------------------------------------------------------------------
// iXOEN generation
// ---------------------------------------------------------------------
// Output enable generated during reads from memory.

  assign iXOEN = (ValidReg == 1'b1 && HwriteReg == 1'b0 ? 1'b0 : 1'b1);

// ---------------------------------------------------------------------
// XWEN generation
// ---------------------------------------------------------------------
// Memory write enable generated from registered HSIZE and address.
// Enabled while the external memory is addressed and when no more wait
// states are to be inserted. Set to X when transfer sizes greater than
// 32 bits (word) are performed.

  assign XwenEn = ((ValidReg == 1'b1 && HwriteReg == 1'b1 &&
                    NextWait == 2'b01) ? 1'b1 : 1'b0);

  assign XwenNext = (XwenEn == 1'b1 && HsizeReg == `SZ_WORD ? `WORD :
                    (XwenEn == 1'b1 && HsizeReg == `SZ_HALF &&
                                       HaddrReg[1] == 1'b1 ? `HALF1 :
                    (XwenEn == 1'b1 && HsizeReg == `SZ_HALF &&
                                       HaddrReg[1] == 1'b0 ? `HALF0 :
                    (XwenEn == 1'b1 && HsizeReg == `SZ_BYTE &&
                                       HaddrReg[1:0] == 2'b11 ? `BYTE3 :
                    (XwenEn == 1'b1 && HsizeReg == `SZ_BYTE &&
                                       HaddrReg[1:0] == 2'b10 ? `BYTE2 :
                    (XwenEn == 1'b1 && HsizeReg == `SZ_BYTE &&
                                       HaddrReg[1:0] == 2'b01 ? `BYTE1 :
                    (XwenEn == 1'b1 && HsizeReg == `SZ_BYTE &&
                                       HaddrReg[1:0] == 2'b00 ? `BYTE0 :
                    `NONE)))))));

// ---------------------------------------------------------------------
// XD Output enable
// ---------------------------------------------------------------------
// Output enable signal used to enable the output data bus to be driven.

  assign XdEn = ((iXOEN & HwriteReg) | TicRead);

// ---------------------------------------------------------------------
// Tristate output drivers
// ---------------------------------------------------------------------
// Tristate outputs for XD.

  assign XD = (XdEn == 1'b1 ? XdInt : 32'hzzzz_zzzz);

// ---------------------------------------------------------------------
// External bus output port drivers
// ---------------------------------------------------------------------
// XA is always driven with the previous value of HADDR stored in
// HaddrReg.

  assign XA = HaddrReg[30:0];

// Output port driven with internal value.

  assign XOEN = iXOEN;

// Registered output chip select lines

  always @( negedge (HRESETn) or posedge (HCLK) )
  begin
    if (!HRESETn)
      XCSN <= 4'b1111;
    else
    begin
      if (HREADYin)
        XCSN <= XcsnNext;
    end
  end

// Registered XWEN to avoid glitches on the outputs

  always @( negedge (HRESETn) or posedge (HCLK) )
  begin
    if (!HRESETn)
      XWEN <= `NONE;
    else
      XWEN <= XwenNext;
  end

// ---------------------------------------------------------------------
// Slave response output drivers
// ---------------------------------------------------------------------
// Drive the output ports with the internal versions.

  assign HREADYout = iHREADYout;
  assign HRESP     = `RSP_OKAY;


endmodule

// --============================== End ==============================--
