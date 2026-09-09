/**************************************************************
 
 Filename : ismc_ahb.v
 
 Descript : interface sync. sram to OCP bus.
 
 create by : gtlee
 
 create date : 2005.3.18
 
 modified for big endian of openrisc.
 modified by : holelee

 Note :  
 
 
 
 History :
 
 
 
**************************************************************/

`timescale 1ns/1ns



module       ismc_ahb
  (
   clk              ,
   rstb             ,

   ahb_sel          ,
   ahb_readyin      ,
   ahb_htrans       ,
   ahb_addr         ,
   ahb_write        ,
   ahb_size         ,
   ahb_wdata        ,
   ahb_rdata        ,
   ahb_ready        ,
   ahb_resp         ,

   sram_csb         ,
   sram_addr        ,
   sram_wrb         ,
   sram_oeb         ,
   sram_dout        ,
   sram_din         
   );

   parameter               ADDR_WIDTH = 15;
   parameter 			   DATA_WIDTH = 32;
   
   input 				   clk;
   input 				   rstb;
   
   input 				   ahb_sel;
   input 				   ahb_readyin;
   input [1:0] 			   ahb_htrans;
   input [ADDR_WIDTH-1:0]  ahb_addr;
   input 				   ahb_write;
   input [2:0] 			   ahb_size;
   input [DATA_WIDTH-1:0]  ahb_wdata;
   output [DATA_WIDTH-1:0] ahb_rdata;
   output 				   ahb_ready;
   output [1:0] 		   ahb_resp;
   
   // Sync. SRAM interface
   output 				   sram_csb;
   output [ADDR_WIDTH-3:0] sram_addr;
   output [3:0] 		   sram_wrb;
   output 				   sram_oeb;
   input [DATA_WIDTH-1:0]  sram_dout;
   output [DATA_WIDTH-1:0] sram_din;
   

   //--------------------------------------------------------
   wire [DATA_WIDTH-1:0]   ahb_rdata;
   wire 				   ahb_ready;
   
   wire 				   sram_csb;
   wire [ADDR_WIDTH-3:0]   sram_addr;
   wire [3:0] 			   sram_wrb;
   wire  				   sram_oeb;
   wire [DATA_WIDTH-1:0]   sram_din;
   
   reg [ADDR_WIDTH-1:0]    ahb_addr_dp; // address at data phase for writing

   reg                     cs;
   reg 					   ns;

   wire 				   ismc_sel;
   
   wire 				   rd_cmd_new;
   reg 					   rd_cmd;
   reg 					   wr_cmd;

   reg [3:0] 			   rd_be_new;
   reg [3:0] 			   wr_be;

   reg 					   rd_dphase;
   
   reg 					   random;
   reg 					   random_1d;
   always @(posedge clk) random = $random/16;
 
   // latch address for write operation
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) ahb_addr_dp <= {ADDR_WIDTH{1'b0}};
	  else if(ahb_readyin) ahb_addr_dp <= ahb_addr;
   end

   // generate be signal
   always@(ahb_size or ahb_addr) begin
	  if(ahb_size == 3'h0) begin // byte access
		 case(ahb_addr[1:0]) // synopsys parallel_case
			2'b00   : rd_be_new <= 4'b0001;
			2'b01   : rd_be_new <= 4'b0010;
			2'b10   : rd_be_new <= 4'b0100;
			default : rd_be_new <= 4'b1000;
		 endcase // case(ahb_addr[1:0])
	  end // if
	  else if(ahb_size == 3'h1) begin // half word access
		 if(ahb_addr[1] == 1'b0)
		   rd_be_new <= 4'b0011;
		 else rd_be_new <= 4'b1100;
	  end // else if
	  else rd_be_new <= 4'b1111;
   end // always@ (ahb_size or ahb_addr)
   
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) wr_be <= 4'h0;
	  else wr_be <= {rd_be_new[0], rd_be_new[1], rd_be_new[2], rd_be_new[3]} ;	// holelee : reverse bits for big endian
   end // always

   assign ismc_sel = (ahb_htrans != 2'h0 && ahb_sel == 1'b1 && ahb_readyin == 1'b1)? 1'b1 : 1'b0;
   
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) wr_cmd <= 1'b0;
	  else if(ismc_sel == 1'b1 && ahb_write == 1'b1) begin
		 wr_cmd <= 1'b1;
	  end
	  else wr_cmd <= 1'b0;
   end // always

   assign rd_cmd_new = (ismc_sel == 1'b1 && ahb_write == 1'b0)? 1'b1 : 1'b0;
   
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) rd_cmd <= 1'b0;
	  else if(ahb_readyin) rd_cmd <= rd_cmd_new;
   end // always

   always@(posedge clk or negedge rstb) begin
	  if(~rstb) rd_dphase <= 1'b0;
	  else if(cs == 1'b1 || ahb_readyin == 1'b0) begin // if wait cyclie
		 rd_dphase <= rd_cmd;
	  end
	  else rd_dphase <= rd_cmd_new;
   end // always
   

   // Generate Wait cycle
   // at read cycle after write cycle
   // if cs == 1, wait cycle.
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) cs <= 1'b0;
	  else cs <= ns;
   end // always

   always@(wr_cmd or rd_cmd_new) begin
	  if(wr_cmd == 1'b1 && rd_cmd_new == 1'b1) begin
		 ns <= 1'b1;
	  end
      else
		ns <= 1'b0;
   end // always


   // Sync. SRAM control signals
   assign   #2 sram_csb = (rd_cmd_new == 1'b1 || rd_cmd == 1'b1 || wr_cmd == 1'b1)?
			      1'b0 : 1'b1;
   
   assign 	#2 sram_addr = (wr_cmd || ahb_readyin == 1'b0)? ahb_addr_dp[ADDR_WIDTH-1:2] : ahb_addr[ADDR_WIDTH-1:2];
   //   assign 	 sram_be = (wr_cmd) ? ~wr_be : ~rd_be_new;
   assign 	#2 sram_wrb = ~{(wr_be[3]&wr_cmd),
							(wr_be[2]&wr_cmd),
							(wr_be[1]&wr_cmd),
							(wr_be[0]&wr_cmd)};
   
   //assign 	 sram_rdb = (cs)? rd_cmd:rd_cmd_new;
   assign #2   sram_oeb = ~rd_dphase;
                          //sram_octrl;
   //                     (wr_cmd | cs)? 1'b1 : ~rd_dphase;
   assign 	#2 sram_din = ahb_wdata;

   // AHB control signals
   assign 	 ahb_rdata = (ahb_ready == 1'b1) ? sram_dout : 32'hxxxxxxxx;
//   assign    ahb_ready = ((~cs & rd_dphase) | wr_cmd);
//   assign    ahb_ready = (~cs);
   assign    ahb_ready = (~cs) && random;
   assign    ahb_resp = 2'h0;
   
endmodule // ismc_ahb


