//notice :: don't modify this code
//version short name

`define  ASSERT_ON
`timescale 1 ns/ 10ps
//INOUT_STATE00_START
module ?BUSNAME?(
//STATE_END

//Write channel signal
//INOUT_STATE01_START
    //_______________________________________________________________
    //For Master ?? :: ?NAME?
    //Write address channel
//ENABLE_ID
    AWID_?NAME?    ,
    AWADDR_?NAME?  ,
    AWLEN_?NAME?   ,
    AWSIZE_?NAME?  ,
    AWBURST_?NAME? ,
//ENABLE_LOCK
    AWLOCK_?NAME?  ,
//ENABLE_CACHE
    AWCACHE_?NAME? ,
//ENABLE_PROT
    AWPROT_?NAME?  ,

    AWVALID_?NAME? ,
    AWREADY_2_?NAME? ,

    
    //Write data channel
//ENABLE_ID
    WID_?NAME?     ,
    WDATA_?NAME?   ,
//ENABLE_WSTRB
    WSTRB_?NAME?   ,
    WLAST_?NAME?   ,
    WVALID_?NAME?  ,
    WREADY_2_?NAME?  ,

    //Write response channel
//ENABLE_ID
    BID_2_?NAME?     ,
    BRESP_2_?NAME?   ,
    BVALID_2_?NAME?  ,
    BREADY_?NAME?  ,
//END_CH
//STATE_END

//INOUT_STATE02_START
    //_______________________________________________________________
    //For Slave ?? :: ?NAME?
    //Write address channel
    AWID_2_?NAME?    ,
    AWADDR_2_?NAME?  ,
    AWLEN_2_?NAME?   ,
    AWSIZE_2_?NAME?  ,
    AWBURST_2_?NAME? ,
//ENABLE_LOCK
    AWLOCK_2_?NAME?  ,
//ENABLE_CACHE
    AWCACHE_2_?NAME? ,
//ENABLE_PROT
    AWPROT_2_?NAME?  ,
    AWVALID_2_?NAME? ,
    AWREADY_?NAME? ,

    //Write data channel
    WID_2_?NAME?     ,
    WDATA_2_?NAME?   ,
//ENABLE_WSTRB
    WSTRB_2_?NAME?   ,
    WLAST_2_?NAME?   ,
    WVALID_2_?NAME?  ,
    WREADY_?NAME?  ,

    //Write response channel
    BID_?NAME?     ,
    BRESP_?NAME?   ,
    BVALID_?NAME?  ,
    BREADY_2_?NAME?  ,
//END_CH
//STATE_END


//Read channel signal
//INOUT_STATE03_START
    //_______________________________________________________________
    //For Master ?? :: ?NAME?
    //Read address channel
//ENABLE_ID
    ARID_?NAME?    ,
    ARADDR_?NAME?  ,
    ARLEN_?NAME?   ,
    ARSIZE_?NAME?  ,
    ARBURST_?NAME? ,
//ENABLE_LOCK
    ARLOCK_?NAME?  ,
//ENABLE_CACHE
    ARCACHE_?NAME? ,
//ENABLE_PROT
    ARPROT_?NAME?  ,

    ARVALID_?NAME? ,
    ARREADY_2_?NAME? ,

    //Read data channel
//ENABLE_ID
    RID_2_?NAME?     ,
    RRESP_2_?NAME?   ,
    RDATA_2_?NAME?   ,
    RLAST_2_?NAME?   ,
    RVALID_2_?NAME?  ,
    RREADY_?NAME?  ,
//STATE_END
    
//INOUT_STATE04_START
    //_______________________________________________________________
    //For Slave ?? :: ?NAME?
    ARID_2_?NAME?    ,
    ARADDR_2_?NAME?  ,
    ARLEN_2_?NAME?   ,
    ARSIZE_2_?NAME?  ,
    ARBURST_2_?NAME? ,
//ENABLE_LOCK
    ARLOCK_2_?NAME?  ,
//ENABLE_CACHE
    ARCACHE_2_?NAME? ,
//ENABLE_PROT
    ARPROT_2_?NAME?  ,

    ARVALID_2_?NAME? ,
    ARREADY_?NAME? ,

    //Read data channel
    RID_?NAME?     ,
    RRESP_?NAME?   ,
    RDATA_?NAME?  ,
    RLAST_?NAME?  ,
    RVALID_?NAME?  ,
    RREADY_2_?NAME?  ,
//STATE_END

    ACLK    ,
    ARESETn 
);
//DEF_STATE

    input   ACLK;
    input   ARESETn;

    //Write Channel SlaveInterface
    //_______________________________________________________________
//INOUT_STATE05_START
    
    //For Master ?? :: ?NAME?
    //Write address channel
//ENABLE_ID
    input   [WRITECHID??_WID-1:0]   AWID_?NAME?;    
    input   [ADDR_WID-1:0]          AWADDR_?NAME?;
    input   [AWLEN_WID-1:0]         AWLEN_?NAME?;
    input   [AWSIZE_WID-1:0]        AWSIZE_?NAME?;  
    input   [AWBURST_WID-1:0]       AWBURST_?NAME?; 
//ENABLE_LOCK
    input   [AWLOCK_WID-1:0]        AWLOCK_?NAME?;  
//ENABLE_CACHE
    input   [AWCACHE_WID-1:0]       AWCACHE_?NAME?; 
//ENABLE_PROT
    input   [AWPROT_WID-1:0]        AWPROT_?NAME?;  

    input   AWVALID_?NAME?; 
    output  AWREADY_2_?NAME?; 

    //Write data channel
//ENABLE_ID
    input   [WRITECHID??_WID-1:0]    WID_?NAME?;     
    input   [BUS_WID-1:0]           WDATA_?NAME?;   
//ENABLE_WSTRB
    input   [WSTRB_WID-1:0]         WSTRB_?NAME?;   
    input   WLAST_?NAME?;   
    input   WVALID_?NAME?;  
    output  WREADY_2_?NAME?;  

    //Write response channel
//ENABLE_ID
    output   [WRITECHID??_WID-1:0]   BID_2_?NAME?;     
    output   [BRESP_WID-1:0]        BRESP_2_?NAME?;   
    output   BVALID_2_?NAME?;  
    input    BREADY_?NAME?;  
//END_CH
//STATE_END


    //Write Channel MasterInterface
    //_______________________________________________________________
//INOUT_STATE06_START
   
    // For slave ?? :: ?NAME?
    //__________________________________________________
    //Write address channel
    output   [WR_SLAVEID??_WID-1:0]AWID_2_?NAME?;    
    output   [ADDR_WID-1:0]     AWADDR_2_?NAME?;
    output   [AWLEN_WID-1:0]    AWLEN_2_?NAME?;
    output   [AWSIZE_WID-1:0]   AWSIZE_2_?NAME?;  
    output   [AWBURST_WID-1:0]  AWBURST_2_?NAME?; 
//ENABLE_LOCK
    output   [AWLOCK_WID-1:0]   AWLOCK_2_?NAME?;  
//ENABLE_CACHE
    output   [AWCACHE_WID-1:0]  AWCACHE_2_?NAME?; 
//ENABLE_PROT
    output   [AWPROT_WID-1:0]   AWPROT_2_?NAME?;  

    output   AWVALID_2_?NAME?; 
    input    AWREADY_?NAME?; 
    
    //Write data channel
    output   [WR_SLAVEID??_WID-1:0]WID_2_?NAME?;     
    output   [BUS_WID-1:0]      WDATA_2_?NAME?;   
//ENABLE_WSTRB
    output   [WSTRB_WID-1:0]    WSTRB_2_?NAME?;   
    output   WLAST_2_?NAME?;   
    output   WVALID_2_?NAME?;  
    input    WREADY_?NAME?; 

    //Write response channel
    input   [WR_SLAVEID??_WID-1:0] BID_?NAME?;     
    input   [BRESP_WID-1:0]     BRESP_?NAME?;   
    input   BVALID_?NAME?;  
    output  BREADY_2_?NAME?;  
//STATE_END


    //Read Channel SlaveInterface
    //_______________________________________________________________
//INOUT_STATE07_START
    
    //For Master ?? :: ?NAME?
    //Read address channel
//ENABLE_ID
    input   [READCHID??_WID-1:0]ARID_?NAME?;    
    input   [ADDR_WID-1:0]     ARADDR_?NAME?;
    input   [ARLEN_WID-1:0]    ARLEN_?NAME?;
    input   [ARSIZE_WID-1:0]   ARSIZE_?NAME?;  
    input   [ARBURST_WID-1:0]  ARBURST_?NAME?; 
//ENABLE_LOCK
    input   [ARLOCK_WID-1:0]   ARLOCK_?NAME?;  
//ENABLE_CACHE
    input   [ARCACHE_WID-1:0]  ARCACHE_?NAME?; 
//ENABLE_PROT
    input   [ARPROT_WID-1:0]   ARPROT_?NAME?;  

    input   ARVALID_?NAME?; 
    output  ARREADY_2_?NAME?; 

    //Read data channel
//ENABLE_ID
    output   [READCHID??_WID-1:0]RID_2_?NAME?;     
    output   [BRESP_WID-1:0]   RRESP_2_?NAME?;   
    output   [BUS_WID-1:0]     RDATA_2_?NAME?;
    output   RLAST_2_?NAME?;
    output   RVALID_2_?NAME?;  
    input    RREADY_?NAME?;  
//END_CH
//STATE_END


    //MasterInterface
    //_______________________________________________________________
//INOUT_STATE08_START
    
    // For slave ??
    //__________________________________________________

    // Read address channel
    output   [RD_SLAVEID??_WID-1:0]ARID_2_?NAME?;    
    output   [ADDR_WID-1:0]     ARADDR_2_?NAME?;
    output   [ARLEN_WID-1:0]    ARLEN_2_?NAME?;
    output   [ARSIZE_WID-1:0]   ARSIZE_2_?NAME?;  
    output   [ARBURST_WID-1:0]  ARBURST_2_?NAME?; 
//ENABLE_LOCK
    output   [ARLOCK_WID-1:0]   ARLOCK_2_?NAME?;  
//ENABLE_CACHE
    output   [ARCACHE_WID-1:0]  ARCACHE_2_?NAME?; 
//ENABLE_PROT
    output   [ARPROT_WID-1:0]   ARPROT_2_?NAME?;  

    output   ARVALID_2_?NAME?; 
    input    ARREADY_?NAME?; 
    

    //Read data channel
    input   [RD_SLAVEID??_WID-1:0] RID_?NAME?;     
    input   [RRESP_WID-1:0]     RRESP_?NAME?;   
    input   [BUS_WID-1:0]       RDATA_?NAME?;  
    input   RLAST_?NAME?;  
    input   RVALID_?NAME?;  
    output  RREADY_2_?NAME?;  

//STATE_END

//INOUT_STATE09_START
//______________________________________________________DEFALUT_SLAVE_START
    // default slave
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
    wire   RREADY_2_?NAME?;  
//STATE_END

//INOUT_STATE10_START
DefaultSlave #(
	.WID_WIDTH(WR_SLAVEID??_WID),
	.RID_WIDTH(RD_SLAVEID??_WID)
)
DefaultSlave
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
		.RREADY(RREADY_2_?NAME?)
);
//______________________________________________________DEFALUT_SLAVE_END
//STATE_END

//INOUT_END
