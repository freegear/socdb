/*
     SD/MMC Card controller wapper
 
     Project : MMC
 
     created by gtlee
 
     date : 2007.6.13
 
     history :
          v1.1 : add an abort signal.
 
     note :
          2007.6.21 : add the new operation signal.
 */



module     cardctrlwrap
  (
   rstb                ,
   clk_card            ,
   clk_sys             ,
   
   // SD/MMC card interface signals
   ci_adsb             ,
   ci_wr               ,
   ci_blastb           ,
   ci_csb              ,
   ci_addr             ,
   ci_beb              ,
   ci_rdata            ,
   ci_wdata            ,
   ci_error            ,
   ci_rdyb             ,
   ci_size             ,
   ci_abortb           ,
   
   // SRAM buffer interface signals
   si_newopb           ,
	si_abortb			,

   si_csb              ,
   si_addr             ,

	si_size				,
	si_wr				,
	


   si_wdata            ,
   si_rdata            ,
   si_beb              ,
   si_wrb              ,
   si_rdb              ,
   si_rdyb             ,
   si_err            
   );

   parameter               CIADDR_WIDTH = 41;
   parameter 			   SIADDR_WIDTH = 41;
   

   // In/Out signals
   input 				   rstb;
   input 				   clk_card;  // clock for the mmc/sd card
   input 				   clk_sys;   // clock for the system
   
   // SD/MMC card interface signals
   input 				   ci_adsb;
   input 				   ci_wr;
   input 				   ci_blastb;
   input [1:0] 			   ci_csb;
   input [CIADDR_WIDTH-1:0] ci_addr;
   input [3:0] 			   ci_beb;
   output [31:0] 		   ci_rdata;
   input [31:0] 		   ci_wdata;
   output 				   ci_error;
   output 				   ci_rdyb;
   input [9:0] 			   ci_size;
   input 				   ci_abortb;
   
   // SRAM buffer interface signals
   output 				   si_newopb; // new operation 2007.6.21
	output					si_abortb;
   output [1:0] 		   si_csb;
   output [SIADDR_WIDTH-1:0] si_addr;

	output	[9:0]			si_size;
	output					si_wr;



   output [31:0] 		   si_wdata;
   input [31:0] 		   si_rdata;
   output [3:0] 		   si_beb;
   output 				   si_wrb;
   output 				   si_rdb;
   input 				   si_rdyb;
   input                   si_err; // for the write protection
   

   //-------------------------------------------------------------------
   reg 					   ads_fgb;
   reg [31:0] 			   ci_rdata;
   wire 				   ci_rdyb; // to SD/MMC controller
   reg 					   ci_error;

   wire 				   si_newopb; // new operation 2007.6.21
   reg [1:0] 			   si_csb;


	reg	[9:0]				si_size;
	reg						si_wr;



   wire 				   si_wrb;
   wire 				   si_rdb;

   reg [SIADDR_WIDTH-1:0]  si_addr;
   reg [31:0] 			   si_wdata;
   reg [3:0] 			   si_beb;

   reg 					   si_rdyb_dly;
   wire 				   si_rdyb_edge;
   
   
   //-------------------------------------------------------------------
   // Handshake signals
   wire 				   abortb_hsk; // 2007.7.20
   reg [1:0] 			   csb_hsk;
   wire 				   rdyb_hsk;
   wire 				   adsb_hsk;
   reg                     lastb_hsk;
   reg 					   wr_hsk;
   reg 					   wr2_hsk;

	reg	[9:0]				size_hsk;


   reg [CIADDR_WIDTH-1:0]  addr_hsk;
   reg [31:0] 			   wdata_hsk;
   reg [3:0] 			   beb_hsk;
   reg [31:0] 			   rdata_hsk;
   
//   reg                     f_sm_loop; // first state machine loop
   
   //-------------------------------------------------------------------
   // State Machine for the SD/MMC card interface
   parameter               CI_IDLE = 0;
   parameter 			   CI_SEND_CMD = CI_IDLE + 1;
   parameter 			   CI_GET_RDY = CI_SEND_CMD + 1;
   parameter 			   CI_END_CMD = CI_GET_RDY + 1;
   parameter               CI_ABORT = CI_END_CMD + 1;
   parameter 			   CI_SM_NUM = CI_ABORT + 1; // State count
   
   parameter 			   CI_SM_INIT = {{(CI_SM_NUM-1){1'b0}},1'b1};

   parameter 			   CI_ST_IDLE = (CI_SM_INIT << CI_IDLE);
   parameter 			   CI_ST_SEND_CMD = (CI_SM_INIT << CI_SEND_CMD);
   parameter 			   CI_ST_GET_RDY = (CI_SM_INIT << CI_GET_RDY);
   parameter 			   CI_ST_END_CMD = (CI_SM_INIT << CI_END_CMD);
   parameter               CI_ST_ABORT = (CI_SM_INIT << CI_ABORT);
   
   reg [CI_SM_NUM-1:0] 	   ci_cs, ci_ns;

   // states
   wire 				   ci_sm_idle = ci_cs[CI_IDLE];
   wire 				   ci_sm_send_cmd = ci_cs[CI_SEND_CMD];
   wire 				   ci_sm_get_rdy = ci_cs[CI_GET_RDY];
   wire 				   ci_sm_end_cmd = ci_cs[CI_END_CMD];
   wire                    ci_sm_abort = ci_cs[CI_ABORT];
   //


   always@(posedge clk_card or negedge rstb) begin
	  if(~rstb) ci_cs <= CI_ST_IDLE;
	  else ci_cs <= ci_ns;
   end


   always@(ci_abortb or ci_cs or ci_adsb or rdyb_hsk or
		   lastb_hsk or ads_fgb or adsb_hsk) begin
	  case(1'b1)
		ci_cs[CI_IDLE] : begin
		   if(ci_abortb == 1'b0)
			 ci_ns <= CI_ST_ABORT;
		   else if(ci_adsb == 1'b0 || ads_fgb == 1'b0)
			 ci_ns <= CI_ST_SEND_CMD;
		   else ci_ns <= CI_ST_IDLE;
		end
		ci_cs[CI_SEND_CMD] : begin
		   if(ci_abortb == 1'b0)
			 ci_ns <= CI_ST_ABORT;
		   else if(rdyb_hsk == 1'b0)
			 ci_ns <= CI_ST_GET_RDY;
		   else ci_ns <= CI_ST_SEND_CMD;
		end
		ci_cs[CI_GET_RDY] : begin
		   if(ci_abortb == 1'b0)
			 ci_ns <= CI_ST_ABORT;
		   else ci_ns <= CI_ST_END_CMD;
		end
		ci_cs[CI_END_CMD] : begin
		   if(ci_abortb == 1'b0)
			 ci_ns <= CI_ST_ABORT;
		   else if(rdyb_hsk == 1'b1) begin
			  if(lastb_hsk == 1'b1)
				ci_ns <= CI_ST_SEND_CMD;
			  else ci_ns <= CI_ST_IDLE;
		   end
		   else ci_ns <= CI_ST_END_CMD;
		end
		ci_cs[CI_ABORT] : begin
		   if(rdyb_hsk == 1'b1 && adsb_hsk == 1'b1)
			 ci_ns <= CI_ST_IDLE;
		   else ci_ns <= CI_ST_ABORT;
		end
		default : ci_ns <= CI_ST_IDLE;
	  endcase // case(1'b1)
   end // always@ (ci_abortb or ci_cs or ci_adsb or rdyb_hsk or...
   
   
   
   //--------------------------------------------------------------------
   // State Machine for the SRAM interface
   parameter               SI_IDLE = 0;
   parameter               SI_NEW_OP = SI_IDLE + 1;
   parameter 			   SI_WAIT_RDYS = SI_NEW_OP + 1;
   parameter 			   SI_SEND_RD = SI_WAIT_RDYS + 1;
   parameter 			   SI_WAIT_FRDY = SI_SEND_RD + 1;
   parameter 			   SI_SEND_RDY = SI_WAIT_FRDY + 1;
   parameter 			   SI_END_CMD = SI_SEND_RDY + 1;
   parameter 			   SI_WAIT_ADS = SI_END_CMD + 1;
   
   parameter               SI_SM_NUM = SI_WAIT_ADS + 1;

   parameter 			   SI_SM_INIT = {{(SI_SM_NUM-1){1'b0}},1'b1};

   parameter               SI_ST_IDLE = (SI_SM_INIT << SI_IDLE);
   parameter               SI_ST_NEW_OP = (SI_SM_INIT << SI_NEW_OP);
   parameter               SI_ST_WAIT_RDYS = (SI_SM_INIT << SI_WAIT_RDYS);
   parameter               SI_ST_SEND_RD = (SI_SM_INIT << SI_SEND_RD);
   parameter               SI_ST_WAIT_FRDY = (SI_SM_INIT << SI_WAIT_FRDY);
   parameter               SI_ST_SEND_RDY = (SI_SM_INIT << SI_SEND_RDY);
   parameter               SI_ST_END_CMD = (SI_SM_INIT << SI_END_CMD);
   parameter               SI_ST_WAIT_ADS = (SI_SM_INIT << SI_WAIT_ADS);

   
   reg [SI_SM_NUM-1:0] 	   si_cs, si_ns;

   // states
   wire 				   si_sm_idle = si_cs[SI_IDLE];
   wire 				   si_sm_wait_rdys = si_cs[SI_WAIT_RDYS];
   wire 				   si_sm_new_op = si_cs[SI_NEW_OP];
   wire 				   si_sm_send_rd = si_cs[SI_SEND_RD];
   wire 				   si_sm_wait_frdy = si_cs[SI_WAIT_FRDY];
   wire 				   si_sm_send_rdy = si_cs[SI_SEND_RDY];
   wire 				   si_sm_end_cmd = si_cs[SI_END_CMD];
   wire 				   si_sm_wait_ads = si_cs[SI_WAIT_ADS];
   //
   

 
   always@(posedge clk_sys or negedge rstb) begin
	  if(~rstb) si_cs <= SI_ST_IDLE;
	  else si_cs <= si_ns;
   end // always

   always@(si_cs or adsb_hsk or si_rdyb or wr_hsk or si_rdb or 
		   rdyb_hsk or lastb_hsk or si_err or abortb_hsk) begin
	  case(1'b1)
		si_cs[SI_IDLE] : begin
		   if(abortb_hsk != 1'b0 && adsb_hsk == 1'b0) begin
				si_ns <= SI_ST_NEW_OP;
/*			  if(si_rdyb == 1'b0) begin
				 if(wr_hsk == 1'b1) // if write
				   si_ns <= SI_ST_SEND_RDY;
				 else si_ns <= SI_ST_SEND_RD;
			  end // if ready
			  else si_ns <= SI_ST_WAIT_RDYS;*/
		   end
		   else si_ns <= SI_ST_IDLE;
		end // case: si_cs[SI_IDLE]

		si_cs[SI_NEW_OP] : begin
			if(abortb_hsk == 1'b0)
				si_ns <= SI_ST_IDLE;
			else if(si_rdyb == 1'b0) begin
				 if(wr_hsk == 1'b1) // if write
				   si_ns <= SI_ST_SEND_RDY;
				 else si_ns <= SI_ST_SEND_RD;
			  end // if ready
			else si_ns <= SI_ST_WAIT_RDYS;
		end

		si_cs[SI_WAIT_RDYS] : begin
		   if(abortb_hsk == 1'b0)
			 si_ns <= SI_ST_IDLE;
		   else if(si_rdyb == 1'b0) begin
			  if(wr_hsk == 1'b1) // if write
				si_ns <= SI_ST_SEND_RDY;
			  else si_ns <= SI_ST_SEND_RD;
		   end // if ready
		   else si_ns <= SI_ST_WAIT_RDYS;
		end
		si_cs[SI_SEND_RD] : begin
		   if(abortb_hsk == 1'b0)
			 si_ns <= SI_ST_IDLE;
		   else si_ns <= SI_ST_WAIT_FRDY;
		end
		si_cs[SI_WAIT_FRDY] : begin
		   if(abortb_hsk == 1'b0)
			 si_ns <= SI_ST_IDLE;
		   else if(si_rdyb == 1'b0)
		   	 //si_ns <= SI_ST_END_CMD; // Revision for Pre Read 2007.8.1 by Duck
			 si_ns <= SI_ST_SEND_RDY;
		   else si_ns <= SI_ST_WAIT_FRDY;
		end
		si_cs[SI_SEND_RDY] : begin
		   if(abortb_hsk == 1'b0)
			 si_ns <= SI_ST_IDLE;
		   else si_ns <= SI_ST_END_CMD;
		end
		si_cs[SI_END_CMD] : begin
		   if(abortb_hsk == 1'b0)
			 si_ns <= SI_ST_IDLE;
		   else if(adsb_hsk == 1'b1) begin
			  if(lastb_hsk == 1'b0 || si_err == 1'b1) // last or error.
				si_ns <= SI_ST_IDLE;
			  else si_ns <= SI_ST_WAIT_ADS;
		   end
		   else si_ns <= SI_ST_END_CMD;
		end
		si_cs[SI_WAIT_ADS] : begin
		   if(abortb_hsk == 1'b0)
			 si_ns <= SI_ST_IDLE;
		   else if(adsb_hsk == 1'b0 && si_rdyb == 1'b0 && 
                   si_rdb == 1'b1 )
			  si_ns <= SI_ST_SEND_RDY;
		   else si_ns <= SI_ST_WAIT_ADS;
		end
		default : si_ns <= SI_ST_IDLE;
	  endcase // case(1'b1)
   end // always@ (si_cs or adsb_hsk or si_rdyb or...


   

   //---------------------------------------------------------------
   // End command state   operation   .
   assign abortb_hsk = ci_abortb & (~ci_sm_abort); // 2007.7.20
   
   always@(posedge clk_card or negedge rstb) begin
	  if(~rstb) ads_fgb <= 1'b1;
	  else if(abortb_hsk == 1'b0) ads_fgb <= 1'b1;
	  else if(ci_adsb == 1'b0)
		ads_fgb <= 1'b0;
	  //else if(rdyb_hsk == 1'b0)
	  else if(ci_rdyb == 1'b0)
		ads_fgb <= 1'b1;
   end // always ads_fgb

   assign adsb_hsk = (ci_sm_send_cmd | ci_sm_get_rdy)? 1'b0 : 1'b1;

   always@(posedge clk_card or negedge rstb) begin
	  if(~rstb) lastb_hsk <= 1'b1;
	  else if(abortb_hsk == 1'b0) lastb_hsk <= 1'b1;
	  else if(ci_sm_send_cmd | ci_sm_idle)
		lastb_hsk <= ci_blastb;
   end // always lastb_hsk
   
   always@(posedge clk_card or negedge rstb) begin
	  if(~rstb) wr_hsk <= 1'b0;
	  else if(abortb_hsk == 1'b0) wr_hsk <= 1'b0;
	  else if(ci_adsb == 1'b0)
		wr_hsk <= ci_wr;
   end // always wr_hsk

   always@(posedge clk_card or negedge rstb) begin
	  if(~rstb) wr2_hsk <= 1'b0;
	  else if(ci_sm_idle) wr2_hsk <= ci_wr;
   end // always wr_hsk


	always@(posedge clk_sys or negedge rstb) begin
		if(~rstb) si_wr	<= 1'b1;
		else if (si_sm_idle)	si_wr	<= wr2_hsk;
	end

	// indicate size
   always@(posedge clk_card or negedge rstb) begin
	  if(~rstb) size_hsk <= 10'h0;
	  else if(ci_sm_idle) size_hsk <= ci_size;
   end // always wr_hsk


	always@(posedge clk_sys or negedge rstb) begin
		if(~rstb) si_size	<= 10'h0;
		else if (si_sm_idle)	si_size	<= size_hsk;
	end
	
		////////////////// abort signal

	reg		si_abortb;
	always@(posedge clk_sys or negedge rstb) begin
		if(~rstb) si_abortb	<= 1'b1;
		else si_abortb <= abortb_hsk;
	end


   assign rdyb_hsk = (si_sm_send_rdy | si_sm_end_cmd)? 1'b0 : 1'b1;
   
   assign ci_rdyb = (ci_sm_get_rdy)? 1'b0 : 1'b1;
   
   always@(posedge clk_card or negedge rstb) begin
	  if(~rstb) ci_error <= 1'b0;
	  else if(abortb_hsk == 1'b0) ci_error <= 1'b0;
	  else if(ci_sm_send_cmd) ci_error <= si_err;
	  else if(ci_sm_end_cmd) ci_error <= 1'b0;
   end // always ci_error


   assign si_wrb = (si_sm_send_rdy)? ~wr_hsk : 1'b1;
   //assign si_rdb = (si_sm_send_rdy | si_sm_send_rd)? wr_hsk : 1'b1;

   reg      si_sm_end_cmd_dly; // 1 cycle delay
   always@(posedge clk_sys or negedge rstb) begin
	  if(~rstb) si_sm_end_cmd_dly <= 1'b0;
	  else si_sm_end_cmd_dly <= si_sm_end_cmd;
   end

   assign si_rdb = ((~si_sm_end_cmd & si_sm_end_cmd_dly) | si_sm_send_rd)? wr_hsk : 1'b1;

   
   //---------------------------------------------------------
   // Select address space
   always@(posedge clk_card or negedge rstb) begin
	  if(~rstb) csb_hsk <= 2'h3;
	  else if(abortb_hsk == 1'b0) csb_hsk <= 2'h3;
	  else if(ci_sm_idle) csb_hsk <= ci_csb;
   end // always csb_hsk


   always@(posedge clk_sys or negedge rstb) begin
	  if(~rstb) si_csb <= 2'h3;
	  else if(abortb_hsk == 1'b0) si_csb <= 2'h3;
	  else if(si_sm_idle) si_csb <= csb_hsk;
   end // always si_csb


   

   //-------------------------------------------------------------
   // 2007.6.21
   // new operation signal
/*
   always@(posedge clk_sys or negedge rstb) begin
	  if(~rstb) f_sm_loop <= 1'b0;
	  else if(abortb_hsk == 1'b0) f_sm_loop <= 1'b0;
	  else if(si_sm_idle) f_sm_loop <= 1'b1;
	  else if(si_sm_wait_ads) f_sm_loop <= 1'b0;
   end // always f_sm_loop
  */
		assign si_newopb = ~si_sm_new_op;

/* 
   always@(wr_hsk or si_sm_send_rdy or si_sm_end_cmd or 
		   si_sm_send_rd or si_sm_wait_frdy or f_sm_loop) begin
	  if(f_sm_loop &wr_hsk &(si_sm_send_rdy | si_sm_end_cmd))
		si_newopb <= 1'b0;
	  else if((~wr_hsk) & (si_sm_send_rd | si_sm_wait_frdy))
		si_newopb <= 1'b0;
	  else si_newopb <= 1'b1;
   end // always si_newopb
   
*/
   
   
   //--------------------------------------------------------------
   // Address
   always@(posedge clk_card or negedge rstb) begin
	  if(~rstb) addr_hsk <= {CIADDR_WIDTH{1'b0}};
	  //else if(abortb_hsk == 1'b0) addr_hsk <= {CIADDR_WIDTH{1'b0}};
	  else if(ci_adsb == 1'b0)
		addr_hsk <= ci_addr;
   end // always addr_hsk

   always@(posedge clk_sys or negedge rstb)begin
	  if(~rstb) si_rdyb_dly <= 1'b0;
	  else if(abortb_hsk == 1'b0) si_rdyb_dly <= 1'b0;
	  else si_rdyb_dly <= si_rdyb;
   end

   assign si_rdyb_edge = (si_rdyb_dly == 1'b1 && 
						  si_rdyb == 1'b0)? 1'b0 : 1'b1;
   
   always@(posedge clk_sys or negedge rstb) begin
	  if(~rstb) si_addr <= {SIADDR_WIDTH{1'b0}};
	  else if(si_sm_idle || abortb_hsk == 1'b0)
		si_addr <= addr_hsk[SIADDR_WIDTH-1:0];
/*
	  else if((si_sm_wait_frdy == 1'b1 && si_rdyb == 1'b0) ||
			  ((si_sm_wait_ads | si_sm_end_cmd) && (si_rdyb_edge == 1'b0)))
		si_addr <= si_addr + 4;
*/
   end // always si_addr

   // Data
   always@(posedge clk_card or negedge rstb) begin
	  if(~rstb) begin
		 wdata_hsk <= {32{1'b0}};
		 beb_hsk <= 4'hf;
	  end
	  else if(adsb_hsk == 1'b1) begin
		 wdata_hsk <= ci_wdata;
		 beb_hsk <= ci_beb;
	  end
   end // always wdata_hsk,beb_hsk
   

   always@(posedge clk_sys or negedge rstb) begin
	  if(~rstb) begin
		 si_wdata <= {32{1'b0}};
		 si_beb <= 4'hf;
	  end
	  else if(adsb_hsk == 1'b0 && (si_sm_idle | si_sm_wait_ads)) begin
		 si_wdata <= wdata_hsk;
		 si_beb <= beb_hsk;
	  end
   end // always si_wdata,si_beb
   
   
   always@(posedge clk_sys or negedge rstb) begin
	  if(~rstb) rdata_hsk <= {32{1'b0}};
	  //else if((si_sm_wait_frdy | si_sm_wait_ads) && si_rdyb == 1'b0)
      else if(si_rdb == 1'b0)
		rdata_hsk <= si_rdata;
   end // always rdata_hsk


   always@(posedge clk_card or negedge rstb) begin
	  if(~rstb) ci_rdata <= {32{1'b0}};
	  else if(ci_sm_send_cmd)
		ci_rdata <= rdata_hsk;
   end // always ci_rdata

   //===============================================================
   // synopsys translate_off
   
   always@(posedge clk_card or negedge rstb) begin
	  if(rstb && ci_abortb == 1'b0)
		$display("!!!! Card Transfer Abort!!!");
   end 
   
   // synopsys translate_on
   //===============================================================
   
endmodule // cardctrlwrap
