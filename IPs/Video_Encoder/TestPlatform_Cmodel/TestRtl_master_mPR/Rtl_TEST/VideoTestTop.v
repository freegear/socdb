module VideoTestTop;

parameter BUS_WID = 32;
parameter ADDR_WID= 32;
parameter MASTERID_WID= 1;
parameter SLAVEID_WID= 3;
parameter AWLEN_WID= 4;
parameter AWSIZE_WID= 3;
parameter AWBURST_WID= 2;
parameter AWLOCK_WID= 2;
parameter AWCACHE_WID= 4;
parameter AWPROT_WID= 3;
parameter WSTRB_WID= 4;
parameter BRESP_WID= 2;
parameter RRESP_WID= 2;
parameter ARLEN_WID= 4;
parameter ARBURST_WID= 2;
parameter ARLOCK_WID= 2;
parameter ARCACHE_WID= 4;
parameter ARPROT_WID= 3;
parameter MASTER_WID= 3;
parameter SLAVE_WID= 3;
parameter SLAVE_NUM= 6;
parameter MASTER_NUM= 5;
parameter SELMASTER_WID= 2;
parameter Wr_REQDEPTH_WID= 2;
parameter Rd_REQDEPTH_WID= 2;
parameter WrPermit_SLAVECNTWID= 3;
parameter RdPermit_SLAVECNTWID= 1;
parameter ARSIZE_WID= 3;

parameter DATA_WIDTH = 32;	// only support 32 bit now
parameter WID_WIDTH = 4;
parameter RID_WIDTH = 4;
parameter ADDR_WIDTH = 32;	// Memory Address Width : should be at least 12(4KB)

parameter MADDR_WIDTH = (DATA_WIDTH == 32) ? (ADDR_WIDTH-2) : (ADDR_WIDTH-3);
// auto assign from above parameter
parameter NUM_BYTE = DATA_WIDTH/8;
parameter ID_WIDTH = (WID_WIDTH > RID_WIDTH) ? WID_WIDTH : RID_WIDTH;

//parameter PERIOD=3.76;	// 133 MHz
parameter PERIOD1=20.83;	// 24MHz
parameter PERIOD2=18.52;	// 27MHz
parameter PHASETIME1=(PERIOD1 / 2);
parameter PHASETIME2=(PERIOD2 / 2);
parameter SDLY=2;

reg   RESETn;
reg   Clock;
reg   Clock_27M;

integer serial_file;
integer compare_file;


always @(posedge VideoTestTop.CLK_27MHZ)
begin
    $fwrite(serial_file,"%d %d SYNC :: %d BLANK :: %d\n",VideoTestTop.VideoEnC.TempBuffer, 
                                                        ADC_OUT,
                                                        SYNC,
                                                        BLANK
                                                        );

    $fwrite(compare_file, "%02h\n",VideoTestTop.VideoEnC.TempBuffer);
end


initial 
begin
    serial_file  = $fopen("./out.w");
    compare_file = $fopen("./compare.out");
    Clock = 0; 
    Clock_27M = 0;
end

always #PHASETIME1 Clock     = ~Clock;
always #PHASETIME2 Clock_27M = ~Clock_27M;
initial
begin
	RESETn = 1'b0;

	repeat(100) @(posedge Clock);
	#(SDLY) RESETn = 1'b1;
end

wire  ACLK;
wire  CLK_27MHZ;
wire  ARESETn;
wire  NTSC_PAL;

assign ACLK      = Clock;
assign CLK_27MHZ = Clock_27M;
assign ARESETn   = RESETn;
assign NTSC_PAL  = 0; // 0 --> ntsc 
                      // 1 --> pal

wire CLK0;
wire CLK1;
wire CLK2;
wire CLK3;

wire [RID_WIDTH-1:0]  ARID;
wire [31:0]           ARADDR;
wire [3:0]            ARLEN;
wire [2:0]            ARSIZE;
wire [1:0]            ARBURST;
//disable lock port
//disable cache port
//disable protect port
wire                  ARVALID;
wire                  ARREADY;

wire  [RID_WIDTH-1:0]  RID;
wire  [DATA_WIDTH-1:0] RDATA;
wire  [1:0]            RRESP;
wire                   RLAST;
wire                   RVALID;
wire                   RREADY;
wire                   DMA_REQ;

wire [4:0]  MEMADDR00;	// discard lower 2 line
wire [4:0]  MEMADDR01;	// discard lower 2 line
wire        MEMWEn00;
wire        MEMWEn01;
wire [31:0] MEMRDATA00;
wire [31:0] MEMRDATA01;
wire [31:0] MEMWDATA00;
wire [31:0] MEMWDATA01;

wire [4:0]  MEMADDR10;	// discard lower 2 line
wire [4:0]  MEMADDR11;	// discard lower 2 line
wire        MEMWEn10;
wire        MEMWEn11;
wire [31:0] MEMRDATA10;
wire [31:0] MEMRDATA11;
wire [31:0] MEMWDATA10;
wire [31:0] MEMWDATA11;

wire [4:0]  MEMADDR20;	// discard lower 2 line
wire [4:0]  MEMADDR21;	// discard lower 2 line
wire        MEMWEn20;
wire        MEMWEn21;
wire [31:0] MEMRDATA20;
wire [31:0] MEMRDATA21;
wire [31:0] MEMWDATA20;
wire [31:0] MEMWDATA21;

wire [4:0]  MEMADDR30;	// discard lower 2 line
wire [4:0]  MEMADDR31;	// discard lower 2 line
wire        MEMWEn30;
wire        MEMWEn31;
wire [31:0] MEMRDATA30;
wire [31:0] MEMRDATA31;
wire [31:0] MEMWDATA30;
wire [31:0] MEMWDATA31;

wire [DATA_WIDTH-1:0]  MEMRDATA;

wire [7:0] ADC_OUT;
wire SYNC;
wire BLANK;

wire [MADDR_WIDTH-1:0] MADDR;	// discard lower 2 line
wire    MCEn;
wire	MWEn;
wire [DATA_WIDTH-1:0]  MRDATA;
wire [DATA_WIDTH-1:0]  MWDATA;




//Simulation Stop function
integer StopCnt;

initial 
begin
    StopCnt = 0;
    if(NTSC_PAL == 0)
        $display("NTSC mode\n");
    else
        $display("PAL mode\n");
end

always @(posedge Clock)
begin
    if(StopCnt == 4)
    begin
        $stop;
    end

    if(ARADDR == 30'd0 & ARVALID & ARREADY)
    begin
        StopCnt = StopCnt +1;
        $display("StopCnt----> %d \n", StopCnt);
    end
end


AxiPC 
#( 
    .DATA_WIDTH(BUS_WID) ,
    .ID_WIDTH(MASTERID_WID),
    .RID_WIDTH(MASTERID_WID)
 )
TEST_AxiPC
  (
   // Global Signals
   .ACLK(ACLK),
   .ARESETn(ARESETn),

   // Write Address Channel
   .AWID      ({MASTERID_WID{1'b0}}),
   .AWADDR    ({ADDR_WID{1'b0}}  ),
   .AWLEN     ({AWLEN_WID{1'b0}}   ),
   .AWSIZE    ({AWSIZE_WID{1'b0}}  ),
   .AWBURST   ({AWBURST_WID{1'b0}} ),
   .AWLOCK    ({AWLOCK_WID{1'b0}}  ),
   .AWCACHE   ({AWCACHE_WID{1'b0}} ),
   .AWPROT    ({AWPROT_WID{1'b0}}  ),
   .AWUSER    ({32{1'b0}}),
   .AWVALID   (1'b0 ),
   .AWREADY   (1'b0 ),
   // Write Channel
   .WID       ({MASTERID_WID{1'b0}}),
   .WLAST       (1'b0   ),
   .WDATA       ({BUS_WID{1'b0}}   ),
   .WSTRB       ({WSTRB_WID{1'b1}}   ),
   .WUSER       ({32{1'b0}}),
   .WVALID      (1'b0  ),
   .WREADY      (1'b0  ),
   // Write Response Channel
   .BID         ({MASTER_WID{1'b0}}),
   .BRESP        ({BRESP_WID{1'b0}}   ),
   .BUSER        ({32{1'b0}}),
   .BVALID       (1'b0  ),
   .BREADY       (1'b0  ),

   // Read Address Channel
   .ARID         ({MASTERID_WID{1'b0}}),
   .ARADDR       (ARADDR),
   .ARLEN        (ARLEN),
   .ARSIZE       (ARSIZE),
   .ARBURST      (ARBURST),
.ARLOCK(2'd0),
.ARCACHE(4'd0),
.ARPROT(3'd0),
   .ARUSER       ({32{1'b0}}),
   .ARVALID      (ARVALID),
   .ARREADY      (ARREADY),

   // Read Channel
   .RID          ({MASTERID_WID{1'b0}}),
   .RLAST        (RLAST),
   .RDATA        (RDATA),
   .RRESP        (RRESP),
   .RUSER        ({32{1'b0}}),
   .RVALID       (RVALID),
   .RREADY       (RREADY),


   // Low power interface
   .CACTIVE      (1'b1),
   .CSYSREQ      (1'b1),
   .CSYSACK      (1'b1)   
   );


TestSlave VideoMem
(
//	AXI Interface
		.ACLK     (ACLK     ), 
		.ARESETn  (ARESETn  ), 
		// Write Address Channel
		.AWID     (0),
		.AWADDR   (0),
		.AWLEN    (0),
		.AWSIZE   (0),
		.AWBURST  (0),
		.AWVALID  (0),
		.AWREADY  (),
//Disable lock port
//Disable cache port
//Disable protect port

		// Write Data Channel
		.WID      (0),
		.WDATA    (0),
//Disable Wstrb
		.WLAST    (0),
		.WVALID   (0),
		.WREADY   (),

		// Write Response Channel
		.BID      (),
		.BRESP    (),
		.BVALID   (),
		.BREADY   (0),

		// Read Address Channel
		.ARID     (0),
		.ARADDR   (ARADDR   ),
		.ARLEN    (ARLEN    ),
		.ARSIZE   (ARSIZE   ),
		.ARBURST  (ARBURST  ),
		.ARVALID  (ARVALID  ),
		.ARREADY  (ARREADY  ),
//Disable lock port
//Disable cache port
//Disable protect port

		// Read Data Channel
		.RID      (),
		.RDATA    (RDATA    ),
		.RRESP    (RRESP    ),
		.RLAST    (RLAST    ),
		.RVALID   (RVALID   ),
		.RREADY   (RREADY   ),

//	SRAM Interface
		.MEMADDR  (MADDR  ),
		.MEMCEn   (MCEn   ),
		.MEMWEn   (MWEn   ),
		.MEMRDATA (MRDATA ),
		.MEMWDATA (MWDATA )
);

VIDEOEnC_SSRAM32bit  VIDEOEnC_SRAM32bit  
(
		.CLK   (ACLK), 

		.ADDR  (MADDR  ),
		.CEn   (MCEn   ),
		.WEn   (MWEn   ),
		.RDATA (MRDATA ),
		.WDATA (MWDATA )
);

VideoEncoderTester VideoEnC
(
//	AXI Interface
		.ACLK     (ACLK), 
        .CLK_27MHZ(CLK_27MHZ),
		.ARESETn  (ARESETn), 

		// Read Address Channel
		.ARADDR   (ARADDR   ),
		.ARLEN    (ARLEN    ),
		.ARSIZE   (ARSIZE   ),
		.ARBURST  (ARBURST  ),
		.ARVALID  (ARVALID  ),
		.ARREADY  (ARREADY  ),

		// Read Data Channel
		.RDATA    (RDATA    ),
		.RRESP    (RRESP    ),
		.RLAST    (RLAST    ),
		.RVALID   (RVALID   ),
		.RREADY   (RREADY   ),

        .DMA_REQ  (DMA_REQ  ),

//  APB bus
        .PENABLE  (0), 
        .PSEL     (0), 
        .PWRITE   (0), 
        .PADDR    (0),  //[3:2] used
        .PWDATA   (0),  //[15:0] used
        .PRDATA   (),

//	SRAM Interface
		.MEMADDR00  (MEMADDR00  ),
		.MEMADDR01  (MEMADDR01  ),
		.MEMWEn00   (MEMWEn00   ),
		.MEMWEn01   (MEMWEn01   ),
		.MEMRDATA00 (MEMRDATA00 ),
		.MEMRDATA01 (MEMRDATA01 ),
		.MEMWDATA00 (MEMWDATA00 ),
		.MEMWDATA01 (MEMWDATA01 ),

		.MEMADDR10  (MEMADDR10  ),
		.MEMADDR11  (MEMADDR11  ),
		.MEMWEn10   (MEMWEn10   ),
		.MEMWEn11   (MEMWEn11   ),
		.MEMRDATA10 (MEMRDATA10 ),
		.MEMRDATA11 (MEMRDATA11 ),
		.MEMWDATA10 (MEMWDATA10 ),
		.MEMWDATA11 (MEMWDATA11 ),

		.MEMADDR20  (MEMADDR20  ),
		.MEMADDR21  (MEMADDR21  ),
		.MEMWEn20   (MEMWEn20   ),
		.MEMWEn21   (MEMWEn21   ),
		.MEMRDATA20 (MEMRDATA20 ),
		.MEMRDATA21 (MEMRDATA21 ),
		.MEMWDATA20 (MEMWDATA20 ),
		.MEMWDATA21 (MEMWDATA21 ),

		.MEMADDR30  (MEMADDR30  ),
		.MEMADDR31  (MEMADDR31  ),
		.MEMWEn30   (MEMWEn30   ),
		.MEMWEn31   (MEMWEn31   ),
		.MEMRDATA30 (MEMRDATA30 ),
		.MEMRDATA31 (MEMRDATA31 ),
		.MEMWDATA30 (MEMWDATA30 ),
		.MEMWDATA31 (MEMWDATA31 ),

        .ADC_OUT   (ADC_OUT   ),
        .SYNC      (SYNC      ),
        .BLANK     (BLANK     )
);

MULTISRAM #(.d_width(32), 
            .addr_width(5),
            .mem_depth(32)
           ) SSRAM0
(
        .data0  (MEMWDATA00 ),
        .data1  (MEMWDATA01 ),
        .waddr0 (MEMADDR00  ),
        .waddr1 (5'd0       ),
        .raddr  (MEMADDR01  ),
        .we0    (MEMWEn00   ),
        .we1    (MEMWEn01   ),
        .clk0   (Clock      ),
        .clk1   (Clock_27M  ),
        .q1     (MEMRDATA01 )
);


MULTISRAM #(.d_width(32), 
            .addr_width(5),
            .mem_depth(32)
           ) SSRAM1
(
        .data0  (MEMWDATA10 ),
        .data1  (MEMWDATA11 ),
        .waddr0 (MEMADDR10  ),
        .waddr1 (5'd0       ),
        .raddr  (MEMADDR11  ),
        .we0    (MEMWEn10   ),
        .we1    (MEMWEn11   ),
        .clk0   (Clock      ),
        .clk1   (Clock_27M  ),
        .q1     (MEMRDATA11 )
);


MULTISRAM #(.d_width(32), 
            .addr_width(5),
            .mem_depth(32)
           ) SSRAM2
(
        .data0  (MEMWDATA20 ),
        .data1  (MEMWDATA21 ),
        .waddr0 (MEMADDR20  ),
        .waddr1 (5'd0       ),
        .raddr  (MEMADDR21  ),
        .we0    (MEMWEn20   ),
        .we1    (MEMWEn21   ),
        .clk0   (Clock      ),
        .clk1   (Clock_27M  ),
        .q1     (MEMRDATA21 )
);


MULTISRAM #(.d_width(32), 
            .addr_width(5),
            .mem_depth(32)
           ) SSRAM3
(
        .data0  (MEMWDATA30 ),
        .data1  (MEMWDATA31 ),
        .waddr0 (MEMADDR30  ),
        .waddr1 (5'd0       ),
        .raddr  (MEMADDR31  ),
        .we0    (MEMWEn30   ),
        .we1    (MEMWEn31   ),
        .clk0   (Clock      ),
        .clk1   (Clock_27M  ),
        .q1     (MEMRDATA31 )
);

endmodule
