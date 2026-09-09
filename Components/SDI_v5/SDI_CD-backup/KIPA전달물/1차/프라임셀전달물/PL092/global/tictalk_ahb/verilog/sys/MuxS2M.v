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
// File Name              : MuxS2M.v.rca
// File Revision          : 1.1
//
// Release Information    : PrimeCell(TM)-GLOBAL-REL1v3
//
// ---------------------------------------------------------------------
// Purpose :
//           Central multiplexer - signals from slaves to masters
//           Stand-alone module to allow ease of removal if an
//           alternative interconnection scheme is to be used.
//
// --=================================================================--

`timescale 1ns/1ps

module MuxS2M (HCLK, HRESETn, HSELIntMem, HSELExtMem, HSELUUT,
               HSELAPBif, HSELArmTest, HRDATAIntMem, HREADYIntMem,
               HRESPIntMem, HRDATAExtMem, HREADYExtMem, HRESPExtMem,
               HRDATAUUT, HREADYUUT, HRESPUUT, HRDATAAPBif,
               HREADYAPBif, HRESPAPBif, HRDATAArmTest, HREADYArmTest,
               HRESPArmTest, HREADYDefault,
               HRESPDefault, HRDATA, HREADY, HRESP);

  input         HCLK;
  input         HRESETn;
  input         HSELIntMem;
  input         HSELExtMem;
  input         HSELUUT;
  input         HSELAPBif;
  input         HSELArmTest;

  input  [31:0] HRDATAIntMem;
  input         HREADYIntMem;
  input   [1:0] HRESPIntMem;

  input  [31:0] HRDATAExtMem;
  input         HREADYExtMem;
  input   [1:0] HRESPExtMem;

  input  [31:0] HRDATAUUT;
  input         HREADYUUT;
  input   [1:0] HRESPUUT;

  input  [31:0] HRDATAAPBif;
  input         HREADYAPBif;
  input   [1:0] HRESPAPBif;

  input  [31:0] HRDATAArmTest;
  input         HREADYArmTest;
  input   [1:0] HRESPArmTest;

  input         HREADYDefault;
  input   [1:0] HRESPDefault;

  output [31:0] HRDATA;
  output        HREADY;
  output  [1:0] HRESP;

// ---------------------------------------------------------------------
// Constant declarations
// ---------------------------------------------------------------------
// HselReg encoding. This must be extended if more than eight AHB
// peripherals are used in the system.
  `define HSEL_INTMEM  8'b00000001
  `define HSEL_EXTMEM  8'b00000010
  `define HSEL_UUT     8'b00000100
  `define HSEL_APBIF   8'b00001000
  `define HSEL_ARMTEST 8'b00010000

// ---------------------------------------------------------------------
// Signal declarations
// ---------------------------------------------------------------------
  wire  [7:0] HselNext; // HSEL input bus
  reg   [7:0] HselReg;  // HSEL input register
  reg         iHREADY;  // Internal HREADY used as HSEL register enable

  reg  [31:0] HRDATA;   // Registered output signal
  reg   [1:0] HRESP;    // Registered output signal

// ---------------------------------------------------------------------
// Beginning of main code
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// HSEL bus and registers
// ---------------------------------------------------------------------
// The internal HSEL bus is made up of the HSEL inputs and extra
// padding for the bits that are not used.

  assign HselNext = {3'b000,
                     HSELArmTest,
                     HSELAPBif,
                     HSELUUT,
                     HSELExtMem,
                     HSELIntMem};

// Registered HSEL outputs are needed to control the slave output
// multiplexers, as the multiplexers must be switched in the cycle
// after the HSEL signals have been driven.

  always @( negedge (HRESETn) or posedge (HCLK) )
  begin
    if (!HRESETn)
      HselReg <= 8'h00;
    else
    begin
      if (iHREADY)
        HselReg <= HselNext;
    end
  end

// ---------------------------------------------------------------------
// Multiplexers
// ---------------------------------------------------------------------
// Multiplexers controlling read data and responses from slaves to
// masters. When no slaves are selected by the Decoder, the default
// outputs are used to generate the response.
// A default read data value is not strictly required as all reads from
// undefined regions of memory receive an error response, but may aid
// debugging by ensuring that the read data bus is zero when no
// peripherals are being accessed.

  always @(HselReg or HRDATAIntMem or HRDATAExtMem or HRDATAUUT or
           HRDATAAPBif or HRDATAArmTest)
  begin
    case (HselReg)
      `HSEL_INTMEM  : HRDATA = HRDATAIntMem;
      `HSEL_EXTMEM  : HRDATA = HRDATAExtMem;
      `HSEL_UUT     : HRDATA = HRDATAUUT;
      `HSEL_APBIF   : HRDATA = HRDATAAPBif;
      `HSEL_ARMTEST : HRDATA = HRDATAArmTest;
      default       : HRDATA = 32'h0000_0000;
    endcase
  end

  always @(HselReg or HREADYIntMem or HREADYExtMem or HREADYUUT or
           HREADYAPBif or HREADYArmTest or HREADYDefault)
  begin
    case (HselReg)
      `HSEL_INTMEM  : iHREADY = HREADYIntMem;
      `HSEL_EXTMEM  : iHREADY = HREADYExtMem;
      `HSEL_UUT     : iHREADY = HREADYUUT;
      `HSEL_APBIF   : iHREADY = HREADYAPBif;
      `HSEL_ARMTEST : iHREADY = HREADYArmTest;
      default       : iHREADY = HREADYDefault;
    endcase
  end

  assign HREADY = iHREADY;

  always @(HselReg or HRESPIntMem or HRESPExtMem or HRESPUUT or
           HRESPAPBif or HRESPArmTest or HRESPDefault)
  begin
    case (HselReg)
      `HSEL_INTMEM  : HRESP = HRESPIntMem;
      `HSEL_EXTMEM  : HRESP = HRESPExtMem;
      `HSEL_UUT     : HRESP = HRESPUUT;
      `HSEL_APBIF   : HRESP = HRESPAPBif;
      `HSEL_ARMTEST : HRESP = HRESPArmTest;
      default       : HRESP = HRESPDefault;
    endcase
  end

endmodule

// --============================== End ==============================--
