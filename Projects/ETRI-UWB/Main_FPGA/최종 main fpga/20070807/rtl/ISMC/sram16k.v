
`define DATA_WIDTH   32

module sram16k
  (
   clk       ,
   addr      ,
   wrb       ,
   oeb       ,
   csb       ,
   datain    ,
   dataout   
  );
   input		    clk;
   input	[11:0] 	addr;
   input 			wrb, oeb, csb;
   input  [`DATA_WIDTH-1:0] datain;
   output [`DATA_WIDTH-1:0] dataout;
   
   parameter 				size = 12'hfff; // ROM size
   

   reg [`DATA_WIDTH-1:0] 	dataout;
   wire [`DATA_WIDTH-1:0] 	data;
   reg [`DATA_WIDTH-1:0] 	rom[size:0];
   
   always @(posedge clk) begin
	 if(!csb) begin
		if(!wrb) rom[addr] <= datain;
		dataout <= rom[addr];
	 end 
   end

endmodule
 
 


