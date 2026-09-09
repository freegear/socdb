
//version short name
//STATE00_START
//Slave Lock signals were generated
//Slave module ??  (Lock signal)  
//_____________________________________________________________________

    wire   [SELWRITE??_WID-1:0]CtlDataWrite2Lock??;
    wire   [SELREAD??_WID-1:0]CtlDataRead2Lock??;     
    wire   Lock2wrmi??;
    wire   UnLock2wrmi??;
    wire   UnLock2rdmi??;
    wire   Lock2rdmi?? ;
    //wire   [SELWRITE??_WID:0]LockPort2wrmi??;
    //wire   [SELREAD??_WID:0]LockPort2rdmi??;
    reg   [SELWRITE??_WID:0]LockPort2wrmi??;
    reg   [SELREAD??_WID:0]LockPort2rdmi??;

    //Syn modified
    wire   ReadIntEmptyWrmi??2Rdmi??;
    wire   DataCntEmptyRdmi??2Wrmi??;

//STATE_END
//_____________________________________________________________________



  parameter STRB_WIDTH = BUS_WID/8; // WSTRB width
  parameter STRB_MAX   = STRB_WIDTH; // WSTRB max index

//STATE_START
// Protocal Checker for master ?NAME?
//_____________________________________________________________________

// synopsys translate_off
`ifdef  ASSERT_ON

AxiPC 
#( 
    .DATA_WIDTH(BUS_WID) ,
    .ID_WIDTH(WRITECHID??_WID ),
    .RID_WIDTH(READCHID??_WID)
 )
?NAME?_AxiPC
  (
   // Global Signals
   .ACLK(ACLK),
   .ARESETn(ARESETn),

//PART_A
   // Write Address Channel
//ENABLE_AW_ID
   .AWID        (AWID_?NAME?    ),
   .AWADDR      (AWADDR_?NAME?  ),
   .AWLEN       (AWLEN_?NAME?   ),
   .AWSIZE      (AWSIZE_?NAME?  ),
   .AWBURST     (AWBURST_?NAME? ),
//ENABLE_LOCK
   .AWLOCK      (AWLOCK_?NAME?  ),
//ENABLE_CACHE
   .AWCACHE     (AWCACHE_?NAME? ),
//ENABLE_PROT
   .AWPROT      (AWPROT_?NAME?  ),
   .AWUSER      ({32{1'b0}}),
   .AWVALID     (AWVALID_?NAME? ),
   .AWREADY     (AWREADY_2_?NAME? ),

   // Write Channel
//ENABLE_WID_ID
   .WID         (WID_?NAME?     ),
   .WLAST       (WLAST_?NAME?   ),
   .WDATA       (WDATA_?NAME?   ),
//ENABLE_WSTRB
   .WSTRB       (WSTRB_?NAME?   ),
   .WUSER       ({32{1'b0}}),
   .WVALID      (WVALID_?NAME?  ),
   .WREADY      (WREADY_2_?NAME?  ),

   // Write Response Channel
//ENABLE_BID_ID
   .BID          (BID_2_?NAME?     ),
   .BRESP        (BRESP_2_?NAME?   ),   
   .BUSER        ({32{1'b0}}),
   .BVALID       (BVALID_2_?NAME?  ),
   .BREADY       (BREADY_?NAME?  ),

//PART_B
   // Read Address Channel
//ENABLE_AR_ID
   .ARID         (ARID_?NAME?    ),
   .ARADDR       (ARADDR_?NAME?  ),
   .ARLEN        (ARLEN_?NAME?   ),
   .ARSIZE       (ARSIZE_?NAME?  ),
   .ARBURST      (ARBURST_?NAME? ),
//ENABLE_LOCK
   .ARLOCK       (ARLOCK_?NAME?  ),
//ENABLE_CACHE
   .ARCACHE      (ARCACHE_?NAME? ),
//ENABLE_PROT
   .ARPROT       (ARPROT_?NAME?  ),
   .ARUSER       ({32{1'b0}}),
   .ARVALID      (ARVALID_?NAME? ),
   .ARREADY      (ARREADY_2_?NAME? ),

   // Read Channel
//ENABLE_RID_ID
   .RID          (RID_2_?NAME?     ),
   .RLAST        (RLAST_2_?NAME?   ),
   .RDATA        (RDATA_2_?NAME?   ),
   .RRESP        (RRESP_2_?NAME?   ),
   .RUSER        ({32{1'b0}}),
   .RVALID       (RVALID_2_?NAME?  ),
   .RREADY       (RREADY_?NAME?  ),

//PART_C
   // Low power interface
   .CACTIVE      (1'b1),
   .CSYSREQ      (1'b1),
   .CSYSACK      (1'b1)   
   );

`endif // `ifdef ASSERT_ON
// synopsys translate_on
//STATE_END

//STATE_START
// Protocal Checker for slave ?NAME?
//_____________________________________________________________________
// synopsys translate_off
`ifdef  ASSERT_ON

AxiPC 
#( 
    .DATA_WIDTH(BUS_WID) ,
    .ID_WIDTH(WR_SLAVEID??_WID ),
    .RID_WIDTH(RD_SLAVEID??_WID)
 )
?NAME?_AxiPC
  (
   // Global Signals
   .ACLK        (ACLK),
   .ARESETn     (ARESETn),

   // Write Address Channel
   .AWID        (AWID_2_?NAME?    ),
   .AWADDR      (AWADDR_2_?NAME?  ),
   .AWLEN       (AWLEN_2_?NAME?   ),
   .AWSIZE      (AWSIZE_2_?NAME?  ),
   .AWBURST     (AWBURST_2_?NAME? ),
//ENABLE_LOCK
   .AWLOCK      (AWLOCK_2_?NAME?  ),
//ENABLE_CACHE
   .AWCACHE     (AWCACHE_2_?NAME? ),
//ENABLE_PROT
   .AWPROT      (AWPROT_2_?NAME?  ),
   .AWUSER      ({32{1'b0}}),
   .AWVALID     (AWVALID_2_?NAME? ),
   .AWREADY     (AWREADY_?NAME? ),

   // Write Channel
   .WID         (WID_2_?NAME?     ),
   .WLAST       (WLAST_2_?NAME?   ),
   .WDATA       (WDATA_2_?NAME?   ),
//ENABLE_WSTRB
   .WSTRB       (WSTRB_2_?NAME?   ),
   .WUSER       ({32{1'b0}}),
   .WVALID      (WVALID_2_?NAME?  ),
   .WREADY      (WREADY_?NAME?  ),

   // Write Response Channel
   .BID          (BID_?NAME?     ),
   .BRESP        (BRESP_?NAME?   ),   
   .BUSER        ({32{1'b0}}),
   .BVALID       (BVALID_?NAME?  ),
   .BREADY       (BREADY_2_?NAME?  ),

   // Read Address Channel
   .ARID         (ARID_2_?NAME?    ),
   .ARADDR       (ARADDR_2_?NAME?  ),
   .ARLEN        (ARLEN_2_?NAME?   ),
   .ARSIZE       (ARSIZE_2_?NAME?  ),
   .ARBURST      (ARBURST_2_?NAME? ),
//ENABLE_LOCK
   .ARLOCK       (ARLOCK_2_?NAME?  ),
//ENABLE_CACHE
   .ARCACHE      (ARCACHE_2_?NAME? ),
//ENABLE_PROT
   .ARPROT       (ARPROT_2_?NAME?  ),
   .ARUSER       ({32{1'b0}}),
   .ARVALID      (ARVALID_2_?NAME? ),
   .ARREADY      (ARREADY_?NAME? ),

   // Read Channel
   .RID          (RID_?NAME?     ),
   .RLAST        (RLAST_?NAME?   ),
   .RDATA        (RDATA_?NAME?   ),
   .RRESP        (RRESP_?NAME?   ),
   .RUSER        ({32{1'b0}}),
   .RVALID       (RVALID_?NAME?  ),
   .RREADY       (RREADY_2_?NAME?  ),

   // Low power interface
   .CACTIVE      (1'b1),
   .CSYSREQ      (1'b1),
   .CSYSACK      (1'b1)   
   );

`endif // `ifdef ASSERT_ON
// synopsys translate_on
//STATE_END

//Write Channel 
//_____________________________________________________________________

WriteChannel 

//STATE01_START
?NAME?_WriteChannel(
//STATE_END

//STATE02_START
    //_______________________________________________________________
    //For Master ??
    //Write address channel
//ENABLE_AW_ID
    .AWIDm??2si??    (AWID_?NAME?    ),
    .AWADDRm??2si??  (AWADDR_?NAME?  ),
    .AWLENm??2si??   (AWLEN_?NAME?   ),
    .AWSIZEm??2si??  (AWSIZE_?NAME?  ),
    .AWBURSTm??2si?? (AWBURST_?NAME? ),
//ENABLE_LOCK
    .AWLOCKm??2si??  (AWLOCK_?NAME?  ),
//ENABLE_CACHE
    .AWCACHEm??2si?? (AWCACHE_?NAME? ),
//ENABLE_PROT
    .AWPROTm??2si??  (AWPROT_?NAME?  ),

    .AWVALIDm??2si?? (AWVALID_?NAME? ),
    .AWREADYsi??2m?? (AWREADY_2_?NAME? ),

    //Write data channel
//ENABLE_WID_ID
    .WIDm??2si??     (WID_?NAME?     ),
    .WDATAm??2si??   (WDATA_?NAME?   ),
//ENABLE_WSTRB
    .WSTRBm??2si??   (WSTRB_?NAME?   ),
    .WLASTm??2si??   (WLAST_?NAME?   ),
    .WVALIDm??2si??  (WVALID_?NAME?  ),
    .WREADYsi??2m??  (WREADY_2_?NAME?  ),

    //Write response channel
//ENABLE_BID_ID
    .BIDsi??2m??     (BID_2_?NAME?     ),
    .BRESPsi??2m??   (BRESP_2_?NAME?   ),
    .BVALIDsi??2m??  (BVALID_2_?NAME?  ),
    .BREADYm??2si??  (BREADY_?NAME?  ),
//END_CH
//STATE_END

//STATE03_START
    //_______________________________________________________________
    //For Slave ??
    //Write address channel
    .AWIDmi??2s??    (AWID_2_?NAME?_merge    ),
    .AWADDRmi??2s??  (AWADDR_2_?NAME?_merge  ),
    .AWLENmi??2s??   (AWLEN_2_?NAME?_merge   ),
    .AWSIZEmi??2s??  (AWSIZE_2_?NAME?_merge  ),
    .AWBURSTmi??2s?? (AWBURST_2_?NAME?_merge ),
//ENABLE_LOCK
    .AWLOCKmi??2s??  (AWLOCK_2_?NAME?_merge  ),
//ENABLE_CACHE
    .AWCACHEmi??2s?? (AWCACHE_2_?NAME?_merge ),
//ENABLE_PROT
    .AWPROTmi??2s??  (AWPROT_2_?NAME?_merge  ),

    .AWVALIDmi??2s?? (AWVALID_2_?NAME?_merge ),
    .AWREADYs??2mi?? (AWREADY_?NAME?_merge ),

    //Write data channel
    .WIDmi??2s??     (WID_2_?NAME?_merge     ),
    .WDATAmi??2s??   (WDATA_2_?NAME?_merge   ),
//ENABLE_WSTRB
    .WSTRBmi??2s??   (WSTRB_2_?NAME?_merge   ),
    .WLASTmi??2s??   (WLAST_2_?NAME?_merge   ),
    .WVALIDmi??2s??  (WVALID_2_?NAME?_merge  ),
    .WREADYs??2mi??  (WREADY_?NAME?_merge  ),

    //Write response channel
    .BIDs??2mi??     (BID_?NAME?_merge     ),
    .BRESPs??2mi??   (BRESP_?NAME?_merge   ),
    .BVALIDs??2mi??  (BVALID_?NAME?_merge  ),
    .BREADYmi??2s??  (BREADY_2_?NAME?_merge  ),
//END_CH
//STATE_END

//STATE04_START
    //_______________________________________________________________
    //For Slave ?? (lock control signal)

    .Lock2wrmi??          (Lock2wrmi??      ),
    .Lock2rdmi??          (Lock2rdmi??      ),
    .UnLock2wrmi??        (UnLock2wrmi??    ),
    .UnLock2rdmi??        (UnLock2rdmi??    ),
    .ARVALIDmi??2s??      (ARVALID_2_?NAME?   ),
    .LockPort2wrmi??      (LockPort2wrmi??  ),
    .ReadIntEmptyWrmi??2Rdmi??     (ReadIntEmptyWrmi??2Rdmi??     ),
    .DataCntEmptyRdmi??2Wrmi??     (DataCntEmptyRdmi??2Wrmi??     ),    
    .CtlDataWrite2Lock??          (CtlDataWrite2Lock??          ),
    
//STATE_END
    
    .SelMAP1 (SelMAP1),
    .ACLK    (ACLK),
    .ARESETn (ARESETn)
);


//Read Channel 
//_____________________________________________________________________

ReadChannel 
//STATE05_START
?NAME?_ReadChannel (
//STATE_END

//STATE06_START
    //_______________________________________________________________
    //For Master ??
    //Read address channel
//ENABLE_AR_ID
    .ARIDm??2si??    (ARID_?NAME?    ),
    .ARADDRm??2si??  (ARADDR_?NAME?  ),
    .ARLENm??2si??   (ARLEN_?NAME?   ),
    .ARSIZEm??2si??  (ARSIZE_?NAME?  ),
    .ARBURSTm??2si?? (ARBURST_?NAME? ),
//ENABLE_LOCK
    .ARLOCKm??2si??  (ARLOCK_?NAME?  ),
//ENABLE_CACHE
    .ARCACHEm??2si?? (ARCACHE_?NAME? ),
//ENABLE_PROT
    .ARPROTm??2si??  (ARPROT_?NAME?  ),

    .ARVALIDm??2si?? (ARVALID_?NAME? ),
    .ARREADYsi??2m?? (ARREADY_2_?NAME? ),

    //Read data channel
//ENABLE_RID_ID
    .RIDsi??2m??     (RID_2_?NAME?     ),
    .RRESPsi??2m??   (RRESP_2_?NAME?   ),
    .RDATAsi??2m??   (RDATA_2_?NAME?   ),
    .RLASTsi??2m??   (RLAST_2_?NAME?   ),
    .RVALIDsi??2m??  (RVALID_2_?NAME?  ),
    .RREADYm??2si??  (RREADY_?NAME?  ),
//END_CH
//STATE_END

//STATE07_START
    //_______________________________________________________________
    //For Slave ??
    //Read address channel
    .ARIDmi??2s??    (ARID_2_?NAME?_merge),
    .ARADDRmi??2s??  (ARADDR_2_?NAME?_merge),
    .ARLENmi??2s??   (ARLEN_2_?NAME?_merge),
    .ARSIZEmi??2s??  (ARSIZE_2_?NAME?_merge),
    .ARBURSTmi??2s?? (ARBURST_2_?NAME?_merge),
//ENABLE_LOCK
    .ARLOCKmi??2s??  (ARLOCK_2_?NAME?_merge),
//ENABLE_CACHE
    .ARCACHEmi??2s?? (ARCACHE_2_?NAME?_merge),
//ENABLE_PROT
    .ARPROTmi??2s??  (ARPROT_2_?NAME?_merge),
    .ARVALIDmi??2s?? (ARVALID_2_?NAME?_merge),
    .ARREADYs??2mi?? (ARREADY_?NAME?_merge),

    //Read data channel
    .RIDs??2mi??     (RID_?NAME?_merge),
    .RRESPs??2mi??   (RRESP_?NAME?_merge),
    .RDATAs??2mi??   (RDATA_?NAME?_merge),
    .RLASTs??2mi??   (RLAST_?NAME?_merge),
    .RVALIDs??2mi??  (RVALID_?NAME?_merge),
    .RREADYmi??2s??  (RREADY_2_?NAME?_merge),
//END_CH
//STATE_END

//STATE08_START
    //_______________________________________________________________
    //For Slave ?? (lock control signal)

    .Lock2rdmi??          (Lock2rdmi??          ),
    .Lock2wrmi??          (Lock2wrmi??          ),
    .UnLock2rdmi??        (UnLock2rdmi??        ),
    .UnLock2wrmi??        (UnLock2wrmi??        ),
    .AWVALIDmi??2s??      (AWVALID_2_?NAME?  ),
    .LockPort2rdmi??      (LockPort2rdmi??      ),
    .ReadIntEmptyWrmi??2Rdmi??    (ReadIntEmptyWrmi??2Rdmi??    ),
    .DataCntEmptyRdmi??2Wrmi??    (DataCntEmptyRdmi??2Wrmi??    ),
    .CtlDataRead2Lock??           (CtlDataRead2Lock??           ),

//STATE_END

    .SelMAP1 (SelMAP1),
    .ACLK    (ACLK),
    .ARESETn (ARESETn)
);

//STATE09_START
    //_______________________________________________________________
    //For Slave ?? (lock control signal)

//assign  LockPort2wrmi?? = CtlDataRead2Lock??; 
//assign  LockPort2rdmi?? = CtlDataWrite2Lock??;

//STATE_END

//STATE09_START

//_______________________________________________________________
//For Slave ?? (lock control signal)
always @(CtlDataRead2Lock?? or
         LockPort2wrmi??
        )
begin
    case(CtlDataRead2Lock??)
//STATE_WIRE
        ?WID0?'d?1?:  LockPort2wrmi?? = ?WID1?'d?2?;
        default:  LockPort2wrmi?? = ;
    endcase
end
//STATE_END

//STATE09_START

//_______________________________________________________________
//For Slave ?? (lock control signal)
always @(CtlDataWrite2Lock?? or 
         LockPort2rdmi??
        )
begin
    case(CtlDataWrite2Lock??)
//STATE_WIRE
        ?WID0?'d?1?:  LockPort2rdmi?? = ?WID1?'d?2?;
        default:  LockPort2rdmi?? = ;
    endcase
end
//STATE_END

//STATE10_START

?NAME?_ChMerge
?NAME?_ChMerge
(
   // Global Signals
   .ACLK(ACLK),
   .ARESETn(ARESETn),

// =================================================================
//  Slave connection
// -----------------------------------------------------------------
    // Write Address Channel
   .AWID        (AWID_2_?NAME?    ),
   .AWADDR      (AWADDR_2_?NAME?  ),
   .AWLEN       (AWLEN_2_?NAME?   ),
   .AWSIZE      (AWSIZE_2_?NAME?  ),
   .AWBURST     (AWBURST_2_?NAME? ),
//ENABLE_LOCK
   .AWLOCK      (AWLOCK_2_?NAME?  ),
//ENABLE_CACHE
   .AWCACHE     (AWCACHE_2_?NAME? ),
//ENABLE_PROT
   .AWPROT      (AWPROT_2_?NAME?  ),
   .AWVALID     (AWVALID_2_?NAME? ),
   .AWREADY     (AWREADY_?NAME? ),

    // Write Data Channel
   .WID         (WID_2_?NAME?     ),
   .WDATA       (WDATA_2_?NAME?   ),
//ENABLE_WSTRB
   .WSTRB       (WSTRB_2_?NAME?   ),
   .WLAST       (WLAST_2_?NAME?   ),
   .WVALID      (WVALID_2_?NAME?  ),
   .WREADY      (WREADY_?NAME?  ),

    // Write Response Channel
   .BID          (BID_?NAME?     ),
   .BRESP        (BRESP_?NAME?   ),   
   .BVALID       (BVALID_?NAME?  ),
   .BREADY       (BREADY_2_?NAME?  ),

    // Read Address Channel
//PART_A
   .ARID         (ARID_2_?NAME?    ),
   .ARADDR       (ARADDR_2_?NAME?  ),
   .ARLEN        (ARLEN_2_?NAME?   ),
   .ARSIZE       (ARSIZE_2_?NAME?  ),
   .ARBURST      (ARBURST_2_?NAME? ),
//ENABLE_LOCK
   .ARLOCK       (ARLOCK_2_?NAME?  ),
//ENABLE_CACHE
   .ARCACHE      (ARCACHE_2_?NAME? ),
//ENABLE_PROT
   .ARPROT       (ARPROT_2_?NAME?  ),
   .ARVALID      (ARVALID_2_?NAME? ),
   .ARREADY      (ARREADY_?NAME? ),

   // Read Channel
   .RID          (RID_?NAME?     ),
   .RLAST        (RLAST_?NAME?   ),
   .RDATA        (RDATA_?NAME?   ),
   .RRESP        (RRESP_?NAME?   ),
   .RVALID       (RVALID_?NAME?  ),
   .RREADY       (RREADY_2_?NAME?  ),

// =================================================================
//  Bus connection
// -----------------------------------------------------------------

	// Write Address Channel
//PART_B
    .AWID2merge     (AWID_2_?NAME?_merge    ),
    .AWADDR2merge   (AWADDR_2_?NAME?_merge  ),
    .AWLEN2merge    (AWLEN_2_?NAME?_merge   ),
    .AWSIZE2merge   (AWSIZE_2_?NAME?_merge  ),
    .AWBURST2merge  (AWBURST_2_?NAME?_merge ),
//ENABLE_LOCK
    .AWLOCK2merge   (AWLOCK_2_?NAME?_merge  ),
//ENABLE_CACHE
    .AWCACHE2merge  (AWCACHE_2_?NAME?_merge ),
//ENABLE_PROT
    .AWPROT2merge   (AWPROT_2_?NAME?_merge  ),
    .AWVALID2merge  (AWVALID_2_?NAME?_merge ),
    .AWREADY2merge  (AWREADY_?NAME?_merge ),

	// Write Data Channel
    .WID2merge      (WID_2_?NAME?_merge     ),
    .WDATA2merge    (WDATA_2_?NAME?_merge   ),
//ENABLE_WSTRB
    .WSTRB2merge    (WSTRB_2_?NAME?_merge   ),
    .WLAST2merge    (WLAST_2_?NAME?_merge   ),
    .WVALID2merge   (WVALID_2_?NAME?_merge  ),
    .WREADY2merge   (WREADY_?NAME?_merge  ),


	// Write Response Channel
//PART_C
    .BID2merge      (BID_?NAME?_merge     ),
    .BRESP2merge    (BRESP_?NAME?_merge   ),
    .BVALID2merge   (BVALID_?NAME?_merge  ),
    .BREADY2merge   (BREADY_2_?NAME?_merge  ),

	// Read Address Channel
    .ARID2merge     (ARID_2_?NAME?_merge),
    .ARADDR2merge   (ARADDR_2_?NAME?_merge),
    .ARLEN2merge    (ARLEN_2_?NAME?_merge),
    .ARSIZE2merge   (ARSIZE_2_?NAME?_merge),
    .ARBURST2merge  (ARBURST_2_?NAME?_merge),
//ENABLE_LOCK
    .ARLOCK2merge   (ARLOCK_2_?NAME?_merge),
//ENABLE_CACHE
    .ARCACHE2merge  (ARCACHE_2_?NAME?_merge),
//ENABLE_PROT
    .ARPROT2merge   (ARPROT_2_?NAME?_merge),
	.ARVALID2merge  (ARVALID_2_?NAME?_merge),
	.ARREADY2merge  (ARREADY_?NAME?_merge),

	// Read Data Channel
	.RID2merge      (RID_?NAME?_merge),
	.RDATA2merge    (RDATA_?NAME?_merge),
	.RRESP2merge    (RRESP_?NAME?_merge),
	.RLAST2merge    (RLAST_?NAME?_merge),
	.RVALID2merge   (RVALID_?NAME?_merge),
	.RREADY2merge   (RREADY_2_?NAME?_merge)
);
//STATE_END

endmodule
//Code_END
