/***********************************************************
   Generate Read timing for FMC
  
   Use AHB
 
   file name : ifmc_rd.v
 
   created by gtlee
 
   date : 2006.3.4
 
   note :
         
 ************************************************************/

module      ifmc_rd
  (
   clk                ,
   rstb               ,
   
   ahb_sel            ,
   ahb_readyin        ,
   ahb_trans          ,
   ahb_addr           ,
   ahb_write          ,
   ahb_size           ,
   
   ahb_rdata          ,
   ahb_ready          ,
   ahb_resp           ,
   
   fm_wrmode          ,
   fm_rdmode          ,
   
   fmr_adr            ,
   fmr_rd             ,
   fmr_rdata          ,
   fmb_ready          ,
   fmb_ready_1cb            
   );

   parameter               ADDR_WIDTH = 18;
   parameter 			   DATA_WIDTH = 32;
   
   input 				   clk;
   input 				   rstb;
   
   input 				   ahb_sel;
   input 				   ahb_readyin;
   input [1:0] 			   ahb_trans;
   input [ADDR_WIDTH-1:2]  ahb_addr;
   input 				   ahb_write;
   input [2:0] 			   ahb_size;

   output [DATA_WIDTH-1:0] ahb_rdata;
   output 				   ahb_ready;
   output [1:0] 		   ahb_resp;

   input 				   fm_wrmode;
   output 				   fm_rdmode;

   // Flash Memory Interface signal
   output [15:0] 		   fmr_adr;
   output 				   fmr_rd;
   input [DATA_WIDTH-1:0]  fmr_rdata;
   input 				   fmb_ready;
   input 				   fmb_ready_1cb;  // fmb_ready보다 1 clock 빠르다. no used
   
 
   //---------------------------------------
   // internal signals
   reg [DATA_WIDTH-1:0]    ahb_rdata;
   wire 				   ahb_ready;
   wire [1:0]			   ahb_resp;

   wire 				   fm_rdmode;

   wire [15:0] 			   fmr_adr;
   wire 				   fmr_rd;

   wire 				   ahb_start;
   reg 					   dphase;
   
   reg [ADDR_WIDTH-1:2]    t_addr;
   reg 					   t_write;
   
   reg 					   rdata_en;
   

   // State Machine
   parameter 			   RD_SM_WIDTH       =   4;
   parameter               RD_SM_INIT        =   {{(RD_SM_WIDTH-1){1'b0}},1'b1};
   
   parameter 			   IDLE              =   0;
   parameter 			   WAIT_ED_WR        =   1;
   parameter 			   FMR_RD            =   2;
   parameter 			   END_RD            =   3;
   
   parameter 			   ST_IDLE           =   (RD_SM_INIT << IDLE);
   parameter 			   ST_WAIT_ED_WR     =   (RD_SM_INIT << WAIT_ED_WR);
   parameter 			   ST_FMR_RD         =   (RD_SM_INIT << FMR_RD);
   parameter 			   ST_END_RD         =   (RD_SM_INIT << END_RD);
   

   reg [RD_SM_WIDTH-1:0]  cs, ns;


   always@(posedge clk or negedge rstb) begin
	  if(~rstb) cs <= ST_IDLE;
	  else cs <= ns;
   end

   always@(cs or ahb_start or fm_wrmode or fmb_ready or dphase) begin
	  case(1'b1)  // synopsys parallel_case
		cs[IDLE] :
		  if( ahb_start ) begin
			 if( fm_wrmode ) 
			   ns <= ST_WAIT_ED_WR;
			 else ns <= ST_FMR_RD;
		  end
		  else ns <=  ST_IDLE;

		cs[WAIT_ED_WR] :
		  if( fm_wrmode ) ns <= cs;
		  else ns <= ST_FMR_RD;

		cs[FMR_RD] :
		  if(fmb_ready) ns <= ST_END_RD;
		  else ns <= ST_FMR_RD;

		cs[END_RD] :
		  if(dphase) ns <= ST_IDLE;
		  else ns <= ST_END_RD;
		
		default : ns <= ST_IDLE;
	  endcase // case(1'b1)
   end
 
   //-------------------------------------------------------------
   assign	   ahb_start = (ahb_sel & (|ahb_trans))? 1'b1 : 1'b0;

   always@(posedge clk or negedge rstb) begin
	  if(~rstb)	dphase <= 1'b0;
	  else if(  cs[IDLE] | ~dphase ) begin
		 dphase <= ahb_readyin;
	  end
   end // always@ (posedge clk or negedge rstb)
   
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) begin
		 t_addr <= {ADDR_WIDTH{1'b0}};
		 t_write <= 1'b0;
	  end
	  else if(cs[IDLE]) begin
		 if( ahb_start) begin // 2006.3.9 add ahb_start
			t_addr <= ahb_addr;
			t_write <= ahb_write;
		 end
		 else begin
			t_addr <= {ADDR_WIDTH{1'b0}};
			t_write <= 1'b0;
		 end // else
	  end // else if
   end // always

   assign 	 fmr_adr = t_addr[17:2]; // low 2bit은 byte selection이므로 무시.
   assign    fmr_rd = cs[FMR_RD];
   assign 	 fm_rdmode = ~cs[IDLE]; // to write control module
   
   // for latching the read data.
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) rdata_en <= 1'b0;
	  else rdata_en <= fmb_ready;
   end
   
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) ahb_rdata <= {DATA_WIDTH{1'b0}};
	  else if(rdata_en) ahb_rdata <= fmr_rdata;
   end

   assign    ahb_ready = (cs[IDLE] | ~dphase)? 1'b1 : 1'b0;
   assign 	 ahb_resp = 2'b00;

   //------------------------------------------------------
   // synopsys translate_off
   
   wire 	 sm_idle = cs[IDLE];
   wire 	 sm_wait_ed_wr = cs[WAIT_ED_WR];
   wire 	 sm_fmr_rd = cs[FMR_RD];
   wire 	 sm_end_rd = cs[END_RD];
   
   // synopsys translate_on
   //------------------------------------------------------

   
endmodule // ifmc_rd


   