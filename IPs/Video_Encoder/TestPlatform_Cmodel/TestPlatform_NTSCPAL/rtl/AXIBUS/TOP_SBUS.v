//START
//version short name
//BUS sorting output generation 2006-8-28

`timescale 1 ns/ 10ps
module TOP_SBUS;

parameter BUS_WID = 32;
parameter ADDR_WID= 32;
parameter MASTERID_WID= 1;
parameter SLAVEID_WID= 2;
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
parameter MASTER_WID= 2;
parameter SLAVE_WID= 3;
parameter SLAVE_NUM= 6;
parameter MASTER_NUM= 2;
parameter SELMASTER_WID= 1;
parameter Wr_REQDEPTH_WID= 4;
parameter Rd_REQDEPTH_WID= 4;
parameter WrPermit_SLAVECNTWID= 5;
parameter RdPermit_SLAVECNTWID= 5;
parameter ARSIZE_WID= 3;
parameter WRITECHID0_WID = 1 ;
parameter WRITECHID1_WID = 1 ;
parameter MAXWRITEID_WID = 1 ;
parameter BLANKWRITEID0_WID = 0 ;
parameter BLANKWRITEID1_WID = 0 ;
parameter READCHID0_WID = 1 ;
parameter READCHID1_WID = 1 ;
parameter WR_SLAVEID0_WID = 2 ;
parameter WR_SLAVEID1_WID = 2 ;
parameter WR_SLAVEID2_WID = 2 ;
parameter WR_SLAVEID3_WID = 2 ;
parameter WR_SLAVEID4_WID = 2 ;
parameter WR_SLAVEID5_WID = 2 ;
parameter RD_SLAVEID0_WID = 2 ;
parameter RD_SLAVEID1_WID = 2 ;
parameter RD_SLAVEID2_WID = 2 ;
parameter RD_SLAVEID3_WID = 2 ;
parameter RD_SLAVEID4_WID = 2 ;
parameter RD_SLAVEID5_WID = 2 ;
parameter SELMASTER0_WID = 1 ;
parameter SELMASTER1_WID = 1 ;
parameter SELMASTER2_WID = 1 ;
parameter SELMASTER3_WID = 1 ;
parameter SELMASTER4_WID = 1 ;
parameter SELMASTER5_WID = 1 ;
parameter SELWRITE0_WID = 1 ;
parameter SELREAD0_WID = 1 ;
parameter SELWRITE1_WID = 1 ;
parameter SELREAD1_WID = 1 ;
parameter SELWRITE2_WID = 1 ;
parameter SELREAD2_WID = 1 ;
parameter SELWRITE3_WID = 1 ;
parameter SELREAD3_WID = 1 ;
parameter SELWRITE4_WID = 1 ;
parameter SELREAD4_WID = 1 ;
parameter SELWRITE5_WID = 1 ;
parameter SELREAD5_WID = 1 ;
parameter SLAVE_WRITEID0_WID = 1 ;
parameter SLAVE_WRITEID1_WID = 1 ;
parameter SLAVE_WRITEID2_WID = 1 ;
parameter SLAVE_WRITEID3_WID = 1 ;
parameter SLAVE_WRITEID4_WID = 1 ;
parameter SLAVE_WRITEID5_WID = 1 ;
parameter SLAVE_READID0_WID = 1 ;
parameter SLAVE_READID1_WID = 1 ;
parameter SLAVE_READID2_WID = 1 ;
parameter SLAVE_READID3_WID = 1 ;
parameter SLAVE_READID4_WID = 1 ;
parameter SLAVE_READID5_WID = 1 ;

    //Write Channel SlaveInterface
    //_______________________________________________________________
    
    //For Master 0 :: ARM
    //Write address channel
//Disable_id_port
    wire   [ADDR_WID-1:0]          AWADDR_ARM;
    wire   [AWLEN_WID-1:0]         AWLEN_ARM;
    wire   [AWSIZE_WID-1:0]        AWSIZE_ARM;  
    wire   [AWBURST_WID-1:0]       AWBURST_ARM; 
    wire   [AWLOCK_WID-1:0]        AWLOCK_ARM;  
//Disable_cache_port
//Disable_protect_port

    wire   AWVALID_ARM; 
    wire  AWREADY_2_ARM; 

    //Write data channel
//Disable_id_port
    wire   [BUS_WID-1:0]           WDATA_ARM;   
    wire   [WSTRB_WID-1:0]         WSTRB_ARM;   
    wire   WLAST_ARM;   
    wire   WVALID_ARM;  
    wire  WREADY_2_ARM;  

    //Write response channel
//Disable_id_port
    wire   [BRESP_WID-1:0]        BRESP_2_ARM;   
    wire   BVALID_2_ARM;  
    wire    BREADY_ARM;  
    //_______________________________________________________________
 
 


    //Write Channel MasterInterface
    //_______________________________________________________________
   
    // For slave 0 :: DDRCtrl
    //__________________________________________________
    //Write address channel
    wire   [WR_SLAVEID0_WID-1:0]AWID_2_DDRCtrl;    
    wire   [ADDR_WID-1:0]     AWADDR_2_DDRCtrl;
    wire   [AWLEN_WID-1:0]    AWLEN_2_DDRCtrl;
    wire   [AWSIZE_WID-1:0]   AWSIZE_2_DDRCtrl;  
    wire   [AWBURST_WID-1:0]  AWBURST_2_DDRCtrl; 
//Disable_lock_port
//Disable_cache_port
//Disable_protect_port

    wire   AWVALID_2_DDRCtrl; 
    wire    AWREADY_DDRCtrl; 
    
    //Write data channel
    wire   [WR_SLAVEID0_WID-1:0]WID_2_DDRCtrl;     
    wire   [BUS_WID-1:0]      WDATA_2_DDRCtrl;   
    wire   [WSTRB_WID-1:0]    WSTRB_2_DDRCtrl;   
    wire   WLAST_2_DDRCtrl;   
    wire   WVALID_2_DDRCtrl;  
    wire    WREADY_DDRCtrl; 

    //Write response channel
    wire   [WR_SLAVEID0_WID-1:0] BID_DDRCtrl;     
    wire   [BRESP_WID-1:0]     BRESP_DDRCtrl;   
    wire   BVALID_DDRCtrl;  
    wire  BREADY_2_DDRCtrl;  
   
    // For slave 1 :: APB0
    //__________________________________________________
    //Write address channel
    wire   [WR_SLAVEID1_WID-1:0]AWID_2_APB0;    
    wire   [ADDR_WID-1:0]     AWADDR_2_APB0;
    wire   [AWLEN_WID-1:0]    AWLEN_2_APB0;
    wire   [AWSIZE_WID-1:0]   AWSIZE_2_APB0;  
    wire   [AWBURST_WID-1:0]  AWBURST_2_APB0; 
//Disable_lock_port
//Disable_cache_port
//Disable_protect_port

    wire   AWVALID_2_APB0; 
    wire    AWREADY_APB0; 
    
    //Write data channel
    wire   [WR_SLAVEID1_WID-1:0]WID_2_APB0;     
    wire   [BUS_WID-1:0]      WDATA_2_APB0;   
//Disable_WSTRB_port
    wire   WLAST_2_APB0;   
    wire   WVALID_2_APB0;  
    wire    WREADY_APB0; 

    //Write response channel
    wire   [WR_SLAVEID1_WID-1:0] BID_APB0;     
    wire   [BRESP_WID-1:0]     BRESP_APB0;   
    wire   BVALID_APB0;  
    wire  BREADY_2_APB0;  
   
    // For slave 2 :: APB1
    //__________________________________________________
    //Write address channel
    wire   [WR_SLAVEID2_WID-1:0]AWID_2_APB1;    
    wire   [ADDR_WID-1:0]     AWADDR_2_APB1;
    wire   [AWLEN_WID-1:0]    AWLEN_2_APB1;
    wire   [AWSIZE_WID-1:0]   AWSIZE_2_APB1;  
    wire   [AWBURST_WID-1:0]  AWBURST_2_APB1; 
//Disable_lock_port
//Disable_cache_port
//Disable_protect_port

    wire   AWVALID_2_APB1; 
    wire    AWREADY_APB1; 
    
    //Write data channel
    wire   [WR_SLAVEID2_WID-1:0]WID_2_APB1;     
    wire   [BUS_WID-1:0]      WDATA_2_APB1;   
//Disable_WSTRB_port
    wire   WLAST_2_APB1;   
    wire   WVALID_2_APB1;  
    wire    WREADY_APB1; 

    //Write response channel
    wire   [WR_SLAVEID2_WID-1:0] BID_APB1;     
    wire   [BRESP_WID-1:0]     BRESP_APB1;   
    wire   BVALID_APB1;  
    wire  BREADY_2_APB1;  
   
    // For slave 3 :: SMC
    //__________________________________________________
    //Write address channel
    wire   [WR_SLAVEID3_WID-1:0]AWID_2_SMC;    
    wire   [ADDR_WID-1:0]     AWADDR_2_SMC;
    wire   [AWLEN_WID-1:0]    AWLEN_2_SMC;
    wire   [AWSIZE_WID-1:0]   AWSIZE_2_SMC;  
    wire   [AWBURST_WID-1:0]  AWBURST_2_SMC; 
//Disable_lock_port
//Disable_cache_port
//Disable_protect_port

    wire   AWVALID_2_SMC; 
    wire    AWREADY_SMC; 
    
    //Write data channel
    wire   [WR_SLAVEID3_WID-1:0]WID_2_SMC;     
    wire   [BUS_WID-1:0]      WDATA_2_SMC;   
    wire   [WSTRB_WID-1:0]    WSTRB_2_SMC;   
    wire   WLAST_2_SMC;   
    wire   WVALID_2_SMC;  
    wire    WREADY_SMC; 

    //Write response channel
    wire   [WR_SLAVEID3_WID-1:0] BID_SMC;     
    wire   [BRESP_WID-1:0]     BRESP_SMC;   
    wire   BVALID_SMC;  
    wire  BREADY_2_SMC;  
   
    // For slave 4 :: IntSRAM
    //__________________________________________________
    //Write address channel
    wire   [WR_SLAVEID4_WID-1:0]AWID_2_IntSRAM;    
    wire   [ADDR_WID-1:0]     AWADDR_2_IntSRAM;
    wire   [AWLEN_WID-1:0]    AWLEN_2_IntSRAM;
    wire   [AWSIZE_WID-1:0]   AWSIZE_2_IntSRAM;  
    wire   [AWBURST_WID-1:0]  AWBURST_2_IntSRAM; 
//Disable_lock_port
//Disable_cache_port
//Disable_protect_port

    wire   AWVALID_2_IntSRAM; 
    wire    AWREADY_IntSRAM; 
    
    //Write data channel
    wire   [WR_SLAVEID4_WID-1:0]WID_2_IntSRAM;     
    wire   [BUS_WID-1:0]      WDATA_2_IntSRAM;   
    wire   [WSTRB_WID-1:0]    WSTRB_2_IntSRAM;   
    wire   WLAST_2_IntSRAM;   
    wire   WVALID_2_IntSRAM;  
    wire    WREADY_IntSRAM; 

    //Write response channel
    wire   [WR_SLAVEID4_WID-1:0] BID_IntSRAM;     
    wire   [BRESP_WID-1:0]     BRESP_IntSRAM;   
    wire   BVALID_IntSRAM;  
    wire  BREADY_2_IntSRAM;  



    //Read Channel SlaveInterface
    //_______________________________________________________________
    
    //For Master 0 :: ARM
    //Read address channel
//Disable_id_port
    wire   [ADDR_WID-1:0]     ARADDR_ARM;
    wire   [ARLEN_WID-1:0]    ARLEN_ARM;
    wire   [ARSIZE_WID-1:0]   ARSIZE_ARM;  
    wire   [ARBURST_WID-1:0]  ARBURST_ARM; 
    wire   [ARLOCK_WID-1:0]   ARLOCK_ARM;  
//Disable_cache_port
//Disable_protect_port

    wire   ARVALID_ARM; 
    wire   ARREADY_2_ARM; 

    //Read data channel
//Disable_id_port
    wire   [BRESP_WID-1:0]   RRESP_2_ARM;   
    wire   [BUS_WID-1:0]     RDATA_2_ARM;
    wire   RLAST_2_ARM;
    wire   RVALID_2_ARM;  
    wire   RREADY_ARM;  
 
    
    //For Master 1 :: VideoEnC
    //Read address channel
//Disable_id_port
    wire   [ADDR_WID-1:0]     ARADDR_VideoEnC;
    wire   [ARLEN_WID-1:0]    ARLEN_VideoEnC;
    wire   [ARSIZE_WID-1:0]   ARSIZE_VideoEnC;  
    wire   [ARBURST_WID-1:0]  ARBURST_VideoEnC; 
//Disable_lock_port
//Disable_cache_port
//Disable_protect_port

    wire   ARVALID_VideoEnC; 
    wire   ARREADY_2_VideoEnC; 

    //Read data channel
//Disable_id_port
    wire   [BRESP_WID-1:0]   RRESP_2_VideoEnC;   
    wire   [BUS_WID-1:0]     RDATA_2_VideoEnC;
    wire   RLAST_2_VideoEnC;
    wire   RVALID_2_VideoEnC;  
    wire   RREADY_VideoEnC;  
 


    //MasterInterface
    //_______________________________________________________________
    
    // For slave 0
    //__________________________________________________

    // Read address channel
    wire   [RD_SLAVEID0_WID-1:0]ARID_2_DDRCtrl;    
    wire   [ADDR_WID-1:0]     ARADDR_2_DDRCtrl;
    wire   [ARLEN_WID-1:0]    ARLEN_2_DDRCtrl;
    wire   [ARSIZE_WID-1:0]   ARSIZE_2_DDRCtrl;  
    wire   [ARBURST_WID-1:0]  ARBURST_2_DDRCtrl; 
//Disable_lock_port
//Disable_cache_port
//Disable_protect_port

    wire   ARVALID_2_DDRCtrl; 
    wire   ARREADY_DDRCtrl; 
    

    //Read data channel
    wire   [RD_SLAVEID0_WID-1:0] RID_DDRCtrl;     
    wire   [RRESP_WID-1:0]     RRESP_DDRCtrl;   
    wire   [BUS_WID-1:0]       RDATA_DDRCtrl;  
    wire   RLAST_DDRCtrl;  
    wire   RVALID_DDRCtrl;  
    wire  RREADY_2_DDRCtrl;  

    
    // For slave 1
    //__________________________________________________

    // Read address channel
    wire   [RD_SLAVEID1_WID-1:0]ARID_2_APB0;    
    wire   [ADDR_WID-1:0]     ARADDR_2_APB0;
    wire   [ARLEN_WID-1:0]    ARLEN_2_APB0;
    wire   [ARSIZE_WID-1:0]   ARSIZE_2_APB0;  
    wire   [ARBURST_WID-1:0]  ARBURST_2_APB0; 
//Disable_lock_port
//Disable_cache_port
//Disable_protect_port

    wire   ARVALID_2_APB0; 
    wire   ARREADY_APB0; 
    

    //Read data channel
    wire   [RD_SLAVEID1_WID-1:0] RID_APB0;     
    wire   [RRESP_WID-1:0]     RRESP_APB0;   
    wire   [BUS_WID-1:0]       RDATA_APB0;  
    wire   RLAST_APB0;  
    wire   RVALID_APB0;  
    wire  RREADY_2_APB0;  

    
    // For slave 2
    //__________________________________________________

    // Read address channel
    wire   [RD_SLAVEID2_WID-1:0]ARID_2_APB1;    
    wire   [ADDR_WID-1:0]     ARADDR_2_APB1;
    wire   [ARLEN_WID-1:0]    ARLEN_2_APB1;
    wire   [ARSIZE_WID-1:0]   ARSIZE_2_APB1;  
    wire   [ARBURST_WID-1:0]  ARBURST_2_APB1; 
//Disable_lock_port
//Disable_cache_port
//Disable_protect_port

    wire   ARVALID_2_APB1; 
    wire   ARREADY_APB1; 
    

    //Read data channel
    wire   [RD_SLAVEID2_WID-1:0] RID_APB1;     
    wire   [RRESP_WID-1:0]     RRESP_APB1;   
    wire   [BUS_WID-1:0]       RDATA_APB1;  
    wire   RLAST_APB1;  
    wire   RVALID_APB1;  
    wire  RREADY_2_APB1;  

    
    // For slave 3
    //__________________________________________________

    // Read address channel
    wire   [RD_SLAVEID3_WID-1:0]ARID_2_SMC;    
    wire   [ADDR_WID-1:0]     ARADDR_2_SMC;
    wire   [ARLEN_WID-1:0]    ARLEN_2_SMC;
    wire   [ARSIZE_WID-1:0]   ARSIZE_2_SMC;  
    wire   [ARBURST_WID-1:0]  ARBURST_2_SMC; 
//Disable_lock_port
//Disable_cache_port
//Disable_protect_port

    wire   ARVALID_2_SMC; 
    wire   ARREADY_SMC; 
    

    //Read data channel
    wire   [RD_SLAVEID3_WID-1:0] RID_SMC;     
    wire   [RRESP_WID-1:0]     RRESP_SMC;   
    wire   [BUS_WID-1:0]       RDATA_SMC;  
    wire   RLAST_SMC;  
    wire   RVALID_SMC;  
    wire  RREADY_2_SMC;  

    
    // For slave 4
    //__________________________________________________

    // Read address channel
    wire   [RD_SLAVEID4_WID-1:0]ARID_2_IntSRAM;    
    wire   [ADDR_WID-1:0]     ARADDR_2_IntSRAM;
    wire   [ARLEN_WID-1:0]    ARLEN_2_IntSRAM;
    wire   [ARSIZE_WID-1:0]   ARSIZE_2_IntSRAM;  
    wire   [ARBURST_WID-1:0]  ARBURST_2_IntSRAM; 
//Disable_lock_port
//Disable_cache_port
//Disable_protect_port

    wire   ARVALID_2_IntSRAM; 
    wire   ARREADY_IntSRAM; 
    

    //Read data channel
    wire   [RD_SLAVEID4_WID-1:0] RID_IntSRAM;     
    wire   [RRESP_WID-1:0]     RRESP_IntSRAM;   
    wire   [BUS_WID-1:0]       RDATA_IntSRAM;  
    wire   RLAST_IntSRAM;  
    wire   RVALID_IntSRAM;  
    wire  RREADY_2_IntSRAM;  

    //_______________________________________________________________


SBUS SBUS(

//MASTER channel signal
    //_______________________________________________________________
    //For Master 0 :: ARM
    //Write address channel

//Disable_id_port
    .AWADDR_ARM  (AWADDR_ARM  ),
    .AWLEN_ARM   (AWLEN_ARM   ),
    .AWSIZE_ARM  (AWSIZE_ARM  ),
    .AWBURST_ARM (AWBURST_ARM ),
    .AWLOCK_ARM  (AWLOCK_ARM  ),
//Disable_cache_port
//Disable_protect_port

    .AWVALID_ARM (AWVALID_ARM ),
    .AWREADY_2_ARM   (AWREADY_2_ARM ),

    //Write data channel
//Disable_id_port
    .WDATA_ARM       (WDATA_ARM   ),
    .WSTRB_ARM       (WSTRB_ARM   ),
    .WLAST_ARM       (WLAST_ARM   ),
    .WVALID_ARM      (WVALID_ARM  ),
    .WREADY_2_ARM    (WREADY_2_ARM),

    //Write response channel
//Disable_id_port
    .BRESP_2_ARM     (BRESP_2_ARM   ),
    .BVALID_2_ARM    (BVALID_2_ARM  ),
    .BREADY_ARM      (BREADY_ARM    ),


    //Read address channel
//Disable_id_port
    .ARADDR_ARM  (ARADDR_ARM  ),
    .ARLEN_ARM   (ARLEN_ARM   ),
    .ARSIZE_ARM  (ARSIZE_ARM  ),
    .ARBURST_ARM (ARBURST_ARM ),
    .ARLOCK_ARM  (ARLOCK_ARM  ),
//Disable_cache_port
//Disable_protect_port

    .ARVALID_ARM (ARVALID_ARM ),
    .ARREADY_2_ARM (ARREADY_2_ARM ),

    //Read data channel
//Disable_id_port
    .RRESP_2_ARM   (RRESP_2_ARM   ),
    .RDATA_2_ARM   (RDATA_2_ARM   ),
    .RLAST_2_ARM   (RLAST_2_ARM   ),
    .RVALID_2_ARM  (RVALID_2_ARM  ),
    .RREADY_ARM  (RREADY_ARM  ),

    //_______________________________________________________________
    //For Master 1 :: VideoEnC
    //Write address channel

    //Read address channel
//Disable_id_port
    .ARADDR_VideoEnC  (ARADDR_VideoEnC  ),
    .ARLEN_VideoEnC   (ARLEN_VideoEnC   ),
    .ARSIZE_VideoEnC  (ARSIZE_VideoEnC  ),
    .ARBURST_VideoEnC (ARBURST_VideoEnC ),
//Disable_lock_port
//Disable_cache_port
//Disable_protect_port

    .ARVALID_VideoEnC (ARVALID_VideoEnC ),
    .ARREADY_2_VideoEnC (ARREADY_2_VideoEnC ),

    //Read data channel
//Disable_id_port
    .RRESP_2_VideoEnC   (RRESP_2_VideoEnC   ),
    .RDATA_2_VideoEnC   (RDATA_2_VideoEnC   ),
    .RLAST_2_VideoEnC   (RLAST_2_VideoEnC   ),
    .RVALID_2_VideoEnC  (RVALID_2_VideoEnC  ),
    .RREADY_VideoEnC  (RREADY_VideoEnC  ),


//SLAVE channel signal
    //_______________________________________________________________
    //For Slave 0 :: DDRCtrl
    //Write address channel
    .AWID_2_DDRCtrl    (AWID_2_DDRCtrl    ),
    .AWADDR_2_DDRCtrl  (AWADDR_2_DDRCtrl  ),
    .AWLEN_2_DDRCtrl   (AWLEN_2_DDRCtrl   ),
    .AWSIZE_2_DDRCtrl  (AWSIZE_2_DDRCtrl  ),
    .AWBURST_2_DDRCtrl (AWBURST_2_DDRCtrl ),
//Disable_lock_port
//Disable_cache_port
//Disable_protect_port
    .AWVALID_2_DDRCtrl (AWVALID_2_DDRCtrl ),
    .AWREADY_DDRCtrl (AWREADY_DDRCtrl ),

    //Write data channel
    .WID_2_DDRCtrl     (WID_2_DDRCtrl     ),
    .WDATA_2_DDRCtrl   (WDATA_2_DDRCtrl   ),
    .WSTRB_2_DDRCtrl   (WSTRB_2_DDRCtrl   ),
    .WLAST_2_DDRCtrl   (WLAST_2_DDRCtrl   ),
    .WVALID_2_DDRCtrl  (WVALID_2_DDRCtrl  ),
    .WREADY_DDRCtrl  (WREADY_DDRCtrl  ),

    //Write response channel
    .BID_DDRCtrl     (BID_DDRCtrl     ),
    .BRESP_DDRCtrl   (BRESP_DDRCtrl   ),
    .BVALID_DDRCtrl  (BVALID_DDRCtrl  ),
    .BREADY_2_DDRCtrl  (BREADY_2_DDRCtrl  ),

    //Read channel signal
    .ARID_2_DDRCtrl    (ARID_2_DDRCtrl    ),
    .ARADDR_2_DDRCtrl  (ARADDR_2_DDRCtrl  ),
    .ARLEN_2_DDRCtrl   (ARLEN_2_DDRCtrl   ),
    .ARSIZE_2_DDRCtrl  (ARSIZE_2_DDRCtrl  ),
    .ARBURST_2_DDRCtrl (ARBURST_2_DDRCtrl ),
//Disable_lock_port
//Disable_cache_port
//Disable_protect_port

    .ARVALID_2_DDRCtrl (ARVALID_2_DDRCtrl ),
    .ARREADY_DDRCtrl   (ARREADY_DDRCtrl ),

    //Read data channel
    .RID_DDRCtrl       (RID_DDRCtrl     ),
    .RRESP_DDRCtrl     (RRESP_DDRCtrl   ),
    .RDATA_DDRCtrl     (RDATA_DDRCtrl  ),
    .RLAST_DDRCtrl     (RLAST_DDRCtrl  ),
    .RVALID_DDRCtrl    (RVALID_DDRCtrl  ),
    .RREADY_2_DDRCtrl  (RREADY_2_DDRCtrl  ),
    //_______________________________________________________________
    //For Slave 1 :: APB0
    //Write address channel
    .AWID_2_APB0    (AWID_2_APB0    ),
    .AWADDR_2_APB0  (AWADDR_2_APB0  ),
    .AWLEN_2_APB0   (AWLEN_2_APB0   ),
    .AWSIZE_2_APB0  (AWSIZE_2_APB0  ),
    .AWBURST_2_APB0 (AWBURST_2_APB0 ),
//Disable_lock_port
//Disable_cache_port
//Disable_protect_port
    .AWVALID_2_APB0 (AWVALID_2_APB0 ),
    .AWREADY_APB0 (AWREADY_APB0 ),

    //Write data channel
    .WID_2_APB0     (WID_2_APB0     ),
    .WDATA_2_APB0   (WDATA_2_APB0   ),
//Disable_WSTRB_port
    .WLAST_2_APB0   (WLAST_2_APB0   ),
    .WVALID_2_APB0  (WVALID_2_APB0  ),
    .WREADY_APB0  (WREADY_APB0  ),

    //Write response channel
    .BID_APB0     (BID_APB0     ),
    .BRESP_APB0   (BRESP_APB0   ),
    .BVALID_APB0  (BVALID_APB0  ),
    .BREADY_2_APB0  (BREADY_2_APB0  ),

    //Read channel signal
    .ARID_2_APB0    (ARID_2_APB0    ),
    .ARADDR_2_APB0  (ARADDR_2_APB0  ),
    .ARLEN_2_APB0   (ARLEN_2_APB0   ),
    .ARSIZE_2_APB0  (ARSIZE_2_APB0  ),
    .ARBURST_2_APB0 (ARBURST_2_APB0 ),
//Disable_lock_port
//Disable_cache_port
//Disable_protect_port

    .ARVALID_2_APB0 (ARVALID_2_APB0 ),
    .ARREADY_APB0   (ARREADY_APB0 ),

    //Read data channel
    .RID_APB0       (RID_APB0     ),
    .RRESP_APB0     (RRESP_APB0   ),
    .RDATA_APB0     (RDATA_APB0  ),
    .RLAST_APB0     (RLAST_APB0  ),
    .RVALID_APB0    (RVALID_APB0  ),
    .RREADY_2_APB0  (RREADY_2_APB0  ),
    //_______________________________________________________________
    //For Slave 2 :: APB1
    //Write address channel
    .AWID_2_APB1    (AWID_2_APB1    ),
    .AWADDR_2_APB1  (AWADDR_2_APB1  ),
    .AWLEN_2_APB1   (AWLEN_2_APB1   ),
    .AWSIZE_2_APB1  (AWSIZE_2_APB1  ),
    .AWBURST_2_APB1 (AWBURST_2_APB1 ),
//Disable_lock_port
//Disable_cache_port
//Disable_protect_port
    .AWVALID_2_APB1 (AWVALID_2_APB1 ),
    .AWREADY_APB1 (AWREADY_APB1 ),

    //Write data channel
    .WID_2_APB1     (WID_2_APB1     ),
    .WDATA_2_APB1   (WDATA_2_APB1   ),
//Disable_WSTRB_port
    .WLAST_2_APB1   (WLAST_2_APB1   ),
    .WVALID_2_APB1  (WVALID_2_APB1  ),
    .WREADY_APB1  (WREADY_APB1  ),

    //Write response channel
    .BID_APB1     (BID_APB1     ),
    .BRESP_APB1   (BRESP_APB1   ),
    .BVALID_APB1  (BVALID_APB1  ),
    .BREADY_2_APB1  (BREADY_2_APB1  ),

    //Read channel signal
    .ARID_2_APB1    (ARID_2_APB1    ),
    .ARADDR_2_APB1  (ARADDR_2_APB1  ),
    .ARLEN_2_APB1   (ARLEN_2_APB1   ),
    .ARSIZE_2_APB1  (ARSIZE_2_APB1  ),
    .ARBURST_2_APB1 (ARBURST_2_APB1 ),
//Disable_lock_port
//Disable_cache_port
//Disable_protect_port

    .ARVALID_2_APB1 (ARVALID_2_APB1 ),
    .ARREADY_APB1   (ARREADY_APB1 ),

    //Read data channel
    .RID_APB1       (RID_APB1     ),
    .RRESP_APB1     (RRESP_APB1   ),
    .RDATA_APB1     (RDATA_APB1  ),
    .RLAST_APB1     (RLAST_APB1  ),
    .RVALID_APB1    (RVALID_APB1  ),
    .RREADY_2_APB1  (RREADY_2_APB1  ),
    //_______________________________________________________________
    //For Slave 3 :: SMC
    //Write address channel
    .AWID_2_SMC    (AWID_2_SMC    ),
    .AWADDR_2_SMC  (AWADDR_2_SMC  ),
    .AWLEN_2_SMC   (AWLEN_2_SMC   ),
    .AWSIZE_2_SMC  (AWSIZE_2_SMC  ),
    .AWBURST_2_SMC (AWBURST_2_SMC ),
//Disable_lock_port
//Disable_cache_port
//Disable_protect_port
    .AWVALID_2_SMC (AWVALID_2_SMC ),
    .AWREADY_SMC (AWREADY_SMC ),

    //Write data channel
    .WID_2_SMC     (WID_2_SMC     ),
    .WDATA_2_SMC   (WDATA_2_SMC   ),
    .WSTRB_2_SMC   (WSTRB_2_SMC   ),
    .WLAST_2_SMC   (WLAST_2_SMC   ),
    .WVALID_2_SMC  (WVALID_2_SMC  ),
    .WREADY_SMC  (WREADY_SMC  ),

    //Write response channel
    .BID_SMC     (BID_SMC     ),
    .BRESP_SMC   (BRESP_SMC   ),
    .BVALID_SMC  (BVALID_SMC  ),
    .BREADY_2_SMC  (BREADY_2_SMC  ),

    //Read channel signal
    .ARID_2_SMC    (ARID_2_SMC    ),
    .ARADDR_2_SMC  (ARADDR_2_SMC  ),
    .ARLEN_2_SMC   (ARLEN_2_SMC   ),
    .ARSIZE_2_SMC  (ARSIZE_2_SMC  ),
    .ARBURST_2_SMC (ARBURST_2_SMC ),
//Disable_lock_port
//Disable_cache_port
//Disable_protect_port

    .ARVALID_2_SMC (ARVALID_2_SMC ),
    .ARREADY_SMC   (ARREADY_SMC ),

    //Read data channel
    .RID_SMC       (RID_SMC     ),
    .RRESP_SMC     (RRESP_SMC   ),
    .RDATA_SMC     (RDATA_SMC  ),
    .RLAST_SMC     (RLAST_SMC  ),
    .RVALID_SMC    (RVALID_SMC  ),
    .RREADY_2_SMC  (RREADY_2_SMC  ),
    //_______________________________________________________________
    //For Slave 4 :: IntSRAM
    //Write address channel
    .AWID_2_IntSRAM    (AWID_2_IntSRAM    ),
    .AWADDR_2_IntSRAM  (AWADDR_2_IntSRAM  ),
    .AWLEN_2_IntSRAM   (AWLEN_2_IntSRAM   ),
    .AWSIZE_2_IntSRAM  (AWSIZE_2_IntSRAM  ),
    .AWBURST_2_IntSRAM (AWBURST_2_IntSRAM ),
//Disable_lock_port
//Disable_cache_port
//Disable_protect_port
    .AWVALID_2_IntSRAM (AWVALID_2_IntSRAM ),
    .AWREADY_IntSRAM (AWREADY_IntSRAM ),

    //Write data channel
    .WID_2_IntSRAM     (WID_2_IntSRAM     ),
    .WDATA_2_IntSRAM   (WDATA_2_IntSRAM   ),
    .WSTRB_2_IntSRAM   (WSTRB_2_IntSRAM   ),
    .WLAST_2_IntSRAM   (WLAST_2_IntSRAM   ),
    .WVALID_2_IntSRAM  (WVALID_2_IntSRAM  ),
    .WREADY_IntSRAM  (WREADY_IntSRAM  ),

    //Write response channel
    .BID_IntSRAM     (BID_IntSRAM     ),
    .BRESP_IntSRAM   (BRESP_IntSRAM   ),
    .BVALID_IntSRAM  (BVALID_IntSRAM  ),
    .BREADY_2_IntSRAM  (BREADY_2_IntSRAM  ),

    //Read channel signal
    .ARID_2_IntSRAM    (ARID_2_IntSRAM    ),
    .ARADDR_2_IntSRAM  (ARADDR_2_IntSRAM  ),
    .ARLEN_2_IntSRAM   (ARLEN_2_IntSRAM   ),
    .ARSIZE_2_IntSRAM  (ARSIZE_2_IntSRAM  ),
    .ARBURST_2_IntSRAM (ARBURST_2_IntSRAM ),
//Disable_lock_port
//Disable_cache_port
//Disable_protect_port

    .ARVALID_2_IntSRAM (ARVALID_2_IntSRAM ),
    .ARREADY_IntSRAM   (ARREADY_IntSRAM ),

    //Read data channel
    .RID_IntSRAM       (RID_IntSRAM     ),
    .RRESP_IntSRAM     (RRESP_IntSRAM   ),
    .RDATA_IntSRAM     (RDATA_IntSRAM  ),
    .RLAST_IntSRAM     (RLAST_IntSRAM  ),
    .RVALID_IntSRAM    (RVALID_IntSRAM  ),
    .RREADY_2_IntSRAM  (RREADY_2_IntSRAM  ),

    .ACLK    (ACLK),
    .ARESETn (ARESETn)
);

endmodule
