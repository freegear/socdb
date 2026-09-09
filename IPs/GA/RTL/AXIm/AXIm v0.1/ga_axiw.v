/****************************************************
 
    AXI Write Module for Graphic Accelerator
 
    file name : ga_axiw.v
    created by gtlee
    data : 2006.7.10
 
    note :
 
    history : 
 
******************************************************/

`timescale 1ns/10ps

module ga_axiw
  (


   );

   parameter        WID_WIDTH = 4;	// AWID/WID/BID width
   parameter 		RID_WIDTH = 4;	// ARID/RID width
   parameter 		DATA_WIDTH = 64;
   parameter 		NUM_BYTE = DATA_WIDTH/8;
   
   
   // AXI Signals
   input [1:0] 		MASTER_ID;
   
   input 			clk;
   input 			rstb;
   
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
   output 				  gwlast;

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
   wire [DATA_WIDTH-1:0]  WDATA;
   wire [NUM_BYTE-1:0] 	  WSTRB;
   wire 				  WLAST;
   wire 				  WVALID;

   reg 					  BREADY;
   
   wire 				  wready;
   wire 				  wlast;

   //----------------------------------
   reg [31:0] 			  addr_dly;
   reg [NUM_BYTE-1:0] 	  be_dly;  // byte enable
   reg [2:0] 			  byte_4_0;
   reg [2:0] 			  byte_4_1;
   reg [3:0] 			  byte_wd; // 한 word내에서 byte수.
   
   reg [5:0] 			  rest_len; // write operation동안 남아있는 총 byte수.
                                    // 0이면 남은 데이터가 없음을 의미.
   reg [5:0] 			  now_len; // command 당 전송해야할 데이터량.
                                   // WR_DATA state동안 전송해야 하는 word수.

   wire [2:0] 			  burst_len; // burst로 전송할 수 있는 량.
   
   
   // check a single write
   //wire [2:0] 			  cmp_addr_8;
   
   // check the 4kbyte alignment
   wire [11:0] 			  cmp_4k; // 남은 byte수와 비교하여 작은 것을 전송량으로 선정.
   wire [8:0] 			  burst_len_4k;

   // cmpare burst_len, burst_len_4k
   wire [9:0] 			  cmp_len_4k;
   

                                  
   
   


   //=================================================
   parameter 			  SM_WIDTH = 5;

   parameter              IDLE = 0;
   parameter 			  CALC_LEN = 1;
   parameter 			  WR_CMD = 2;
   parameter 			  WR_DATA = 3;
   parameter 			  WR_DATA_RESP = 4;

   parameter 			  ST_IDLE = (SM_WIDTH'h01 << IDLE);
   parameter              ST_CALC_LEN = (SM_WIDTH'h01 << CALC_LEN);
   parameter 			  ST_WR_CMD = (SM_WIDTH'h01 << WR_CMD);
   parameter              ST_WR_DATA = (SM_WIDTH'h01 << WR_DATA);
   parameter              ST_WR_DATA_RESP = (SM_WIDTH'h01 << WR_DATA_RESP);

   
   reg [SM_WIDTH-1:0] 	  ns,cs;

   always(posedge clk or negedge rstb) begin
	  if(~rstb) cs <= ST_IDLE;
	  else cs <= ns;
   end // always
   
   always@(cs or rest_len or AWREADY or now_len) begin
	  case(1'b1) begin
		 cs[IDLE] :
		   if(wr) ns <= ST_CALC_LEN;
		   else ns <= ST_IDLE;
		 
		 cs[CALC_LEN] :
		   if(rest_len == 6'h00) ns <= ST_IDLE;
		   else ns <= ST_WR_CMD;
		 
		 cs[WR_CMD] :
		   if(AWREADY) ns <= ST_WR_DATA;
		   else ns <= ST_WR_CMD;
		 
		 cs[WR_DATA] :
		   if(now_len == 6'h00) ns <= ST_WR_DATA_RESP;
		   else  ns <= WR_DATA;

		 cs[WR_DATA_RESP] :
		   if(BVALID) ns <= CLAC_LEN;
		   else ns <= ST_WR_DATA_REAP;
		 
		 default :
		    ns <= ST_IDLE;

	  endcase // case(1'b1)
   end // always@ (cs or rest_len or AWREADY or now_len)

   //-------------------------------------------------------
   
   // if wr, rest_len = wsize + 1

   
   // word내에서 한번에 전송할수 있는 byte 수.
   //assign      cmp_addr_8 =  ~addr_dly[2:0];
   // 7 - addr = 8 + {1'b1,~addr} = {1'b0,~addr}
   
   //
   assign      cmp_4k = ~addr_dly[11:0];
   assign      burst_len_4k = cmp_4k[11:3];
   
   assign      burst_len = rest_len[5:3]; // word개수 추출.

   assign 	   cmp_len_4k = {7'h00,burst_len} + {1'b0,addr_dly[11:3]};
               // if 1, over the 4k.
               // if 0, under the 4k
                       // = {7'h00,burst_len} + {1'b1,~burst_len_4k} + 1; //X

   //------------------
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) be_dly <= {NUM_BYTE{1'b0}};
	  else if(gwr == 1'b1)
		be_dly <= gwbe;
   end // always

   // count bytes
   always@(be_dly) begin
	  byte_4_0 <= be_dly[0] + be_dly[1] + be_dly[2] + be_dly[3];
	  byte_4_1 <= be_dly[4] + be_dly[5] + be_dly[6] + be_dly[7];
   end // always
   
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) byte_wd <= 4'h0;
	  else     byte_wd <= byte_4_0 + byte_4_1;
   end

 
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) now_len <= 6'h00;
	  // Initial 
	  else if(cs[WR_CMD]) begin
		 if(&be_dly == 1'b0) // under word
		   now_len <={2'h0,byte_wd};
		 else if(cmp_len_4k[9] == 1'b0) // under the 4k
		   now_len <= {burst_len,3'h0};
		 else // over the 4k
		   now_len <= {burst_len_4k[2:0],3'h0};
	  end // else if
	  // send words
	  else if(cs[WR_DATA] & AWREADY) begin
		 if(&gwbe == 1'b0)
		   now_len <= 6'h00;
		 else now_len <= now_len + 6'h38; // now_len - one word
	  end // else if
   end // always
   
  
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) addr_dly <= {32{1'b0}};
	  else if(cs[IDLE] == 1'b1 && gwr == 1'b1)
		addr_dly <= gaddr;
	  else if(cs[WR_CMD] & AWREADY & AWVALID) // at the end command cycle
		addr_dly <= addr_dly + {{29{1'b0}},now_len}; // next start address
   end // always


   
   //-----------
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) rest_len <= 6'h00;
	  else if(gwr == 1'b1 && cs[IDLE] == 1'b1)
		rest_len <= gwsize + 6'h01;
	    // gwsize는 0이면 1byte전송을 의미하지만 rest_len은 1이어야 1byte를
	    // 나타낸다 따라서 이를 보정하기 위하여 1을 더한다.
	  else if(cs[WR_CMD] == 1'b1 && AWREADY == 1'b1)  begin
		 if(&gwbe == 1'b0) // word중 일부만 전송.
		   rest_len <= rest_len + {1'b1,~byte_wd} + 1;
		 else  // rest_len - AWLEN -1 = rest_len + (~AWLEN) + 1 - 1
		   rest_len <= rest_len + {~AWLEN[2:0],3'h0}; // burst length는 한번에 전송.
	  end // else if
   end // always@ (posedge clk or negedge rstb)
   







   
   //-------------------------------
   // Write address
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) AWADDR <= {32{1'b0}};
	  else if(cs[CALC_LEN]) AWADDR <= addr_dly;
   end
   
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) AWLEN <= 4'h0;
	  else if(cs[CALC_LEN]) begin
		 if(&be_dly == 1'b0 || |rest_len[5:3] == 1'b0) // single
		   AWLEN <= 4'h1;
		 else if(cmp_len_4k[9] == 1'b0) // under the 4k
		   AWLEN <= {1'b0,burst_len} + 4'hf;
		 else AWLEN <= {1'b0,burst_len_4k[2:0]} + 4'hf;
	  end
   end // always
  

   assign      AWVALID = cs[WR_CMD];
   
   assign      AWID = {WID_WIDTH{1'b0}}; // no ID
   assign 	   AWSIZE = 3'b011; // 
   assign 	   AWBURST = 2'b01; // INCR
   assign 	   AWLOCK = 2'b00; // Normal
   assign 	   AWCACHE = 4'h0; // non cachable
   assign 	   AWPROT = 3'h0;
  
   //---------------------------------
   // Write data
   assign 	   WID = {WID_WIDTH{1'b0}}; // no ID

   always@(posedge clk or negedge rstb) begin
	  if(~rstb) begin
		 WDATA <= {DATA_WIDTH{1'b0}};
		 WSTRB <= {NUM_BYTE{1'b0}};
		 WLAST <= 1'b0;
	  end // if
	  else if( (cs[WR_CMD] == 1'b1 && AWREADY == 1'b1) ||
			   (cs[WR_DATA] == 1'b1 && WREADY == 1'b1)) begin
		 WDATA <= gwdata;
	 	 WSTRB <= gwbe;
		 if(now_len[5:3] == 3'h0)  WLAST <= 1'b1;
		 else  WLAST <= 1'b0;
	  end // else if
   end // always

   assign WVALID = cs[WR_DATA];
   
   
   

   always@(posedge clk or negedge rstb) begin
	  if(~rstb) BREADY <= 1'b0;
	  else BREADY <= BVALID;
   end
   
endmodule // ga_axiw
