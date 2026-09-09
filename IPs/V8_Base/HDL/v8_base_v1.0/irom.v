/* 
 
 Internal Mask Rom Model for SDI V5
 
 
 created : 2006.2.22
 
 note :
    data는 1 clock 늦게 출력된다
    output enable은 출력포트를 disable하는 역활만 하며 일반적으로 사용할때에는
    low로 고정하여 사용한다.
 
 */
`timescale 1ns/10ps

`define DATA_WIDTH   8

module irom
  (
   clk       ,
   addr      ,
   oeb       ,
   csb       ,
   romdata   
   );
   input            clk;
   input [13:0] 	addr;
   input 			oeb, csb;
   output [`DATA_WIDTH-1:0] romdata;
   
   reg [`DATA_WIDTH-1:0] 	romdata;
   
   // parameter wid = 228 ; // data width
   parameter 				size = 14'h3fff; // ROM size
   
   //wire f23, f22, f21, f20, f19, f18, f17, f16, f15, f14, f13, f12;
   //wire f11, f10, f9,  f8,  f7,  f6,  f5,  f4,  f3,  f2,  f1,  f0;
   wire [`DATA_WIDTH-1:0] 	data;
   
   reg [`DATA_WIDTH-1:0] 	rom[size:0];
   
   initial $readmemh ("./irom.dat",rom);
   
   wire 					doen = ~csb;
   
   //assign data = $getpattern (rom64[addr]);
   
   assign 					data = rom[addr];
   
   always @(posedge clk) 
	 romdata <= (doen==1) ? data : {`DATA_WIDTH{1'bz}};

endmodule
 
 

