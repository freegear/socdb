// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 1998 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
// 
// -----------------------------------------------------------------------------
// Version and Release Control Information:
// 
// File Name           : buswatch.v.rca 
// File Revision       : 1.1 
// 
// Release Information : PrimeCell(TM)-GLOBAL-r8p0-00rel0 
// 
// -----------------------------------------------------------------------------
// Purpose             : APB slave protocol checker module
// --=========================================================================--
 
`timescale 1ns/1ps

module BUSWATCH (BNRES, BCLK, PWRITE, PENABLE, PRDATA, PSEL);

   parameter
      PRDATA_mask = 32'hFFFFFFFF,
      SUPPRESSONRESET = 0,
      MESG_ENB = 0;

   `include "../tbench/timing.v"
    
  input BNRES;
  input BCLK;
  input PWRITE;
  input PENABLE;
  input [31:0] PRDATA;
  input PSEL;

  reg SETUP_VIOL_FLAG, HOLD_VIOL_FLAG;

  wire pread;
  reg RES_STORED, RES_SIG;
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
          if (DATABUS[INDEX] === 1'bx)
            RESULT = 1'b1;
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
          if (DATABUS[INDEX] === 1'bz)
            RESULT = 1'b1;
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

  // Test for data being driven when UUT is not selected 

  always @(posedge (BCLK))
  begin
    if (MESG_ENB && PSEL !== 1 && PRDATA !== 32'h00000000) 
      begin
        $write("%t: PD0R: PRDATA has non-zero value on rising BCLK ", $time);
        $display("when UUT is not selected ");
      end
  end 

  always @(negedge (BCLK))
  begin
    if (MESG_ENB && PSEL !== 1 && PRDATA !== 32'h00000000) 
      begin
        $write("%t: PD0F: PRDATA has non-zero value on falling BCLK ", $time);
        $display("when UUT is not selected ");
      end
  end

  // Test for data going to X or Z

 always @(negedge BNRES)
 begin
   RES_STORED <= 1'b1;
 end 

 always @(posedge BNRES)
 begin
   if (RES_STORED === 1)
     RES_SIG <= 1'b1;
 end

 always @(PRDATA)
 begin
   if (RES_SIG === 1 )
     if (IS_PDATA_X(PRDATA))
       $display("%t: PDX: PRDATA unknown", $time);
     if (IS_PDATA_Z(PRDATA))
       $display("%t: PDZ: PRDATA tristated", $time);
 end 

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
