//////////////////////////////////////////////////////////////////////////////////
// TITLE :                 I2C MicroProcessor Model
// FILE NAME :             i2cm_up_model.vhd
// AUTHER :                Jinil Chung (jichung@konkuk.ac.kr)
// ORGANIZATION :          Konkuk Univ. VLSI Design Lab.
// CREATED :               December 14, 2002
// LAST UPDATED :          December 14, 2002
// PLATFORM :              MS Windows 2000 professional
// SIMULATOR :             ModelSim SE 5.5c
// SYNTHESIZER :           Synplify pro 7.0
// TARGET :                FPGA (ALTERA EPF10K10TC144-3)
// DISCRIPTION :           This module defines I2C MicroProcessor Model
// REVISION NUMBER :       -
// VERSION NUMBER :        1.0
// DATE OF CHANGE :        -
// MODIFIEER :             -
// DESCRIPTION OF CHANGE : -
// NOTICE :                -
//////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////
// I2C MicroProcessor Model
//////////////////////////////////////////////////////////////////////////////////
//
//
//////////////////////////////////////////////////////////////////////////////////

`timescale 1 ns /10 ps


module i2cm_up_model (clk, rst_n, din, ack, err, rty, addr, dout, cyc, stb, we, sel) ;

parameter DWIDTH = 8 ;
parameter AWIDTH = 8 ;

input  clk ;
input  rst_n ;
input  [DWIDTH-1   : 0] din ;
input  ack ;
input  err ;
input  rty ;

output [AWIDTH-1   : 0] addr ;
output [DWIDTH-1   : 0] dout ;
output cyc ;
output stb ;
output we ;
output [DWIDTH/8-1 : 0] sel ;


//////////////////////////////////////////////////////////////////////////////////
// 00_LocalWires&Regs ////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

reg [AWIDTH-1   : 0] addr ;
reg [DWIDTH-1   : 0] dout ;
reg cyc ;
reg stb ;
reg we ;
reg [DWIDTH/8-1 : 0] sel ;

reg [DWIDTH-1   : 0] q_r ;


//////////////////////////////////////////////////////////////////////////////////
// 01_Initial_Memory /////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

initial
begin
  addr = {AWIDTH{1'bx}} ;
  dout = {DWIDTH{1'bx}} ;
  cyc  = 1'b0 ;
  stb  = 1'bx ;
  we   = 1'hx ;
  sel  = {DWIDTH/8{1'bx}} ;
  #1 ;
  $display ("\nINFO: MicroProcessor Model instantiated (%m)\n") ;
end


//////////////////////////////////////////////////////////////////////////////////
// 02_WriteCycle /////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

task up_write ;

input   delay ;
integer delay ;

input [AWIDTH-1 : 0] a ;
input [DWIDTH-1 : 0] d ;

begin

  // wait initial delay
  repeat(delay) @(posedge clk) ;

  // assert signal
  #1 ;
  addr = a ;
  dout = d ;
  cyc  = 1'b1 ;
  stb  = 1'b1 ;
  we   = 1'b1 ;
  sel  = {DWIDTH/8{1'b1}} ;
  @(posedge clk) ;

  // wait for acknowledge from slave
  while (~ack) @(posedge clk) ;

  // negate signals
  #1 ;
  cyc  = 1'b0 ;
  stb  = 1'bx ;
  addr = {AWIDTH{1'bx}} ;
  dout = {DWIDTH{1'bx}} ;
  we   = 1'hx ;
  sel  = {DWIDTH/8{1'bx}} ;

end
endtask

//////////////////////////////////////////////////////////////////////////////////
// 03_ReadCycle //////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

task up_read ;

input   delay ;
integer delay ;

input  [AWIDTH-1 : 0] a ;
output [DWIDTH-1 : 0] d ;

begin

  // wait initial delay
  repeat (delay) @(posedge clk) ;

  // assert signals
  #1 ;
  addr = a ;
  dout = {DWIDTH{1'bx}} ;
  cyc  = 1'b1 ;
  stb  = 1'b1 ;
  we   = 1'b0 ;
  sel  = {DWIDTH/8{1'b1}} ;
  @(posedge clk) ;

  // wait for acknowledge from slave
  while (~ack) @(posedge clk) ;

  // negate signals
  #1 ;
  cyc  = 1'b0 ;
  stb  = 1'bx ;
  addr = {AWIDTH{1'bx}} ;
  dout = {DWIDTH{1'bx}} ;
  we   = 1'hx ;
  sel  = {DWIDTH/8{1'bx}} ;
  d    = din ;

end
endtask


//////////////////////////////////////////////////////////////////////////////////
// 04_CompareCycle //////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

task up_cmp ;
	
input   delay ;
integer delay ;

input [AWIDTH-1 : 0] a ;
input [DWIDTH-1 : 0] d_exp ;

begin

  up_read (delay, a, q_r) ;

  if (d_exp !== q_r)
    $display ("Data compare error. Received %h, expected %h at time %t", q_r, d_exp, $time) ;

end
endtask

endmodule


