
`DATA_WIDTH   32

module sram4k
  (
   clk       ,
   addr      ,
   wrb       ,
   oeb       ,
   csb       ,
   datain    ,
   dataout   
  );
   
   input	[11:0] 	addr;
   input 			wrb, oeb, csb;
   input  [`DATA_WIDTH-1:0] datain;
   output [`DATA_WIDTH-1:0] dataout;
   
   parameter 				size = 12'hfff; // ROM size
   

   reg [`DATA_WIDTH-1:0] 	romdata;
   
   
   wire [`DATA_WIDTH-1:0] 	data;
   
   reg [`DATA_WIDTH-1:0] 	rom[size:0];
   
   wire 					doen = ~csb;
   assign 					data = rom[addr];
   
   always @(posedge clk) begin
	 dataout <= data;
   end

   always @(posedge clk) begin
     if(!csb && !wrb) rom[addr] <= data;
   end

endmodule
 
 


