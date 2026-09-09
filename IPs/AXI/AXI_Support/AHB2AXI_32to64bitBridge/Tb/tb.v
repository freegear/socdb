
`define NCSIM


module tb;

parameter DATA_WIDTH = 64;	
parameter WID_WIDTH = 4;
parameter RID_WIDTH = 4;
parameter ADDR_WIDTH = 32;	// Memory Address Width : should be at least 12(4KB)

parameter MADDR_WIDTH = (DATA_WIDTH == 32) ? (ADDR_WIDTH-2) : (ADDR_WIDTH-3);
parameter NUM_BYTE = DATA_WIDTH/8;
parameter ID_WIDTH = (WID_WIDTH > RID_WIDTH) ? WID_WIDTH : RID_WIDTH;

parameter WRAP_SUPPORT = 1;	// WRAP Burst support flag at random read/write test
parameter DWORD_ONLY = 0;	// DWord Only or Word/HWord/Byte support
parameter AWQ_WIDTH = 4;	// AW Request Que(4 bit : que length 16)
parameter WDQ_WIDTH = 8;	// WD Data Que(16*16)


parameter SIDLE = 0, SHOLD = 1, SCHANGE_CLK = 2;

reg  ACLK2;
reg  HCLK;
reg  ARESETn;
reg  RandomChange;
reg  IDLE_d;
reg  SW_CLK;
reg  HOLDBridge;

wire IDLE;
wire ClockEn;  

wire [1:0] AWLOCK;
wire [3:0] AWCACHE;
wire [2:0] AWPROT;
wire [1:0] ARLOCK;
wire [3:0] ARCACHE;
wire [2:0] ARPROT;

initial begin

    ACLK2 = 0;
    HCLK = 0;
    ARESETn    = 0;
#500;
    ARESETn = 1;
end

always #(20)  HCLK = ~HCLK;
always @(posedge HCLK) ACLK2 = ~ACLK2;

wire      ACLK     = (SW_CLK) ? ACLK2:HCLK;
assign #1 ClockEn  = (SW_CLK) ? ~ACLK:1'b1;

reg  CH_OK;
reg [3:0] State;
reg [3:0] NxState;

wire StateIsIDLE = State[SIDLE];
wire StateIsChclock = State[SCHANGE_CLK];
wire StateIsHold = State[SHOLD];
reg  StateIsChclock_d;

wire ACT_IDLE = IDLE & !IDLE_d;
wire ChMux    = StateIsChclock & !StateIsChclock_d; 

always @(posedge HCLK or negedge ARESETn) begin

    if(!ARESETn) IDLE_d <= 1'b0;
    else         IDLE_d <= IDLE;

    if(ACT_IDLE) RandomChange = $random;

    if(!ARESETn) StateIsChclock_d <= 1'b0;
    else         StateIsChclock_d <= StateIsChclock ;

    if(!ARESETn)    SW_CLK <= 1'b0;
    else if(ChMux)  SW_CLK <= ~SW_CLK;

    if(!ARESETn) begin
        CH_OK  <= 1'b0;
    end
    else begin
        if(State[SCHANGE_CLK]) CH_OK  <= 1'b1;
        else                   CH_OK  <= 1'b0;
    end

    if(!ARESETn) begin
        HOLDBridge <= 1'b0;
    end
    else begin
        if(StateIsIDLE & RandomChange)
            HOLDBridge <= 1'b1;
        else if(StateIsChclock)
            HOLDBridge <= 1'b0;
    end
end


always @(posedge HCLK or negedge ARESETn) begin

    if(!ARESETn) begin
        
        State[SIDLE] <= 1'b1;
        State[SCHANGE_CLK] <= 1'b0;
        State[SHOLD] <= 1'b0;
    end
    else begin
        State <= NxState;
    end

end

always @(State or IDLE or HOLDBridge or CH_OK)
begin
    NxState = 0;

    case(1'b1) // synopsys parallel_case full_case

        State[SIDLE]: 
            if(HOLDBridge)
                NxState[SHOLD] = 1'b1;
            else
                NxState[SIDLE] = 1'b1;
        State[SHOLD]:
            if(HOLDBridge & IDLE)
                NxState[SCHANGE_CLK] = 1'b1;
            else
                NxState[SHOLD] = 1'b1;
        State[SCHANGE_CLK]:
            if(CH_OK)
                NxState[SIDLE] = 1'b1;
            else
                NxState[SCHANGE_CLK] = 1'b1;

    endcase
end


//wire...........
wire  [WID_WIDTH-1:0]  AWID = 0;
wire  [ADDR_WIDTH-1:0] AWADDR;
wire  [3:0]            AWLEN;
wire  [2:0]            AWSIZE;
wire  [1:0]            AWBURST;
wire                   AWVALID;
wire                   AWREADY;

wire  [WID_WIDTH-1:0]  WID = 0;
wire  [DATA_WIDTH-1:0] WDATA;
wire  [NUM_BYTE-1:0]   WSTRB;
wire                   WLAST;
wire                   WVALID;
wire                   WREADY;


wire [WID_WIDTH-1:0]  BID = 0;
wire [1:0]            BRESP;
wire                  BVALID;
wire                  BREADY;

wire  [WID_WIDTH-1:0]  ARID = 0;
wire  [ADDR_WIDTH-1:0] ARADDR;
wire  [3:0]            ARLEN;
wire  [2:0]            ARSIZE;
wire  [1:0]            ARBURST;
wire                   ARVALID;
wire                   ARREADY;

wire [WID_WIDTH-1:0]  RID = 0;
wire [DATA_WIDTH-1:0] RDATA;
wire [1:0]            RRESP;
wire                  RLAST;
wire                  RVALID;
wire                  RREADY;

wire [MADDR_WIDTH -1:0]waddr0;	
wire [MADDR_WIDTH -1:0]raddr0;	
wire [NUM_BYTE-1:0]   we0;
wire [DATA_WIDTH-1:0] MEMRDATA;
wire [DATA_WIDTH-1:0] MEMWDATA;
wire cen;

wire [31:0]          HADDR;
wire [ 1:0]          HTRANS;
wire                 HWRITE;
wire [2:0]           HSIZE;
wire [2:0]           HBURST;
wire [3:0]           HPROT;
wire                 HLOCK;
wire [31:0]          HWDATA;
wire [31:0]          HRDATA;
wire                 HREADY;
wire [1:0]           HRESP;

wire #1 HREADY_d = HREADY;

`ifdef NCSIM

initial begin 
  $shm_open("./shm.shm"); 
  $shm_probe("AS"); 
end

`endif

AHBTestMaster 	AHBTestMaster 	// AHB-lite master
(
	    .HCLK     (HCLK), 
	    .HRESETn  (ARESETn), 
	    .HADDR    (HADDR    ),
	    .HTRANS   (HTRANS   ),
	    .HWRITE   (HWRITE   ),
	    .HSIZE    (HSIZE    ),
	    .HBURST   (HBURST   ),
	    .HPROT    (HPROT    ),
	    .HLOCK    (HLOCK    ),	// same timing with HMASTLOCK
	    .HWDATA   (HWDATA   ),
	    .HRDATA   (HRDATA   ),
	    .HREADY   (HREADY   ),
	    .HRESP    (HRESP    )
);

AHB32bit2AXI64bitBridge
Bridge
(
//	Common Interface
		.ACLK       (ACLK), 
		.HCLK       (HCLK), 
        .ClockEn    (ClockEn),
		.RESETn     (ARESETn), 
        .IDLE       (IDLE),
        .HOLDBridge (HOLDBridge),

// AHB Interface
		.HADDR       (HADDR       ),
		.HTRANS      (HTRANS      ),
		.HWRITE      (HWRITE      ),
		.HSIZE       (HSIZE       ),
		.HBURST      (HBURST      ),
		.HPROT       (HPROT       ),
		.HWDATA      (HWDATA      ),
		.HRDATA      (HRDATA      ),
		.HREADY_IN   (HREADY_d    ),
		.HREADY_OUT  (HREADY      ),
		.HRESP       (HRESP       ),
        .HSEL        (1'b1),
		.HMASTLOCK   (HLOCK),

// AXI Interface
		// Write Address Channel
		.AWADDR      (AWADDR      ),
		.AWLEN       (AWLEN       ),
		.AWSIZE      (AWSIZE      ),
		.AWBURST     (AWBURST     ),
		.AWLOCK      (AWLOCK      ),
		.AWCACHE     (AWCACHE     ),
		.AWPROT      (AWPROT      ),
		.AWVALID     (AWVALID     ),
		.AWREADY     (AWREADY     ),

		// Write Data Channel
		.WDATA       (WDATA       ),
		.WSTRB       (WSTRB       ),
		.WLAST       (WLAST       ),
		.WVALID      (WVALID      ),
		.WREADY      (WREADY      ),

		// Write Response Channel
		.BRESP       (BRESP       ),
		.BVALID      (BVALID      ),
		.BREADY      (BREADY      ),

		// Read Address Channel
		.ARADDR      (ARADDR      ),
		.ARLEN       (ARLEN       ),
		.ARSIZE      (ARSIZE      ),
		.ARBURST     (ARBURST     ),
		.ARLOCK      (ARLOCK      ),
		.ARCACHE     (ARCACHE     ),
		.ARPROT      (ARPROT      ),
		.ARVALID     (ARVALID     ),
		.ARREADY     (ARREADY     ),

		// Read Data Channel
		.RDATA       (RDATA       ),
		.RRESP       (RRESP       ),
		.RLAST       (RLAST       ),
		.RVALID      (RVALID      ),
		.RREADY      (RREADY      )
);

TestSlave #(
            .DATA_WIDTH     (DATA_WIDTH     ),

            .WID_WIDTH      (WID_WIDTH      ),
            .RID_WIDTH      (RID_WIDTH      ),
            .ADDR_WIDTH     (ADDR_WIDTH     ),
                                            
            .WRAP_SUPPORT   (WRAP_SUPPORT   ),
            .DWORD_ONLY     (DWORD_ONLY     )
           )
TestSlave
(
//	AXI Interface
		.ACLK     (ACLK     ), 
		.ARESETn  (ARESETn  ), 

		// Write Address Channel
		.AWID     (AWID     ),
		.AWADDR   (AWADDR   ),
		.AWLEN    (AWLEN    ),
		.AWSIZE   (AWSIZE   ),
		.AWBURST  (AWBURST  ),
		.AWLOCK   (AWLOCK   ),
		.AWCACHE  (AWCACHE  ),
		.AWPROT   (AWPROT   ),
		.AWVALID  (AWVALID  ),
		.AWREADY  (AWREADY  ),

		// Write Data Channel
		.WID      (WID      ),
		.WDATA    (WDATA    ),
		.WSTRB    (WSTRB    ),
		.WLAST    (WLAST    ),
		.WVALID   (WVALID   ),
		.WREADY   (WREADY   ),

		// Write Response Channel
		.BID      (BID      ),
		.BRESP    (BRESP    ),
		.BVALID   (BVALID   ),
		.BREADY   (BREADY   ),

		// Read Address Channel
		.ARID     (ARID     ),
		.ARADDR   (ARADDR   ),
		.ARLEN    (ARLEN    ),
		.ARSIZE   (ARSIZE   ),
		.ARBURST  (ARBURST  ),
		.ARLOCK   (ARLOCK   ),
		.ARCACHE  (ARCACHE  ),
		.ARPROT   (ARPROT   ),
		.ARVALID  (ARVALID  ),
		.ARREADY  (ARREADY  ),


		// Read Data Channel
		.RID      (RID      ),
		.RDATA    (RDATA    ),
		.RRESP    (RRESP    ),
		.RLAST    (RLAST    ),
		.RVALID   (RVALID   ),
		.RREADY   (RREADY   )
);

endmodule
