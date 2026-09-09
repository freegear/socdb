// ======================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// -----------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : TestSlave64.v
// File Revision       : 0.1
//  ----------------------------------------------------------------------
//  Purpose     : This module is programmable AXI master signal generator.
//              : This is behavioral model.(You cannot synthesize this)
//  ======================================================================

`timescale 1ns/10ps
module TestSlave
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
        AWLOCK   ,
        AWCACHE  ,
        AWPROT   ,
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
        ARLOCK   ,
        ARCACHE  ,
        ARPROT   ,
		ARVALID  ,
		ARREADY  ,

		// Read Data Channel
		RID      ,
		RDATA    ,
		RRESP    ,
		RLAST    ,
		RVALID   ,
		RREADY   

);

// ==============================================================================
//  Parameter declation
// ------------------------------------------------------------------------------

parameter DATA_WIDTH = 64;	
parameter WID_WIDTH = 4;
parameter RID_WIDTH = 4;
parameter ADDR_WIDTH = 32;	    // Memory Address Width : should be at least 12(4KB)

parameter WRAP_SUPPORT= 1;	// WRAP Burst support flag at random read/write test
parameter DWORD_ONLY  = 0;	// DWord Only or Word/HWord/Byte support

parameter MAXID_WID   = (WID_WIDTH >= RID_WIDTH) ? WID_WIDTH : RID_WIDTH;

parameter MADDR_WIDTH = (DATA_WIDTH == 32) ? (ADDR_WIDTH-2) : (ADDR_WIDTH-3);
parameter ADDR_MIN    = (DATA_WIDTH == 32) ? 2 : 3;
parameter NUM_BYTE    = DATA_WIDTH/8;


// ==============================================================================
//  input output declation
// ------------------------------------------------------------------------------
input   ACLK;
input   ARESETn;


input [WID_WIDTH-1:0]  AWID;
input [31:0]           AWADDR;
input [3:0]            AWLEN;
input [2:0]            AWSIZE;
input [1:0]            AWBURST;
input [1:0]            AWLOCK;
input [3:0]            AWCACHE;
input [2:0]            AWPROT;
input                  AWVALID;
output                 AWREADY;

input  [WID_WIDTH-1:0]  WID;
input  [DATA_WIDTH-1:0] WDATA;
input  [NUM_BYTE-1:0]   WSTRB;
input                   WLAST;
input                   WVALID;
output                  WREADY;

output [WID_WIDTH-1:0]  BID;
output [1:0]            BRESP;
output                  BVALID;
input                   BREADY;

input [RID_WIDTH-1:0]  ARID;
input [31:0]           ARADDR;
input [3:0]            ARLEN;
input [2:0]            ARSIZE;
input [1:0]            ARBURST;
input [1:0]            ARLOCK;
input [3:0]            ARCACHE;
input [2:0]            ARPROT;
input                  ARVALID;
output                 ARREADY;

output [WID_WIDTH-1:0]  RID;
output [DATA_WIDTH-1:0] RDATA;
output [1:0]            RRESP;
output                  RLAST;
output                  RVALID;
input                   RREADY;

// ==============================================================================
//  TestSlave
// ------------------------------------------------------------------------------

wire [MADDR_WIDTH-1 : 0]waddr0;	
wire [MADDR_WIDTH-1 : 0]raddr0;	
wire [NUM_BYTE-1:0]   we0;
wire [DATA_WIDTH-1:0] MEMRDATA;
wire [DATA_WIDTH-1:0] MEMWDATA;

wire [MADDR_WIDTH-1 :0] waddr64;	
wire [MADDR_WIDTH-1 :0] raddr64;	
wire [MADDR_WIDTH-1 :0] waddr32;	
wire [MADDR_WIDTH-1 :0] raddr32;	

wire [63:0] MEMRDATA64;
wire [63:0] MEMWDATA64;
wire [31:0] MEMRDATA32;
wire [31:0] MEMWDATA32;
wire [3:0]  we32;
wire [7:0]  we64;

assign MEMRDATA   = (DATA_WIDTH == 64) ? MEMRDATA64 : MEMRDATA32;
assign MEMWDATA64 = (DATA_WIDTH == 64) ? MEMWDATA   : 0;
assign MEMWDATA32 = (DATA_WIDTH == 32) ? MEMWDATA   : 0;

assign waddr64 =(DATA_WIDTH == 64) ? waddr0 : 0;	
assign raddr64 =(DATA_WIDTH == 64) ? raddr0 : 0;	
assign waddr32 =(DATA_WIDTH == 32) ? waddr0 : 0;	
assign raddr32 =(DATA_WIDTH == 32) ? raddr0 : 0;	

assign we32 = (DATA_WIDTH == 32) ? we0 : 0;
assign we64 = (DATA_WIDTH == 64) ? we0 : 0;


TestSlaveC #(

            .DATA_WIDTH     (DATA_WIDTH     ),
            .WID_WIDTH      (WID_WIDTH      ),
            .RID_WIDTH      (RID_WIDTH      ),
            .ADDR_WIDTH     (ADDR_WIDTH     ),
                                            
            .WRAP_SUPPORT   (WRAP_SUPPORT   ),
            .DWORD_ONLY     (DWORD_ONLY     )

           )
TestSlaveC
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
		.waddr0   (waddr0   ),
		.raddr0   (raddr0   ),
		.we0      (we0      ),
		.MEMRDATA (MEMRDATA ),
		.MEMWDATA (MEMWDATA )
);

// ==============================================================================
//  64bit TEST SSRAM
// ------------------------------------------------------------------------------

TestSSRAM64bit  SSRAM64
(
		.CLK     (ACLK), 

		.ADDR0   (waddr64[23:0]      ),
		.ADDR1   (raddr64[23:0]      ),
		.CEn     (1'b0),
		.WEn     (we64),
		.RDATA   (MEMRDATA64    ),
		.WDATA   (MEMWDATA64    )
);

// ==============================================================================
//  32bit TEST SSRAM
// ------------------------------------------------------------------------------

TestSSRAM32bit  SSRAM32
(
		.CLK     (ACLK), 

		.ADDR0   (waddr32[23:0]      ),
		.ADDR1   (raddr32[23:0]      ),
		.CEn     (1'b0),
		.WEn     (we32),
		.RDATA   (MEMRDATA32    ),
		.WDATA   (MEMWDATA32    )
);



endmodule

// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : TestSSRAM64bit.v
// File Revision       : 0.1
//  -----------------------------------------------------------------------------
//  Purpose            : Synchronous SRAM
//                     : This module is for test purpose only.
//  =============================================================================

`timescale 1ns/10ps

module TestSSRAM64bit 
(
		CLK     , 

		ADDR0   ,
		ADDR1   ,
		CEn     ,
		WEn     ,
		RDATA   ,
		WDATA
);

//
// module parameter
//
parameter ADDR_WIDTH = 24;	// Memory Address Width : should be at least 12(4KB)

input  CLK;
input  [ADDR_WIDTH-1:0] ADDR0;
input  [ADDR_WIDTH-1:0] ADDR1;
input  CEn;
input  [7:0] WEn;
input  [63:0] WDATA;
output [63:0] RDATA;

//wire  [ADDR_WIDTH-1:0] ADDR0 = ADDR;
reg [63:0] memory[{(ADDR_WIDTH-1){1'b1}}:0];
assign RDATA = memory[ADDR1];

always @(posedge CLK)
begin
	if(CEn == 1'b0)
	begin
		if(WEn[0] == 1'b1)
			memory[ADDR0] = (memory[ADDR0] & 64'hFFFFFFFFFFFFFF00) | {32'd0, 24'd0, WDATA[7:0]};
		if(WEn[1] == 1'b1)
			memory[ADDR0] = (memory[ADDR0] & 64'hFFFFFFFFFFFF00FF) | {32'd0, 16'd0, WDATA[15:8], 8'd0}; 
		if(WEn[2] == 1'b1)
			memory[ADDR0] = (memory[ADDR0] & 64'hFFFFFFFFFF00FFFF) | {32'd0, 8'd0,  WDATA[23:16], 16'd0};
		if(WEn[3] == 1'b1)
			memory[ADDR0] = (memory[ADDR0] & 64'hFFFFFFFF00FFFFFF) | {32'd0, WDATA[31:24], 24'd0};      

		if(WEn[4] == 1'b1)
			memory[ADDR0] = (memory[ADDR0] & 64'hFFFFFF00FFFFFFFF) | {24'd0, WDATA[39:32], 32'd0};
		if(WEn[5] == 1'b1)
			memory[ADDR0] = (memory[ADDR0] & 64'hFFFF00FFFFFFFFFF) | {16'd0, WDATA[47:40], 8'd0, 32'd0};  
		if(WEn[6] == 1'b1)
			memory[ADDR0] = (memory[ADDR0] & 64'hFF00FFFFFFFFFFFF) | {8'd0,  WDATA[55:48], 16'd0, 32'd0};
		if(WEn[7] == 1'b1)
			memory[ADDR0] = (memory[ADDR0] & 64'h00FFFFFFFFFFFFFF) | {WDATA[63:56], 24'd0, 32'd0};       

	end
end

endmodule


// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : SSRAM32bit.v
// File Revision       : 0.1
//  -----------------------------------------------------------------------------
//  Purpose            : Synchronous SRAM
//                     : This module is for test purpose only.
//  =============================================================================

`timescale 1ns/10ps

module TestSSRAM32bit 
(
		CLK     , 

		ADDR0   ,
		ADDR1   ,
		CEn     ,
		WEn     ,
		RDATA   ,
		WDATA
);

//
// module parameter
//
parameter ADDR_WIDTH = 24;	// Memory Address Width : should be at least 12(4KB)

input  CLK;
input  [ADDR_WIDTH-1:0] ADDR0;
input  [ADDR_WIDTH-1:0] ADDR1;
input  CEn;
input  [3:0] WEn;
input  [31:0] WDATA;
output [31:0] RDATA;

reg [31:0] memory[{(ADDR_WIDTH-1){1'b1}}:0];
assign RDATA = memory[ADDR1];

integer i;
always @(posedge CLK)
begin
	if(CEn == 1'b0)
	begin
		if(WEn[0] == 1'b1)
			memory[ADDR0] = (memory[ADDR0] & 32'hFFFFFF00) | {24'd0, WDATA[7:0]};
		if(WEn[1] == 1'b1)
			memory[ADDR0] = (memory[ADDR0] & 32'hFFFF00FF) | {16'd0, WDATA[15:8], 8'd0};  // memory[ADDR0][15:8] = WDATA[15:8];
		if(WEn[2] == 1'b1)
			memory[ADDR0] = (memory[ADDR0] & 32'hFF00FFFF) | {8'd0,  WDATA[23:16], 16'd0};// memory[ADDR0][23:16] = WDATA[23:16];
		if(WEn[3] == 1'b1)
			memory[ADDR0] = (memory[ADDR0] & 32'h00FFFFFF) | {WDATA[31:24], 24'd0};       // memory[ADDR0][31:24] = WDATA[31:24];
	end
end

endmodule


// ======================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// -----------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : TestSlave.v
// File Revision       : 0.1
//  ----------------------------------------------------------------------
//  Purpose     : This module is programmable AXI master signal generator.
//              : This is behavioral model.(You cannot synthesize this)
//  ======================================================================

`timescale 1ns/10ps

module TestSlaveC
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
		waddr0  ,
		raddr0  ,
		we0   ,
		MEMRDATA ,
		MEMWDATA
);

//
// module parameter
//
parameter DATA_WIDTH = 32;	
parameter WID_WIDTH = 4;
parameter RID_WIDTH = 4;
parameter ADDR_WIDTH = 32;	    // Memory Address Width : should be at least 12(4KB)

parameter WRAP_SUPPORT  = 1;	// WRAP Burst support flag at random read/write test
parameter DWORD_ONLY    = 0;	// DWord Only or Word/HWord/Byte support

parameter MADDR_WIDTH = (DATA_WIDTH == 32) ? (ADDR_WIDTH-2) : (ADDR_WIDTH-3);
parameter ADDR_MIN    = (DATA_WIDTH == 32) ? 2 : 3;

// auto assign from above parameter
parameter NUM_BYTE = DATA_WIDTH/8;
parameter ID_WIDTH = (WID_WIDTH > RID_WIDTH) ? WID_WIDTH : RID_WIDTH;

parameter CNT_WIDTH = 32;  

parameter AWQ_WIDTH = 4;	// AW Request Que(4 bit : que length 16)
parameter WDQ_WIDTH = 8;	// WD Data Que(16*16)

parameter ARQ_WIDTH = 4;	// AR Request Que
parameter RDQ_WIDTH = 8;	// RD DAta Que for each ARID

parameter AWQ_LEN = {AWQ_WIDTH{1'b1}}+1;
parameter WDQ_LEN = {WDQ_WIDTH{1'b1}}+1;
parameter ARQ_LEN = {ARQ_WIDTH{1'b1}}+1;
parameter RDQ_LEN = {RDQ_WIDTH{1'b1}}+1;
parameter RID_LEN = {RID_WIDTH{1'b1}}+1;
parameter WID_LEN = {WID_WIDTH{1'b1}}+1;




// ARSIZE/AWSIZE
`define SIZE_BYTE	3'b000
`define SIZE_HWORD	3'b001
`define SIZE_WORD	3'b010
`define SIZE_DWORD	3'b011

// AWBURST/ARBURST
`define BURST_FIXED	2'b00
`define BURST_INCR	2'b01
`define BURST_WRAP	2'b10

// ARLOCK/AWLOCK signal
`define NORMAL_ACCESS		2'b00
`define EXCLUSIVE_ACCESS	2'b01
`define LOCKED_ACCESS		2'b10

// CACHE signal
`define NO_CACHE			4'b0000

// PROT signal
`define NO_PROTECTION		3'b000

`define RESP_OKAY	2'b00
//`define RESP_OKAY	2'b10

//
// input/output port
//
input  ACLK;
input  ARESETn;

input  [WID_WIDTH-1:0]  AWID;
input  [ADDR_WIDTH-1:0] AWADDR;
input  [3:0]            AWLEN;
input  [2:0]            AWSIZE;
input  [1:0]            AWBURST;
input                   AWVALID;
output                  AWREADY;

input  [WID_WIDTH-1:0]  WID;
input  [DATA_WIDTH-1:0] WDATA;
input  [NUM_BYTE-1:0]   WSTRB;
input                   WLAST;
input                   WVALID;
output                  WREADY;


output [WID_WIDTH-1:0]  BID;
output [1:0]            BRESP;
output                  BVALID;
input                   BREADY;

input  [RID_WIDTH-1:0]  ARID;
input  [ADDR_WIDTH-1:0] ARADDR;
input  [3:0]            ARLEN;
input  [2:0]            ARSIZE;
input  [1:0]            ARBURST;
input                   ARVALID;
output                  ARREADY;

output [RID_WIDTH-1:0]  RID;
output [DATA_WIDTH-1:0] RDATA;
output [1:0]            RRESP;
output                  RLAST;
output                  RVALID;
input                   RREADY;


output [MADDR_WIDTH-1 : 0]waddr0;	
output [MADDR_WIDTH-1 : 0]raddr0;	
output [NUM_BYTE-1:0]   we0;
input  [DATA_WIDTH-1:0] MEMRDATA;
output [DATA_WIDTH-1:0] MEMWDATA;

/*
always @(posedge ACLK) begin
    if(WVALID & WREADY) begin
        if(waddr0[23:0] !== MEMWDATA[23:0]) begin
            $display($time, "Error data");
            $stop;
        end
    end
end
*/

// AR Channel Que & Data
reg  [ARQ_WIDTH-1:0]  ARQ_WINDEX;	// Write Que Index
reg  [ARQ_WIDTH-1:0]  ARQ_RINDEX;	// Read Que Index
reg  [WID_WIDTH-1:0]  ARID_Q[ARQ_LEN-1:0];
reg  [ADDR_WIDTH-1:0] ARADDR_Q[ARQ_LEN-1:0];
reg  [3:0]            ARLEN_Q[ARQ_LEN-1:0];
reg  [2:0]            ARSIZE_Q[ARQ_LEN-1:0];
reg  [1:0]            ARBURST_Q[ARQ_LEN-1:0];
reg  [1:0]            ARLOCK_Q[ARQ_LEN-1:0];
reg  [3:0]            ARCACHE_Q[ARQ_LEN-1:0];
reg  [2:0]            ARPROT_Q[ARQ_LEN-1:0];
wire   ARQ_empty;
assign ARQ_empty = (ARQ_RINDEX == ARQ_WINDEX) ? 1'b1 : 1'b0;
assign ARQ_full  = (ARQ_RINDEX == (ARQ_WINDEX+1'b1)) ? 1'b1 : 1'b0;

reg [ADDR_WIDTH-1:0] AREndBurst[ARQ_LEN-1:0];
reg rARREADY;
reg RVALID;

reg [WID_WIDTH-1:0]  RID;

reg [ADDR_WIDTH-1:0] Araddr;
reg [4:0]            ArLen;
reg [2:0]            ArSize;
reg [1:0]            ArBurst;
reg [ID_WIDTH-1:0]   ArID;
reg [1:0]            ArLock;
reg [3:0]            ArCache;
reg [2:0]            ArProt;

reg [11:0]  ArIncrSize;
reg [11:0]  ArIncreasedAddr;
reg [10:0]  RdCnt;
reg [10:0]  rWrapMask;

// AW Channel Que & Data
reg  [AWQ_WIDTH-1:0]  AWQ_WINDEX;	// Write Que Index
reg  [AWQ_WIDTH-1:0]  AWQ_RINDEX;	// Read Que Index
reg  [WID_WIDTH-1:0]  AWID_Q[AWQ_LEN-1:0];
reg  [ADDR_WIDTH-1:0] AWADDR_Q[AWQ_LEN-1:0];
reg  [3:0]            AWLEN_Q[AWQ_LEN-1:0];
reg  [2:0]            AWSIZE_Q[AWQ_LEN-1:0];
reg  [1:0]            AWBURST_Q[AWQ_LEN-1:0];
reg  [1:0]            AWLOCK_Q[AWQ_LEN-1:0];
reg  [3:0]            AWCACHE_Q[AWQ_LEN-1:0];
reg  [2:0]            AWPROT_Q[AWQ_LEN-1:0];
wire AWQ_empty;
assign AWQ_empty = (AWQ_RINDEX == AWQ_WINDEX) ? 1'b1 : 1'b0;
assign AWQ_full  = (AWQ_RINDEX == (AWQ_WINDEX+1'b1)) ? 1'b1 : 1'b0;

reg  [WID_WIDTH-1:0]  BID;
reg  [1:0]            BRESP;
reg                   BVALID;
reg                   PASS_WR;
reg [ID_WIDTH-1:0]    PASS_ID;

reg [ADDR_WIDTH-1:0] AWEndBurst[AWQ_LEN-1:0];
reg rAWREADY;
reg rWREADY;

reg [ADDR_WIDTH-1:0] Awaddr;
reg [3:0]            AwLen;
reg [2:0]            AwSize;
reg [1:0]            AwBurst;
reg [ID_WIDTH-1:0]   AwID;
reg [1:0]            AwLock;
reg [3:0]            AwCache;
reg [2:0]            AwProt;
reg [10:0]           WrapMask;

reg [11:0]  AwIncrSize;
reg [11:0]  AwIncreasedAddr;
reg [10:0]  WrCnt;
reg [NUM_BYTE-1:0]   WSTRB_d;
reg [DATA_WIDTH-1:0] WDATA_d;
reg EN_WRITE_d;

//Address Write enable
assign AWREADY = (AWQ_full) ? 1'b0 : rAWREADY;
wire EN_AWRITE = AWREADY & AWVALID;

//Write enable
wire EN_WRITE  = WREADY & WVALID;
assign WREADY  = rWREADY;

//Address Read enable
assign ARREADY = (ARQ_full) ? 1'b0 : rARREADY;
wire EN_AREAD  = ARREADY & ARVALID;

//Read enable
wire EN_READ  = RREADY & RVALID;


//BID, BRESP and BVALID generation
always @(posedge ACLK or negedge ARESETn) begin

    if(!ARESETn) begin
        BID <= 0;
        BRESP <= 2'b11;
        BVALID <= 0;
    end
    else begin
        if(PASS_WR) begin
            BRESP  <= `RESP_OKAY;
            BVALID <= 1'b1;
            BID    <= PASS_ID;
        end
        else if(BREADY) begin
            BRESP  <= 2'b11;
            BVALID <= 1'b0;
            BID    <= 0;
        end
        else begin
            BRESP  <= BRESP;
            BVALID <= BVALID;
            BID    <= BID;
        end
    end
end

assign RRESP = `RESP_OKAY;	
assign RLAST = ((ArLen == RdCnt) && RVALID) ? 1'b1: 1'b0;	

//ARREADY and RREADY generation
always @(posedge ACLK or negedge ARESETn) begin
    if(!ARESETn) begin
        rARREADY    <= 1'b0;
        RVALID     <= 1'b0;
        Araddr     <= 0;
        ArLen      <= 0;
        ArSize     <= 0;
        ArBurst    <= 0;
        ARQ_RINDEX <= 0;
        ARQ_WINDEX <= 0;
        RdCnt      <= 0;

        RID        <= 0;
    end 
    else begin
        if(ARQ_full) rARREADY <= 1'b0;
        else         rARREADY <= $random;

        /*
        if((ArLen == RdCnt) && RVALID) begin
            RRESP <= `RESP_OKAY;	
        end
        */

        if(EN_READ) begin
            if((ArLen == RdCnt)) begin
                RdCnt <= 0;
                RVALID <= 1'b0;
            end
            else begin
                RdCnt <= RdCnt + 1;
                RVALID <= $random;
            end
            //RRESP <= `RESP_OKAY;	
        end
        else begin
            if(RdCnt == 0) RVALID <= 1'b0;
            //else           RVALID <= $random;
            else           RVALID <= 1'b1;
        end

        if(EN_AREAD && !ARQ_full) aread(ARID, ARADDR, ARLEN, ARSIZE, ARBURST);

        if(!ARQ_empty && (RdCnt == 0)) begin
            RdCnt <= RdCnt + 1;

            ArID   <=  ARID_Q[ARQ_RINDEX];
            Araddr <=  ARADDR_Q[ARQ_RINDEX]; 
            ArLen  <=  ARLEN_Q[ARQ_RINDEX] + 1;
            ArSize <=  ARSIZE_Q[ARQ_RINDEX]; 
            ArBurst<=  ARBURST_Q[ARQ_RINDEX];
            ArLock <=  ARLOCK_Q[ARQ_RINDEX]; 
            ArCache<=  ARCACHE_Q[ARQ_RINDEX];
            ArProt <=  ARPROT_Q[ARQ_RINDEX]; 

            RID <=  ARID_Q[ARQ_RINDEX];

            ARQ_RINDEX <= ARQ_RINDEX + 1;
        end
        else if(EN_READ) begin

		    case(ArBurst)
			    2'b01: // INCR Burst
						Araddr[11:0] <= ArIncreasedAddr[11:0];		// Only update for 4 KB
			    2'b10: // WRAP Burst
						Araddr[10:0] <= (Araddr[10:0]&(~rWrapMask))|(ArIncreasedAddr[10:0]&rWrapMask);
			    default:	// FIXED Burst or Unknown Burst
						Araddr[11:0] <= Araddr[11:0];
		    endcase

        end
    end
end

//AWREADY and WREADY generation
always @(posedge ACLK or negedge ARESETn) begin
    if(!ARESETn) begin
        rAWREADY    <= 1'b0;
        rWREADY     <= 1'b1;
        Awaddr     <= 0;
        AwLen      <= 0;
        AwSize     <= 0;
        AwBurst    <= 0;
        AWQ_RINDEX <= 0;
        AWQ_WINDEX <= 0;
        WrCnt      <= 0;
        PASS_WR    <= 0;
        PASS_ID <= 0;
        WSTRB_d <=0;
        WDATA_d <= 0;

        EN_WRITE_d <= 0;
    end 
    else begin
        WSTRB_d <= WSTRB;
        WDATA_d <= WDATA;
        EN_WRITE_d <= EN_WRITE;

        if(AWQ_full) rAWREADY <= 1'b0;
        else         rAWREADY <= 1'b1;
        //else         rAWREADY <= $random;

        /*
        if(AWQ_empty || (AwLen !== WrCnt))      WREADY <= 1'b0;
        else if(AWQ_empty || (AwLen !== WrCnt)) WREADY <= 1'b0;
        else                                    WREADY <= $random;
        */

        if(EN_AWRITE && !AWQ_full) awrite(AWID, AWADDR, AWLEN, AWSIZE, AWBURST);

        //if(EN_WRITE && (WrCnt == 0)) begin
        if(!AWQ_empty && (WrCnt == 0)) begin
            WrCnt <= WrCnt + 1;
            PASS_WR <= 0;

            AwID   <=  AWID_Q[AWQ_RINDEX];
            Awaddr <=  AWADDR_Q[AWQ_RINDEX]; 
            AwLen  <=  AWLEN_Q[AWQ_RINDEX];
            AwSize <=  AWSIZE_Q[AWQ_RINDEX]; 
            AwBurst<=  AWBURST_Q[AWQ_RINDEX];
            AwLock <=  AWLOCK_Q[AWQ_RINDEX]; 
            AwCache<=  AWCACHE_Q[AWQ_RINDEX];
            AwProt <=  AWPROT_Q[AWQ_RINDEX]; 

            AWQ_RINDEX <= AWQ_RINDEX + 1;
            rWREADY     <= 1'b0;
        end
        else if(EN_WRITE) begin

            if(WLAST) begin
                PASS_ID <= AwID;
                if((AwLen+1) !== WrCnt) begin
                    $display("Error :: Write data is not enough [epxedted %d] but [%d] \n", AwLen, WrCnt);
                    $stop;
                    PASS_WR <= 0;
                end
                else begin
                    WrCnt <= 0;
                    PASS_WR <= 1;
                    rWREADY <= 1'b0;
                end
            end
            else begin
                WrCnt <= WrCnt + 1;
                PASS_WR <= 0;
                rWREADY <= $random;
            end

		    case(AwBurst)
			    2'b01: // INCR Burst
						Awaddr[11:0] <= AwIncreasedAddr[11:0];		// Only update for 4 KB
			    2'b10: // WRAP Burst
						Awaddr[10:0] <= (Awaddr[10:0]&(~WrapMask))|(AwIncreasedAddr[10:0]&WrapMask);
			    default:	// FIXED Burst or Unknown Burst
						Awaddr[11:0] <= Awaddr[11:0];
		    endcase

        end
        else begin
            if(WrCnt==0) rWREADY <= 1'b0;
            else         rWREADY <= $random;
            PASS_WR <= 0;
        end
    end
end

// rWrap mask signal
wire [3:0] ArLenM1 = ArLen -1;
always @(ArSize or ArLen)
	case((ArLen))
	4'b0001:	// 2
	begin
		case (ArSize)
		3'b000: rWrapMask <= 11'b00000000001; //1
		3'b001: rWrapMask <= 11'b00000000011; //2
		3'b010: rWrapMask <= 11'b00000000111; //4
		3'b011: rWrapMask <= 11'b00000001111; //8
		3'b100: rWrapMask <= 11'b00000011111; //16
		3'b101: rWrapMask <= 11'b00000111111; //32
		3'b110: rWrapMask <= 11'b00001111111; //64
		3'b111: rWrapMask <= 11'b00011111111; //128
		endcase
	end
	4'b0011:	// 4
	begin
		case (ArSize)
		3'b000: rWrapMask <= 11'b00000000011; //1
		3'b001: rWrapMask <= 11'b00000000111; //2
		3'b010: rWrapMask <= 11'b00000001111; //4
		3'b011: rWrapMask <= 11'b00000011111; //8
		3'b100: rWrapMask <= 11'b00000111111; //16
		3'b101: rWrapMask <= 11'b00001111111; //32
		3'b110: rWrapMask <= 11'b00011111111; //64
		3'b111: rWrapMask <= 11'b00111111111; //128
		endcase
	end
	4'b0111:	// 8
	begin
		case (ArSize)
		3'b000: rWrapMask <= 11'b00000000111; //1
		3'b001: rWrapMask <= 11'b00000001111; //2
		3'b010: rWrapMask <= 11'b00000011111; //4
		3'b011: rWrapMask <= 11'b00000111111; //8
		3'b100: rWrapMask <= 11'b00001111111; //16
		3'b101: rWrapMask <= 11'b00011111111; //32
		3'b110: rWrapMask <= 11'b00111111111; //64
		3'b111: rWrapMask <= 11'b01111111111; //128
		endcase
	end
	4'b1111:	// 16
	begin
		case (ArSize[1:0])
		3'b000: rWrapMask <= 11'b00000001111; //1
		3'b001: rWrapMask <= 11'b00000011111; //2
		3'b010: rWrapMask <= 11'b00000111111; //4
		3'b011: rWrapMask <= 11'b00001111111; //8
		3'b100: rWrapMask <= 11'b00011111111; //16
		3'b101: rWrapMask <= 11'b00111111111; //32
		3'b110: rWrapMask <= 11'b01111111111; //64
		3'b111: rWrapMask <= 11'b11111111111; //128
		endcase
	end
	default: rWrapMask <= 11'bxxxxxxxxxxx;	// don't care
endcase

// Wrap mask signal
wire [3:0] AwLenM1 = AwLen -1;
always @(AwSize or AwLenM1)
	case((AwLenM1))
	4'b0001:	// 2
	begin
		case (AwSize)
		3'b000: WrapMask <= 11'b00000000001; //1
		3'b001: WrapMask <= 11'b00000000011; //2
		3'b010: WrapMask <= 11'b00000000111; //4
		3'b011: WrapMask <= 11'b00000001111; //8
		3'b100: WrapMask <= 11'b00000011111; //16
		3'b101: WrapMask <= 11'b00000111111; //32
		3'b110: WrapMask <= 11'b00001111111; //64
		3'b111: WrapMask <= 11'b00011111111; //128
		endcase
	end
	4'b0011:	// 4
	begin
		case (AwSize)
		3'b000: WrapMask <= 11'b00000000011; //1
		3'b001: WrapMask <= 11'b00000000111; //2
		3'b010: WrapMask <= 11'b00000001111; //4
		3'b011: WrapMask <= 11'b00000011111; //8
		3'b100: WrapMask <= 11'b00000111111; //16
		3'b101: WrapMask <= 11'b00001111111; //32
		3'b110: WrapMask <= 11'b00011111111; //64
		3'b111: WrapMask <= 11'b00111111111; //128
		endcase
	end
	4'b0111:	// 8
	begin
		case (AwSize)
		3'b000: WrapMask <= 11'b00000000111; //1
		3'b001: WrapMask <= 11'b00000001111; //2
		3'b010: WrapMask <= 11'b00000011111; //4
		3'b011: WrapMask <= 11'b00000111111; //8
		3'b100: WrapMask <= 11'b00001111111; //16
		3'b101: WrapMask <= 11'b00011111111; //32
		3'b110: WrapMask <= 11'b00111111111; //64
		3'b111: WrapMask <= 11'b01111111111; //128
		endcase
	end
	4'b1111:	// 16
	begin
		case (AwSize)
		3'b000: WrapMask <= 11'b00000001111; //1
		3'b001: WrapMask <= 11'b00000011111; //2
		3'b010: WrapMask <= 11'b00000111111; //4
		3'b011: WrapMask <= 11'b00001111111; //8
		3'b100: WrapMask <= 11'b00011111111; //16
		3'b101: WrapMask <= 11'b00111111111; //32
		3'b110: WrapMask <= 11'b01111111111; //64
		3'b111: WrapMask <= 11'b11111111111; //128
		endcase
	end
	default: WrapMask <= 11'bxxxxxxxxxxx;	// don't care
endcase

task aread;
	input [WID_WIDTH-1:0] arid;
	input [ADDR_WIDTH-1:0] araddr;
	input [3:0]  arlen;
	input [2:0]  arsize;
	input [1:0]  arburst;
	reg   [ADDR_WIDTH-1:0] ov_check;
		begin
			ARID_Q[ARQ_WINDEX] = arid;
			ARADDR_Q[ARQ_WINDEX] = araddr;
			ARLEN_Q[ARQ_WINDEX] = arlen;
			ARSIZE_Q[ARQ_WINDEX] = arsize;
			ARBURST_Q[ARQ_WINDEX] = arburst;
			ARLOCK_Q[ARQ_WINDEX] = `NORMAL_ACCESS;
			ARCACHE_Q[ARQ_WINDEX] = `NO_CACHE;
			ARPROT_Q[ARQ_WINDEX] = `NO_PROTECTION;

            if(arburst == `BURST_FIXED)
                AREndBurst[AWQ_WINDEX] = araddr; 
            else 
                AREndBurst[AWQ_WINDEX] = araddr + ((arsize+1) * (arlen +1)); 

            if(arburst == `BURST_WRAP & !WRAP_SUPPORT) 	begin
		        $display("BUG: WARP burst function is not surpporting in TestSlave");
                $stop;
            end

            if(arsize !== `SIZE_DWORD & DWORD_ONLY) 	begin
		        $display("BUG: only double word size support");
                $stop;
            end

            if(arburst == `BURST_WRAP & WRAP_SUPPORT) 	begin
                if(arlen !== 1 && arlen !== 3  && arlen !== 7 && arlen !== 15) begin
		            $display("BUG: the length of the burst must be 2,4,8 or 16 [%h]\n", arlen);
                    $stop;
                end
            end

            if(arburst == `BURST_WRAP & WRAP_SUPPORT) 	begin

                case(arsize)

                `SIZE_HWORD: begin
                      if(araddr[0] === 1'b1) begin
		                $display("BUG: the startaddress must be aligned in WRAP function ");
                        $stop;
                      end
                    end
                `SIZE_WORD: begin
                      if(araddr[1:0] !== 2'b00) begin
		                $display("BUG: the startaddress must be aligned in WRAP function ");
                        $stop;
                      end
                    end
                `SIZE_DWORD: begin
                      if(araddr[2:0] !== 3'b000) begin
		                $display("BUG: the startaddress must be aligned in WRAP function ");
                        $stop;
                      end
                    end

                endcase
            end

		    case(arsize[1:0])
		        2'b00:   ov_check = araddr+ arlen;
		        2'b01:   ov_check = araddr+(arlen*2);
		        2'b10:   ov_check = araddr+(arlen*4);
		        default: ov_check = araddr+(arlen*8);
            endcase

            if(ov_check[11:0] > 4095 && arburst !== `BURST_WRAP) begin
		        $display("BUG:  the address length is over the 4k byte boundry rule");
		        $display("BUG:  startaddr[%h] arlen[%h] arsize[%d]",araddr,arlen,arsize);
		        $display($time, "BUG:  ov_check[%h]\n",ov_check[11:0]);

                $stop;
            end
			ARQ_WINDEX = ARQ_WINDEX + 1'b1;
		end
endtask


task awrite;
	input [WID_WIDTH-1:0] awid;
	input [ADDR_WIDTH-1:0] awaddr;
	input [3:0]  awlen;
	input [2:0]  awsize;
	input [1:0]  awburst;
	reg   [ADDR_WIDTH-1:0] ov_check;
		begin
			AWID_Q[AWQ_WINDEX] = awid;
			AWADDR_Q[AWQ_WINDEX] = awaddr;
			AWLEN_Q[AWQ_WINDEX] = awlen;
			AWSIZE_Q[AWQ_WINDEX] = awsize;
			AWBURST_Q[AWQ_WINDEX] = awburst;
			AWLOCK_Q[AWQ_WINDEX] = `NORMAL_ACCESS;
			AWCACHE_Q[AWQ_WINDEX] = `NO_CACHE;
			AWPROT_Q[AWQ_WINDEX] = `NO_PROTECTION;


            if(awburst == `BURST_FIXED)
                AWEndBurst[AWQ_WINDEX] = awaddr; 
            else 
                AWEndBurst[AWQ_WINDEX] = awaddr + ((awsize+1) * (awlen +1)); 

            if(awburst == `BURST_WRAP & !WRAP_SUPPORT) 	begin
		        $display("BUG: WARP burst function is not surpporting in TestSlave");
                $stop;
            end

            if(awsize !== `SIZE_DWORD & DWORD_ONLY) 	begin
		        $display("BUG: only double word size support");
                $stop;
            end

            if(awburst == `BURST_WRAP & WRAP_SUPPORT) 	begin
                if(awlen !== 1 && awlen !== 3  && awlen !== 7 && awlen !== 15) begin
		            $display("BUG: the length of the burst must be 2,4,8 or 16");
                    $stop;
                end
            end

            if(awburst == `BURST_WRAP & WRAP_SUPPORT) 	begin

                case(awsize)

                `SIZE_HWORD: begin
                      if(awaddr[0] === 1'b1) begin
		                $display("BUG: the startaddress must be aligned in WRAP function ");
                        $stop;
                      end
                    end
                `SIZE_WORD: begin
                      if(awaddr[1:0] !== 2'b00) begin
		                $display("BUG: the startaddress must be aligned in WRAP function ");
                        $stop;
                      end
                    end
                `SIZE_DWORD: begin
                      if(awaddr[2:0] !== 3'b000) begin
		                $display("BUG: the startaddress must be aligned in WRAP function ");
                        $stop;
                      end
                    end

                endcase
            end

		    case(awsize[1:0])
		        2'b00:   ov_check = awaddr+ awlen;
		        2'b01:   ov_check = awaddr+(awlen*2);
		        2'b10:   ov_check = awaddr+(awlen*4);
		        default: ov_check = awaddr+(awlen*8);
            endcase

            if(ov_check[11:0] > 4095 && awburst !== `BURST_WRAP) begin
		        $display("BUG:  the address length is over the 4k byte boundry rule");
		        $display("BUG:  startaddr[%h] awlen[%h] awsize[%d]",awaddr,awlen,awsize);
		        $display($time, "BUG:  ov_check[%h]\n",ov_check[11:0]);
                $stop;
            end

			AWQ_WINDEX = AWQ_WINDEX + 1'b1;
		end
endtask

always @(AwSize)
	case (AwSize)
	3'b000: AwIncrSize <= 1;
	3'b001: AwIncrSize <= 2;
	3'b010: AwIncrSize <= 4;
	3'b011: AwIncrSize <= 8;
	3'b100: AwIncrSize <= 16;
	3'b101: AwIncrSize <= 32;
	3'b110: AwIncrSize <= 64;
	3'b111: AwIncrSize <= 128;
	endcase

always @(ArSize)
	case (ArSize)
	3'b000: ArIncrSize <= 1;
	3'b001: ArIncrSize <= 2;
	3'b010: ArIncrSize <= 4;
	3'b011: ArIncrSize <= 8;
	3'b100: ArIncrSize <= 16;
	3'b101: ArIncrSize <= 32;
	3'b110: ArIncrSize <= 64;
	3'b111: ArIncrSize <= 128;
	endcase


always @(Awaddr or AwIncrSize) AwIncreasedAddr <= Awaddr[11:0] + AwIncrSize;
always @(Araddr or ArIncrSize) ArIncreasedAddr <= Araddr[11:0] + ArIncrSize;

//Write channel output 
assign waddr0   = Awaddr[ADDR_WIDTH-1:ADDR_MIN];
assign we0      = ((WrCnt > 0) & EN_WRITE) ? WSTRB : 1'b0; 
assign MEMWDATA = WDATA;

//Read channel output 
assign raddr0   = (RdCnt > 0) ? Araddr[ADDR_WIDTH-1:ADDR_MIN] : 0;
assign RDATA    = MEMRDATA;

endmodule
