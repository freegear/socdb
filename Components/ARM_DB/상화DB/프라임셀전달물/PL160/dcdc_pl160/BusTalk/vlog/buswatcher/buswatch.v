// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 1999 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
// 
// -----------------------------------------------------------------------------
// Version and Release Control Information:
// 
// File Name           : buswatch.v,v 
// File Revision       : 1.2 
// 
// Release Information : PL160-REL1v1 
// 
// -----------------------------------------------------------------------------
// Purpose             : APB slave protocol checker module
// --=========================================================================--

`timescale 1ns/1ps
 
module BUSWATCH (BNRES, BCLK, PWRITE, PENABLE, PRDATA, PSEL);

   parameter
      PRDATA_mask = 32'hFFFFFFFF,
      SUPPRESSONRESET = 0;

   `include "../tbench/timing.v"
    
  input BNRES;
  input BCLK;
  input PWRITE;
  input PENABLE;
  input [31:0] PRDATA;
  input PSEL;

  reg SETUP_VIOL_FLAG, HOLD_VIOL_FLAG;

  wire pread;
  parameter [1:4] parmesans = 4'b0101;
  time times [1:3];
  
  function  IS_PDATA_X;
 
    input [31:0] DATABUS;
    reg RESULT;
  begin
    RESULT = 1'b0;
    begin : _LOOPLABELEXIT_1
      integer INDEX;
      for (INDEX = 31; INDEX >= 0; INDEX = INDEX - 1)
        begin : _LOOPLABELNEXT_1
          case (DATABUS[INDEX])
            1'bx,1'bx,1'bz,1'bx,1'bx :
              RESULT = 1'b1;
            default  : ;
          endcase
        end
    end
 
    IS_PDATA_X =  RESULT;
  end
  endfunction
 
  function  IS_PDATA_Z;
 
    input [31:0] DATABUS;
    reg RESULT;
  begin
    RESULT = 1'b0;
    begin : _LOOPLABELEXIT_1
      integer INDEX;
      for (INDEX = 31; INDEX >= 0; INDEX = INDEX - 1)
        begin : _LOOPLABELNEXT_1
          case (DATABUS[INDEX])
            1'bz,1'bz,1'bz,1'bz,1'bz :
              RESULT = 1'b1;
            default  : ;
          endcase
        end
    end
 
    IS_PDATA_Z =  RESULT;
  end
  endfunction
 
  
  // --------------------------------------------------------------------------
  //   APB Checking:
  //         *  All output timing parameters are controlled
  //         *  PRDATA driven to a known value on the falling edge of PENABLE
  //         *  PRDATA driven to high impedanceon  the rising edge of PENABLE (writes)
  //            PREAD defined as qualifier for all violation checks
  // --------------------------------------------------------------------------

  // Test for data being driven during peripheral reads
/* -----\/----- EXCLUDED -----\/-----
  
  always @( negedge (PENABLE) )
  begin
    if (!PSEL && !PWRITE && !IS_PDATA_Z (PRDATA))
        $display("%t: PDZF00: PRDATA not tri-stated on read when UUT not selected ",
 	         $time);
    if (!PSEL && PWRITE && !IS_PDATA_Z (PRDATA))
        $display("%t: PDXF01: PRDATA not tri-stated on write when UUT not selected",
 	         $time);
    if (PSEL && !PWRITE && IS_PDATA_Z (PRDATA & PRDATA_mask))
        $display("%t: PDXF10: PRDATA tri-stated on falling edge of PENABLE during read",
 	         $time);
    if (PSEL && PWRITE && !IS_PDATA_Z (PRDATA))
        $display("%t: PDXF11: PRDATA not tri-stated on falling edge of PENABLE during write",
 	         $time);
  end
 -----/\----- EXCLUDED -----/\----- */
 

  // Test for data bus contention during peripheral writes
/* -----\/----- EXCLUDED -----\/-----
  
  always @( posedge (PENABLE) )
  begin
      if (!PSEL && !PWRITE && !IS_PDATA_Z(PRDATA) )
        $display("%t: PDZR00: PRDATA not tri-stated on read when UUT not selected",
	         $time);
      if (!PSEL && PWRITE && !IS_PDATA_Z(PRDATA) )
        $display("%t: PDXR01: PRDATA not tri-stated on write when UUT not selected",
	         $time);
      if (PSEL && !PWRITE && !IS_PDATA_Z(PRDATA) )
        $display("%t: PDZR10: PRDATA not tri-stated on rising edge of PENABLE during read",
	         $time);
      if (PSEL && PWRITE && !IS_PDATA_Z(PRDATA) )
        $display("%t: PDXR11: PRDATA not tri-stated on rising edge of PENABLE during write",
	         $time);

  end
-----/\----- EXCLUDED -----/\----- */

  // pread is general qualifier for read setup and hold checking

  assign pread = PENABLE && PSEL && !PWRITE && (BNRES || SUPPRESSONRESET);

  // Use Verilog system tasks to perform timing checks on peripheral data bus 
  
  specify
  
    specparam Tsetup = `Tclkh - `Tovpdr, Thold = `Tohpdr;
    
    $setup ( PRDATA, posedge BCLK &&& pread, Tsetup, SETUP_VIOL_FLAG);
    $hold  ( posedge BCLK &&& pread, PRDATA, Thold, HOLD_VIOL_FLAG);
 
  endspecify

  always @(SETUP_VIOL_FLAG)
  begin
        $display("Timing Violation: at time:%t: %s", $time,
                 "(Tovpdr) PRDATA valid after rising BCLK during read" );
  end
 
  always @(HOLD_VIOL_FLAG)
  begin
        $display("Timing Violation: at time:%t: %s", $time,
                 "(Tohpdr) PRDATA hold after rising BCLK during read");
  end
 
endmodule

// --================================= End ===================================--
