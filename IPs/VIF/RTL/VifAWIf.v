/****************************************************
 
    AXI Write Module for Graphic Accelerator
 
    file name : ga_axiw.v
    created by gtlee
    data : 2006.7.11
 
    note :
       
    history : 
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
   gwdata			 ,
   gwready           ,
   gwbusy
   );


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
   input [3:0] 			  gwsize; // if 0, 1 word.
   input [DATA_WIDTH-1:0] gwdata;
   output 				  gwready;
   output 				  gwbusy;
   //===================================================
   // AXI Address and command
   wire [WID_WIDTH-1:0]   AWID;
   wire [31:0] 			  AWADDR;
   wire [3:0] 			  AWLEN;
   wire [2:0] 			  AWSIZE;
   wire [1:0] 			  AWBURST;
   wire [1:0] 			  AWLOCK;
   wire [3:0] 			  AWCACHE;
   wire [2:0] 			  AWPROT;
   wire 				  AWVALID;

   // save transfer informations
   reg [31:2] 			  waddr;
   reg [3:0] 			  wsize;

   // at AXI 
   wire 				  sent_data; // 1 word의 전송이 완료.
   
   
   // target information
   reg [31:0] 			  twaddr; // the target address of the now command
   reg [3:0] 			  twsize; // the target write size of the now command

   // 4kbyte boundary
   wire [10:0] 			  end_addr;
   wire 				  over_bound; // boundary에 걸쳐있음을 나타냄.
   reg                    rest_wr_op; // rest write operation
   
   wire [3:0] 			  length_4k;
   wire [3:0] 			  length_rest; // boundary이후 남은 word의 수.
   wire [31:0] 			  waddr_next; // boundary이후의 write address.

   // delay gwready signal
   reg 					  gwready;
   reg 					  gwready_d1;
   reg 					  gwready_d2;

   wire 				  gwbusy;
   
   //   data buffers
   reg [31:0] 			  data_b0;
   reg [31:0] 			  data_b1;
   reg [31:0] 			  data_b2;
   reg [31:0] 			  data_b3;
   reg 					  data_fg0;
   reg 					  data_fg1;
   reg 					  data_fg2;
   reg 					  data_fg3;
   
   reg [3:0] 			  get_rsize; // 남은 가져올 데이터의 개수.
   reg [3:0] 			  send_rsize; // 남은 전송할 데이터의 개수.

   // AXI write data bus
   wire [WID_WIDTH-1:0]   WID;
   wire [DATA_WIDTH-1:0]  WDATA;
   wire [NUM_BYTE-1:0] 	  WSTRB;
   wire 				  WLAST;
   wire 				  WVALID;
   
   //=================================================
   // Send write address

   parameter   AIDLE = 1'b0;
   parameter   AWAIT = 1'b1;
   
   reg 		   acs, ans;
   

   //=================================================
   parameter 			  SM_WIDTH = 5;
   parameter              SM_INIT = {{(SM_WIDTH-1){1'b0}},1'b1};
   
   parameter              IDLE = 0;
   parameter 			  PRD = 1;
   parameter 			  WR_DATA = 2;
   parameter 			  WT_RESP = 3;
   parameter 			  NEXT_WR_CMD = 4;

   parameter 			  ST_IDLE = (SM_INIT << IDLE);
   parameter              ST_PRD = (SM_INIT << PRD);
   parameter 			  ST_WR_DATA = (SM_INIT << WR_DATA);
   parameter              ST_WT_RESP = (SM_INIT << WT_RESP);
   parameter              ST_NEXT_WR_CMD = (SM_INIT << NEXT_WR_CMD);
   
   
   reg [SM_WIDTH-1:0] 	  ns,cs;

   always@(posedge clk or negedge rstb) begin
	  if(~rstb) cs <= ST_IDLE;
	  else cs <= ns;
   end // always
   
   always@(cs or gwr or send_rsize or acs or BVALID or sent_data or rest_wr_op) begin
	  case(1'b1)   // synopsys parallel_case
		 cs[IDLE] :
		   if(gwr) ns <= ST_PRD;
		   else ns <= ST_IDLE;
		 
		 cs[PRD] :
		   ns <= ST_WR_DATA;
		 
		 cs[WR_DATA] :
		   if(send_rsize == 4'h0 && sent_data == 1'b1) // 전송 완료.
			 ns <= ST_WT_RESP;
		   else ns <= ST_WR_DATA;
		
		 cs[WT_RESP] :
		   if(BVALID && acs == AIDLE) begin
			  if(rest_wr_op) 
				ns <= ST_NEXT_WR_CMD;
			  else 
				ns <= ST_IDLE;
		   end
		   else ns <= ST_WT_RESP;

		cs[NEXT_WR_CMD] :
		   ns <= ST_PRD;
		
		 default :
		    ns <= ST_IDLE;
	  endcase // case(1'b1)
   end // always@ (cs or gwr or rest_len or BVALID)
   
   //------------------------------------------------------
   // synopsys translate_off
   wire   sm_idle = cs[IDLE];
   wire   sm_prd = cs[PRD];
   wire   sm_wr_data = cs[WR_DATA];
   wire   sm_wt_resp = cs[WT_RESP];
   wire   sm_next_wr_cmd = cs[NEXT_WR_CMD];
   // synopsys translate_on
   //------------------------------------------------------


   //==================================================
   // Send write address

   always@(posedge clk or negedge rstb) begin
	  if(~rstb)  acs <= AIDLE;
	  else acs <= ans;
   end


   always@(acs or cs or AWREADY) begin
	  if(acs == AIDLE) begin
		 if(cs[PRD])
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
   assign          AWVALID = (acs == AWAIT)? 1'b1 : 1'b0;
   
   assign 		   AWID = {WID_WIDTH{1'b0}}; // no ID
   assign 		   AWSIZE = 3'b010; // 32bit
   assign 		   AWBURST = 2'b01; // INCR
   assign 		   AWLOCK = 2'b00; // Normal
   assign 		   AWCACHE = 4'h0; // non cachable
   assign 		   AWPROT = 3'h0;
   assign          AWLEN = twsize;
   assign 		   AWADDR = twaddr;
   
   //==============================================================
   // latch transfer informations
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) begin
		 waddr <= {30{1'b0}};
		 wsize <= {32{1'b0}};
	  end // if reset
	  else if(gwr == 1'b1 && cs[IDLE] == 1'b1) begin
		 waddr <= gwaddr[31:2];
		 wsize <= gwsize;
	  end // else
   end // always
   

   //==============================================================
   // next target address and size
   //    check the 4kbyte boundary
   assign end_addr = {1'b0,&gwaddr[11:6],gwaddr[5:2]} + {2'b00, gwsize};
   assign over_bound = end_addr[10];

   always@(posedge clk or negedge rstb) begin
	  if(~rstb) rest_wr_op <= 1'b0;
	  else if(gwr && cs[IDLE])
		rest_wr_op <= over_bound;
	  else if(cs[NEXT_WR_CMD])
		rest_wr_op <= 1'b0;
   end // always
   

   assign length_4k = 4'h1 + ~gwaddr[5:2]; // 5'b10000 - gwaddr[5:2]
   
   assign length_rest = wsize - twsize;
   assign waddr_next = {(waddr[31:12] + 20'h00001),{12{1'b0}}};
   
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) begin
		 twsize <= 4'h0;
		 twaddr <= {32{1'b0}};
	  end
	  else if(gwr && cs[IDLE]) begin
		 if(over_bound == 1'b0)
		   twsize <= gwsize;
		 else twsize <= length_4k;
		 twaddr <= gwaddr;
	  end
	  else if(cs[NEXT_WR_CMD]) begin
		 twsize <= length_rest;
		 twaddr <= waddr_next;
	  end
   end // always

   
   
   //----------------------------------------------------------
   // Data counter
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) get_rsize <= 4'h0;
	  else if(cs[PRD]) begin
		// get_rsize <= twsize - 1;
		 get_rsize <= twsize ;
	  end
	  else if(cs[WR_DATA] && gwready) begin
		 get_rsize <= get_rsize - 1;
	  end
   end // always
   
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) send_rsize <= 4'h0;
	  else if(cs[PRD]) begin
		 send_rsize <= twsize;
	  end
	  else if(cs[WR_DATA] && sent_data) begin
		 send_rsize <= send_rsize - 1;
	  end
   end // always

   

   //--------------------------------------------------------------
   // Output gwready
   wire [1:0]     read_cnt;
   
   assign    read_cnt = gwready_d1 + gwready_d2;
   
   always@(cs or get_rsize or read_cnt or data_fg0 or data_fg1 or data_fg2) begin
	  //if(~rstb) gwready <= 1'b0;  else
	  if(cs[PRD])
		 gwready <= 1'b1;
	  else if(cs[WR_DATA] && (|get_rsize) ) begin
		 if(1'b1) begin
//		 if(gwready == 1'b1) begin
			if((read_cnt == 2'h2 && data_fg2 == 1'b0) ||
			   (read_cnt == 2'h1 && data_fg1 == 1'b0) ||
			   (read_cnt == 2'h0 && data_fg0 == 1'b0)
			   )
			  gwready <= 1'b1;
			else gwready <= 1'b0;
		 end // if		 
		 else begin
			if((read_cnt == 2'h2 && data_fg1 == 1'b0) ||
			   (read_cnt == 2'h1 && data_fg0 == 1'b0) ||
			   (read_cnt == 2'h0)
			   ) // restart condition
			  gwready <= 1'b1;
			else gwready <= 1'b0;
		 end // else: !if(gwready == 1'b1)
	  end // if (cs[WR_DATA])
	  else  gwready <= 1'b0;
   end // always@ (posedge clk or negedge rstb)
   

   assign gwbusy = ~cs[IDLE];
   
   //----------------------------------------------------------------
   // delay gwready signal
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) begin
		 gwready_d1 <= 1'b0;
		 gwready_d2 <= 1'b0;
	  end
	  else begin
		 if(cs[PRD]) begin
			//gwready_d1 <= 1'b1;
			//gwready_d2 <= 1'b1;
			gwready_d1 <= 1'b1;
			gwready_d2 <= 1'b0;
		 end
		 else begin
			gwready_d1 <= gwready;
			gwready_d2 <= gwready_d1;
		 end
	  end // else
   end // always. gwready_d
   
   
   
   //----------------------------------------------------------------
   // management the data buffer
   assign sent_data = WVALID & WREADY;
   
   //     buffer update
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) begin
		 data_b0 <= {32{1'b0}};
		 data_fg0 <= 1'b0;
	  end
//	  else if(cs[IDLE] == 1'b0) begin
	  else if(cs[WR_DATA] == 1'b1) begin
		 case({gwready_d2,sent_data,data_fg1}) // synopsys parallel_case full_case
		   3'b010 : begin // shift out next buffer and clear
			  data_b0 <= {32{1'b0}};
			  data_fg0 <= 1'b0;
		   end
		   3'b011 : begin // shift out next buffer and clear
			  data_b0 <= {32{1'b0}};
			  data_fg0 <= 1'b0;
		   end
		   3'b101 : begin // input a new data
			  data_b0 <= gwdata;
			  data_fg0 <= 1'b1;
		   end
		   3'b111 : begin // shift out next buffer and clear
			  data_b0 <= {32{1'b0}};
			  data_fg0 <= 1'b0;
		   end
		   default : begin
	 		  data_b0 <= data_b0;
			  data_fg0 <= data_fg0;
			end
		   /*
		   default
		   3'b000 : ;
		   3'b001 : ;
		   3'b100 : ;
		   3'b110 : ;
		   		   
		 if(gwready_d2 == 1'b1 && sent_data == 1'b0 && data_fg1 == 1'b1) begin
			// input a new data
		   data_b0 <= gwdata;
		   data_fg0 <= 1'b1;
		 end
		 else if(sent_data == 1'b1)begin
			// shift out next buffer and clear
			data_b0 <= {32{1'b0}};
			data_fg0 <= 1'b0;
		 end
			*/
		 endcase // case({gwready_d2,sent_data,data_fg1})
	  end // if (cs[IDLE] == 1'b0)
   end // always@ (posedge clk or negedge rstb)

   
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) begin
		 data_b1 <= {32{1'b0}};
		 data_fg1 <= 1'b0;
	  end
//	  else if(cs[IDLE] == 1'b0) begin
	  else if(cs[WR_DATA] == 1'b1) begin
		 case({sent_data,gwready_d2,data_fg0,data_fg2}) // synopsys parallel_case full_case
		   4'b1001 : begin // out data, no input => clear and shift up
			  data_b1 <= {32{1'b0}};
			  data_fg1 <= 1'b0;
		   end
		   4'b1011 : begin // out data, shift up => update to data_b0
			  data_b1 <= data_b0;
			  data_fg1 <= 1'b1;
		   end
		   4'b0101 : begin
			  if(data_fg1 == 1'b0) begin
				 data_b1 <= gwdata;
				 data_fg1 <= 1'b1;
			  end
		   end
		   // synopsys translate_off
		   //4'b0111 : $display("%t : AXI Host buffer overflow",$time);
		   //4'b1000 : $display("%t : AXI Host buffer underflow",$time);
		   4'b1010 : $display("%t : AXI Host buffer fault",$time);
		   //4'b1100 : $display("%t : AXI Host buffer underflow",$time);
		   4'b1110 : $display("%t : AXI Host buffer fault",$time);
		   // synopsys translate_on
		   4'b1101 : begin // out data, input
			  if(data_fg1 == 1'b1) begin // shift out and input new
				 data_b1 <= gwdata;
				 data_fg1 <= 1'b1;
			  end
		   end
		   4'b1111 : begin // out data, shift up => update to data_b0
			  data_b1 <= data_b0;
			  data_fg1 <= 1'b1;
		   end		   
		   default : begin
		      data_b1 <= data_b1;
		      data_fg1 <= data_fg1;
			end
		    /*  
		   default :;
		   4'b0000 : ;
		   4'b0001 : ;
		   4'b0010 : ;
		   4'b0011 : ;
		   4'b0100 : ;
		   4'b0110 : ;
			 */
		 endcase // case({sent_data,gwready_d2,data_fg0,data_fg2})
	  end // if (cs[IDLE] == 1'b0)
   end // always@ (posedge clk or negedge rstb)

   
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) begin
		 data_b2 <= {32{1'b0}};
		 data_fg2 <= 1'b0;
	  end
//	  else if(cs[IDLE] == 1'b0) begin
	  else if(cs[WR_DATA] == 1'b1) begin
		 case({sent_data,gwready_d2,data_fg1,data_fg3}) // synopsys parallel_case full_case
		   4'b1001 : begin // out data, no input => clear and shift up
			  data_b2 <= {32{1'b0}};
			  data_fg2 <= 1'b0;
		   end
		   4'b1011 : begin // out data, shift up => update to data_b0
			  data_b2 <= data_b1;
			  data_fg2 <= 1'b1;
		   end
		   4'b0101 : begin
			  if(data_fg2 == 1'b0) begin
				 data_b2 <= gwdata;
				 data_fg2 <= 1'b1;
			  end
		   end
		   // synopsys translate_off
		   //4'b0111 : $display("%t : AXI Host buffer overflow",$time);
		   //4'b1000 : $display("%t : AXI Host buffer underflow",$time);
		   4'b1010 : $display("%t : AXI Host buffer fault",$time);
		   //4'b1100 : $display("%t : AXI Host buffer underflow",$time);
		   4'b1110 : $display("%t : AXI Host buffer fault",$time);
		   // synopsys translate_on
		   4'b1101 : begin // out data, input
			  if(data_fg2 == 1'b1) begin // shift out and input new
				 data_b2 <= gwdata;
				 data_fg2 <= 1'b1;
			  end
		   end
		   4'b1111 : begin // out data, shift up => update to data_b0
			  data_b2 <= data_b1;
			  data_fg2 <= 1'b1;
		   end		   
		   default : begin
			  data_b2 <= data_b2;
			  data_fg2 <= data_fg2;
			end
		    /*  
		   default :;
		   4'b0000 : ;
		   4'b0001 : ;
		   4'b0010 : ;
		   4'b0011 : ;
		   4'b0100 : ;
		   4'b0110 : ;
			 */
		 endcase // case({sent_data,gwready_d2,data_fg1,data_fg3})
	  end // if (cs[IDLE] == 1'b0)
   end // always@ (posedge clk or negedge rstb)

   
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) begin
		 data_b3 <= {32{1'b0}};
		 data_fg3 <= 1'b0;
	  end
//	  else if(cs[PRD] == 1'b1) begin
//		 data_b3 <= gwdata;
//		 data_fg3 <= 1'b1;
//	  end
//	  else if(cs[IDLE] == 1'b0) begin
	  else if(cs[WR_DATA] == 1'b1) begin
		 case({sent_data,gwready_d2,data_fg2}) // synopsys parallel_case full_case
		   3'b010 : begin // input a new data
			  if(data_fg3 == 1'b0) begin // if empty, store a new data
				 data_b3 <= gwdata;
				 data_fg3 <= 1'b1;
			  end
		   end
		   3'b100 : begin // out data ==> clear
			  data_b3 <= {32{1'b0}};
			  data_fg3 <= 1'b0;
		   end
		   3'b101 : begin // out data, shift up ==> store the buffer1 data
			  data_b3 <= data_b2;
			  data_fg3 <= 1'b1;
		   end
		   3'b110 : begin // out data, input new, no shift up ==> store a new data
			  data_b3 <= gwdata;
			  data_fg3 <= 1'b1;
		   end
		   3'b111 : begin // out data, shift up ==> store the buffer1 data
			  data_b3 <= data_b2;
			  data_fg3 <= 1'b1;
		   end
		   default : begin
			  data_b3 <= data_b3;
			  data_fg3 <= data_fg3;
			end
		   /*
		   default :;
		   3'b000 : ;
		   3'b001 : ;
		   3'b011 : ;
			*/
		 endcase // case({sent_data,gwready_d2,data_fg1})
	  end // if (cs[IDLE] == 1'b0)
   end // always@ (posedge clk or negedge rstb)


   //==========================================================
   // AXI write data bus
   assign WID = {WID_WIDTH{1'b0}}; // no ID
   assign WDATA = data_b3;
   assign WSTRB = {NUM_BYTE{1'b1}};
   assign WLAST = (cs[IDLE] == 1'b0 && send_rsize == 4'h0)? 1'b1 : 1'b0;
   assign WVALID = cs[WR_DATA] & data_fg3;
   
   //==========================================================
   // AXI Response bus
   assign BREADY = cs[WT_RESP] & BVALID;

				   
endmodule // axi_host_wr
