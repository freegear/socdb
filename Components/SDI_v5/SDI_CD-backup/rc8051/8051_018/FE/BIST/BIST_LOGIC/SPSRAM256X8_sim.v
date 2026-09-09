// ** FILE : SynTest RAM BIST Verilog testbench file
// ** NAME : SPSRAM256X8_sim.v
// ** TOOL : srambist V1.2.0 r01 (05/30/01 09:35:47)
// ** TIME : Tue Jul  3 15:05:48 2001


`timescale 1ns / 10ps

`define normal_mode     1'b0
`define bist_mode       1'b1
`define POWER_ON_RESET  151
`define TCLK_PERIOD     100
`define TCLK_LOW        50
`define TCLK_HIGH       50

module TestBench ;

 wire  CLK_n ; 
 reg   CEN_n ; 
 reg   WEN_n ; 
 wire  [7 : 0] Q_n ; 
 reg   [7 : 0] D_n ; 
 reg   [7 : 0] A_n ; 
 reg   sim_clk ; 
 wire  sim_clk_n ; 
 reg   BistMode ; 
 wire  BistFail ; 
 wire  ErrMap ; 
 wire  Finish ; 
 integer count ;    // count total simulation cycles

assign sim_clk_n = sim_clk ;
assign CLK_n = sim_clk_n ;

Bisted_SPSRAM256X8  BistedRAM_i0 (
                                   .CLK ( CLK_n ) ,
                                   .CEN ( CEN_n ) ,
                                   .WEN ( WEN_n ) ,
                                   .Q ( Q_n ) ,
                                   .D ( D_n ) ,
                                   .A ( A_n ) ,
                                   .BistMode ( BistMode ) ,
                                   .BistFail ( BistFail ) ,
                                   .Finish ( Finish ) ,
                                   .ErrMap ( ErrMap ) 
                                 );

// Generate clock for simulation

always
begin
   sim_clk <= 1'b0 ;
   #( `TCLK_HIGH ) ;
   sim_clk <= 1'b1 ;
   count = count + 1 ;
   #( `TCLK_LOW ) ;
end

initial begin
  $display($time, "  Initialize Circuits\n");
   BistMode <= `normal_mode ;
   count = 0 ;
   CEN_n <= 1'b0 ;
   WEN_n <= 1'b0 ;
   D_n <= 0;
   A_n <= 0;

   #(`POWER_ON_RESET) ;
   $display($time, "  Testing Bist Operation\n");
   BistMode <= `bist_mode ;
   wait (Finish)

   #(`TCLK_PERIOD) ;

   $display($time, "  Finish SRAM BIST simulation. Total BIST simulation cycles : %0d .\n\n", count);

   if (BistFail === 1'b0)
      $display($time, "  Bist Operation succeeded.\n");
   else
      $display($time, "  Bist Operation failed !!!\n");

   $finish;
end

// Compare procedure

always @(posedge sim_clk)
begin
   if (BistMode === 1'b1) begin
      if (ErrMap === 1'b1)
         $display($time, "  ** The BIST detected an error at cycle : [ %0d ].", count);
   end
end

endmodule

