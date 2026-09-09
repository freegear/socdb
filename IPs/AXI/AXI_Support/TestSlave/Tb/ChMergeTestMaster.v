// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : ChMergeTestMaster.v
// File Revision       : 0.1
//  -----------------------------------------------------------------------------
//  Purpose            : This module is programmable AXI master signal generator.
//                     : This is behavioral model.(You cannot synthesize this)
//  =============================================================================


`timescale 1ns/10ps

module ChMergeTestMaster
(
		ACLK     , 
		ARESETn  , 

		// Write Address Channel
        AWID    ,
        AWADDR  ,
        AWLEN   ,
        AWSIZE  ,
        AWBURST ,
        AWLOCK  ,
        AWCACHE ,
        AWPROT  ,
        AWVALID ,
        AWREADY ,

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
parameter WID_WIDTH = 4;	// AWID/WID/BID width
parameter RID_WIDTH = 4;	// ARID/RID width
parameter RANDOMIZE = 1;	// VALID & READY timing is random
parameter WRAP_SUPPORT = 1;	// WRAP Burst support flag at random read/write test
parameter DWORD_ONLY = 0;	// DWord Only or Word/HWord/Byte support
parameter WORD_HALFWORD_BYTE_SINGLE_ONLY = 0;	
                    // Halfword/byte transfer will be only single tranfer(not burst)
parameter MAXIMUM_IDLE_CNT = 100000;	
                    // maximum idle cycle without generating error

parameter MAXID_WID = (WID_WIDTH >= RID_WIDTH) ? WID_WIDTH : RID_WIDTH;
parameter PRIORITY_WCH_RCHB = 1;
                    // priority chnnel setting (0 ==> RCH high priority)

parameter AWGAP_WIDTH = MAXID_WID - WID_WIDTH;
parameter ARGAP_WIDTH = MAXID_WID - RID_WIDTH;
parameter NUM_BYTE = DATA_WIDTH/8;

// ==============================================================================
//  input output declation
// ------------------------------------------------------------------------------

input  ACLK;
input  ARESETn;

output [WID_WIDTH-1:0]  AWID;
output [31:0]           AWADDR;
output [3:0]            AWLEN;
output [2:0]            AWSIZE;
output [1:0]            AWBURST;
output [1:0]            AWLOCK;
output [3:0]            AWCACHE;
output [2:0]            AWPROT;
output                  AWVALID;
input                   AWREADY;

output [WID_WIDTH-1:0]  WID;
output [DATA_WIDTH-1:0] WDATA;
output [NUM_BYTE-1:0]   WSTRB;
output                  WLAST;
output                  WVALID;
input                   WREADY;

input  [WID_WIDTH-1:0]  BID;
input  [1:0]            BRESP;
input                   BVALID;
output                  BREADY;

output [RID_WIDTH-1:0]  ARID;
output [31:0]           ARADDR;
output [3:0]            ARLEN;
output [2:0]            ARSIZE;
output [1:0]            ARBURST;
output [1:0]            ARLOCK;
output [3:0]            ARCACHE;
output [2:0]            ARPROT;
output                  ARVALID;
input                   ARREADY;

input  [RID_WIDTH-1:0]  RID;
input  [DATA_WIDTH-1:0] RDATA;
input  [1:0]            RRESP;
input                   RLAST;
input                   RVALID;
output                  RREADY;

// ==============================================================================
//  Wire & Reg. declation
// ------------------------------------------------------------------------------

reg AWREADY2merge; 
reg ARREADY2merge; 
reg AWVALID;
reg ARVALID;
wire AWVALID2merge;  
wire ARVALID2merge;

reg [2:0] CrState;
reg [2:0] NxState;

// ==============================================================================
//  Merge Channel State 
// ------------------------------------------------------------------------------

parameter IDLE = 0;
parameter WRR  = 1;
parameter RDR  = 2;

parameter CrStateIDLE = 3'd1;
parameter CrStateWRR  = 3'd2;
parameter CrStateRDR  = 3'd4;

always @(AWVALID2merge or ARVALID2merge or 
         AWVALID or AWREADY or
         ARVALID or ARREADY or
         CrState
        ) begin

    NxState = 0;
    case(1'b1) 
        CrState[IDLE]: 
            begin
                //Write channel priority is higher then Read channel priority
                if(ARVALID2merge & AWVALID2merge & PRIORITY_WCH_RCHB)       
                    NxState[WRR] = 1'b1;
                //Read channel priority is higher then Write channel priority
                else if(ARVALID2merge & AWVALID2merge & !PRIORITY_WCH_RCHB) 
                    NxState[RDR] = 1'b1;
                //Read Channel
                else if(ARVALID2merge & !AWVALID2merge) 
                    NxState[RDR]  = 1'b1;
                //Write Channel
                else if(!ARVALID2merge & AWVALID2merge) 
                    NxState[WRR]  = 1'b1;
                else                        
                    NxState[IDLE] = 1'b1;
            end
        CrState[WRR]: 
            begin
                if(AWVALID & AWREADY) NxState[IDLE] = 1'b1;
                else                  NxState[WRR]  = 1'b1;
            end
        CrState[RDR]: 
            begin
                if(ARVALID & ARREADY) NxState[IDLE] = 1'b1;
                else                  NxState[RDR]  = 1'b1;
            end

    endcase

end

always @(posedge ACLK or negedge ARESETn) begin

    if(!ARESETn) begin
        CrState[IDLE] <= 1'b1;
        CrState[WRR]  <= 1'b0;
        CrState[RDR]  <= 1'b0;
    end
    else begin
        CrState <= NxState;
    end
end


// ==============================================================================
//  Merge Channel Register Pass
// ------------------------------------------------------------------------------

always @(CrState or 
         AWVALID2merge or
         AWREADY or
         ARVALID2merge or
         ARREADY
         )
begin

    case(CrState)

        CrStateWRR: begin
                    AWVALID =  AWVALID2merge;
                    AWREADY2merge = AWREADY;
                    ARVALID = 1'b0;
                    ARREADY2merge = 1'b0;
              end
        CrStateRDR: begin
                    AWVALID = 1'b0;
                    AWREADY2merge = 1'b0;
                    ARVALID = ARVALID2merge;
                    ARREADY2merge = ARREADY;
              end

        default: begin
                    AWVALID = 1'b0;
                    AWREADY2merge = 1'b0;
                    ARVALID = 1'b0;
                    ARREADY2merge = 1'b0;
              end

    endcase

end

// ==============================================================================
//  TestMaster64
// ------------------------------------------------------------------------------

TestMaster64 #(

    .DATA_WIDTH                     (DATA_WIDTH                    ),
    .WID_WIDTH                      (WID_WIDTH                     ),
    .RID_WIDTH                      (RID_WIDTH                     ),
    .RANDOMIZE                      (RANDOMIZE                     ),
    .WRAP_SUPPORT                   (WRAP_SUPPORT                  ),
    .DWORD_ONLY                     (DWORD_ONLY                    ),
    .WORD_HALFWORD_BYTE_SINGLE_ONLY (WORD_HALFWORD_BYTE_SINGLE_ONLY),
    .MAXIMUM_IDLE_CNT               (MAXIMUM_IDLE_CNT              )

        )
TestMaster64
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
		.AWVALID  (AWVALID2merge  ),
		.AWREADY  (AWREADY2merge  ),

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
		.ARVALID  (ARVALID2merge  ),
		.ARREADY  (ARREADY2merge  ),

		// Read Data Channel
		.RID      (RID      ),
		.RDATA    (RDATA    ),
		.RRESP    (RRESP    ),
		.RLAST    (RLAST    ),
		.RVALID   (RVALID   ),
		.RREADY   (RREADY   )  
);

endmodule
