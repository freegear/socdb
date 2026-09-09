/*
     Test Bench
 
     Project : MMC
 
     created by gtlee
 
     date : 2007.6.18
 
     history :
 
     note :
         use rom and sync.sram.
         read rom and write sram, then compare.
 */
`timescale 1ns/10ps


//`define 			   CARD_CLK    18.5
`define 			   CARD_CLK    100
`define 			   HF_CD_CLK   (`CARD_CLK/2)
   
`define 			   SYS_CLK     10
`define 			   HF_SYS_CLK  (`SYS_CLK/2)


module    Atb_1;

   
   parameter               CIADDR_WIDTH = 41;
   parameter 			   SIADDR_WIDTH = 12;

   
   reg 					   rstb;
   reg 					   clk_card;
   reg 					   clk_sys;
   
   initial begin
	  rstb = 1'b0;
	  clk_card = 1'b1;
	  clk_sys = 1'b1;

	  #(`SYS_CLK*10.5) rstb = 1'b1;
   end

   always #(`HF_CD_CLK) clk_card <= ~clk_card;
   always #(`HF_SYS_CLK) clk_sys <= ~clk_sys;
   

   wire 				   ci_adsb;
   wire 				   ci_wr;
   wire 				   ci_blastb;
   wire [1:0] 			   ci_csb;
   wire [CIADDR_WIDTH-1:0] ci_addr;
   wire [3:0] 			   ci_beb;
   wire [31:0] 			   ci_rdata;
   wire [31:0] 			   ci_wdata;
   wire 				   ci_error;
   wire 				   ci_rdyb;
   wire [9:0] 			   ci_size;

   // SRAM buffer interface signals
   wire [1:0] 			   si_csb;
   wire [SIADDR_WIDTH-1:0] si_addr;
   wire [31:0] 			   si_wdata;
   wire [31:0] 			   si_rdata;
   wire [3:0] 			   si_beb;
   wire 				   si_wrb;
   wire 				   si_rdb;
   wire 				   si_rdyb;
   wire 				   si_err;
   
   // start signals
   reg [1:0] 			   csb;
   reg [19:0] 			   addr;
   reg [9:0] 			   size; // word size
   reg 					   rd;
   reg 					   wr;
   wire 				   busy;
   
   
   
   
   cardctrlwrap
	 #(.CIADDR_WIDTH(CIADDR_WIDTH),
	   .SIADDR_WIDTH(SIADDR_WIDTH)) 
   cardctrlwrap
	 (
	  .rstb                ( rstb ),
	  .clk_card            ( clk_card ),
	  .clk_sys             ( clk_sys ),
	  
	  // SD/MMC card interface signals
	  .ci_adsb             ( ci_adsb ),
	  .ci_wr               ( ci_wr ),
	  .ci_blastb           ( ci_blastb ),
	  .ci_csb              ( ci_csb ),
	  .ci_addr             ( ci_addr ),
	  .ci_beb              ( ci_beb ),
	  .ci_rdata            ( ci_rdata ),
	  .ci_wdata            ( ci_wdata ),
	  .ci_error            ( ci_error ),
	  .ci_rdyb             ( ci_rdyb ),
	  .ci_size             ( ci_size ),
	  
	  // SRAM buffer interface signals
	  .si_csb              ( si_csb ),
	  .si_addr             ( si_addr ),
	  .si_wdata            ( si_wdata ),
	  .si_rdata            ( si_rdata ),
	  .si_beb              ( si_beb ),
	  .si_wrb              ( si_wrb ),
	  .si_rdb              ( si_rdb ),
	  .si_rdyb             ( si_rdyb ),
	  .si_err              ( si_err )
	  ); // cardctrlwrap
   
   
   
   ci_model 
	 #(.CIADDR_WIDTH(CIADDR_WIDTH),
	   .SIADDR_WIDTH(SIADDR_WIDTH))
   ci_model
	 (
	  .rstb               ( rstb ),
	  .clk_card           ( clk_card ),  // clock for the mmc/sd card
	  
	  // SD/MMC card interface signals
	  .ci_adsb            ( ci_adsb ),
	  .ci_wr              ( ci_wr ),
	  .ci_blastb          ( ci_blastb ),
	  .ci_csb             ( ci_csb ),
	  .ci_addr            ( ci_addr ),
	  .ci_beb             ( ci_beb ),
	  .ci_rdata           ( ci_rdata ),
	  .ci_wdata           ( ci_wdata ),
	  .ci_error           ( ci_error ),
	  .ci_rdyb            ( ci_rdyb ),
	  .ci_size            ( ci_size ),
	  
	  // start signals
	  .csb                ( csb ),
	  .addr               ( addr ),
	  .size               ( size ), // word size
	  .rd                 ( rd ),
	  .wr                 ( wr ),
	  .busy               ( busy )
	  ); // ci_model



   si_model #(.SIADDR_WIDTH(SIADDR_WIDTH)) si_model
	 (
	  .rstb              ( rstb ),
	  .clk_sys           ( clk_sys ),
	  
	  .si_addr           ( si_addr ),
	  .si_wdata          ( si_wdata ),
	  .si_rdata          ( si_rdata ),
	  .si_beb            ( si_beb ),
	  .si_wrb            ( si_wrb ),
	  .si_rdb            ( si_rdb ),
	  .si_rdyb           ( si_rdyb ),
	  .si_err            ( si_err )
	  ); // si_model


   initial begin
	  addr = 0;
	  size = 0;
	  rd = 0;
	  wr = 0;
	  csb = 2'h3;
	  
	  wait(rstb);
	  repeat(20) @(posedge clk_card);

	  repeat(100) begin
		 
		 #1 addr = 0;
		 size = 11;
		 rd = 0;
		 wr = 1;
		 csb = 2'h2;
		 wait(busy);
		 #1 wr = 0;
		 csb = 2'h3;
		 wait(~busy);
		 repeat(2) @(posedge clk_card);
		 // read and varify
		 #1 rd = 1;
		 wr = 0;
		 csb = 2'h2;
		 wait(busy);
		 #1 rd = 0;
		 csb = 2'h3;
		 wait(~busy);
		 repeat(10) @(posedge clk_card);
		 
		 //----------------------------------------
		 #1 addr = 20'h00014;
		 size = 6;
		 rd = 0;
		 wr = 1;
		 csb = 2'h2;
		 wait(busy);
		 #1 wr = 0;
		 csb = 2'h3;
		 wait(~busy);
		 repeat(1) @(posedge clk_card);
		 // read and varify
		 #1 rd = 1;
		 wr = 0;
		 csb = 2'h2;
		 wait(busy);
		 #1 rd = 0;
		 csb = 2'h3;
		 wait(~busy);
		 repeat(10) @(posedge clk_card);
		 
		 //----------------------------------------
		 #1 addr = 20'h00020;
		 size = 1;
		 rd = 0;
		 wr = 1;
		 csb = 2'h2;
		 wait(busy);
		 #1 wr = 0;
		 csb = 2'h3;
		 wait(~busy);
		 repeat(1) @(posedge clk_card);
		 // read and varify
		 #1 rd = 1;
		 wr = 0;
		 csb = 2'h2;
		 wait(busy);
		 #1 rd = 0;
		 csb = 2'h3;
		 wait(~busy);
		 repeat(10) @(posedge clk_card);
	  end // repeat (10)
	  
	  //----------------------------------------
	  // end simulation
	  repeat(2) @(posedge clk_card);	  
	  $display("End Simualtion");
	  $display("===============================================");
	  $stop;
	  
	  
   end // initial begin
   
endmodule // Atb_1


