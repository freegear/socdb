
//version short name



`timescale 1 ns/ 10ps
module tb;

parameter CLK_HALFPERIOD=10;

reg         ACLK        ;     // APB system clock
reg         ARESETn     ;     // APB system reset
always #CLK_HALFPERIOD	ACLK = ~ACLK;
initial ACLK 		= 0;     // clock
initial
begin
	ARESETn 	= 0;     // reset
	repeat(10) @(posedge ACLK);
	ARESETn	= 1;
end

wire    SelMAP1 = 1'b0;

//DEF_STATE
initial
    $timeformat(-9, 0, " ns", 0);

parameter NUM_BYTE    = BUS_WID/8;
parameter MADDR_WIDTH = (BUS_WID == 32) ? (ADDR_WID-2) : (ADDR_WID-3);

    //Write Channel SlaveInterface
    //_______________________________________________________________
//STATE00_START
    
    //For Master ?? :: ?NAME?
    //Write address channel
//ENABLE_AW_ID
    wire   [WRITECHID??_WID-1:0]   AWID_?NAME?;    
    wire   [ADDR_WID-1:0]          AWADDR_?NAME?;
    wire   [AWLEN_WID-1:0]         AWLEN_?NAME?;
    wire   [AWSIZE_WID-1:0]        AWSIZE_?NAME?;  
    wire   [AWBURST_WID-1:0]       AWBURST_?NAME?; 
//ENABLE_LOCK
    wire   [AWLOCK_WID-1:0]        AWLOCK_?NAME?;  
//ENABLE_CACHE
    wire   [AWCACHE_WID-1:0]       AWCACHE_?NAME?; 
//ENABLE_PROT
    wire   [AWPROT_WID-1:0]        AWPROT_?NAME?;  

    wire   AWVALID_?NAME?; 
    wire  AWREADY_2_?NAME?; 

    //Write data channel
//ENABLE_WID_ID
    wire   [WRITECHID??_WID-1:0]   WID_?NAME?;     
    wire   [BUS_WID-1:0]           WDATA_?NAME?;   
//ENABLE_WSTRB
    wire   [WSTRB_WID-1:0]         WSTRB_?NAME?;   
    wire   WLAST_?NAME?;   
    wire   WVALID_?NAME?;  
    wire  WREADY_2_?NAME?;  

    //Write response channel
//ENABLE_BID_ID
    wire   [WRITECHID??_WID-1:0]  BID_2_?NAME?;     
    wire   [BRESP_WID-1:0]        BRESP_2_?NAME?;   
    wire   BVALID_2_?NAME?;  
    wire    BREADY_?NAME?;  
    //_______________________________________________________________
//END_CH
//STATE_END


    //Write Channel MasterInterface
    //_______________________________________________________________
//STATE01_START
   
    // For slave ?? :: ?NAME?
    //__________________________________________________
    //Write address channel
    wire   [WR_SLAVEID??_WID-1:0]AWID_2_?NAME?;    
    wire   [ADDR_WID-1:0]     AWADDR_2_?NAME?;
    wire   [AWLEN_WID-1:0]    AWLEN_2_?NAME?;
    wire   [AWSIZE_WID-1:0]   AWSIZE_2_?NAME?;  
    wire   [AWBURST_WID-1:0]  AWBURST_2_?NAME?; 
//ENABLE_LOCK
    wire   [AWLOCK_WID-1:0]   AWLOCK_2_?NAME?;  
//ENABLE_CACHE
    wire   [AWCACHE_WID-1:0]  AWCACHE_2_?NAME?; 
//ENABLE_PROT
    wire   [AWPROT_WID-1:0]   AWPROT_2_?NAME?;  

    wire   AWVALID_2_?NAME?; 
    wire    AWREADY_?NAME?; 
    
    //Write data channel
    wire   [WR_SLAVEID??_WID-1:0]WID_2_?NAME?;     
    wire   [BUS_WID-1:0]      WDATA_2_?NAME?;   
//ENABLE_WSTRB
    wire   [WSTRB_WID-1:0]    WSTRB_2_?NAME?;   
    wire   WLAST_2_?NAME?;   
    wire   WVALID_2_?NAME?;  
    wire    WREADY_?NAME?; 

    //Write response channel
    wire   [WR_SLAVEID??_WID-1:0] BID_?NAME?;     
    wire   [BRESP_WID-1:0]     BRESP_?NAME?;   
    wire   BVALID_?NAME?;  
    wire  BREADY_2_?NAME?;  
//STATE_END



    //Read Channel SlaveInterface
    //_______________________________________________________________
//STATE02_START
    
    //For Master ?? :: ?NAME?
    //Read address channel
//ENABLE_AR_ID
    wire   [READCHID??_WID-1:0]ARID_?NAME?;    
    wire   [ADDR_WID-1:0]     ARADDR_?NAME?;
    wire   [ARLEN_WID-1:0]    ARLEN_?NAME?;
    wire   [ARSIZE_WID-1:0]   ARSIZE_?NAME?;  
    wire   [ARBURST_WID-1:0]  ARBURST_?NAME?; 
//ENABLE_LOCK
    wire   [ARLOCK_WID-1:0]   ARLOCK_?NAME?;  
//ENABLE_CACHE
    wire   [ARCACHE_WID-1:0]  ARCACHE_?NAME?; 
//ENABLE_PROT
    wire   [ARPROT_WID-1:0]   ARPROT_?NAME?;  

    wire   ARVALID_?NAME?; 
    wire   ARREADY_2_?NAME?; 

    //Read data channel
//ENABLE_RID_ID
    wire   [READCHID??_WID-1:0]RID_2_?NAME?;     
    wire   [BRESP_WID-1:0]   RRESP_2_?NAME?;   
    wire   [BUS_WID-1:0]     RDATA_2_?NAME?;
    wire   RLAST_2_?NAME?;
    wire   RVALID_2_?NAME?;  
    wire   RREADY_?NAME?;  
//END_CH
//STATE_END


    //MasterInterface
    //_______________________________________________________________
//STATE03_START
    
    // For slave ??
    //__________________________________________________

    // Read address channel
    wire   [RD_SLAVEID??_WID-1:0]ARID_2_?NAME?;    
    wire   [ADDR_WID-1:0]     ARADDR_2_?NAME?;
    wire   [ARLEN_WID-1:0]    ARLEN_2_?NAME?;
    wire   [ARSIZE_WID-1:0]   ARSIZE_2_?NAME?;  
    wire   [ARBURST_WID-1:0]  ARBURST_2_?NAME?; 
//ENABLE_LOCK
    wire   [ARLOCK_WID-1:0]   ARLOCK_2_?NAME?;  
//ENABLE_CACHE
    wire   [ARCACHE_WID-1:0]  ARCACHE_2_?NAME?; 
//ENABLE_PROT
    wire   [ARPROT_WID-1:0]   ARPROT_2_?NAME?;  

    wire   ARVALID_2_?NAME?; 
    wire   ARREADY_?NAME?; 
    

    //Read data channel
    wire   [RD_SLAVEID??_WID-1:0] RID_?NAME?;     
    wire   [RRESP_WID-1:0]     RRESP_?NAME?;   
    wire   [BUS_WID-1:0]       RDATA_?NAME?;  
    wire   RLAST_?NAME?;  
    wire   RVALID_?NAME?;  
    wire  RREADY_2_?NAME?;  

//STATE_END
    //_______________________________________________________________


//STATE04_START
SBUS ?BUSNAME?(
//STATE_END

//Write channel signal
//MASTER channel signal
//STATE05_START
    //_______________________________________________________________
    //For Master ?? :: ?NAME?
    //Write address channel
//PART_A
//ENABLE_AW_ID
    .AWID_?NAME?    (AWID_?NAME?    ),
    .AWADDR_?NAME?  (AWADDR_?NAME?  ),
    .AWLEN_?NAME?   (AWLEN_?NAME?   ),
    .AWSIZE_?NAME?  (AWSIZE_?NAME?  ),
    .AWBURST_?NAME? (AWBURST_?NAME? ),
//ENABLE_LOCK
    .AWLOCK_?NAME?  (AWLOCK_?NAME?  ),
//ENABLE_CACHE
    .AWCACHE_?NAME? (AWCACHE_?NAME? ),
//ENABLE_PROT
    .AWPROT_?NAME?  (AWPROT_?NAME?  ),

    .AWVALID_?NAME? (AWVALID_?NAME? ),
    .AWREADY_2_?NAME?   (AWREADY_2_?NAME? ),

    //Write data channel
//ENABLE_WID_ID
    .WID_?NAME?         (WID_?NAME?     ),
    .WDATA_?NAME?       (WDATA_?NAME?   ),
//ENABLE_WSTRB
    .WSTRB_?NAME?       (WSTRB_?NAME?   ),
    .WLAST_?NAME?       (WLAST_?NAME?   ),
    .WVALID_?NAME?      (WVALID_?NAME?  ),
    .WREADY_2_?NAME?    (WREADY_2_?NAME?),

    //Write response channel
//ENABLE_BID_ID
    .BID_2_?NAME?       (BID_2_?NAME?     ),
    .BRESP_2_?NAME?     (BRESP_2_?NAME?   ),
    .BVALID_2_?NAME?    (BVALID_2_?NAME?  ),
    .BREADY_?NAME?      (BREADY_?NAME?    ),

//PART_B
    //Read address channel
//ENABLE_AR_ID
    .ARID_?NAME?    (ARID_?NAME?    ),
    .ARADDR_?NAME?  (ARADDR_?NAME?  ),
    .ARLEN_?NAME?   (ARLEN_?NAME?   ),
    .ARSIZE_?NAME?  (ARSIZE_?NAME?  ),
    .ARBURST_?NAME? (ARBURST_?NAME? ),
//ENABLE_LOCK
    .ARLOCK_?NAME?  (ARLOCK_?NAME?  ),
//ENABLE_CACHE
    .ARCACHE_?NAME? (ARCACHE_?NAME? ),
//ENABLE_PROT
    .ARPROT_?NAME?  (ARPROT_?NAME?  ),

    .ARVALID_?NAME? (ARVALID_?NAME? ),
    .ARREADY_2_?NAME? (ARREADY_2_?NAME? ),

    //Read data channel
//ENABLE_RID_ID
    .RID_2_?NAME?     (RID_2_?NAME?     ),
    .RRESP_2_?NAME?   (RRESP_2_?NAME?   ),
    .RDATA_2_?NAME?   (RDATA_2_?NAME?   ),
    .RLAST_2_?NAME?   (RLAST_2_?NAME?   ),
    .RVALID_2_?NAME?  (RVALID_2_?NAME?  ),
    .RREADY_?NAME?  (RREADY_?NAME?  ),
//PART_C
//STATE_END

//SLAVE channel signal
//STATE06_START
    //_______________________________________________________________
    //For Slave ?? :: ?NAME?
    //Write address channel
    .AWID_2_?NAME?    (AWID_2_?NAME?    ),
    .AWADDR_2_?NAME?  (AWADDR_2_?NAME?  ),
    .AWLEN_2_?NAME?   (AWLEN_2_?NAME?   ),
    .AWSIZE_2_?NAME?  (AWSIZE_2_?NAME?  ),
    .AWBURST_2_?NAME? (AWBURST_2_?NAME? ),
//ENABLE_LOCK
    .AWLOCK_2_?NAME?  (AWLOCK_2_?NAME?  ),
//ENABLE_CACHE
    .AWCACHE_2_?NAME? (AWCACHE_2_?NAME? ),
//ENABLE_PROT
    .AWPROT_2_?NAME?  (AWPROT_2_?NAME?  ),
    .AWVALID_2_?NAME? (AWVALID_2_?NAME? ),
    .AWREADY_?NAME? (AWREADY_?NAME? ),

    //Write data channel
    .WID_2_?NAME?     (WID_2_?NAME?     ),
    .WDATA_2_?NAME?   (WDATA_2_?NAME?   ),
//ENABLE_WSTRB
    .WSTRB_2_?NAME?   (WSTRB_2_?NAME?   ),
    .WLAST_2_?NAME?   (WLAST_2_?NAME?   ),
    .WVALID_2_?NAME?  (WVALID_2_?NAME?  ),
    .WREADY_?NAME?  (WREADY_?NAME?  ),

    //Write response channel
    .BID_?NAME?     (BID_?NAME?     ),
    .BRESP_?NAME?   (BRESP_?NAME?   ),
    .BVALID_?NAME?  (BVALID_?NAME?  ),
    .BREADY_2_?NAME?  (BREADY_2_?NAME?  ),

    //Read channel signal
    .ARID_2_?NAME?    (ARID_2_?NAME?    ),
    .ARADDR_2_?NAME?  (ARADDR_2_?NAME?  ),
    .ARLEN_2_?NAME?   (ARLEN_2_?NAME?   ),
    .ARSIZE_2_?NAME?  (ARSIZE_2_?NAME?  ),
    .ARBURST_2_?NAME? (ARBURST_2_?NAME? ),
//ENABLE_LOCK
    .ARLOCK_2_?NAME?  (ARLOCK_2_?NAME?  ),
//ENABLE_CACHE
    .ARCACHE_2_?NAME? (ARCACHE_2_?NAME? ),
//ENABLE_PROT
    .ARPROT_2_?NAME?  (ARPROT_2_?NAME?  ),

    .ARVALID_2_?NAME? (ARVALID_2_?NAME? ),
    .ARREADY_?NAME?   (ARREADY_?NAME? ),

    //Read data channel
    .RID_?NAME?       (RID_?NAME?     ),
    .RRESP_?NAME?     (RRESP_?NAME?   ),
    .RDATA_?NAME?     (RDATA_?NAME?  ),
    .RLAST_?NAME?     (RLAST_?NAME?  ),
    .RVALID_?NAME?    (RVALID_?NAME?  ),
    .RREADY_2_?NAME?  (RREADY_2_?NAME?  ),
//STATE_END

    .ACLK    (ACLK),
    .SelMAP1 (SelMAP1),
    .ARESETn (ARESETn)
);



//STATE09_START
//_______________________________________________________________
// Master ??
?NAME?_TestMaster  #(
	.WID_WIDTH(WRITECHID??_WID),
	.RID_WIDTH(READCHID??_WID)
)
?NAME?_TestMaster
(
		.MASTER_ID(?WID?'d??),

//PART_A
//ENABLE_AW_ID
		.AWID(AWID_?NAME?),
		.AWADDR(AWADDR_?NAME?),
		.AWLEN(AWLEN_?NAME?),
		.AWSIZE(AWSIZE_?NAME?),
		.AWBURST(AWBURST_?NAME?),
//ENABLE_LOCK
		.AWLOCK(AWLOCK_?NAME?),
//ENABLE_CACHE
		.AWCACHE(AWCACHE_?NAME?),
//ENABLE_PROT
		.AWPROT(AWPROT_?NAME?),
		.AWVALID(AWVALID_?NAME?),
		.AWREADY(AWREADY_2_?NAME?),

//ENABLE_WID_ID
		.WID(WID_?NAME?),
		.WDATA(WDATA_?NAME?),
//ENABLE_WSTRB
		.WSTRB(WSTRB_?NAME?),
		.WLAST(WLAST_?NAME?),
		.WVALID(WVALID_?NAME?),
		.WREADY(WREADY_2_?NAME?),

//ENABLE_BID_ID
		.BID(BID_2_?NAME?),
		.BRESP(BRESP_2_?NAME?),
		.BVALID(BVALID_2_?NAME?),
		.BREADY(BREADY_?NAME?),

//PART_B
//ENABLE_AR_ID
		.ARID(ARID_?NAME?),
		.ARADDR(ARADDR_?NAME?),
		.ARLEN(ARLEN_?NAME?),
		.ARSIZE(ARSIZE_?NAME?),
		.ARBURST(ARBURST_?NAME?),
//ENABLE_LOCK
		.ARLOCK(ARLOCK_?NAME?),
//ENABLE_CACHE
		.ARCACHE(ARCACHE_?NAME?),
//ENABLE_PROT
		.ARPROT(ARPROT_?NAME?),
		.ARVALID(ARVALID_?NAME?),
		.ARREADY(ARREADY_2_?NAME?),

		// Read Data Channel
//ENABLE_RID_ID
		.RID(RID_2_?NAME?),
		.RDATA(RDATA_2_?NAME?),
		.RRESP(RRESP_2_?NAME?),
		.RLAST(RLAST_2_?NAME?),
		.RVALID(RVALID_2_?NAME?),
		.RREADY(RREADY_?NAME?),
//PART_C
		.ACLK    (ACLK),
        .SelMAP1 (SelMAP1),
		.ARESETn (ARESETn)
);
//STATE_END


//STATE10_START
//_______________________________________________________________
// Slave ?? :: ?NAME?
wire [ADDR_WID-1:0] MEMADDR??;
wire [BUS_WID-1:0] MEMRDATA??;
wire [BUS_WID-1:0] MEMWDATA??;
wire        MEMCEn??;
wire [NUM_BYTE-1:0]  MEMWEn??;

?IntSRAMController? #(
    .DATA_WIDTH(BUS_WID), 
	.WID_WIDTH(WR_SLAVEID??_WID),
	.RID_WIDTH(RD_SLAVEID??_WID)
)
IntSRAMController??
(
		.ACLK(ACLK),
		.ARESETn(ARESETn),

		.AWID(AWID_2_?NAME?),
		.AWADDR(AWADDR_2_?NAME?),
		.AWLEN(AWLEN_2_?NAME?),
		.AWSIZE(AWSIZE_2_?NAME?),
		.AWBURST(AWBURST_2_?NAME?),
		.AWVALID(AWVALID_2_?NAME?),
		.AWREADY(AWREADY_?NAME?),
//ENABLE_LOCK
        .AWLOCK  (AWLOCK_2_?NAME?  ),
//ENABLE_CACHE
        .AWCACHE (AWCACHE_2_?NAME? ),
//ENABLE_PROT
        .AWPROT  (AWPROT_2_?NAME?  ),

		.WID(WID_2_?NAME?),
		.WDATA(WDATA_2_?NAME?),
		.WLAST(WLAST_2_?NAME?),
		.WVALID(WVALID_2_?NAME?),
//ENABLE_WSTRB
        .WSTRB  (WSTRB_2_?NAME?),
		.WREADY (WREADY_?NAME?),

		.BID(BID_?NAME?),
		.BRESP(BRESP_?NAME?),
		.BVALID(BVALID_?NAME?),
		.BREADY(BREADY_2_?NAME?),

		.ARID(ARID_2_?NAME?),
		.ARADDR(ARADDR_2_?NAME?),
		.ARLEN(ARLEN_2_?NAME?),
		.ARSIZE(ARSIZE_2_?NAME?),
		.ARBURST(ARBURST_2_?NAME?),
		.ARVALID(ARVALID_2_?NAME?),
		.ARREADY(ARREADY_?NAME?),
//ENABLE_LOCK
        .ARLOCK  (ARLOCK_2_?NAME?  ),
//ENABLE_CACHE
        .ARCACHE (ARCACHE_2_?NAME? ),
//ENABLE_PROT
        .ARPROT  (ARPROT_2_?NAME?  ),

		// Read Data Channel
		.RID(RID_?NAME?),
		.RDATA(RDATA_?NAME?),
		.RRESP(RRESP_?NAME?),
		.RLAST(RLAST_?NAME?),
		.RVALID(RVALID_?NAME?),
		.RREADY(RREADY_2_?NAME?),

		.MEMADDR(MEMADDR??[MADDR_WIDTH-1:0]),
		.MEMCEn(MEMCEn??),
		.MEMWEn(MEMWEn??),
		.MEMRDATA(MEMRDATA??),
		.MEMWDATA(MEMWDATA??)
);

?NAME?_SSRAM32bit #( .ADDR_WIDTH(MADDR_WIDTH), .BUS_WID(BUS_WID) ) SRAM??
(
		.CLK(ACLK),
		.ADDR(MEMADDR??[MADDR_WIDTH-1:0]),
		.CEn(MEMCEn??),
		.WEn(MEMWEn??),
		.RDATA(MEMRDATA??),
		.WDATA(MEMWDATA??)
);
//STATE_END

endmodule
//Code_END


