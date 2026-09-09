
//version short name
//BUS sorting output generation 2006-8-28
//ACLK & RESETn is not defined 

`timescale 1 ns/ 10ps
module TOP_SBUS;

    wire    SelMAP1;
//DEF_STATE

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
    .ARESETn (ARESETn),
    .SelMAP1 (SelMAP1)
);

endmodule
//Code_END


