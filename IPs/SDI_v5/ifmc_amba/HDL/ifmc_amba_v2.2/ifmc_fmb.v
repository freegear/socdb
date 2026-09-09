/*
   Flash Memory Block
  
   Protection 기능 포함.
 
   file name : ifmc_fmb.v
 
   created by gtlee
 
   date : 2006.2.28
 
 
   note :
      Address는 cpu가 출력한 address[17:2]가 mapping된다.
      Flash read timing control을 수행.
 */


module     ifmc_fmb
  (
   clk             ,
   rstb            ,

   rdwaitcycle     ,
   info_rd         ,
   fmr_adr         , 
   fmr_rd          , 
   fmr_rdata       ,
   ready_1cb       ,
   ready           ,

   fm_wrmode       ,
   fmw_adr         ,
   fmw_xe          ,
   fmw_ye          ,
   fmw_se          ,
   fmw_erase       ,
   fmw_mas1        ,
   fmw_prog        ,
   fmw_nvstr       ,
   fmw_ifren       ,
   fmw_din         ,
   
   hdp             ,
   rdp             ,
   smart           ,
   
   fm_xadr         ,
   fm_yadr         ,
   fm_xe           ,
   fm_ye           ,
   fm_se           ,
   fm_erase        ,
   fm_mas1         ,
   fm_prog         ,
   fm_nvstr        ,
   fm_ifren        ,
   fm_din          ,
   fm_dout         
   );
   parameter             PROT_ADDR  =     16'h000F;
   parameter 			 SMART_ADDR =     16'h000E;
      
   input                 clk;
   input 				 rstb;

   input [1:0] 			 rdwaitcycle; // read cycle count. from reg module
   input 				 info_rd;
   input [15:0] 		 fmr_adr;   // ahb_addr[17:2]
   input 				 fmr_rd;   // chip select
   output [31:0] 		 fmr_rdata;
   output 				 ready_1cb;  // 1 clock before ready
   output 				 ready;

   input 				 fm_wrmode;
   input [15:0] 		 fmw_adr;
   input 				 fmw_xe;
   input 				 fmw_ye;
   input 				 fmw_se;
   input 				 fmw_erase;
   input 				 fmw_mas1;
   input 				 fmw_prog;
   input 				 fmw_nvstr;
   input 				 fmw_ifren;
   input [31:0] 		 fmw_din;
   
   // protection information
   output 				 hdp;
   output 				 rdp;
   output [15:0] 		 smart;
   
   // Flash Memory Core Pin
   output [9:0]          fm_xadr;
   output [5:0] 		 fm_yadr;
   output 				 fm_xe;     // address enable
   output 				 fm_ye;     // address enable
   output 				 fm_se;     // sense amp
   output 				 fm_erase;
   output 				 fm_mas1;
   output 				 fm_prog;
   output 				 fm_nvstr;
   output 				 fm_ifren;  // information block enable
   output [31:0] 		 fm_din;
   input [31:0] 		 fm_dout;
   

   //---------------------------------------------------
   // Internal signals
   wire 				 ready_1cb;
   wire 				 ready;
   reg [31:0] 			 fmr_rdata;

   reg 					 hdp; // bit 17
   reg 					 rdp; // bit 27
   reg [15:0] 			 smart;

   reg [9:0] 			 fm_xadr;
   reg [5:0] 			 fm_yadr;
   reg 					 fm_xe;     // address enable
   reg 					 fm_ye;     // address enable
   reg 					 fm_se;
   reg 					 fm_prog;
   reg 					 fm_erase;
   reg 					 fm_mas1;
   reg 					 fm_nvstr;
   reg 					 fm_ifren;
   reg [31:0] 			 fm_din;

   wire 				 op_read;
   wire 				 op_prog;
   wire 				 op_perase;
   wire 				 op_berase;
   
   
   //--------------------------------------------------

   reg [1:0] 			 cnt; // counter
   wire 				 read_end;
   
   //===================================================
   // State Machine
   parameter 			 FMB_SM_WIDTH =          9;
   parameter 			 FMB_SM_INIT  = {{(FMB_SM_WIDTH-1){1'b0}},1'b1};
     
   parameter 			 START         =        0;
   parameter 			 WAIT0         =        1;
   parameter 			 WAIT1         =        2;
   parameter 			 WAIT2         =        3;
   parameter 			 SET_RD_PROT   =        4;
   parameter 			 WAIT_RD_PROT  =        5;
   parameter 			 SET_RD_SMART  =        6;
   parameter 			 WAIT_RD_SMART =        7;
   parameter 			 NORMAL        =        8;
   

   parameter 			 ST_START            =  (FMB_SM_INIT << START);
   parameter 			 ST_WAIT0            =  (FMB_SM_INIT << WAIT0);
   parameter 			 ST_WAIT1            =  (FMB_SM_INIT << WAIT1);
   parameter 			 ST_WAIT2            =  (FMB_SM_INIT << WAIT2);
   parameter 			 ST_SET_RD_PROT      =  (FMB_SM_INIT << SET_RD_PROT);
   parameter 			 ST_WAIT_RD_PROT     =  (FMB_SM_INIT << WAIT_RD_PROT);
   parameter 			 ST_SET_RD_SMART     =  (FMB_SM_INIT << SET_RD_SMART);
   parameter 			 ST_WAIT_RD_SMART    =  (FMB_SM_INIT << WAIT_RD_SMART);
   parameter 			 ST_NORMAL           =  (FMB_SM_INIT << NORMAL);
   
   
   reg [FMB_SM_WIDTH-1:0] 	 cs, ns;
   
   // read operation
   parameter 				 RD_SM_WIDTH        =  4;
   parameter 				 RD_SM_INIT        = {{(RD_SM_WIDTH-1){1'b0}},1'b1};
   
   parameter 				 IDLE              =   0;
   parameter 				 SETCNT            =   1;
   parameter 				 READ              =   2;
   parameter 				 RDEND             =   3;
   
   parameter 				 ST_IDLE          =    (RD_SM_INIT << IDLE);
   parameter 				 ST_SETCNT        =    (RD_SM_INIT << SETCNT);
   parameter 				 ST_READ          =    (RD_SM_INIT << READ);
   parameter 				 ST_RDEND         =    (RD_SM_INIT << RDEND);


   reg [RD_SM_WIDTH-1:0]    rd_cs, rd_ns;
   
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) rd_cs <= ST_IDLE;
	  else rd_cs <= rd_ns;
   end

   always@(rd_cs or cs or op_read or cnt or fm_wrmode) begin
	  case (1'b1)   // synopsys parallel_case
		rd_cs[IDLE] :
		  if( fm_wrmode == 1'b1)
			rd_ns <= ST_IDLE;
		  else if( cs[NORMAL] == 1'b1 && op_read == 1'b1)
			rd_ns <= ST_SETCNT;
		  else if( cs[SET_RD_PROT] | cs[SET_RD_SMART])
			rd_ns <= ST_SETCNT;
		  else rd_ns <= ST_IDLE;

		rd_cs[SETCNT] : rd_ns <= ST_READ;

		rd_cs[READ] :
		  if(cnt == 2'h0) rd_ns <= ST_RDEND;
		  else rd_ns <= ST_READ;

		rd_cs[RDEND] : rd_ns <= ST_IDLE;

		default : rd_ns <= ST_IDLE;
	  endcase // case(1'b1)
   end // always@ (rd_cs or cs or op_read or cnt)
   
   //---------------------------------------
   // Init Protection Register

   
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) cs <= ST_START;
	  else cs <= ns;
   end

   always@(cs or read_end) begin
	  case(1'b1)  // synopsys parallel_case
		cs[START] : ns <= ST_WAIT0;
		
		cs[WAIT0] : ns <= ST_WAIT1;

		cs[WAIT1] : ns <= ST_WAIT2;

		cs[WAIT2] : ns <= ST_SET_RD_PROT;

		cs[SET_RD_PROT] : ns <= ST_WAIT_RD_PROT; // rd_cs is IDLE

		cs[WAIT_RD_PROT] :
		  if(read_end) ns <= ST_SET_RD_SMART;
		  else ns <= ST_WAIT_RD_PROT;

		cs[SET_RD_SMART] : ns <= ST_WAIT_RD_SMART; // rd_cs is IDLE

		cs[WAIT_RD_SMART] :
		  if(read_end) ns <= ST_NORMAL;
		  else ns <= ST_WAIT_RD_SMART;

		cs[NORMAL] : ns <= ST_NORMAL;
		
		default : ns <= ST_START;
	  endcase // case(1'b1)
   end // always@ (cs or read_end)
   
   //---------------------------------------------------------
   // control signals

   assign       op_read   =  fmr_rd;
   assign 		op_prog   = ~fmr_rd & fmw_prog;
   assign 		op_perase = ~fmr_rd & fmw_erase;
   assign 		op_berase = ~fmr_rd & fmw_mas1;
   
   // Protection Information
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) begin
		 hdp <= 1'b1;
		 rdp <= 1'b1;
	  end
	  else if(cs[WAIT_RD_PROT] == 1'b1 && read_end == 1'b1) begin
		 // read after reset.  from FM
		 hdp <= fm_dout[17];
		 rdp <= fm_dout[27];
	  end
	  else if(fmw_ifren == 1'b1 && op_prog == 1'b1 && fmw_adr == PROT_ADDR && 
			  fmw_xe == 1'b1 && fmw_ye == 1'b1) begin
		 // protection programming
		 hdp <= hdp & fmw_din[17];
		 rdp <= rdp & fmw_din[27];
	  end
	  else if(fmw_ifren == 1'b1 && op_berase == 1'b1) begin
		 // erase information block
		 hdp <= 1'b1;
		 rdp <= 1'b1;
	  end
   end // always@ (posedge clk or negedge rstb)
   
   // Smart Information
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) smart <= {16{1'b1}};
	  else if(cs[WAIT_RD_SMART] == 1'b1 && read_end == 1'b1) 
		 // read after reset. from FM
		 smart <= fm_dout[15:0];
	  else if(fmw_ifren == 1'b1 && op_prog == 1'b1 && fmw_adr == SMART_ADDR && 
			  fmw_xe == 1'b1 && fmw_ye == 1'b1)
		 // protection programming
		smart <= smart & fmw_din[15:0];
	  else if(fmw_ifren == 1'b1 && op_berase == 1'b1)
		 // erase information block
		smart <= {16{1'b1}};
   end // always@ (posedge clk or negedge rstb)

   //------------------------------------------------
   // Read timing counter
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) cnt <= 2'h3;
	  else if(rd_cs[SETCNT])
		cnt <= rdwaitcycle;
	  else if(rd_cs[READ]) cnt <= cnt + 2'h3;  // cnt - 1 = cnt + 3
   end
   
   //------------------------------------------------
   //
   assign       read_end = rd_cs[RDEND];
   assign       ready = cs[NORMAL] & read_end;
   assign 		ready_1cb = cs[NORMAL] & rd_cs[READ] & ~(|cnt);
   
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) fmr_rdata <= {31{1'b1}};
	  else if(read_end)
		fmr_rdata <= fm_dout;
   end
   
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) fm_din <= {31{1'b1}};
	  else //if( rd_cs[IDLE] )
		fm_din <= fmw_din;
   end
   
   // FM address signal
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) begin
		 fm_xadr <= {10{1'b0}};
		 fm_yadr <= {6{1'b0}};
	  end
	  else if(cs[SET_RD_PROT]) begin
		 fm_xadr <= {10{1'b0}};
		 fm_yadr <= 6'h0F;
	  end
	  else if(cs[SET_RD_SMART]) begin
		 fm_xadr <= {10{1'b0}};
		 fm_yadr <= 6'h0E;
	  end
	  else if(cs[NORMAL] & rd_cs[IDLE]) begin
		 if(fm_wrmode) begin
			fm_xadr <= fmw_adr[15:6];
			fm_yadr <= fmw_adr[5:0];
		 end
		 else begin
			fm_xadr <= fmr_adr[15:6];
			fm_yadr <= fmr_adr[5:0];
		 end
	  end
   end // always@ (posedge clk or negedge rstb)
   
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) begin
		 fm_xe <= 1'b0;
		 fm_ye <= 1'b0;
	  end
	  else if(cs[SET_RD_PROT] | cs[SET_RD_SMART]) begin
		 fm_xe <= 1'b1;
		 fm_ye <= 1'b1;
	  end
	  else if(cs[NORMAL] & rd_cs[IDLE]) begin
		 if(fm_wrmode) begin
			fm_xe <= fmw_xe;
			fm_ye <= fmw_ye;
		 end
		 else begin
			fm_xe <= op_read;
			fm_ye <= op_read;
		 end
	  end
   end // always@ (posedge clk or negedge rstb)


   always@(posedge clk or negedge rstb) begin
	  if(~rstb) fm_se <= 1'b0;
	  else if(cs[NORMAL] & rd_cs[IDLE])
		fm_se <= op_read;
	  else if(cs[SET_RD_PROT] | cs[WAIT_RD_PROT] |
			  cs[SET_RD_SMART] | cs[WAIT_RD_SMART])
		fm_se <= 1'b1;
   end

   always@(posedge clk or negedge rstb) begin
	  if(~rstb) begin
		 fm_prog <= 1'b0;
		 fm_erase <= 1'b0;
		 fm_mas1 <= 1'b0;
		 fm_nvstr <= 1'b0;
	  end
	  else if(cs[NORMAL] & rd_cs[IDLE] ) begin
		 if(fm_wrmode) begin
			fm_prog <= fmw_prog;
			fm_erase <= fmw_erase;
			fm_mas1 <= fmw_mas1;
			fm_nvstr <= fmw_nvstr;
		 end
		 else begin // at read
			fm_prog <= 1'b0;
			fm_erase <= 1'b0;
			fm_mas1 <= 1'b0;
			fm_nvstr <= 1'b0;
		 end // else: !if(op_prog)
	  end // if (cs[NORMAL] & rd_cs[IDLE] )
	  else begin
		 fm_prog <= 1'b0;
		 fm_erase <= 1'b0;
		 fm_mas1 <= 1'b0;
		 fm_nvstr <= 1'b0;
	  end // else: !if(cs[NORMAL])
   end // always@ (posedge clk or negedge rstb)
   
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) fm_ifren <= 1'b0;
	  else if(~cs[NORMAL])
		fm_ifren <= 1'b1; // read protection after reset
	  else if(rd_cs[IDLE]) begin
		 if(fm_wrmode)
		   fm_ifren <= fmw_ifren;
		 else if(info_rd)
		   fm_ifren <= 1'b1;  // infomation block read. for debugging
		 else 
		   fm_ifren <= 1'b0;  // main memory read
	  end
   end // always@ (posedge clk or negedge rstb)
   
   
   //------------------------------------------------------
   // synopsys translate_off
   wire      sm_idle = rd_cs[IDLE];
   wire 	 sm_setcnt = rd_cs[SETCNT];
   wire 	 sm_read = rd_cs[READ];
   wire 	 sm_rdend = rd_cs[RDEND];
   
   wire      sm_start = cs[START];
   wire 	 sm_wait0 = cs[WAIT0];
   wire 	 sm_wait1 = cs[WAIT1];
   wire 	 sm_wait2 = cs[WAIT2];
   wire      sm_set_rd_prot = cs[SET_RD_PROT];
   wire      sm_wait_rd_prot = cs[WAIT_RD_PROT];
   wire      sm_set_rd_smart = cs[SET_RD_SMART];
   wire      sm_wait_rd_smart = cs[WAIT_RD_SMART];
   wire      sm_normal = cs[NORMAL];
   
   // synopsys translate_on
   //------------------------------------------------------
   
endmodule // ifmc_fmb

