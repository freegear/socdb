/*
  Dual port SRAM for USB buffer
 
  Port A : write only
  Port B : read only
 
 
 */

`timescale 1 ns/1 ps

module DPSSRAM128x36 (
   QA,
   CLKA,
   CENA,
   WENA,
   AA,
   DA,
   QB,
   CLKB,
   CENB,
   WENB,
   AB,
   DB
);
   parameter		   BITS = 36;
   parameter		   word_depth = 128;
   parameter		   addr_width = 7;
   parameter		   wordx = {BITS{1'bx}};
   parameter		   addrx = {addr_width{1'bx}};
	
   output [BITS-1:0] QA;
   input CLKA;
   input CENA;   // active low
   input WENA;
   input [addr_width-1:0] AA;
   input [BITS-1:0] DA;
   output [BITS-1:0] QB;
   input CLKB;
   input CENB;
   input WENB;
   input [addr_width-1:0] AB;
   input [BITS-1:0] DB;

   reg [BITS-1:0]	   mem [word_depth-1:0];
   reg [BITS-1:0] QA;
   reg [BITS-1:0] QB;

   always@(posedge CLKA) begin
	  if(CENA == 1'b0 && WENA == 1'b0)
		mem[AA] <= DA;
   end // always. CLKA
   
   always@(posedge CLKB) begin
	  if(CENB == 1'b0 && WENB == 1'b1)
		QA <= mem[AB];
   end // always. CLKB
   
   
   always@(posedge CLKB) begin
	  if(CENB == 1'b0 && WENB == 1'b1)
		QB <= mem[AB];
   end // always. CLKB
   

endmodule
