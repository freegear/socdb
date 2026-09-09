/*
 
 Test bench for Divider
 
 Project : Grahpic Accelerator
 File name : Atb_div.v
 creaded by : gltee
 created date : 2004.10.15

 notes :
 
 history :
     2006.7.14 modified for multi-cycle divider
 
 */
`timescale 1ns / 100ps

   
`define   CLK_FREQ      10
`define   DATA_WIDTH    (4*17)

module Atb_div;
   parameter WIDTH_DIVD = 16;
   parameter WIDTH_DIVS = 16;
   parameter STAGES = 11;
   
   reg 		     clk;
   reg 			 rstb;

   reg [15:0] 		     romaddr;
   wire [0:`DATA_WIDTH-1]    romdata;


   wire [WIDTH_DIVD-1:0]   dividend; // 13bits
   wire [WIDTH_DIVS-1:0]   divisor;  // 13bits
   
   wire [15:0] 	    q;
   wire [15:0] 	    r;

   wire [15:0] 		q_i;
   wire [15:0] 	    r_i;

   reg 				diven; // enable
   wire				divend; // end
   
   integer 	    i;
   
   initial begin
	  clk = 0;
	  rstb = 0;
	  #(`CLK_FREQ*20) rstb = 1;
	  
   end // initial
   
   
   always #(`CLK_FREQ/2)  clk <= ~clk;

   initial romaddr <= 0;

   always@(posedge clk) begin
	  if(~rstb) romaddr <= 0;
	  else if(divend == 1'b1)
		romaddr <= romaddr + 1;
   end
   
   
   rom tb_rom(romaddr, romdata, 1'b0, 1'b0);

   //assign 	    rstb        = romdata[3];
   assign #2 	dividend    = romdata[1*4+0:4*4+3];
   assign #2 	divisor     = romdata[5*4+0:8*4+3];
   assign #2 	q_i         = romdata[9*4+0:12*4+3];
   assign #2 	r_i         = romdata[13*4+0:16*4+3];
   
   divider    divider
     (
      .clk              ( clk ),
      .rstb             ( rstb ),
	  .diven            ( diven ),
      .dividend         ( dividend ),
      .divisor          ( divisor ),

	  .divend           ( divend ),
      .q                ( q ),
	  .r                ( r )
      );

   always@(posedge clk) begin
	  diven <= ~rstb | divend;
   end
   
   integer 		result_log;

   initial      result_log = $fopen("result_log.txt");
   
   wire [16:0] 	diff_q;
   wire [16:0] 	abs_diff_q;
   
   assign 		diff_q = q_i - q;
   assign 		abs_diff_q = (diff_q[16]==1)?(17'h1ffff-diff_q):diff_q;
   
   wire [16:0] 	diff_r;
   wire [16:0] 	abs_diff_r;   
   assign 		diff_r = r_i - r;
   assign 		abs_diff_r = (diff_r[16]==1)?(17'h1ffff-diff_r):diff_r;
   
   always@(posedge clk) begin
      if(rstb) begin
		 $fdisplay(result_log,"dividend:%h  divisor:%h  q_i:%h  q:%h  r_i:%h  r:%h",
				   dividend,divisor,q_i,q,r_i,r);
		 if(abs_diff_q >= 17'h00004)
		   $fdisplay(result_log,"Err : Q %h",abs_diff_q);

		 if(abs_diff_r >= 17'h00004)
		   $fdisplay(result_log,"Err : R %h",abs_diff_r);
      end
   end
   
   
endmodule // tb_div

/////////////////////////////////////////////////////////////////////
//
// ROM initialize

module rom (addr, romdata, oeb, csb);
input	[15:0] 	addr;
input 			oeb, csb;
output 	[`DATA_WIDTH-1:0] romdata;

reg [`DATA_WIDTH-1:0] romdata;

// parameter wid = 228 ; // data width
parameter size = 16'hffff; // ROM size

//wire f23, f22, f21, f20, f19, f18, f17, f16, f15, f14, f13, f12;
//wire f11, f10, f9,  f8,  f7,  f6,  f5,  f4,  f3,  f2,  f1,  f0;
wire [`DATA_WIDTH-1:0] data;

reg [`DATA_WIDTH-1:0] rom[size:0];

initial $readmemh ("./div_test.rom",rom);

wire doen = ~(oeb | csb);

//assign data = $getpattern (rom64[addr]);
assign data = rom[addr];

always @(doen or data)
   romdata = (doen==1) ? data : {`DATA_WIDTH{1'bz}};

endmodule // rom
