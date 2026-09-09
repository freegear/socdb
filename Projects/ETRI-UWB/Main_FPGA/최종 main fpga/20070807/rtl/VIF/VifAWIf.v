/****************************************************
 
    AXI Write Module for Graphic Accelerator
 
    file name : ga_axiw.v
    created by gtlee
    data : 2006.7.11
 
    note :
       
    history : 
        2007.1.24 : revision 0.4. gwreay가 처음부터 출력되어야 유효한 
                    데이터를 받을 수 있다.
******************************************************/

`timescale 1ns/10ps

module VifAWIf
  (
   clk               ,
   rstb              ,
   
   AWID              ,
   AWADDR            ,
   AWLEN             ,
   AWSIZE            ,
   AWBURST           ,
   AWLOCK            ,
   AWCACHE           ,
   AWPROT            ,
   AWVALID           ,
   AWREADY           ,
   
   WID               ,
   WDATA             ,
   WSTRB             ,
   WLAST             ,
   WVALID            ,
   WREADY            ,
   
   BID               ,
   BRESP             ,
   BVALID            ,
   BREADY            ,
   
   
   gwr               ,
   gwaddr            ,
   gwsize            ,
   gwbe              ,
   gwdata			 ,
   gwready           ,
   gwbusy              
   );

//`include "VifPara.v"
   parameter        WID_WIDTH = 4;	// AWID/WID/BID width
   parameter 		RID_WIDTH = 4;	// ARID/RID width
   parameter 		DATA_WIDTH = 32;
   parameter 		NUM_BYTE = DATA_WIDTH/8;

   input 			clk;
   input 			rstb;
 
   // AXI Signals
   output [WID_WIDTH-1:0] AWID;
   output [31:0] 	AWADDR;
   output [3:0] 	AWLEN;
   output [2:0] 	AWSIZE;
   output [1:0] 	AWBURST;
   output [1:0] 	AWLOCK;
   output [3:0] 	AWCACHE;
   output [2:0] 	AWPROT;
   output 			AWVALID;
   input 			AWREADY;
   
   output [WID_WIDTH-1:0] WID;
   output [DATA_WIDTH-1:0] WDATA;
   output [NUM_BYTE-1:0]   WSTRB;
   output           WLAST;
   output 			WVALID;
   input 			WREADY;

   input [WID_WIDTH-1:0] BID;
   input [1:0] 			 BRESP;
   input 				 BVALID;
   output 				 BREADY;

   // Internal bus signals
   input 				  gwr;
   input [31:0] 		  gwaddr;
   input [4:0] 			  gwsize; // if 0, 1byte
   input [NUM_BYTE-1:0]   gwbe;
   input [DATA_WIDTH-1:0] gwdata;
   output 				  gwready;
   output 				  gwbusy;

   //===================================================
   
   wire [WID_WIDTH-1:0]   AWID;
   reg [31:0] 			  AWADDR;
   reg [3:0] 			  AWLEN;
   wire [2:0] 			  AWSIZE;
   wire [1:0] 			  AWBURST;
   wire [1:0] 			  AWLOCK;
   wire [3:0] 			  AWCACHE;
   wire [2:0] 			  AWPROT;
   wire 				  AWVALID;
   
   wire [WID_WIDTH-1:0]   WID;
   reg [DATA_WIDTH-1:0]   WDATA;
   reg [NUM_BYTE-1:0] 	  WSTRB;
   wire 				  WLAST;
   wire 				  WVALID;

   wire 				  BREADY;
   
   wire 				  gwready; 
   wire 				  gwbusy;  

   //----------------------------------
   // input delay and calc next parameters
   reg [31:0] 			  addr_dly;
   reg [NUM_BYTE-1:0] 	  be_dly;   // byte enable
   reg [DATA_WIDTH-1:0]   data_dly;
   reg 					  WREADY_dly;
   reg 					  gwready_pre;
   
   reg [NUM_BYTE-1:0] 	  be_dly2;   // for read delay 2 clock
   reg [DATA_WIDTH-1:0]   data_dly2;
      
   //reg [2:0] 			  byte_4_0;
   //reg [2:0] 			  byte_4_1;
   //reg [3:0] 			  byte_wd; // 1 word내에서 byte수.
   //wire [5:0] 			  need_wd; // read할 총 word수.
   wire [3:0] 			  burst_len; // 남은 burst 전송량.
   
   // check a single write
   //wire [2:0] 			  cmp_addr_8;
   
   // check the 4kbyte alignment
   wire [11:0] 			  cmp_4k; // 남은 byte수와 비교하여 작은 것을 전송량으로 선정.
   wire [8:0] 			  burst_4k; // 4k boundary까지 가능한 burst 수.
   // cmpare burst_len, burst_len_4k
   wire [7:0] 			  cmp_len_4k;
   wire [3:0] 			  small_wd;
   wire [3:0] 			  less_wd; // 4k boundary와 burst length사이에 작은 값.

   reg [5:0] 			  rest_len; // write operation동안 남아있는 총 byte수.
                                    // 0이면 남은 데이터가 없음을 의미.
   reg [5:0] 			  rest_lenm1; // rest_len - 1   
   wire [5:0] 			  cmp_byte;
   
   reg [5:0] 			  send_byte; // send bytes
   
   reg [3:0] 			  now_len; // command 당 전송해야할 데이터량.
                                   // WR_DATA state동안 전송해야 하는 word수.
   
   //=================================================
   parameter 			  SM_WIDTH = 4;
   parameter              SM_INIT = {{(SM_WIDTH-1){1'b0}},1'b1};
   
   parameter              IDLE = 0;
   parameter 			  CALC_LEN = 1;
   parameter 			  WR_CMD = 2;
   parameter 			  WR_RESP = 3;

   parameter 			  ST_IDLE = (SM_INIT << IDLE);
   parameter              ST_CALC_LEN = (SM_INIT << CALC_LEN);
   parameter 			  ST_WR_CMD = (SM_INIT << WR_CMD);
   parameter              ST_WR_RESP = (SM_INIT << WR_RESP);

   
   reg [SM_WIDTH-1:0] 	  ns,cs;
   
   reg                    sm_wr_resp_dly ;

   always@(posedge clk or negedge rstb) begin
	  if(~rstb) cs <= ST_IDLE;
	  else cs <= ns;
   end // always
   
   always@(cs or gwr or rest_len or BVALID) begin
	  case(1'b1)   // synopsys parallel_case
		 cs[IDLE] :
		   if(gwr) ns <= ST_CALC_LEN;
		   else ns <= ST_IDLE;
		 
		 cs[CALC_LEN] :
		   ns <= ST_WR_CMD;
		 
		 cs[WR_CMD] : // must be single clock
		   ns <= ST_WR_RESP;
		 
		 cs[WR_RESP] :
		   if(BVALID) begin  // && acs == AIDLE
		   //if(BVALID && acs == AIDLE) begin
			  if(rest_len == 6'h00) // end . 
				ns <= ST_IDLE;
			  else 
				ns <= ST_CALC_LEN;
		   end
		   else ns <= ST_WR_RESP;
		 
		 default :
		    ns <= ST_IDLE;
	  endcase // case(1'b1)
   end // always@ (cs or gwr or rest_len or BVALID)
   
   //------------------------------------------------------
   // synopsys translate_off
   wire   sm_idle = cs[IDLE];
   wire   sm_calc_len = cs[CALC_LEN];
   wire   sm_wr_cmd = cs[WR_CMD];
   wire   sm_wr_resp = cs[WR_RESP];
   // synopsys translate_on
   //------------------------------------------------------

   always@(posedge clk or negedge rstb) begin
      if(!rstb) sm_wr_resp_dly <= 1'b0;
      else sm_wr_resp_dly <= cs[WR_RESP];
   end //  always sm_wr_resp_dly 


   //---------------------------------------------------
   // 이번 operation에서 전송할 byte수.
   reg 	  gwready_dly;
   
   always@(posedge clk or negedge rstb) begin
	  if(!rstb) gwready_dly <= 1'b0;
	  else gwready_dly <= gwready;
   end
   

   
   //------------------
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) begin
		 be_dly <= {NUM_BYTE{1'b0}};
		 data_dly <= {DATA_WIDTH{1'b0}};
	  end // if
	  //else if(gwr == 1'b1 || (cs[IDLE] == 1'b0 && WREADY_dly == 1'b1)) begin	// gtlee insert WREADY_dly 1117
	  else if(gwready) begin
		 be_dly <= gwbe;
		 data_dly <= gwdata;
	  end // else if
   end // always


   always@(posedge clk or negedge rstb) begin
	  if(~rstb) begin
		 be_dly2 <= {NUM_BYTE{1'b0}};
		 data_dly2 <= {DATA_WIDTH{1'b0}};
	  end // if
	  else if(gwready_dly) begin
		 be_dly2 <= gwbe;
		 data_dly2 <= gwdata;
	  end // else if
   end // always



   //---------------------------------
   // at CALC_LEN stage
   // count bytes
   // word내에서 한번에 전송할수 있는 byte 수.
   //-------------------------------------------------------
   // calc. rest length
   // 남아 있는 총 byte수.
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) rest_len <= 6'h00;
	  else if(cs[IDLE] == 1'b1 && gwr == 1'b1)
		rest_len <= {1'b0,gwsize} + 6'h01;
	    // gwsize는 0이면 1byte전송을 의미하지만 rest_len은 1이어야 1byte를
	    // 나타낸다 따라서 이를 보정하기 위하여 1을 더한다.
	  else if(cs[WR_CMD] == 1'b1)  begin
		 // calc. rest bytes 
		   rest_len <= rest_len + {~send_byte}; // do not add 1
	  end // else if
   end // always@ (posedge clk or negedge rstb)

   // rest_len보다 1 clock 느림.
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) rest_lenm1 <= 6'h00;
	  else if(cs[IDLE] == 1'b1 && gwr == 1'b1)
		rest_lenm1 <= gwsize;
	  else 
 		rest_lenm1 <= rest_len[5:0] + 6'h3F;// rest_len - 1
   end // always@ (posedge clk or negedge rstb)

   //------------------------
   //always@(be_dly) begin
   //	  byte_4_0 <= be_dly[0] + be_dly[1] + be_dly[2] + be_dly[3];
   //	  byte_4_1 <= be_dly[4] + be_dly[5] + be_dly[6] + be_dly[7];
   //end // always

   // if start address is aligned.
   assign      burst_len = (&rest_lenm1[1:0])? 
						   rest_lenm1[5:2] : rest_lenm1[5:2] + 4'hf; // word개수 추출. 0~4
   
   assign 	   cmp_len_4k = {1'h0,burst_len, 2'b0} + {1'b0,&addr_dly[11:6],addr_dly[5:0]};	// East
                            // = burst_len - burst_4k
                            // = burst_len + ~burst_4k - 1 + 1
                            // = burst_len + ~burst_4k
               // if msb is 1, over the 4k.
               // if msb is 0, under the 4k
   assign      cmp_4k = ~addr_dly[11:0]; 
                   // = (4k - 1) - addr_dly[11:0]
                   // = (4k - 1) + ~addr_dly[11:0] + 1
                   // = 4k + ~addr_dly[11:0]
                   // = ~addr_dly[11:0]
                   // 0 ~ (4k-1)
   assign      burst_4k = cmp_4k[11:2]; // 0 ~
   assign      small_wd = (cmp_len_4k[7])? burst_4k[3:0] : burst_len;
   assign      less_wd = (rest_lenm1[5:2] == 4'h0)? 4'h0 : small_wd;
   // 0 ~ 5

   assign      cmp_byte = {1'b0,rest_lenm1[4:0]} + {4'h0,addr_dly[1:0]};
   
   // valid at the WR_CMD stage
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) send_byte <= 6'h00;  // 0 ~ 31
	  else if(cs[CALC_LEN]) begin
		 if(|addr_dly[1:0] == 1'b1) begin  // under word
			if(|cmp_byte[5:2] == 1'b1) // if next word is existed
			  send_byte <= {4'h0,(~addr_dly[1:0])};
			else send_byte <= {4'h0,rest_lenm1[1:0]};
		 end
		 else if(rest_lenm1[5:2] == 4'h0) // 남은 byte가 word보다 작을때.
		   send_byte <= rest_lenm1;
		 else send_byte <= {less_wd,2'h3};
	  end
   end // always
   
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) now_len <= 4'h0;  // 1 ~ 5
	  // Initial 
	  else if(cs[CALC_LEN]) begin
		 if(|addr_dly[1:0] == 1'b1) // under word
		   now_len <= 4'h0;
		 else 
		   now_len <= less_wd[3:0];
	  end // else if
   end // always

   //-----------
   
   //always@(posedge clk or negedge rstb) begin
   //	  if(~rstb) byte_wd <= 4'h0; 
   //   else     byte_wd <= {1'b0,byte_4_0} + {1'b0,byte_4_1};
   //end // always

   always@(posedge clk or negedge rstb) begin
	  if(~rstb) addr_dly <= {32{1'b0}};
	  else if(cs[IDLE] == 1'b1 && gwr == 1'b1)
		addr_dly <= gwaddr;
	  else if(cs[WR_CMD]) // at the end command cycle
		addr_dly <= addr_dly + {{26{1'b0}},send_byte} 
					+ {{31{1'b0}},1'b1}; // next start address
   end // always

   //==================================================
   // Send write address

   parameter   AIDLE = 1'b0;
   parameter   AWAIT = 1'b1;
   
   reg 		   acs, ans;

   always@(posedge clk or negedge rstb) begin
	  if(~rstb)  acs <= AIDLE;
	  else acs <= ans;
   end


   always@(acs or cs or AWREADY) begin
	  if(acs == AIDLE) begin
		 if(cs[CALC_LEN])
		   ans <= AWAIT;
		 else ans <= AIDLE;
	  end
	  else begin
		 if(AWREADY)
		   ans <= AIDLE;
		 else ans <= AWAIT;
	  end
   end // always@ (acs or cs or AWREADY)

   //------------------------------------------------------
   // synopsys translate_off
   wire   sm_await = (acs == AWAIT)? 1'b1 : 1'b0;
   wire   sm_aidle = (acs == AIDLE)? 1'b1 : 1'b0;
   // synopsys translate_on
   //------------------------------------------------------

   //----------------------------
   
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) AWADDR <= {32{1'b0}};
	  else if(cs[CALC_LEN]) AWADDR <= addr_dly;
   end
   
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) AWLEN <= 4'h0;
	  else if(cs[CALC_LEN]) begin
		 if((|addr_dly[1:0]) == 1'b1 || (|rest_lenm1[5:2]) == 1'b0) // single
		   // rest_lenm1 : it must be 0 ~ 31
		   // rest_lenm1은 처음에는 IDLE에서 latch하고, 이후에난 rest_len을
		   // latch하므로 time이 맞게 된다.
		   AWLEN <= 4'h0;
		 else AWLEN <= less_wd;
	  end
   end // always
  

   assign          AWVALID = (acs == AWAIT)? 1'b1 : 1'b0;
   
   assign 		   AWID = {WID_WIDTH{1'b0}}; // no ID
   assign 		   AWSIZE = 3'b010; // 32bit
   assign 		   AWBURST = 2'b01; // INCR
   assign 		   AWLOCK = 2'b00; // Normal
   assign 		   AWCACHE = 4'h0; // non cachable
   assign 		   AWPROT = 3'h0;
   
   //======================================================
   // Transfer Datas
   reg [3:0]       send_wd; // 전송해야 할 word의 수.
   reg 			   post_t; // post state counter
   reg             pwvalid; // pre dvalid
   reg             dcs_pre_send; // delayed signal
   reg             dcs_post_d; // delay signal
   
   
   parameter       DSM_WIDTH = 5;
   parameter 	   DSM_INIT = {{(DSM_WIDTH-1){1'b0}},1'b1};
   
   parameter       DIDLE = 0;  // data idle
   parameter       DPRE  = 1;
   parameter       DPRD  = 2;
   parameter       DSEND = 3;  // data send
   parameter       DPOST = 4;

   parameter       ST_DIDLE = (DSM_INIT << DIDLE);
   parameter       ST_DPRE  = (DSM_INIT << DPRE);
   parameter       ST_DPRD  = (DSM_INIT << DPRD);
   parameter       ST_DSEND = (DSM_INIT << DSEND);
   parameter       ST_DPOST = (DSM_INIT << DPOST);
   
   reg [DSM_WIDTH-1:0] dcs, dns;
   
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) dcs <= ST_DIDLE;
	  else dcs <= dns;
   end

   always@(cs or dcs or now_len or send_wd or WREADY) begin
	  case(1'b1)   // synopsys parallel_case
		dcs[DIDLE] :
		  if(cs[CALC_LEN]) dns <= ST_DPRE;
		  else dns <= ST_DIDLE;
		
		dcs[DPRE] :
		  //if(now_len == 4'h0) dns <= ST_DIDLE; // if single word
		  if(now_len == 4'h0) dns <= ST_DPOST;
		  else dns <= ST_DPRD;
		
		dcs[DPRD] : dns <= ST_DSEND;
		
		dcs[DSEND] :
		  if(send_wd == 4'h1 && WREADY == 1'b1) dns <= ST_DPOST;
		  else dns <= ST_DSEND;
		
		dcs[DPOST] :
		  if(WREADY)
			dns <= ST_DIDLE;
		  else dns <= ST_DPOST;
		
		default : dns <= ST_DIDLE;
	  endcase // case(dcs)
   end // always@ (cs or dcs or now_len or send_wd or post_t)
   
   //------------------------------------------------------
   // synopsys translate_off
   wire   sm_didle = dcs[DIDLE];
   wire   sm_dpre  = dcs[DPRE];
   wire   sm_dprd  = dcs[DPRD];
   wire   sm_dsend = dcs[DSEND];
   wire   sm_dpost = dcs[DPOST];
   // synopsys translate_on
   //------------------------------------------------------
   
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) WREADY_dly <= 1'b1;
	  else if(dcs[DPRE] == 1'b1 || WVALID == 1'b0)
		WREADY_dly <= 1'b1;
	  else WREADY_dly <= WREADY;
   end // always


   // if post_t == 1, last write operand command
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) post_t <= 1'b0;
	  //else if(dcs[DPOST] & AWREADY) post_t <= 1'b1; // each 1 cycle
	  else if(dcs[DPRE]) begin // initial
		 if(rest_len == send_byte) post_t <= 1'b1; // 1 cycle
		 else post_t <= 1'b0; // 2 cycle
	  end
   end // always


   // 0 ~ 3= 1 word ~ 4 word
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) send_wd <= 4'h0; 
	  // send words
	  else if(dcs[DPRE]) send_wd <= now_len ; // now_len + 1
	  else if(dcs[DSEND] & WREADY) begin
		 send_wd <= send_wd + 4'hf; // send_wd - 1
	  end // else if
   end // always@ (posedge clk or negedge rstb)


   // Write data
   assign 	   WID = {WID_WIDTH{1'b0}}; // no ID

   always@(posedge clk or negedge rstb) begin
	  if(~rstb) begin
		 WDATA <= {DATA_WIDTH{1'b0}};
		 WSTRB <= {NUM_BYTE{1'b0}};
	  end // if
	  else if(dcs[DPRE]) begin
		 if( !gwready_dly ) begin
		 	WDATA <= data_dly2;
	 		WSTRB <= be_dly2;
		 end
		 else begin
			WDATA <= gwdata;
	 		WSTRB <= gwbe;
		 end
	  end
	  else if((dcs[DSEND] | dcs[DPRD] == 1'b1) &&
			  WREADY == 1'b1) begin
		 if(WREADY_dly == 1'b0) begin // get from delayed buffer
			WDATA <= data_dly;
			WSTRB <= be_dly;
		 end
		 else if( !gwready_dly ) begin
		 	WDATA <= data_dly2;
	 		WSTRB <= be_dly2;
		 end
		 else if( gwready_dly ) begin
			WDATA <= gwdata;
	 		WSTRB <= gwbe;
		 end
	  end // else if
   end // always

   assign WLAST = dcs[DPOST];  // & post_t;

   always@(posedge clk or negedge rstb) begin
	  if(~rstb) pwvalid <= 1'b0;
	  else pwvalid <= dcs[DSEND];
   end

   assign WVALID = dcs[DSEND] | dcs[DPOST];
   
   // to internal block
   // combinational logic에서는 WREADY와 같이 delay가 큰 신호는 사용하지
   // 않는다.
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) dcs_pre_send <= 1'b0;
	  else if(dcs[DPRE] | dcs[DSEND]) dcs_pre_send <= 1'b1;
	  else  dcs_pre_send <= 1'b0;
   end // always

   always@(posedge clk or negedge rstb) begin
	  if(~rstb) dcs_post_d <= 1'b0;
	  else  dcs_post_d <= dcs[DPOST];
   end // always

//   always@(dcs_pre_send) gwready_pre = dcs_pre_send;
   
   always@(now_len or dcs_pre_send or dcs or WREADY_dly or 
		   send_wd or post_t or dcs_post_d or rest_len or
		   cs or sm_wr_resp_dly) begin
	  if((|now_len[3:0]) == 1'b1 && // not single word
		 ((dcs_pre_send & dcs[DPRD]) == 1'b1))
		gwready_pre <= 1'b1;
	  else if(send_wd[3:1] != 3'h0 && 
				(dcs[DSEND] == 1'b1 && WREADY_dly == 1'b1))// || (now_len == 4'h0 && dcs[DPOST]))
		gwready_pre <= 1'b1;
	  else if(~dcs_post_d & dcs[DPOST] & (|rest_len)) 
		gwready_pre <= 1'b1; // if next read is existed.
	  //else if(sm_wr_resp_dly == 1'b1 && cs[CALC_LEN] == 1'b1)
	  //  gwready_pre <= 1'b1; // at 4k boundary split
	  else gwready_pre <= 1'b0;
   end // always. gwready_pre

   // generate gwready
   reg 		 gwr_dly;
   reg       gwr_redge;
   
   always@(posedge clk or negedge rstb) begin
	  if(!rstb) gwr_dly <= 1'b0;
	  else 
		gwr_dly <= gwr;
   end // always. gwr_dly
   
   always@(posedge clk or negedge rstb) begin
	  if(!rstb) gwr_redge <= 1'b0;
	  else if(gwr == 1'b1 && gwr_dly == 1'b0)
		gwr_redge <= 1'b1;
	  else gwr_redge <= 1'b0;
   end // always. gwr_redge
   
	  
   assign gwready = gwready_pre | gwr_redge;

   assign gwbusy = cs[IDLE];

   
   //============================================
   // Wait Response
   assign 	   BREADY = BVALID;
   
   
endmodule // ga_axiw

