
`define NCSIM
//`define INTERCON


module tb;

parameter DATA_WIDTH = 64;	
parameter WID_WIDTH = 4;
parameter RID_WIDTH = 4;
parameter ADDR_WIDTH = 32;	// Memory Address Width : should be at least 12(4KB)

parameter RANDOMIZE = 1;	// VALID & READY timing is random
parameter WRAP_SUPPORT = 1;	// WRAP Burst support flag at random read/write test
parameter DWORD_ONLY = 0;	// DWord Only or Word/HWord/Byte support

parameter WORD_HALFWORD_BYTE_SINGLE_ONLY = 0;	
                    // Halfword/byte transfer will be only single tranfer(not burst)
parameter MAXIMUM_IDLE_CNT = 100000;	

parameter MADDR_WIDTH = (DATA_WIDTH == 32) ? (ADDR_WIDTH-2) : (ADDR_WIDTH-3);
parameter NUM_BYTE = DATA_WIDTH/8;
parameter ID_WIDTH = (WID_WIDTH > RID_WIDTH) ? WID_WIDTH : RID_WIDTH;

parameter MAXID_WID = (WID_WIDTH >= RID_WIDTH) ? WID_WIDTH : RID_WIDTH;


reg  ACLK;
reg  ARESETn;

initial begin

    ACLK = 0;
    ARESETn = 0;
#500;
    ARESETn = 1;
end

always #(5) ACLK = ~ACLK;

//wire...........

wire [WID_WIDTH-1:0]  AWID;
wire [ADDR_WIDTH-1:0] AWADDR;
wire [3:0]            AWLEN;
wire [2:0]            AWSIZE;
wire [1:0]            AWBURST;
wire [1:0]            AWLOCK;
wire [3:0]            AWCACHE;
wire [2:0]            AWPROT;
wire                  AWVALID;
wire                  AWREADY;

wire  [WID_WIDTH-1:0]  WID;
wire  [DATA_WIDTH-1:0] WDATA;
wire  [NUM_BYTE-1:0]   WSTRB;
wire                   WLAST;
wire                   WVALID;
wire                   WREADY;

wire [WID_WIDTH-1:0]  BID;
wire [1:0]            BRESP;
wire                  BVALID;
wire                  BREADY;


wire  [RID_WIDTH-1:0]  ARID;
wire  [ADDR_WIDTH-1:0] ARADDR;
wire  [3:0]            ARLEN;
wire  [2:0]            ARSIZE;
wire  [1:0]            ARBURST;
wire                   ARVALID;
wire                   ARREADY;
wire [1:0]             ARLOCK;
wire [3:0]            ARCACHE;
wire [2:0]            ARPROT;

wire [RID_WIDTH-1:0]  RID;
wire [DATA_WIDTH-1:0] RDATA;
wire [1:0]            RRESP;
wire                  RLAST;
wire                  RVALID;
wire                  RREADY;

`ifdef NCSIM

initial begin 
  $shm_open("./shm.shm"); 
  $shm_probe("AS"); 
end

`endif

ChMergeTestMaster #(

    .DATA_WIDTH                     (DATA_WIDTH                    ),
    .WID_WIDTH                      (WID_WIDTH                     ),
    .RID_WIDTH                      (RID_WIDTH                     ),
    .RANDOMIZE                      (RANDOMIZE                     ),
    .WRAP_SUPPORT                   (WRAP_SUPPORT                  ),
    .DWORD_ONLY                     (DWORD_ONLY                    ),
    .WORD_HALFWORD_BYTE_SINGLE_ONLY (WORD_HALFWORD_BYTE_SINGLE_ONLY),
    .MAXIMUM_IDLE_CNT               (MAXIMUM_IDLE_CNT              )

     )
ChMergeTestMaster
(
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
