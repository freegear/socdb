

module ssram(clk, data_i,data_o, addr, we_n, rd_n, cs_n);

   parameter               ADDR_WIDTH = 16;
   parameter 			   DATA_WIDTH = 32;
   
   input 				   clk;
   input [DATA_WIDTH-1:0]  data_i;
   output [DATA_WIDTH-1:0] data_o;
   input [ADDR_WIDTH-1:0]  addr;
   input 				   we_n, rd_n, cs_n;
   

   wire [DATA_WIDTH-1:0]   data_o;
   
   parameter 			   size = {ADDR_WIDTH{1'b1}};
   
   reg [DATA_WIDTH-1:0] 	mem[0:size];
   reg [DATA_WIDTH-1:0] 	rd_buff;
   wire [DATA_WIDTH-1:0] 	wr_buff;
   
   wire 		wr;
   wire 		rd;

   assign #2 	wr_buff = data_i;
   assign #2 	wr = (cs_n == 1'b0 && we_n == 1'b0)? 1'b1:1'b0;
   assign #2 	rd = (cs_n == 1'b0 && rd_n == 1'b0)? 1'b1:1'b0;

   always@(posedge clk) begin
	  if(wr == 1'b1)
		mem[addr] <= wr_buff;
   end

   always@(posedge clk) begin
		rd_buff <= mem[addr];
   end
   

   assign data_o = rd_buff;
   
endmodule // ssram
