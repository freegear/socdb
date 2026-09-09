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
// File Name              : apbmux.v.rca
// File Revision          : 1.4
//
// Release Information    : PrimeCell(TM)-PL011-REL1v3
//
// ---------------------------------------------------------------------
// Purpose : Mux for APB Data Reads
//
// --=================================================================--

`timescale 1ns/1ps

module apbmux (
       PCLK,
       PRESETn,
       PSEL,
       PSELT,
       PRData0,
       PRData1,
       PRData
       );

// Set this define to 0 if the PRDATA checking has to be disabled.
`define DATA_CHECK 1'b0

input         PCLK;
input         PRESETn;
input         PSEL;
input         PSELT;
input  [31:0] PRData0;
input  [31:0] PRData1;

output [31:0] PRData;

wire   [31:0] PRData0;
wire   [31:0] PRData1;

reg    [31:0] PRData;
reg           RES_STORED;
reg           RES_SIG;

wire    [1:0] MuxSel;

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

assign MuxSel = {PSELT, PSEL};

always @ (MuxSel or PRData0 or PRData1)  
begin : p_DataMux
  case (MuxSel)
    2'b00   : PRData = 32'h00000000; 
    2'b01   : PRData = PRData0;
    2'b10   : PRData = PRData1;
    default : PRData = 32'h00000000;
  endcase
 
  if (MuxSel == 2'b11)
   $display("Error !! PSEL and PSELT asserted at the same time : '%0d'",
              $time); 
end // p_DataMux;

always @(negedge PRESETn)
begin
  RES_STORED <= 1'b1;
end
 
always @(posedge PRESETn)
begin
  if (RES_STORED === 1)
    RES_SIG <= 1'b1;
end

// Test for data being driven when UUT is not selected
always @(posedge (PCLK))
begin
  if (RES_SIG === 1'b1 && `DATA_CHECK && PSEL !== 1 &&
      PRData0 !== 32'h00000000)
     begin
       $write("%t: PD0R: PRDATA has non-zero value on rising PCLK ", 
                                                                 $time);
       $display("when UUT is not selected ");
     end
end
 
always @(negedge (PCLK))
begin
  if (RES_SIG === 1'b1 && `DATA_CHECK && PSEL !== 1 &&
      PRData0 !== 32'h00000000)
    begin
      $write("%t: PD0F: PRDATA has non-zero value on falling PCLK ", 
                                                                $time); 
      $display("when UUT is not selected");
    end
end

// Test for data being driven when Trickbox is not selected
always @(posedge (PCLK))
begin
  if (RES_SIG === 1'b1 &&`DATA_CHECK && PSELT !== 1 && 
      PRData1 !== 32'h00000000)
    begin
      $write("%t: PD0R: PRDATA has non-zero value on rising PCLK ", 
                                                                 $time);
      $display("when Trickbox is not selected");
    end
end
 
always @(negedge (PCLK))
begin
  if (RES_SIG === 1'b1 && `DATA_CHECK && PSELT !== 1 &&
      PRData1 !== 32'h00000000)
    begin
      $write("%t: PD0F: PRDATA has non-zero value on falling PCLK ", 
                                                                 $time);
      $display("when Trickbox is not selected");
    end
end
 
endmodule

// --============================== End ==============================--
