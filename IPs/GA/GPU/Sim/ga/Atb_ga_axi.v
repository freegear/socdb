/****************************************************
 
    Test bench for a AXI interface 
 
    file name : Ath_ga_axi.v
    created by gtlee
    data : 2006.7.14
 
    note :
 
    history : 
 
******************************************************/

`timescale 1ns/10ps

`define   CLK_FREQ      10
`define   DLY            2


module Atb_ga_axi;
   reg            clk;
   reg 			  rstb;

   integer        logfile;
   

   initial begin
	  logfile = $fopen("AXI_SIM.log");
	  
	  clk = 0;
	  rstb = 0;
	  #(`CLK_FREQ*20) rstb = 1;
   end // initial

   always #(`CLK_FREQ/2)  clk <= ~clk;


   //================================================
   // AXI bus signals
   parameter             WID_WIDTH = 4;	// AWID/WID/BID width
   parameter 			 RID_WIDTH = 4;	// ARID/RID width
   parameter 			 DATA_WIDTH = 64;
   parameter 			 NUM_BYTE = DATA_WIDTH/8;
   
   wire [WID_WIDTH-1:0]  AWID;
   wire [31:0] 			 AWADDR;
   wire [3:0] 			 AWLEN;
   wire [2:0] 			 AWSIZE;
   wire [1:0] 			 AWBURST; // fixed
   wire [1:0] 			 AWLOCK;  // fixed
   wire [3:0] 			 AWCACHE; // fixed
   wire [2:0] 			 AWPROT;  // fixed
   wire 				 AWVALID;
   reg 					 AWREADY;
   
   wire [WID_WIDTH-1:0]  WID;
   wire [DATA_WIDTH-1:0] WDATA;
   wire [NUM_BYTE-1:0] 	 WSTRB;
   wire 				 WLAST;
   wire 				 WVALID;
   wire 				 WREADY;
   
   
   wire [WID_WIDTH-1:0]  BID;
   wire [1:0] 			 BRESP;
   reg 					 BVALID;
   wire 				 BREADY;
   
   //-------------------------------
   wire [RID_WIDTH-1:0]  ARID;
   wire [31:0] 			 ARADDR;
   wire [3:0] 			 ARLEN;
   wire [2:0] 			 ARSIZE;
   wire [1:0] 			 ARBURST;
   wire [1:0] 			 ARLOCK;
   wire [3:0] 			 ARCACHE;
   wire [2:0] 			 ARPROT;
   wire 				 ARVALID;
   reg 					 ARREADY;
   
   wire [RID_WIDTH-1:0]  RID;
   wire [DATA_WIDTH-1:0] RDATA;
   wire [1:0] 			 RRESP;
   wire 				 RLAST;
   wire 				 RVALID;
   wire 				 RREADY;

   //-------------------------------------------
   // Graphic bus
   reg 					 grd;
   reg [31:0] 			 graddr;
   reg [4:0] 			 grsize;
   wire [NUM_BYTE-1:0] 	 grbe;
   wire [DATA_WIDTH-1:0] grdata;
   wire 				 grvalid;
   wire 				 grbusy;
   
   reg 					 gwr;
   reg [31:0] 			 gwaddr;
   reg [4:0] 			 gwsize;
   reg [NUM_BYTE-1:0] 	 gwbe;
   wire [DATA_WIDTH-1:0] gwdata;
   wire 				 gwready;
   wire 				 gwbusy;

   
   
	  
   ga_axim    ga_axim
	 (
	  .clk                 ( clk ),
	  .rstb                ( rstb ),
	  
	  .AWID                ( AWID ),
	  .AWADDR              ( AWADDR ),
	  .AWLEN               ( AWLEN ),
	  .AWSIZE              ( AWSIZE ),
	  .AWBURST             ( AWBURST ),
	  .AWLOCK              ( AWLOCK ),
	  .AWCACHE             ( AWCACHE ),
	  .AWPROT              ( AWPROT ),
	  .AWVALID             ( AWVALID ),
	  .AWREADY             ( AWREADY ),
	  
	  .WID                 ( WID ),
	  .WDATA               ( WDATA ),
	  .WSTRB               ( WSTRB ),
	  .WLAST               ( WLAST ),
	  .WVALID              ( WVALID ),
	  .WREADY              ( WREADY ),
	  
	  .BID                 ( BID ),
	  .BRESP               ( BRESP ),
	  .BVALID              ( BVALID ),
	  .BREADY              ( BREADY ),
	  
	  .ARID                ( ARID ),
	  .ARADDR              ( ARADDR ),
	  .ARLEN               ( ARLEN ),
	  .ARSIZE              ( ARSIZE ),
	  .ARBURST             ( ARBURST ),
	  .ARLOCK              ( ARLOCK ),
	  .ARCACHE             ( ARCACHE ),
	  .ARPROT              ( ARPROT ),
	  .ARVALID             ( ARVALID ),
	  .ARREADY             ( ARREADY ),
	  
	  .RID                 ( RID ),
	  .RDATA               ( RDATA ),
	  .RRESP               ( RRESP ),
	  .RLAST               ( RLAST ),
	  .RVALID              ( RVALID ),
	  .RREADY              ( RREADY ),
	  
	  .grd                 ( grd ),
	  .graddr              ( graddr ),
	  .grsize              ( grsize ),
	  .grbe                ( grbe ),
	  .grdata              ( grdata ),
	  .grvalid             ( grvalid ),
	  .grbusy              ( grbusy ),
	  
	  .gwr                 ( gwr ),
	  .gwaddr              ( gwaddr ),
	  .gwsize              ( gwsize ),
	  .gwbe                ( gwbe ),
	  .gwdata              ( gwdata ),
	  .gwready             ( gwready ),
	  .gwbusy              ( gwbusy )
	  );

   //==============================================
   // AXI bus dummy
   initial begin
	  graddr = 0;
	  grsize = 0;
	  grd = 0;
	  gwr  = 0;
	  gwaddr = 0;
	  gwsize = 0;
   end // initial
   

   
   //------------------------------
   // recieve write address
   always@(posedge clk) begin
	  if(rstb & AWVALID) begin
		 $fdisplay(logfile,"AXI:Write. A:%h, L:%h, S:%h",AWADDR,AWLEN,AWSIZE);
	  end
   end // always

   // send address ready
   always@(posedge clk) begin
	  if(~rstb) AWREADY <= 1'b0;
	  else if(AWREADY) AWREADY <= 1'b0;
	  else if(AWVALID)  AWREADY <= 1'b1;
	  else AWREADY <= 1'b0;
   end // always
   
   // received write datas
   always@(posedge clk) begin
	  if(rstb & WVALID) 
		 $fdisplay(logfile,"AXI:Write. D:%h",WDATA);
   end

   // send data ready
   reg        pre_wready;
   
   always@(posedge clk) begin
	  if(rstb & WVALID & ~WLAST)  pre_wready <= 1'b1;
	  else pre_wready <= 1'b0;
   end

   assign   WREADY = pre_wready | WLAST;
   
   
   reg [3:0]   resp_dly;
   
   // send response
   
   always@(posedge clk) begin
	  if(~rstb) resp_dly <= 4'h0;
	  else if(rstb & BREADY) resp_dly <= 4'h0;
	  else if(rstb & WLAST & WVALID)
		resp_dly <= 4'h1;
	  else 
		resp_dly <= {resp_dly[2:0],resp_dly[3]};
   end // always


   always@(posedge clk) begin
	  if(~rstb) BVALID <= 1'b0;
	  else if(BREADY)  BVALID <= 1'b0;
	  else if(resp_dly[3]) BVALID <= 1'b1;
   end // always
	
   assign     BID = 0;
   assign     BRESP = 0;

   initial begin
	  BVALID = 0;
   end
   
   //------------------------------
   // receive read address
   reg    rd_en;
   
   always@(posedge clk) begin
	  if(rstb & ARVALID) begin
		 $fdisplay(logfile,"AXI:Read. A:%h, L:%h, S:%h",ARADDR,ARLEN,ARSIZE);
	  end // if
   end // always

   always@(posedge clk or negedge rstb) begin
	  if(~rstb) rd_en <= 0;
	  else if(ARVALID & ARREADY) rd_en <= 1;
	  else if(RLAST) rd_en <= 0;
   end
   
   
   // send address ready
   always@(posedge clk) begin
	  if(~rstb) ARREADY <= 1'b0;
	  else if(ARREADY) ARREADY <= 1'b0;
	  else if(ARVALID)  ARREADY <= 1'b1;
	  else ARREADY <= 1'b0;
   end // always
   
   // send read datas
   reg [7:0]   rdata;

   always@(posedge clk or negedge rstb) begin
	  if(~rstb) rdata <= 1;
	  else if(RREADY & RVALID) // readed
		rdata <= rdata + 9;
   end // always
   
   // store size
   reg [4:0] rd_burst_len;
   
   always@(posedge clk) begin
	  if(~rstb) rd_burst_len <= 0;
	  else if(ARVALID) begin
		 if(RREADY & RVALID)
		   rd_burst_len <= {1'b0,ARLEN} - 1;
		 else 
		   rd_burst_len <= {1'b0,ARLEN};
	  end
	  else if(RREADY && RVALID)
		rd_burst_len <= rd_burst_len - 1;
   end // always

   assign       RDATA = {rdata+8'h07,rdata+8'h06,rdata+8'h05,rdata+8'h04,
						 rdata+8'h03,rdata+8'h02,rdata+8'h01,rdata+8'h00};
   assign 		RLAST = (rd_en == 1 && rd_burst_len == 0)? 1 : 0;
   assign 		RRESP = 0;
   assign 		RVALID = (rd_en == 1 && rd_burst_len[4] == 1'b0)? 1 : 0;
   assign       RID = 0;
   

   //==================================
   // graphic bus signals
   always@(posedge clk) begin
	  if(rstb & grvalid) begin
		 $fdisplay(logfile,"GBUS:Read. RData:%h",grdata);
		 if(grbusy)
		   $fdisplay(logfile,"GBUS:Read. End Read.");
	  end
   end // always

   reg [7:0]   wdata;
   
   always@(posedge clk or negedge rstb) begin
	 if(~rstb) wdata <= {2'b01,{6{1'b0}}};
	 else if(gwready) wdata <= wdata + 9;
   end // always

   assign gwdata = {wdata+8'h07,wdata+8'h06,wdata+8'h05,wdata+8'h04,
					wdata+8'h03,wdata+8'h02,wdata+8'h01,wdata+8'h00};

   reg [31:0] waddr;
   reg [5:0]  wsize;
   
   // gnerate address
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) waddr <= 0;
	  else if(gwr)	 waddr <= gwaddr;
	  else if(gwready) waddr <= {(waddr[31:3]+1),3'h0};
   end // always

   always@(posedge clk or negedge rstb) begin
	  if(~rstb) wsize = 0;
	  else if(gwr) wsize = gwsize;
	  else if(gwready) begin
		 if(waddr[2:0] == 0) begin
			if(|wsize[5:3] == 1'b0)
			  wsize = 0;
			else wsize = wsize - 6'h08;
		 end
		 else begin
			if(wsize <= {3'h0,~waddr[2:0]})
			  wsize = 0;
			else wsize = wsize - {3'h0,~waddr[2:0]} - 1;
		 end
	  end // if (gwready)
   end  // always
       
   always@(posedge clk) begin
	  case(wsize)
		5'h00 :
		  gwbe = 8'b0000_0001;
		5'h01 :
		  gwbe = 8'b0000_0011;
		5'h02 :
		  gwbe = 8'b0000_0111;
		5'h03 :
		  gwbe = 8'b0000_1111;
		5'h04 :
		  gwbe = 8'b0001_1111;
		5'h05 :
		  gwbe = 8'b0011_1111;
		5'h06 :
		  gwbe = 8'b0111_1111;
		default :
		  gwbe = 8'b1111_1111;
	  endcase // case(gwsize)
	  
	  case(waddr[2:0])
		3'h0 :
		  gwbe = gwbe[7:0];
		3'h1 :
		  gwbe = {gwbe[6:0],1'b0};
		3'h2 :
		  gwbe = {gwbe[5:0],2'h0};
		3'h3 :
		  gwbe = {gwbe[4:0],3'h0};
		3'h4 :
		  gwbe = {gwbe[3:0],4'h0};
		3'h5 :
		  gwbe = {gwbe[2:0],5'h00};
		3'h6 :
		  gwbe = {gwbe[1:0],6'h0};
		default :
		  gwbe = {gwbe[0],7'h0};
	  endcase // case(waddr[2:0])
	  
   end // always@ (posedge clk)
   
      
   // Read command Task
   task read_cmd;
	  input [31:0] addr;
	  input [4:0]  size;
	  begin
		 grd = 0;
		 @(posedge clk) #`DLY
		 graddr = addr;
		 grsize = size;

		 grd = 1;
		 @(posedge clk) #`DLY
		   grd = 0;

		 wait(grbusy);
		 @(posedge clk);
		 
	  end
   endtask // read_cmd
   
   
   // write command
   task write_cmd;
	  input [31:0] addr;
	  input [4:0] size;
	  begin
		 gwr = 0;
		 
		 @(posedge clk) #`DLY
		 gwaddr = addr;
		 gwsize = size;

		 gwr = 1;
		 @(posedge clk) #`DLY
		   gwr = 0;
		 wait(gwbusy);
		 @(posedge clk);


		 // send write response
		 /*
		 #(`CLK_FREQ*20)
		 BVALID = 1;
		 wait(BREADY);
		 @(posedge clk);
		 BVALID = 0;
		 @(posedge clk);
		  */
	  end
   endtask // write_cmd
   

   
   // read/write commad
   initial begin
	  wait(rstb);
	  #(`CLK_FREQ*20) 
	  read_cmd(32'h00001000,16); // 17byte

	  write_cmd(32'h0003000,30); // 31 byte

	  #(`CLK_FREQ*20)
	  read_cmd(32'h00001002,8); // 9byte

	  write_cmd(32'h0003000,15); // 16 byte

	  
	  #(`CLK_FREQ*20)
	  read_cmd(32'h00001004,6); // 7byte

	  write_cmd(32'h0003006,31); // 32 byte
	  
	  
   end // initial
   
   
initial begin
  $shm_open("Atb_ga_axi.shm");
  $shm_probe(Atb_ga_axi, "ASC");
end

   
endmodule // Atb_ga_axi


