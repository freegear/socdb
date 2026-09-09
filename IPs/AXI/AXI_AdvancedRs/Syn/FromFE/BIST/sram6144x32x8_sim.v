// ** FILE : SynTest RAM BIST Verilog testbench file
// ** NAME : sram6144x32x8_sim.v
// ** TOOL : srambist V1.2.0 r01 (05/30/01 09:35:47)
// ** TIME : Wed Jul 19 01:22:32 2000


`timescale 1ns / 10ps

`define normal_mode     1'b0
`define bist_mode       1'b1
`define POWER_ON_RESET  20
`define TCLK_PERIOD     13
`define TCLK_LOW        6
`define TCLK_HIGH       7

module TestBench ;

 wire  CLK_n ; 
 reg   CEN_n ; 
 reg   OEN_n ; 
 reg   [3 : 0] WEN_n ; 
 wire  [31 : 0] Q_n ; 
 reg   [31 : 0] D_n ; 
 reg   [12 : 0] A_n ; 
 reg   sim_clk ; 
 wire  sim_clk_n ; 
 reg   BistMode ; 
 wire  BistFail ; 
 wire  ErrMap ; 
 wire  Finish ; 
 integer count ;    // count total simulation cycles

assign sim_clk_n = sim_clk ;
assign CLK_n = sim_clk_n ;

Bisted_sram6144x32x8  BistedRAM_i0 (
                                     .CLK ( CLK_n ) ,
                                     .CEN ( CEN_n ) ,
                                     .OEN ( OEN_n ) ,
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
   OEN_n <= 1'b0 ;
   WEN_n <= 4'b0000 ;
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

