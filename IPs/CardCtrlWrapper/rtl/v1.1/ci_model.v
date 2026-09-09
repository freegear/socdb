/*
     SD/MMC Card interface model
 
     Project : MMC
 
     created by gtlee
 
     date : 2007.6.15
 
     history :
 
     note :
 
 */


module    ci_model
  (
   rstb               ,
   clk_card           ,  // clock for the mmc/sd card
   
   // SD/MMC card interface signals
   ci_adsb            ,
   ci_wr              ,
   ci_blastb          ,
   ci_csb             ,
   ci_addr            ,
   ci_beb             ,
   ci_rdata           ,
   ci_wdata           ,
   ci_error           ,
   ci_rdyb            ,
   ci_size            ,
   ci_abortb          ,
   
   // start signals
   csb                ,
   addr               ,
   size               , // word size
   rd                 ,
   wr                 ,
   busy               
   );

   parameter               CIADDR_WIDTH = 41;
   parameter 			   SIADDR_WIDTH = 12;
   
   // In/Out signals
   input 				   rstb;
   input 				   clk_card;  // clock for the mmc/sd card

   // SD/MMC card interface signals
   output 				   ci_adsb;
   output 				   ci_wr;
   output 				   ci_blastb;
   output [1:0] 		   ci_csb;
   output [CIADDR_WIDTH-1:0] ci_addr;
   output [3:0] 		   ci_beb;
   input [31:0] 		   ci_rdata;
   output [31:0] 		   ci_wdata;
   input 				   ci_error;
   input 				   ci_rdyb;
   output [9:0] 		   ci_size;
   input 				   ci_abortb;
   
   // start signals
   input [1:0] 			   csb;
   input [19:0] 		   addr;
   input [9:0] 			   size; // word size
   input 				   rd;
   input 				   wr;
   output 				   busy;


   //-------------------------------------------------------------

   reg                     cmd_rwb;
   
   reg [9:0] 			   size_cnt;
   wire 				   ci_adsb;
   wire                    ci_wr;
   wire 				   ci_blastb;
   reg [1:0] 			   ci_csb;
   reg [CIADDR_WIDTH-1:0]  ci_addr;
   wire [3:0] 			   ci_beb;

   wire [31:0] 			   ci_wdata;
   reg [9:0] 			   ci_size;
   
   wire 				   busy;
   

   //-------------------------------------------------------------
   // State Machine
   parameter               CIM_IDLE = 0;
   parameter               CIM_SEND_ADS = CIM_IDLE + 1;
   parameter 			   CIM_END_SIZE = CIM_SEND_ADS + 1;

   parameter               CIM_SM_NUM = CIM_END_SIZE + 1;

   parameter               CIM_SM_INIT = {{(CIM_SM_NUM-1){1'b0}},1'b1};

   parameter               CIM_ST_IDLE = (CIM_SM_INIT << CIM_IDLE);
   parameter               CIM_ST_SEND_ADS = (CIM_SM_INIT << CIM_SEND_ADS);
   parameter 			   CIM_ST_END_SIZE = (CIM_SM_INIT << CIM_END_SIZE);

   reg [CIM_SM_NUM-1:0]    cim_cs, cim_ns;
   
   // states
   wire 				   cim_sm_idle = cim_cs[CIM_IDLE];
   wire 				   cim_sm_send_ads = cim_cs[CIM_SEND_ADS];
   wire 				   cim_sm_end_size = cim_cs[CIM_END_SIZE];
   //

   
   always@(posedge clk_card or negedge rstb) begin
	  if(~rstb || ~ci_abortb) cim_cs <= CIM_ST_IDLE;
	  else cim_cs <= cim_ns;
   end // always cim_cs
   

   always@(cim_cs or wr or rd or size_cnt or ci_rdyb) begin
	  case(1'b1)
		cim_cs[CIM_IDLE] : begin
		   if(rd | wr) cim_ns <= CIM_ST_SEND_ADS;
		   else cim_ns <= CIM_ST_IDLE;
		end
		cim_cs[CIM_SEND_ADS] : begin
		   cim_ns <= CIM_ST_END_SIZE;
		end
		cim_cs[CIM_END_SIZE] : begin
		   if(size_cnt == 0 & ci_rdyb == 1'b0)
			 cim_ns <= CIM_ST_IDLE;
		   else 
			 cim_ns <= CIM_ST_END_SIZE;
		end
		default : cim_ns <= CIM_ST_END_SIZE;
	  endcase // case(1'b1)
   end // always@ (cim_cs or wr or rd or size_cnt)
   



   
   //----------------------------------------------------------
   always@(posedge clk_card or negedge rstb) begin
	  if(~rstb) cmd_rwb <= 1'b1;
	  else if(cim_sm_idle) cmd_rwb <= rd;
   end
   
   always@(posedge clk_card or negedge rstb) begin
	  if(~rstb) size_cnt <= 0;
	  else if(cim_sm_idle) size_cnt <= size - 1;
	  else if(cim_sm_end_size & (~ci_rdyb)) size_cnt <= size_cnt - 1;
   end // always ci_csb
   

   assign     ci_adsb = ~cim_sm_send_ads;
   assign     ci_wr = cim_sm_send_ads & (~cmd_rwb);

   assign 	  ci_blastb = (size_cnt == 0)? 1'b0 : 1'b1;

   //   assign 	  ci_csb = 2'h1;
   always@(posedge clk_card or negedge rstb) begin
	  if(~rstb) ci_csb <= 2'h3;
	  else if(rd | wr) ci_csb <= csb;
   end // always ci_csb
   
   
   always@(posedge clk_card or negedge rstb) begin
	  if(~rstb) ci_addr <= 0;
	  else if(cim_sm_idle & (rd | wr)) ci_addr <= {{(CIADDR_WIDTH-20){1'b0}},addr[19:2],2'h0};
	  else if(cim_sm_end_size & (~ci_rdyb)) ci_addr <= ci_addr + 4;
   end // always ci_addr

   assign ci_beb = 4'b0000;

   always@(posedge clk_card or negedge rstb) begin
	  if(~rstb) ci_size <= 0;
	  else if(cim_sm_idle & (rd | wr)) ci_size <= size;
   end // always ci_size

   assign   busy = ~cim_sm_idle;



   
   

   //-------------------------------------------------------
   // interface a data rom
   //   for write channel
   wire [11:0]  ADDR_a;
   wire 		CEn_a;
   wire [31:0] 	RDATA_a;
   
   //   for read channel
   wire [11:0]  ADDR_b = 0;
   wire 		CEn_b = 1;
   wire [31:0] 	RDATA_b;
   
   DROM         drom
	 (
	  .CLK       ( clk_card ), 
	  .ADDR_a    ( ADDR_a ),
	  .CEn_a     ( CEn_a ),
	  .OEn_a     ( 1'b0 ),
	  .RDATA_a   ( RDATA_a ),
	  
	  .ADDR_b    ( ADDR_b ),
	  .CEn_b     ( CEn_b ),
	  .OEn_b     ( 1'b0 ),
	  .RDATA_b   ( RDATA_b )
	  );

   assign 	   CEn_a = 0;
   assign 	   ADDR_a = ci_addr[13:2];

   assign 	   ci_wdata = RDATA_a;



   
   
   //-------------------------------------------------------
   integer 	   wr_file;
   integer 	   rd_file;

   initial     wr_file = $fopen("wr_file.log");
   initial     rd_file = $fopen("rd_file.log");

   always@(posedge clk_card or negedge rstb) begin
	  if(ci_adsb == 1'b0) begin
		 if(cmd_rwb == 1'b0) begin // at write
			$display("Write Operation from Card");
			$fdisplay(wr_file,"");
			
			$display(,"=========================================");
			$fdisplay(wr_file,"=========================================");

			$display("Time:%tns",$time);
			$fdisplay(wr_file,"Time:%tns",$time);
			
			$display("Address : %h",ci_addr);
			$fdisplay(wr_file,"Address : %h",ci_addr);

			$display("Size : %h",ci_size);
			$fdisplay(wr_file,"Size : %h",ci_size);
		 end
		 else begin
			$display("Read Operation from Card");
			$fdisplay(rd_file,"");
			
			$display(,"=========================================");
			$fdisplay(rd_file,"=========================================");

			$display("Time:%tns",$time);
			$fdisplay(rd_file,"Time:%tns",$time);
			
			$display("Address : %h",ci_addr);
			$fdisplay(rd_file,"Address : %h",ci_addr);

			$display("Size : %h",ci_size);
			$fdisplay(rd_file,"Size : %h",ci_size);
		 end // else: !if(cmd_rwb == 1'b0)
	  end // if (ci_adsb == 1'b0)
   end // always@ (posedge clk_card or negedge rstb)


   
   always@(posedge clk_card or negedge rstb) begin
	  if(ci_rdyb == 1'b0) begin
		 if(cmd_rwb == 1'b0) begin // at write
			$display("Data : %h",ci_wdata);
			$fdisplay(wr_file,"Data : %h",ci_wdata);
		 end
		 else begin
			$display("Data : %h",ci_rdata);
			$fdisplay(rd_file,"Data : %h",ci_rdata);
		 end // else: !if(cmd_rwb == 1'b0)
	  end // if (ci_rdyb == 1'b0)
   end // always@ (posedge clk_card or negedge rstb)
   



   

   //-------------------------------------------------------
   // compare the read data
   integer 	file;

   initial file = $fopen("compare.log");
   
   
   always@(posedge clk_card or negedge rstb) begin
	  if(rstb & cmd_rwb & (~ci_rdyb)) begin
		 if(RDATA_a !== ci_rdata) begin
			$display("%t-FAIL-ORG:%h RD:%h",$time,RDATA_a,ci_rdata);
			$fdisplay(file,"%t-FAIL-ORG:%h RD:%h",$time,RDATA_a,ci_rdata);
			$stop;
			
		 end
		 else begin
			$display("%t-SUCC-ORG:%h RD:%h",$time,RDATA_a,ci_rdata);
			$fdisplay(file,"%t-SUCC-ORG:%h RD:%h",$time,RDATA_a,ci_rdata);
		 end
	  end // if
   end // always compare


endmodule // ci_model

