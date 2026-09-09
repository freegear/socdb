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
	  
	  clk = 1;
	  rstb = 0;
	  #(`CLK_FREQ*20) rstb = 1;
   end // initial

   always #(`CLK_FREQ/2)  clk <= ~clk;


   //================================================
   // AXI bus signals
   parameter             ID_WID  =    4;
   parameter 			 ID_WIDTH = ID_WID;
   parameter             WID_WIDTH = 4;	// AWID/WID/BID width
   parameter 			 RID_WIDTH = 4;	// ARID/RID width
   parameter 			 MASTER_WID = 4;
   parameter 			 SID_WIDTH = ID_WID+MASTER_WID;
   
   parameter 			 DATA_WIDTH = 32;
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
   wire 				 AWREADY;
   
   wire [WID_WIDTH-1:0]  WID;
   wire [DATA_WIDTH-1:0] WDATA;
   wire [NUM_BYTE-1:0] 	 WSTRB;
   wire 				 WLAST;
   wire 				 WVALID;
   wire 				 WREADY;
   
   
   wire [WID_WIDTH-1:0]  BID;
   wire [1:0] 			 BRESP;
   wire 				 BVALID;
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
   wire 				 ARREADY;
   
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

   // Slave 0 : Internal SRAM
   wire [29:0] 			 MEMADDR;
   wire [DATA_WIDTH-1:0] MEMRDATA;
   wire [DATA_WIDTH-1:0] MEMWDATA;
   wire 				 MEMCEn;
   wire [NUM_BYTE-1:0] 	 MEMWEn;
   
   
	  
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

   IntSRAMController #(.DATA_WIDTH(DATA_WIDTH),
					   .RID_WIDTH(WID_WIDTH),
					   .WID_WIDTH(WID_WIDTH)) 
   IntSRAMController
	 (
	  .ACLK(clk),
	  .ARESETn(rstb),
	  
	  .AWID(AWID),
	  .AWADDR(AWADDR),
	  .AWLEN(AWLEN),
	  .AWSIZE(AWSIZE),
	  .AWBURST(AWBURST),
	  .AWVALID(AWVALID),
	  .AWREADY(AWREADY),
	  //.AWREADY(),
	  
	  .WID(WID),
	  .WDATA(WDATA),
	  .WSTRB(WSTRB),
	  .WLAST(WLAST),
	  .WVALID(WVALID),
	  .WREADY(WREADY),
	  
	  .BID(BID),
	  .BRESP(BRESP),
	  .BVALID(BVALID),
	  .BREADY(BREADY),
	  
	  .ARID(ARID),
	  .ARADDR(ARADDR),
	  .ARLEN(ARLEN),
	  .ARSIZE(ARSIZE),
	  .ARBURST(ARBURST),
	  .ARVALID(ARVALID),
	  .ARREADY(ARREADY),
	  
	  // Read Data Channel
	  .RID(RID),
	  .RDATA(RDATA),
	  .RRESP(RRESP),
	  .RLAST(RLAST),
	  .RVALID(RVALID),
	  .RREADY(RREADY),
	  
	  .MEMADDR(MEMADDR[29:0]),
	  .MEMCEn(MEMCEn),
	  .MEMWEn(MEMWEn),
	  .MEMRDATA(MEMRDATA),
	  .MEMWDATA(MEMWDATA)
	  );

   SSRAM #(14,32) SRAM
	 (
	  .CLK(clk),
	  .ADDR(MEMADDR[13:0]),
	  .CEn(MEMCEn),
	  .WEn(MEMWEn),
	  .RDATA(MEMRDATA),
	  .WDATA(MEMWDATA)
	  );

   //==============================================
   initial begin
	  graddr = 0;
	  grsize = 0;
	  grd = 0;
	  gwr  = 0;
	  gwaddr = 0;
	  gwsize = 0;
   end // initial

   //==============================================
   // AXI bus dummy
   
   //assign AWREADY = AWVALID; // fail
   
   
   //------------------------------
   // recieve write address
   always@(posedge clk) begin
	  if(rstb & AWVALID) begin
		 $fdisplay(logfile,"AXI:Write. A:%h, L:%h, S:%h",AWADDR,AWLEN,AWSIZE);
	  end
   end // always

   
   // received write datas
   always@(posedge clk) begin
	  if(rstb & WVALID) 
		 $fdisplay(logfile,"AXI:Write. D:%h",WDATA);
   end

   
   //------------------------------
   // receive read address
   //reg    rd_en;
   
   always@(posedge clk) begin
	  if(rstb & ARVALID) begin
		 $fdisplay(logfile,"AXI:Read. A:%h, L:%h, S:%h",ARADDR,ARLEN,ARSIZE);
	  end // if
   end // always



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
   
   // generate address
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) waddr <= 0;
	  else if(gwr)	 waddr <= gwaddr;
	  else if(gwready) waddr <= {(waddr[31:3]+1),3'h0};
   end // always

  
   reg [1:0] wladdr_dly;

   always@(posedge clk or posedge rstb) begin
	  if(!rstb) wladdr_dly <= 0;
	  else if(gwready)
		wladdr_dly <= waddr[1:0];
   end // always
   
	  
   
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) wsize = 6'h04;
	  else if(gwr) wsize = gwsize + 6'h04;
	  else if(gwready) begin
		 if(wladdr_dly[1:0] == 2'h0) begin
			if(|gwsize[5:2] == 1'b0)
			  wsize = 0;
			else wsize = wsize - 6'h04;
		 end
		 else begin
			if(wsize <= {4'h0,~wladdr_dly[1:0]})
			  wsize = 0;
			else wsize = wsize - {4'h0,~wladdr_dly[1:0]} - 1;
		 end
	  end // if (gwready)
   end  // always

   reg [3:0] wbe;
   
   always@(wsize) begin
	  case(wsize)
		4'h0 :
		  #1 wbe = 4'b0001;
		4'h1 :
		  #1 wbe = 4'b0011;
		4'h2 :
		  #1 wbe = 4'b0111;
		default :
		  #1 wbe = 4'b1111;
	  endcase // case(gwsize)
   end // always@ (wsize or waddr)

  
   always@(wbe or wladdr_dly) begin
   //always@(posedge clk) begin
	  case({1'b0,wladdr_dly[1:0]})
		3'h0 :
		  gwbe = wbe[3:0];
		3'h1 :
		  gwbe = {wbe[2:0],1'b0};
		3'h2 :
		  gwbe = {wbe[1:0],2'h0};
		default :
		  gwbe = {wbe[0],3'h0};
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
	  write_cmd(32'h00000300,5'd31); // 32byte
	  read_cmd (32'h00000300,5'd31); // 32byte
	  $fdisplay(logfile,"");

	  write_cmd(32'h00000323,5'd31); // 32byte
	  read_cmd (32'h00000323,5'd31); // 32byte
	  $fdisplay(logfile,"");
	  
	  write_cmd(32'h00000320,5'd30); // 31byte
	  read_cmd (32'h00000320,5'd30); // 31byte
	  $fdisplay(logfile,"");

	  write_cmd(32'h00000330,5'd7); // 8 byte
	  read_cmd (32'h00000330,5'd7); // 8 byte
	  $fdisplay(logfile,"");

	  // 4k boundary
	  write_cmd(32'h00000ff0,5'd20); // 21byte
	  read_cmd (32'h00000ff0,5'd20); // 21byte
	  $fdisplay(logfile,"");

	  write_cmd(32'h00000ff8,5'd20); // 21byte
	  read_cmd (32'h00000ff8,5'd20); // 21byte
	  
   end // initial
   
   

   
endmodule // Atb_ga_axi


