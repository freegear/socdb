
module TestSlave_bus 
(
//	AXI Interface
		ACLK     , 
		ARESETn  , 
		// Write Address Channel
		AWID     ,
		AWADDR   ,
		AWLEN    ,
		AWSIZE   ,
		AWBURST  ,
		AWVALID  ,
		AWREADY  ,

		// Write Data Channel
		WID      ,
		WDATA    ,
		WSTRB    ,
		WLAST    ,
		WVALID   ,
		WREADY   ,

		// Write Response Channel
		BID      ,
		BRESP    ,
		BVALID   ,
		BREADY   ,

		// Read Address Channel
		ARID     ,
		ARADDR   ,
		ARLEN    ,
		ARSIZE   ,
		ARBURST  ,
		ARVALID  ,
		ARREADY  ,

		// Read Data Channel
		RID      ,
		RDATA    ,
		RRESP    ,
		RLAST    ,
		RVALID   ,
		RREADY   ,

//	SRAM Interface
		MEMADDR  ,
		MEMCEn   ,
		MEMWEn   ,
		MEMRDATA ,
		MEMWDATA
);

//
// module parameter
//
parameter DATA_WIDTH = 32;	// only support 32 bit now
parameter WID_WIDTH = 4;
parameter RID_WIDTH = 4;
parameter ADDR_WIDTH = 32;	// Memory Address Width : should be at least 12(4KB)

parameter MADDR_WIDTH = (DATA_WIDTH == 32) ? (ADDR_WIDTH-2) : (ADDR_WIDTH-3);
// auto assign from above parameter
parameter NUM_BYTE = DATA_WIDTH/8;
parameter ID_WIDTH = (WID_WIDTH > RID_WIDTH) ? WID_WIDTH : RID_WIDTH;

`define RESP_OKAY	2'b00

//
// input/output port
//
input  ACLK;
input  ARESETn;

input  [7:0]  AWID;
input  [ADDR_WIDTH-1:0] AWADDR;
input  [3:0]            AWLEN;
input  [2:0]            AWSIZE;
input  [1:0]            AWBURST;
input                   AWVALID;
output                  AWREADY;

input  [7:0]  WID;
input  [DATA_WIDTH-1:0] WDATA;
input  [NUM_BYTE-1:0]   WSTRB;
input                   WLAST;
input                   WVALID;
output                  WREADY;


output [7:0]  BID;
output [1:0]            BRESP;
output                  BVALID;
input                   BREADY;

input  [7:0]  ARID;
input  [ADDR_WIDTH-1:0] ARADDR;
input  [3:0]            ARLEN;
input  [2:0]            ARSIZE;
input  [1:0]            ARBURST;
input                   ARVALID;
output                  ARREADY;

output [7:0]  RID;
output [DATA_WIDTH-1:0] RDATA;
output [1:0]            RRESP;
output                  RLAST;
output                  RVALID;
input                   RREADY;

output [MADDR_WIDTH-1:0] MEMADDR;	// discard lower 2 line
output                  MEMCEn;
output [NUM_BYTE-1:0]   MEMWEn;
input  [DATA_WIDTH-1:0] MEMRDATA;
output [DATA_WIDTH-1:0] MEMWDATA;


wire  [7:0]  AWIDts2s;
wire  [ADDR_WIDTH-1:0] AWADDRts2s;
wire  [3:0]            AWLENts2s;
wire  [2:0]            AWSIZEts2s;
wire  [1:0]            AWBURSTts2s;
wire                   AWVALIDts2s;
wire                   AWREADYs2ts;


TestSlaveBuffer
U0TestSlaveBuffer(
    
    //Global signal
    .ACLK    (ACLK    ),
    .ARESETn (ARESETn ),

    //For slave 
    //Write address channel
    .AWIDts2s    (AWIDts2s    ),
    .AWADDRts2s  (AWADDRts2s  ),
    .AWLENts2s   (AWLENts2s   ),
    .AWSIZEts2s  (AWSIZEts2s  ),
    .AWBURSTts2s (AWBURSTts2s ),
    .AWLOCKts2s  (),
    .AWCACHEts2s (),
    .AWPROTts2s  (),

    .AWVALIDts2s (AWVALIDts2s ),
    .AWREADYs2ts (AWREADYs2ts ),

    //For test 
    //Write address channel
    .AWIDmi2ts    (AWID    ),
    .AWADDRmi2ts  (AWADDR  ),
    .AWLENmi2ts   (AWLEN   ),
    .AWSIZEmi2ts  (AWSIZE  ),
    .AWBURSTmi2ts (AWBURST ),
    .AWLOCKmi2ts  ( 0),
    .AWCACHEmi2ts ( 0),
    .AWPROTmi2ts  ( 0),

    .AWVALIDmi2ts (AWVALID ),
    .AWREADYts2mi (AWREADY ),
    .BVALID       (BVALID  ),
    .BREADY       (BREADY  )
);


IntSRAMController 
#(
	.WID_WIDTH(8),
	.RID_WIDTH(8)
)
U0IntSRAMController 
(
//	AXI Interface
		.ACLK     (ACLK     ), 
		.ARESETn  (ARESETn  ), 
		// Write Address Channel
		.AWID     (AWIDts2s     ),
		.AWADDR   (AWADDRts2s   ),
		.AWLEN    (AWLENts2s    ),
		.AWSIZE   (AWSIZEts2s   ),
		.AWBURST  (AWBURSTts2s  ),
		.AWVALID  (AWVALIDts2s  ),
		.AWREADY  (AWREADYs2ts  ),

       /*
		.AWID     (AWID     ),
		.AWADDR   (AWADDR   ),
		.AWLEN    (AWLEN    ),
		.AWSIZE   (AWSIZE   ),
		.AWBURST  (AWBURST  ),
		.AWVALID  (AWVALID  ),
		.AWREADY  (AWREADY  ),
        */

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
		.ARVALID  (ARVALID  ),
		.ARREADY  (ARREADY  ),

		// Read Data Channel
		.RID      (RID      ),
		.RDATA    (RDATA    ),
		.RRESP    (RRESP    ),
		.RLAST    (RLAST    ),
		.RVALID   (RVALID   ),
		.RREADY   (RREADY   ),

//	SRAM Interface
		.MEMADDR  (MEMADDR  ),
		.MEMCEn   (MEMCEn   ),
		.MEMWEn   (MEMWEn   ),
		.MEMRDATA (MEMRDATA ),
		.MEMWDATA (MEMWDATA )
);
endmodule
