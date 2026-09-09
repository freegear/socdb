/*********************************************************************
 AXI to AHB Slave wrapper
 
 created by gtlee
 
 history
    v1.0
 
    v2.0 : Add Retry Cycle

  
 **********************************************************************/



module axi2slave
  (
   ACLK               ,
   ARESETn            ,

   AWID               ,
   AWADDR             ,
   AWLEN              ,
   AWSIZE             ,
   AWBURST            ,
   AWVALID            ,
   AWREADY            ,

   WID                ,
   WDATA              ,
   WSTRB              ,
   WLAST              ,
   WVALID             ,
   WREADY             ,
   
   BID                ,
   BRESP              ,
   BVALID             ,
   BREADY             ,

   ARID               ,
   ARADDR             ,
   ARLEN              ,
   ARSIZE             ,
   ARBURST            ,
   ARVALID            ,
   ARREADY            ,

   RID                ,
   RDATA              ,
   RRESP              ,
   RLAST              ,
   RVALID             ,
   RREADY             ,

   // AHB Slave
   HADDR              ,
   HTRANS             ,
   HBURST             ,
   HWRITE             ,
   HSIZE              ,
   HWDATA             ,
   HSEL               ,
   HREADY_in          ,
   HREADY_out         ,
   HRESP              ,
   HRDATA             
   );
   parameter DATA_WIDTH = 32;	// only support 32 bit now
   parameter WID_WIDTH = 2;
   parameter RID_WIDTH = 2;
   parameter ADDR_WIDTH = 32;	// Memory Address Width : should be at least 12(4KB)

   parameter MADDR_WIDTH = (DATA_WIDTH == 32) ? (ADDR_WIDTH-2) : (ADDR_WIDTH-3);
   // auto assign from above parameter
   parameter NUM_BYTE = DATA_WIDTH/8;
   parameter ID_WIDTH = (WID_WIDTH > RID_WIDTH) ? WID_WIDTH : RID_WIDTH;
   
`define RESP_OKAY	2'b00
`define RESP_RETRY	2'b10

   input          ACLK;
   input 		  ARESETn;
   
   input [WID_WIDTH-1:0] AWID;
   input [ADDR_WIDTH-1:0] AWADDR;
   input [3:0] 	  AWLEN;
   input [2:0] 	  AWSIZE;
   input [1:0] 	  AWBURST;
   input 		  AWVALID;
   output 		  AWREADY;
   
   input [WID_WIDTH-1:0]  WID;
   input [DATA_WIDTH-1:0] WDATA;
   input [NUM_BYTE-1:0]   WSTRB;
   input 		  WLAST;
   input 		  WVALID;
   output 		  WREADY;
   
   output [WID_WIDTH-1:0] BID;
   output [1:0]   BRESP;
   output 		  BVALID;
   input 		  BREADY;
   
   input [RID_WIDTH-1:0]  ARID;
   input [ADDR_WIDTH-1:0] ARADDR;
   input [3:0] 	  ARLEN;
   input [2:0] 	  ARSIZE;
   input [1:0] 	  ARBURST;
   input 		  ARVALID;
   output 		  ARREADY;
   
   output [RID_WIDTH-1:0] RID;
   output [DATA_WIDTH-1:0] RDATA;
   output [1:0]    RRESP;
   output 		   RLAST;
   output 		   RVALID;
   input 		   RREADY;
   
   
   // AHB slave singal out
   //output		HCLK      ;
   //output		HRESETn   ;
   output [31:0]   HADDR     ;
   output [ 1:0]   HTRANS    ;
   output [ 2:0]   HBURST    ;
   output 		   HWRITE    ;
   output [ 2:0]   HSIZE     ;
   output [31:0]   HWDATA    ;
   output 		   HSEL      ;
   output 		   HREADY_in ;
   
   input 		   HREADY_out;
   input [ 1:0]    HRESP     ;
   input [31:0]    HRDATA    ;


   // internal signals
   wire 		   AWREADY;
   wire 		   WREADY;
   wire [WID_WIDTH-1:0] BID;
   wire [1:0]	   BRESP;
   wire 		   BVALID;

   wire 		   ARREADY;
   wire [RID_WIDTH-1:0] RID;
   wire [DATA_WIDTH-1:0] RDATA;
   wire [1:0]	   RRESP;
   wire 		   RLAST;
   wire 		   RVALID;

   wire [31:0] 	   HADDR     ;
   reg [ 1:0] 	   HTRANS    ;
   reg [ 2:0] 	   HBURST    ;
   reg 			   HWRITE    ;
   reg [ 2:0] 	   HSIZE     ;
   wire [31:0] 	   HWDATA    ;
   wire 		   HSEL      ;
   wire 		   HREADY_in ;

   // internal signals
   reg [ID_WIDTH-1:0] ID;
//   reg 			   op_kind; // read or write
   wire 		   wr_ok;
   wire 		   rd_ok;
//   wire 		   op_ok;
   
   
   reg [31:0] 	   addr_add; // address adder
   reg [31:0] 	   addr_retry; // backup a address for the retry cycle.
   
   reg [4:0] 	   trans_word_num;
   reg [4:0] 	   word_num_retry; // backup a transfer count for the retry clycle.
//   reg [2:0] 	   burst_mode;
//   reg [31:0] 	   wdata_d1;

   reg             op_ok; // 진행중인 operation의 error여부를 저장.
   
   //---------------------------------------------------------
   // SM
   parameter 		IDLE = 0;
   parameter        SEND_CMD = IDLE + 1;
   parameter 		READ_DATA = SEND_CMD + 1;
   parameter 		WRITE_DATA = READ_DATA + 1;
   parameter        RETRY_IDLE = WRITE_DATA + 1;
   parameter 		SEND_RESP = RETRY_IDLE + 1;

   parameter 		SM_NUM = SEND_RESP + 1;
   parameter 		SM_INIT = {{(SM_NUM-1){1'b0}},1'b1};
   
   parameter 		ST_IDLE       = (SM_INIT << IDLE);
   parameter 		ST_SEND_CMD   = (SM_INIT << SEND_CMD);
   parameter 		ST_READ_DATA  = (SM_INIT << READ_DATA);
   parameter 		ST_WRITE_DATA = (SM_INIT << WRITE_DATA);
   parameter 		ST_RETRY_IDLE = (SM_INIT << RETRY_IDLE);
   parameter 		ST_SEND_RESP  = (SM_INIT << SEND_RESP);
   
   
   reg [SM_NUM-1:0] cs, ns;

   reg [1:0] 		retry_dly;
   

   
   //---------------------------------------------------------
   //
   wire 	 sm_idle       = cs[IDLE];
   wire 	 sm_send_cmd   = cs[SEND_CMD];
   wire 	 sm_read_data  = cs[READ_DATA];
   wire 	 sm_write_data = cs[WRITE_DATA];
   wire 	 sm_retry_idle = cs[RETRY_IDLE];
   wire 	 sm_send_resp  = cs[SEND_RESP];
   //
   //---------------------------------------------------------

   always@(posedge ACLK or negedge ARESETn) begin
	  if(~ARESETn) cs <= ST_IDLE;
	  else cs <= ns;
   end // always
   
   always@(cs or AWVALID or ARVALID or HWRITE or rd_ok or wr_ok or retry_dly or
		   trans_word_num or BREADY or WLAST or HRESP or HREADY_out) begin
	  case(1'b1)
		cs[IDLE] : begin // no response
		   if(AWVALID | ARVALID) ns <= ST_SEND_CMD;
		   else ns <= ST_IDLE;
		end

		cs[SEND_CMD] : begin // active HTRANS and ARREADY or AWREADY
		   if(HRESP == `RESP_OKAY && HREADY_out == 1'b1) begin
			  if(HWRITE == 1'b1)
				ns <= ST_WRITE_DATA;
			  else ns <= ST_READ_DATA;
		   end
		   else ns <= ST_SEND_CMD;
		end
		
		cs[READ_DATA] : begin
		   if(HRESP == `RESP_RETRY)
			 ns <= ST_RETRY_IDLE;
		   else if(HRESP[0] == 1'b1 && HREADY_out == 1'b1) // error or split
			 ns <= ST_IDLE;
		   else if(rd_ok & trans_word_num[4] == 1'b1)
			 ns <= ST_IDLE;
		   else ns <= ST_READ_DATA;
		end

		cs[WRITE_DATA] : begin
		   if(HRESP == `RESP_RETRY)
			 ns <= ST_RETRY_IDLE;
		   else if(HRESP[0] == 1'b1 && HREADY_out == 1'b1) // error or split
			 ns <= ST_SEND_RESP;
		   else if(wr_ok & WLAST ) //trans_word_num[4] == 1'b1)
			 ns <= ST_SEND_RESP;
		   else ns <= ST_WRITE_DATA;
		end

		cs[RETRY_IDLE] : begin
		   if(retry_dly == 2'b11 && HREADY_out == 1'b1)
			 ns <= ST_SEND_CMD;
		   else ns <= ST_RETRY_IDLE;
		end
		
		cs[SEND_RESP] : begin
		   if(BREADY) ns <= ST_IDLE;
		   else ns <= ST_SEND_RESP;
		end
		default : ns <= ST_IDLE;
	  endcase // case(1'b1)
   end // always@ (cs or AWVALID or ARVALID or HWRITE or rd_ok or wr_ok or...


   // Wait count at the Retry Idle state
   always@(posedge ACLK or negedge ARESETn) begin
	  if(~ARESETn) retry_dly <= 2'b00;
	  else if(sm_retry_idle && retry_dly != 2'b11) retry_dly <= retry_dly + 2'h1;
	  else retry_dly <= 2'h0;
   end
   

   //------------------------------------------------------
  
   assign wr_ok = WVALID & HREADY_out & (HRESP == `RESP_OKAY);
   assign rd_ok = RVALID & RREADY & HREADY_out & (HRESP == `RESP_OKAY);
   
   always@(posedge ACLK or negedge ARESETn) begin
	  if(~ARESETn) begin
		 addr_add <= {32{1'b0}};
		 trans_word_num <= 5'h00;
	  end // if reset
	  else if(sm_idle == 1'b1) begin
         if(AWVALID) begin // if write
	   		addr_add <= AWADDR;
	   		trans_word_num <= {1'b0,AWLEN};
		 end // if write
		 else begin
	   		addr_add <= ARADDR;
	   		trans_word_num <= {1'b0,ARLEN};
		 end // else read
	  end // else if sm_idle
	  else if(sm_retry_idle) begin
		 addr_add <= addr_retry ;
		 trans_word_num <= word_num_retry ;
	  end
	  else if(sm_send_cmd | (sm_read_data & rd_ok) | (sm_write_data & wr_ok)) begin
		 addr_add <= {addr_add[31:2],2'h0} + 4; // clear the low 2bits at the burst transfer
		 trans_word_num <= trans_word_num - 1 ; // burst count
	  end // if ok op
   end // always@ (posedge ACLK or negedge ARESETn)
   

   // backup for the Retry
   always@(posedge ACLK or negedge ARESETn) begin 
	  if(~ARESETn)	begin
		 addr_retry <= {32{1'b0}};
		 word_num_retry <= 5'h00;
	  end // if
	  else if(sm_send_cmd == 1'b1 && sm_retry_idle == 1'b0) begin
		 addr_retry <= addr_add;
		 word_num_retry <= trans_word_num;
	  end // else
   end // always@ (posedge ACLK or negedge ARESETn)
   

   // Store a error event
   always@(posedge ACLK or negedge ARESETn) begin
	  if(~ARESETn)     op_ok <= 1'b1;
	  else if(sm_idle) op_ok <= 1'b1;
	  else if(HRESP[0] == 1'b1) op_ok <= 1'b0; // error
   end // always
   

   //-------------------------------------------------------------
   // generate the AHB signals
   assign HADDR = addr_add;

   wire [3:0] sel_len;

   assign 	  sel_len = (AWVALID)? AWLEN : ARLEN;
   
   always@(posedge ACLK or negedge ARESETn) begin
   	  if(~ARESETn) HBURST<=3'h0;
      else if(sm_idle) begin
		 case( sel_len )
		 4'h0 : HBURST <= 3'h0;   // single
		 4'h3 : HBURST <= 3'h3;   // inc 4
		 4'h7 : HBURST <= 3'h5;   // inc 8
		 4'hf : HBURST <= 3'h7;   // inc 16
		 default : HBURST <= 3'h1; // unspecified length. not support
		 endcase // case( sel_len )
	  end // if
   end // always@ (posedge ACLK or negedge ARESETn)

   
   always@(posedge ACLK or negedge ARESETn) begin
   	  if(~ARESETn) HSIZE <= 0;
      else if(sm_idle) begin
		 if(AWVALID)
		   HSIZE <= AWSIZE;
		 else HSIZE <= ARSIZE;
	  end // if
   end // always

   
   always@(sm_idle or sm_send_cmd or sm_read_data or sm_write_data or
		   HWRITE or WVALID or trans_word_num or RVALID or RREADY) begin
      if( sm_idle ) HTRANS <= 2'h0;
	  else if( sm_send_cmd )  HTRANS <= 2'h2; // first or non sequential
	  else if( sm_read_data | sm_write_data ) begin
	     if(trans_word_num[4] == 1'b1) HTRANS <= 2'h0;
		 else if((HWRITE & WVALID) |   // if write
			(~HWRITE & RVALID & RREADY)) begin // if read
			HTRANS <= 2'h3; // burst sequntial. OK
		 end
		 else HTRANS <= 2'h1; // Wait
	  end
	  else HTRANS <= 2'h0;
   end // always htrans

   
   always@(posedge ACLK or negedge ARESETn ) begin
	  if(~ARESETn)	 HWRITE <= 1'b0;
      else if(sm_idle) begin
         if(AWVALID) HWRITE <= 1'b1;
         else        HWRITE <= 1'b0;
      end // if sm_idle
   end // always
   
   assign      HSEL = ~sm_idle;
   assign 	   HREADY_in = HREADY_out;
   assign      HWDATA = WDATA;
   
   
   //-----------------------------------------------------------------
   // AXI interface signals
   assign      AWREADY = ((sm_idle & ~AWVALID) | (sm_send_cmd & HWRITE))? 1'b1 : 1'b0;
   assign      ARREADY = ((sm_idle & ~ARVALID) | (sm_send_cmd & (~HWRITE)))? 1'b1 : 1'b0;
   
   assign      WREADY = ((sm_idle & ~WVALID) | (sm_write_data & HREADY_out & (HRESP == `RESP_OKAY)))? 1'b1 : 1'b0;
   assign 	   BVALID = (sm_send_resp)? 1'b1 : 1'b0;
   assign      RVALID = (sm_read_data & HREADY_out & (HRESP == `RESP_OKAY))? 1'b1 : 1'b0;

   always@(posedge ACLK or negedge ARESETn ) begin
	  if(~ARESETn) ID <= {ID_WIDTH{1'b0}};
	  else if( sm_idle ) begin
         if(AWVALID)  // if write
			ID <= {{ID_WIDTH{1'b0}},AWID};
		 else         // if read
			ID <= {{ID_WIDTH{1'b0}},ARID};
	  end
   end // always@ (posedge ACLK or negedge ARESETn )

   assign      BID = ID[WID_WIDTH-1:0];
   assign 	   RID = ID[RID_WIDTH-1:0];

   assign      RDATA = HRDATA;

   assign 	   BRESP = (HWRITE && op_ok == 1'b0)? 2'h2 : 2'b0; // write
   assign 	   RRESP = (!HWRITE && (op_ok == 1'b0 || HRESP[0] == 1'b1))? 2'h2 : 2'b0; // read

   assign 	   RLAST = (sm_read_data & RVALID & trans_word_num[4] == 1'b1)? 1'b1 : 1'b0;
   
endmodule // axi2slave
