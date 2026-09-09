
//STATE00_START
//Slave Lock signals were generated
//Slave module ??  (Lock signal)  
//_____________________________________________________________________

    wire   [SELMASTER??_WID-1:0]CtlDataWrite2Lock??;
    wire   [SELMASTER??_WID-1:0]CtlDataRead2Lock??;     
    wire   Lock2wrmi??;
    wire   UnLock2wrmi??;
    wire   UnLock2rdmi??;
    wire   Lock2rdmi?? ;
    wire   [SELMASTER??_WID-1:0]LockPort2wrmi??;
    wire   [SELMASTER??_WID-1:0]LockPort2rdmi??;

    //Syn modified
    wire   ReadIntEmptyWrmi??2Rdmi??;
    wire   DataCntEmptyRdmi??2Wrmi??;

//STATE_END
//_____________________________________________________________________



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

   // Write Address Channel
   .AWID(AWIDm?NAME?2si??    ),
   .AWADDR(AWADDRm?NAME?2si??  ),
   .AWLEN(AWLENm?NAME?2si??   ),
   .AWSIZE(AWSIZEm?NAME?2si??  ),
   .AWBURST(AWBURSTm?NAME?2si?? ),
   .AWLOCK(AWLOCKm?NAME?2si??  ),
   .AWCACHE(AWCACHEm?NAME?2si?? ),
   .AWPROT(AWPROTm?NAME?2si??  ),
   .AWUSER({32{1'b0}}),
   .AWVALID(AWVALIDm?NAME?2si?? ),
   .AWREADY(AWREADYsi??2m?NAME? ),

   // Write Channel
   .WID         (WIDm?NAME?2si??     ),
   .WLAST       (WLASTm?NAME?2si??   ),
   .WDATA       (WDATAm?NAME?2si??   ),
   .WSTRB       (WSTRBm?NAME?2si??   ),
   .WUSER       ({32{1'b0}}),
   .WVALID      (WVALIDm?NAME?2si??  ),
   .WREADY      (WREADYsi??2m?NAME?  ),

   // Write Response Channel
   .BID          (BIDsi??2m?NAME?     ),
   .BRESP        (BRESPsi??2m?NAME?   ),   
   .BUSER        ({32{1'b0}}),
   .BVALID       (BVALIDsi??2m?NAME?  ),
   .BREADY       (BREADYm?NAME?2si??  ),

   // Read Address Channel
   .ARID         (ARIDm?NAME?2si??    ),
   .ARADDR       (ARADDRm?NAME?2si??  ),
   .ARLEN        (ARLENm?NAME?2si??   ),
   .ARSIZE       (ARSIZEm?NAME?2si??  ),
   .ARBURST      (ARBURSTm?NAME?2si?? ),
   .ARLOCK       (ARLOCKm?NAME?2si??  ),
   .ARCACHE      (ARCACHEm?NAME?2si?? ),
   .ARPROT       (ARPROTm?NAME?2si??  ),
   .ARUSER       ({32{1'b0}}),
   .ARVALID      (ARVALIDm?NAME?2si?? ),
   .ARREADY      (ARREADYsi??2m?NAME? ),

   // Read Channel
   .RID          (RIDsi??2m?NAME?     ),
   .RLAST        (RLASTsi??2m?NAME?   ),
   .RDATA        (RDATAsi??2m?NAME?   ),
   .RRESP        (RRESPsi??2m?NAME?   ),
   .RUSER        ({32{1'b0}}),
   .RVALID       (RVALIDsi??2m?NAME?  ),
   .RREADY       (RREADYm?NAME?2si??  ),

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
   .ACLK(ACLK),
   .ARESETn(ARESETn),

   // Write Address Channel
   .AWID(AWIDmi??2s?NAME?    ),
   .AWADDR(AWADDRmi??2s?NAME?  ),
   .AWLEN(AWLENmi??2s?NAME?   ),
   .AWSIZE(AWSIZEmi??2s?NAME?  ),
   .AWBURST(AWBURSTmi??2s?NAME? ),
   .AWLOCK(AWLOCKmi??2s?NAME?  ),
   .AWCACHE(AWCACHEmi??2s?NAME? ),
   .AWPROT(AWPROTmi??2s?NAME?  ),
   .AWUSER({32{1'b0}}),
   .AWVALID(AWVALIDmi??2s?NAME? ),
   .AWREADY(AWREADYs?NAME?2mi?? ),

   // Write Channel
   .WID         (WIDmi??2s?NAME?     ),
   .WLAST       (WLASTmi??2s?NAME?   ),
   .WDATA       (WDATAmi??2s?NAME?   ),
   .WSTRB       (WSTRBmi??2s?NAME?   ),
   .WUSER       ({32{1'b0}}),
   .WVALID      (WVALIDmi??2s?NAME?  ),
   .WREADY      (WREADYs?NAME?2mi??  ),

   // Write Response Channel
   .BID          (BIDs?NAME?2mi??     ),
   .BRESP        (BRESPs?NAME?2mi??   ),   
   .BUSER        ({32{1'b0}}),
   .BVALID       (BVALIDs?NAME?2mi??  ),
   .BREADY       (BREADYmi??2s?NAME?  ),

   // Read Address Channel
   .ARID         (ARIDmi??2s?NAME?    ),
   .ARADDR       (ARADDRmi??2s?NAME?  ),
   .ARLEN        (ARLENmi??2s?NAME?   ),
   .ARSIZE       (ARSIZEmi??2s?NAME?  ),
   .ARBURST      (ARBURSTmi??2s?NAME? ),
   .ARLOCK       (ARLOCKmi??2s?NAME?  ),
   .ARCACHE      (ARCACHEmi??2s?NAME? ),
   .ARPROT       (ARPROTmi??2s?NAME?  ),
   .ARUSER       ({32{1'b0}}),
   .ARVALID      (ARVALIDmi??2s?NAME? ),
   .ARREADY      (ARREADYs?NAME?2mi?? ),

   // Read Channel
   .RID          (RIDs?NAME?2mi??     ),
   .RLAST        (RLASTs?NAME?2mi??   ),
   .RDATA        (RDATAs?NAME?2mi??   ),
   .RRESP        (RRESPs?NAME?2mi??   ),
   .RUSER        ({32{1'b0}}),
   .RVALID       (RVALIDs?NAME?2mi??  ),
   .RREADY       (RREADYmi??2s?NAME?  ),

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
    .AWIDm??2si??    (AWIDm?NAME?2si??    ),
    .AWADDRm??2si??  (AWADDRm?NAME?2si??  ),
    .AWLENm??2si??   (AWLENm?NAME?2si??   ),
    .AWSIZEm??2si??  (AWSIZEm?NAME?2si??  ),
    .AWBURSTm??2si?? (AWBURSTm?NAME?2si?? ),
    .AWLOCKm??2si??  (AWLOCKm?NAME?2si??  ),
    .AWCACHEm??2si?? (AWCACHEm?NAME?2si?? ),
    .AWPROTm??2si??  (AWPROTm?NAME?2si??  ),

    .AWVALIDm??2si?? (AWVALIDm?NAME?2si?? ),
    .AWREADYsi??2m?? (AWREADYsi??2m?NAME? ),

    //Write data channel
    .WIDm??2si??     (WIDm?NAME?2si??     ),
    .WDATAm??2si??   (WDATAm?NAME?2si??   ),
    .WSTRBm??2si??   (WSTRBm?NAME?2si??   ),
    .WLASTm??2si??   (WLASTm?NAME?2si??   ),
    .WVALIDm??2si??  (WVALIDm?NAME?2si??  ),
    .WREADYsi??2m??  (WREADYsi??2m?NAME?  ),

    //Write response channel
    .BIDsi??2m??     (BIDsi??2m?NAME?     ),
    .BRESPsi??2m??   (BRESPsi??2m?NAME?   ),
    .BVALIDsi??2m??  (BVALIDsi??2m?NAME?  ),
    .BREADYm??2si??  (BREADYm?NAME?2si??  ),
//STATE_END

//STATE03_START
    //_______________________________________________________________
    //For Slave ??
    //Write address channel
    .AWIDmi??2s??    (AWIDmi??2s?NAME?    ),
    .AWADDRmi??2s??  (AWADDRmi??2s?NAME?  ),
    .AWLENmi??2s??   (AWLENmi??2s?NAME?   ),
    .AWSIZEmi??2s??  (AWSIZEmi??2s?NAME?  ),
    .AWBURSTmi??2s?? (AWBURSTmi??2s?NAME? ),
    .AWLOCKmi??2s??  (AWLOCKmi??2s?NAME?  ),
    .AWCACHEmi??2s?? (AWCACHEmi??2s?NAME? ),
    .AWPROTmi??2s??  (AWPROTmi??2s?NAME?  ),

    .AWVALIDmi??2s?? (AWVALIDmi??2s?NAME? ),
    .AWREADYs??2mi?? (AWREADYs?NAME?2mi?? ),

    //Write data channel
    .WIDmi??2s??     (WIDmi??2s?NAME?     ),
    .WDATAmi??2s??   (WDATAmi??2s?NAME?   ),
    .WSTRBmi??2s??   (WSTRBmi??2s?NAME?   ),
    .WLASTmi??2s??   (WLASTmi??2s?NAME?   ),
    .WVALIDmi??2s??  (WVALIDmi??2s?NAME?  ),
    .WREADYs??2mi??  (WREADYs?NAME?2mi??  ),

    //Write response channel
    .BIDs??2mi??     (BIDs?NAME?2mi??     ),
    .BRESPs??2mi??   (BRESPs?NAME?2mi??   ),
    .BVALIDs??2mi??  (BVALIDs?NAME?2mi??  ),
    .BREADYmi??2s??  (BREADYmi??2s?NAME?  ),

//STATE_END

//STATE04_START
    //_______________________________________________________________
    //For Slave ?? (lock control signal)

    .Lock2wrmi??          (Lock2wrmi??      ),
    .Lock2rdmi??          (Lock2rdmi??      ),
    .UnLock2wrmi??        (UnLock2wrmi??    ),
    .UnLock2rdmi??        (UnLock2rdmi??    ),
    .ARVALIDmi??2s??      (ARVALIDmi??2s?NAME?   ),
    .LockPort2wrmi??      (LockPort2wrmi??  ),
    .ReadIntEmptyWrmi??2Rdmi??     (ReadIntEmptyWrmi??2Rdmi??     ),
    .DataCntEmptyRdmi??2Wrmi??     (DataCntEmptyRdmi??2Wrmi??     ),    
    .CtlDataWrite2Lock??          (CtlDataWrite2Lock??          ),
    
//STATE_END
    
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
    .ARIDm??2si??    (ARIDm?NAME?2si??    ),
    .ARADDRm??2si??  (ARADDRm?NAME?2si??  ),
    .ARLENm??2si??   (ARLENm?NAME?2si??   ),
    .ARSIZEm??2si??  (ARSIZEm?NAME?2si??  ),
    .ARBURSTm??2si?? (ARBURSTm?NAME?2si?? ),
    .ARLOCKm??2si??  (ARLOCKm?NAME?2si??  ),
    .ARCACHEm??2si?? (ARCACHEm?NAME?2si?? ),
    .ARPROTm??2si??  (ARPROTm?NAME?2si??  ),

    .ARVALIDm??2si?? (ARVALIDm?NAME?2si?? ),
    .ARREADYsi??2m?? (ARREADYsi??2m?NAME? ),

    //Read data channel
    .RIDsi??2m??     (RIDsi??2m?NAME?     ),
    .RRESPsi??2m??   (RRESPsi??2m?NAME?   ),
    .RDATAsi??2m??   (RDATAsi??2m?NAME?   ),
    .RLASTsi??2m??   (RLASTsi??2m?NAME?   ),
    .RVALIDsi??2m??  (RVALIDsi??2m?NAME?  ),
    .RREADYm??2si??  (RREADYm?NAME?2si??  ),
//STATE_END

//STATE07_START
    //_______________________________________________________________
    //For Slave ??
    //Read address channel
    .ARIDmi??2s??    (ARIDmi??2s?NAME?    ),
    .ARADDRmi??2s??  (ARADDRmi??2s?NAME?  ),
    .ARLENmi??2s??   (ARLENmi??2s?NAME?   ),
    .ARSIZEmi??2s??  (ARSIZEmi??2s?NAME?  ),
    .ARBURSTmi??2s?? (ARBURSTmi??2s?NAME? ),
    .ARLOCKmi??2s??  (ARLOCKmi??2s?NAME?  ),
    .ARCACHEmi??2s?? (ARCACHEmi??2s?NAME? ),
    .ARPROTmi??2s??  (ARPROTmi??2s?NAME?  ),

    .ARVALIDmi??2s?? (ARVALIDmi??2s?NAME? ),
    .ARREADYs??2mi?? (ARREADYs?NAME?2mi?? ),

    //Read data channel
    .RIDs??2mi??     (RIDs?NAME?2mi??     ),
    .RRESPs??2mi??   (RRESPs?NAME?2mi??   ),
    .RDATAs??2mi??   (RDATAs?NAME?2mi??   ),
    .RLASTs??2mi??   (RLASTs?NAME?2mi??   ),
    .RVALIDs??2mi??  (RVALIDs?NAME?2mi??  ),
    .RREADYmi??2s??  (RREADYmi??2s?NAME?  ),
//STATE_END

//STATE08_START
    //_______________________________________________________________
    //For Slave ?? (lock control signal)

    .Lock2rdmi??          (Lock2rdmi??          ),
    .Lock2wrmi??          (Lock2wrmi??          ),
    .UnLock2rdmi??        (UnLock2rdmi??        ),
    .UnLock2wrmi??        (UnLock2wrmi??        ),
    .AWVALIDmi??2s??      (AWVALIDmi??2s?NAME?  ),
    .LockPort2rdmi??      (LockPort2rdmi??      ),
    .ReadIntEmptyWrmi??2Rdmi??    (ReadIntEmptyWrmi??2Rdmi??    ),
    .DataCntEmptyRdmi??2Wrmi??    (DataCntEmptyRdmi??2Wrmi??    ),
    .CtlDataRead2Lock??           (CtlDataRead2Lock??           ),

//STATE_END

    .ACLK    (ACLK),
    .ARESETn (ARESETn)
);

//STATE09_START
    //_______________________________________________________________
    //For Slave ?? (lock control signal)

assign  LockPort2wrmi?? = CtlDataRead2Lock??; 
assign  LockPort2rdmi?? = CtlDataWrite2Lock??;

//STATE_END


endmodule
//Code_END
