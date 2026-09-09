/****************************************************
 
    AXI Read Module for Graphic Accelerator
 
    file name : ga_axir.v
    created by gtlee
    data : 2006.7.10
 
    note :
 
    history : 
 
******************************************************/

`timescale 1ns/10ps

module ga_axir
  (
   clk            ,
   rstb           ,
   
   ARID           ,
   ARADDR         ,
   ARLEN          ,
   ARSIZE         ,
   ARBURST        ,
   ARLOCK         ,
   ARCACHE        ,
   ARPROT         ,
   ARVALID        ,
   ARREADY        ,
   
   RID            ,
   RDATA          ,
   RRESP          ,
   RLAST          ,
   RVALID         ,
   RREADY         ,
   
   grd            ,
   graddr         ,
   grsize         ,
   grbe           ,
   grdata         ,
   grvalid        ,
   grbusy         
   );


   parameter              WID_WIDTH = 4;	// AWID/WID/BID width
   parameter 			  RID_WIDTH = 4;	// ARID/RID width
   parameter 			  DATA_WIDTH = 64;
   parameter 			  NUM_BYTE = DATA_WIDTH/8;
   
   input 				  clk;
   input 				  rstb;
 
   // AXI Signals
   output [RID_WIDTH-1:0] ARID;
   output [31:0] 		  ARADDR;
   output [3:0] 		  ARLEN;
   output [2:0] 		  ARSIZE;
   output [1:0] 		  ARBURST;
   output [1:0] 		  ARLOCK;
   output [3:0] 		  ARCACHE;
   output [2:0] 		  ARPROT;
   output 				  ARVALID;
   input 				  ARREADY;
   
   input [RID_WIDTH-1:0]  RID;
   input [DATA_WIDTH-1:0] RDATA;
   input [1:0] 			  RRESP;
   input 				  RLAST;
   input 				  RVALID;
   output 				  RREADY;

   // Internal bus signals
   input                  grd;
   input [31:0] 		  graddr;
   input [4:0] 			  grsize;
   output [NUM_BYTE-1:0]  grbe;
   output [DATA_WIDTH-1:0] grdata;
   output 				  grvalid;
   output 				  grbusy;   

   //===============================================
   wire [RID_WIDTH-1:0]   ARID;
   reg [31:0] 			  ARADDR;
   reg [3:0] 			  ARLEN;
   wire [2:0] 			  ARSIZE;
   wire [1:0] 			  ARBURST;
   wire [1:0] 			  ARLOCK;
   wire [3:0] 			  ARCACHE;
   wire [2:0] 			  ARPROT;
   wire 				  ARVALID;

   wire 				  RREADY;
   
   wire [NUM_BYTE-1:0] 	  grbe;
   reg [DATA_WIDTH-1:0]   grdata;
   reg 					  grvalid;
   wire 				  grbusy;   
   
   //------------------------------------------
   reg [31:0] 			  addr_dly;
   //reg [NUM_BYTE-1:0] 	  be_dly;   // byte enable
   
   reg [5:0] 			  rest_len; // write operation동안 남아있는 총 byte수.
                                    // 0이면 남은 데이터가 없음을 의미.
   reg [4:0] 			  rest_lenm1;
   
   wire [5:0] 			  need_wd; // read할 총 word수.
   //wire [2:0] 			  less_wd;
   reg [5:0] 			  send_byte;
   
   //wire [5:0] 			  cmp_byte;

   reg [2:0] 			  now_len; // command 당 전송해야할 데이터량.
                                   // RD_DATA state동안 전송해야 하는 word수.
   wire [2:0] 			  burst_len; // 남은 burst 전송량.
   
   // check a single write
   //wire [2:0] 			  cmp_addr_8;
   
   // check the 4kbyte alignment
   wire [11:0] 			  cmp_4k; // 남은 byte수와 비교하여 작은 것을 전송량으로 선정.
   wire [8:0] 			  burst_4k; // 4k boundary까지 가능한 burst 수.
   // cmpare burst_len, burst_len_4k
   wire [7:0] 			  cmp_len_4k;

   //------------------------------------------
   parameter          AIDLE = 1'b0;
   parameter 		  AWAIT = 1'b1;
   
   reg 				  acs, ans;

   //---------------------------------------------
   parameter 		  ST_DIDLE = 1'b1;
   parameter 		  ST_DDATA = 1'b0;
   reg 				  dcs; // if 1, idle


   //=================================================
   parameter 			  SM_WIDTH = 4;
   parameter              SM_INIT = {{(SM_WIDTH-1){1'b0}},1'b1};
   
   parameter              IDLE = 0;
   parameter 			  CALC_LEN = 1;
   parameter 			  RD_CMD = 2;
   parameter 			  RD_DATA = 3;

   parameter 			  ST_IDLE = (SM_INIT << IDLE);
   parameter              ST_CALC_LEN = (SM_INIT << CALC_LEN);
   parameter 			  ST_RD_CMD = (SM_INIT << RD_CMD);
   parameter              ST_RD_DATA = (SM_INIT << RD_DATA);
   
   
   reg [SM_WIDTH-1:0] 	  ns,cs;

   always@(posedge clk or negedge rstb) begin
	  if(~rstb) cs <= ST_IDLE;
	  else cs <= ns;
   end // always
   
   always@(cs or grd or acs or dcs or rest_len) begin
	  case(1'b1)   // synopsys parallel_case
		 cs[IDLE] :
		   if(grd) ns <= ST_CALC_LEN;
		   else ns <= ST_IDLE;
		 
		 cs[CALC_LEN] :
		   ns <= ST_RD_CMD;
		 
		 cs[RD_CMD] :  // must be single clock
		   ns <= ST_RD_DATA;
		 
		 cs[RD_DATA] :
		   if(acs == AIDLE && dcs == ST_DIDLE) begin // All end
			  if(rest_len == 6'h00) // end
				ns <= ST_IDLE;
			  else ns <= ST_CALC_LEN;
		   end
		   else ns <= ST_RD_DATA;
		 
		 default :
		    ns <= ST_IDLE;
	  endcase // case(1'b1)
   end // always@ (cs or rest_len or BVALID)
   
   //------------------------------------------------------
   // synopsys translate_off
   wire   sm_idle = cs[IDLE];
   wire   sm_calc_len = cs[CALC_LEN];
   wire   sm_rd_cmd = cs[RD_CMD];
   wire   sm_rd_data = cs[RD_DATA];
   // synopsys translate_on
   //------------------------------------------------------
   
   //-------------------------------------------------------
   // calc. rest length
   // 남아 있는 총 byte수. 
   // range : 1~32
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) rest_len <= 6'h00;
	  else if(cs[IDLE] == 1'b1 && grd == 1'b1)
		rest_len <= {1'b0,grsize} + 6'h01;
	    // grsize는 0이면 1byte전송을 의미하지만 rest_len은 1이어야 1byte를
	    // 나타낸다 따라서 이를 보정하기 위하여 1을 더한다.
	  else if(cs[RD_CMD] == 1'b1)  begin
		 // calc. rest bytes 
		   rest_len <= rest_len + {~send_byte} + 1'h0;
	  end // else if
   end // always@ (posedge clk or negedge rstb)

   always@(posedge clk or negedge rstb) begin
	  if(~rstb) rest_lenm1 <= 5'h00;
	  else if(cs[IDLE] == 1'b1 && grd == 1'b1)
		rest_lenm1 <= {1'b0,grsize};
	  else 
		 // calc. rest bytes 
		   rest_lenm1 <= rest_len +  6'h3F;//{~send_byte};
   end // always@ (posedge clk or negedge rstb)

   //---------------------------------------------------
   // read 할 word수.
   //    word의 일부만 차지하는 경우도 word루 읽어 byte enable로
   //  at CALC_LEN stage
   assign      need_wd = {3'h0,addr_dly[2:0]} + rest_lenm1; // word수 : {1 ~ 5,0bxxx}
   assign      burst_len = need_wd[5:3]; // word개수 추출.
   
   assign      cmp_4k = ~addr_dly[11:0];
   
   assign 	   cmp_len_4k = {2'h0,rest_lenm1} + 
			                {1'b0,&addr_dly[11:6],addr_dly[5:0]};
                            // = burst_len - burst_4k
                            // = burst_len + ~burst_4k - 1 + 1
                            // = burst_len + ~burst_4k
               // if msb is 1, over the 4k.
               // if msb is 0, under the 4k
   assign      burst_4k = cmp_4k[11:3];
   //assign      less_wd = (cmp_len_4k[7])? burst_4k[2:0] : burst_len;
               // 0 ~ 4

   // 다음 command에서 read할 word의 숫자.
   // 0 ~ 3
   always@(addr_dly or cmp_len_4k or burst_4k or burst_len) begin
	  //if(|addr_dly[2:0] == 1'b1) now_len <= 3'b0;
	  if(cmp_len_4k[7]) now_len <= burst_4k[2:0];
	  else  now_len <= burst_len;
   end
   

   
   // valid at the RD_CMD stage
   // 읽은 word수.
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) send_byte <= 6'h00;  // 0 ~ 31
	  else if(cs[CALC_LEN]) begin
		 //if(|addr_dly[2:0] == 1'b1)
		 if(cmp_len_4k[7]) send_byte <= {burst_4k[2:0],~addr_dly[2:0]}; // 4k boundary
		 else //if(|rest_len[2:0] == 1'b1) // 마지막 word는 일부분만 사용.
		   send_byte <= rest_lenm1; // all read
		 //else send_byte <= {now_len,3'h7};
	  end
   end // always

  
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) addr_dly <= {32{1'b0}};
	  else if(cs[IDLE] == 1'b1 && grd == 1'b1)
		addr_dly <= graddr;
	  else if(cs[RD_CMD]) // at the end command cycle
		addr_dly <= {(addr_dly[31:3] + {{26{1'b0}},send_byte[5:3]}+ {{31{1'b0}},1'b1})
					 ,3'h0}; // next start address
   end // always

   //==================================================
   // Send read address

   always@(posedge clk or negedge rstb) begin
	  if(~rstb)  acs <= AIDLE;
	  else acs <= ans;
   end


   always@(acs or cs or ARREADY) begin
	  if(acs == AIDLE) begin
		 if(cs[CALC_LEN])
		   ans <= AWAIT;
		 else ans <= AIDLE;
	  end
	  else begin
		 if(ARREADY)
		   ans <= AIDLE;
		 else ans <= AWAIT;
	  end
   end // always@ (acs or cs or ARREADY)

   //------------------------------------------------------
   // synopsys translate_off
   wire   sm_await = (acs == AWAIT)? 1'b1 : 1'b0;
   wire   sm_aidle = (acs == AIDLE)? 1'b1 : 1'b0;
   // synopsys translate_on
   //------------------------------------------------------

   //--------------------------------------
   
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) ARADDR <= {32{1'b0}};
	  else if(cs[CALC_LEN]) ARADDR <= addr_dly;
   end
   
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) ARLEN <= 4'h0;
	  else if(cs[CALC_LEN]) begin
		 ARLEN <= now_len; // -1
	  end
   end // always
   
   assign      ARVALID = (acs == AWAIT)? 1'b1 : 1'b0;
   
   assign      ARID = {WID_WIDTH{1'b0}}; // no ID
   assign 	   ARSIZE = 3'b011; // 
   assign 	   ARBURST = 2'b01; // INCR
   assign 	   ARLOCK = 2'b00; // Normal
   assign 	   ARCACHE = 4'h0; // non cachable
   assign 	   ARPROT = 3'h0;
   
   //======================================================
   // Receive Datas

   reg [2:0]   rest_addr;
   reg [5:0]   now_byte; // 남은 byte수.
   reg [5:0]   next_byte;
   wire [6:0]  rd_size; // 1 word 내인지.

   reg [7:0]   pre_be;
   reg [7:0]   part_be;

   always@(posedge clk or negedge rstb) begin
	  if(~rstb) dcs <= ST_DIDLE;
	  else if(cs[CALC_LEN]) dcs <= ST_DDATA;
	  else if(RVALID & RLAST) dcs <= ST_DIDLE;
   end // always
   
   //------------------------------------------------------
   // synopsys translate_off
   wire   sm_ddata = (dcs == ST_DDATA)? 1'b1 : 1'b0;
   wire   sm_didle = (dcs == ST_DIDLE)? 1'b1 : 1'b0;
   // synopsys translate_on
   //------------------------------------------------------


   always@(posedge clk or negedge rstb) begin
	  if(~rstb) rest_addr <= 3'h0;
	  else if(cs[RD_CMD])
		rest_addr <= addr_dly[2:0];
	  else if(RVALID)	rest_addr <= 3'h0;
   end

   // word에서 시작주소로부터 남은 byte수는
   //    ~rest_addr : 0 ~ 7 = 1byte ~ 8byte
   // 이 된다.
   // 이값과 read 남은 byte수와 비교하면 다음 word가 있는지 없는지 알 수 있다.
   // now_byte - (~rest_addr) = now_byte + ~(~rest_addr) + 1
   // = now_byte + rest_addr + 1
   // if now_byte < ~rest_addr, minus
   // if now_byte = ~rest_addr, plus
   // if now_byte > ~rest_addr, plus
   //
   // now_byte + rest_addr
   // if now_byte < ~rest_addr, minus
   // if now_byte = ~rest_addr, minus
   // if now_byte > ~rest_addr, plus
   assign      rd_size = {1'b0,now_byte} + {4'hf,rest_addr} + 1; // only use the sign
   
   always@(rd_size or rest_addr or now_byte) begin
	  if(rd_size[6] == 1'b0)
		//now_byte - ~rest_addr + 1 = now_byte + {11111,rest_addr} - 1 + 1
		next_byte <= now_byte + {3'h7,rest_addr};
	  else next_byte <= 6'h00;
   end
   
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) now_byte <= 6'h00;  // 0 ~ 31
	  else if(cs[RD_CMD])
		 now_byte <= send_byte;
	  else if(cs[RD_DATA] & RVALID) begin
		 now_byte <= next_byte;
	  end // else if
   end // always@ (posedge clk or negedge rstb)
   
   // generate pre byte enable
   always@(now_byte) begin
	  if(|now_byte[5:3] == 1'b1)
		pre_be <= 8'hff;
	  else 
		case(now_byte[2:0])   // synopsys parallel_case
		   3'h0 :
			 pre_be <= 8'b00000001;
		   3'h1 :
			 pre_be <= 8'b00000011;
		   3'h2 :
			 pre_be <= 8'b00000111;
		   3'h3 :
			 pre_be <= 8'b00001111;
		   3'h4 :
			 pre_be <= 8'b00011111;
		   3'h5 :
			 pre_be <= 8'b00111111;
		   3'h6 :
			 pre_be <= 8'b01111111;
		   default :
			 pre_be <= 8'b11111111;
		endcase // case(now_byte[2:0])
   end // always@ (now_byte)

   always@(posedge clk or negedge rstb) begin
	  if(~rstb) part_be <= 8'h00;
	  else 
		case(rest_addr)   // synopsys parallel_case
		   3'h0 :
			 part_be <= pre_be;
		   3'h1 :
			 part_be <= {pre_be[6:0],1'h0};
		   3'h2 :
			 part_be <= {pre_be[5:0],2'h0};
		   3'h3 :
			 part_be <= {pre_be[4:0],3'h0};
		   3'h4 :
			 part_be <= {pre_be[3:0],4'h0};
		   3'h5 :
			 part_be <= {pre_be[2:0],5'h00};
		   3'h6 :
			 part_be <= {pre_be[1:0],6'h00};
		   default :
			 part_be <= {pre_be[0],7'h00};
		endcase // case(rest_addr)
   end // always@ (rest_addr or pre_be)
   

   assign        grbe = part_be;
   
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) begin
		 grdata <= {DATA_WIDTH{1'b0}};
		 grvalid <= 1'b0;
	  end
	  //else if(cs[RD_DATA] & RVALID) begin
	  else begin
		 grdata <= RDATA;
		 grvalid <= RVALID;
	  end
   end // always

   assign    grbusy = cs[IDLE];
   
   assign 	 RREADY = 1; //RVALID;

   
endmodule // ga_axir

   
