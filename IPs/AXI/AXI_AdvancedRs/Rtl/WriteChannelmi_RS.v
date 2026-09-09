
module  WriteChannelmi_RS(
    
    //Global signal
    ACLK    ,
    ARESETn ,

    //For slave 
    //Write address channel
    AWIDmi2s    ,
    AWADDRmi2s  ,
    AWLENmi2s   ,
    AWSIZEmi2s  ,
    AWBURSTmi2s ,
    AWLOCKmi2s  ,
    AWCACHEmi2s ,
    AWPROTmi2s  ,

    AWVALIDmi2s ,
    AWREADYs2mi ,

    //Write data channel
    WIDmi2s     ,
    WDATAmi2s   ,
    WSTRBmi2s   ,
    WLASTmi2s   ,
    WVALIDmi2s  ,
    WREADYs2mi  ,

    //Write response channel
    BIDs2mi     ,
    BRESPs2mi   ,
    BVALIDs2mi  ,
    BREADYmi2s  ,

    //Slave interface signal

    //Write address channel
    //Master0
    AWIDsi02mi    ,
    AWADDRsi02mi  ,
    AWLENsi02mi   ,
    AWSIZEsi02mi  ,
    AWBURSTsi02mi ,
    AWLOCKsi02mi  ,
    AWCACHEsi02mi ,
    AWPROTsi02mi  ,

    //Master1
    AWIDsi12mi    ,
    AWADDRsi12mi  ,
    AWLENsi12mi   ,
    AWSIZEsi12mi  ,
    AWBURSTsi12mi ,
    AWLOCKsi12mi  ,
    AWCACHEsi12mi ,
    AWPROTsi12mi  ,

    //Master2
    AWIDsi22mi    ,
    AWADDRsi22mi  ,
    AWLENsi22mi   ,
    AWSIZEsi22mi  ,
    AWBURSTsi22mi ,
    AWLOCKsi22mi  ,
    AWCACHEsi22mi ,
    AWPROTsi22mi  ,

    //Master3
    AWIDsi32mi    ,
    AWADDRsi32mi  ,
    AWLENsi32mi   ,
    AWSIZEsi32mi  ,
    AWBURSTsi32mi ,
    AWLOCKsi32mi  ,
    AWCACHEsi32mi ,
    AWPROTsi32mi  ,

    //Master 0/1/2/3
    AWVALIDsi2mi  ,

    AWREADYmi2si  ,

    //Write data channel
    //Master 0
    WIDsi02mi   ,     
    WDATAsi02mi ,   
    WSTRBsi02mi ,   

    //Master 1
    WIDsi12mi   ,     
    WDATAsi12mi ,   
    WSTRBsi12mi ,   

    //Master 2
    WIDsi22mi   ,     
    WDATAsi22mi ,   
    WSTRBsi22mi ,   

    //Master 3
    WIDsi32mi   ,     
    WDATAsi32mi ,   
    WSTRBsi32mi ,   

    //Master 0/1/2/3
    WLASTsi2mi   ,
    WVALIDsi2mi  ,

    //output 1port
    WREADYmi2si  ,

    //Write response channel
    BIDmi2si     ,
    BRESPmi2si   ,
    BVALIDmi2si  ,

    BREADYsi2mi,

    //Lock control
    Lock2Wrmi,
    UnLock2Wrmi,

    Lock2Rdmi,
    UnLock2Rdmi,

    ARVALID,

    LockPort,
    ReadIntEmptyWrmi2Rdmi,
    DataCntEmptyRdmi2Wrmi,
    CtlDataWrite2Lock

    );
`include "Def.v"

    input   ACLK;
    input   ARESETn;

    // For slave 
    // 2s (Slave)
    output   [(ID_WID+MASTER_WID-1):0]       AWIDmi2s;    
    output   [ADDR_WID-1:0]     AWADDRmi2s;
    output   [AWLEN_WID-1:0]    AWLENmi2s;
    output   [AWSIZE_WID-1:0]   AWSIZEmi2s;  
    output   [AWBURST_WID-1:0]  AWBURSTmi2s; 
    output   [AWLOCK_WID-1:0]   AWLOCKmi2s;  
    output   [AWCACHE_WID-1:0]  AWCACHEmi2s; 
    output   [AWPROT_WID-1:0]   AWPROTmi2s;  

    output   AWVALIDmi2s; 
    input    AWREADYs2mi; 
    

    //Write data channel
    output   [(ID_WID+MASTER_WID-1):0]       WIDmi2s;     
    output   [BUS_WID-1:0]      WDATAmi2s;   
    output   [WSTRB_WID-1:0]    WSTRBmi2s;   
    output   WLASTmi2s;   
    output   WVALIDmi2s;  
    input    WREADYs2mi; 

    //Write response channel
    input   [(ID_WID+MASTER_WID-1):0]      BIDs2mi;     
    input   [BRESP_WID-1:0]   BRESPs2mi;   
    input   BVALIDs2mi;  
    output  BREADYmi2s;  
    
    //From SI(slave interface)
    //M0
    input   [ID_WID-1:0]       AWIDsi02mi;    
    input   [ADDR_WID-1:0]     AWADDRsi02mi;
    input   [AWLEN_WID-1:0]    AWLENsi02mi;
    input   [AWSIZE_WID-1:0]   AWSIZEsi02mi;  
    input   [AWBURST_WID-1:0]  AWBURSTsi02mi; 
    input   [AWLOCK_WID-1:0]   AWLOCKsi02mi;  
    input   [AWCACHE_WID-1:0]  AWCACHEsi02mi; 
    input   [AWPROT_WID-1:0]   AWPROTsi02mi; 

    //M1
    input   [ID_WID-1:0]       AWIDsi12mi;    
    input   [ADDR_WID-1:0]     AWADDRsi12mi;
    input   [AWLEN_WID-1:0]    AWLENsi12mi;
    input   [AWSIZE_WID-1:0]   AWSIZEsi12mi;  
    input   [AWBURST_WID-1:0]  AWBURSTsi12mi; 
    input   [AWLOCK_WID-1:0]   AWLOCKsi12mi;  
    input   [AWCACHE_WID-1:0]  AWCACHEsi12mi; 
    input   [AWPROT_WID-1:0]   AWPROTsi12mi; 

    //M2
    input   [ID_WID-1:0]       AWIDsi22mi;    
    input   [ADDR_WID-1:0]     AWADDRsi22mi;
    input   [AWLEN_WID-1:0]    AWLENsi22mi;
    input   [AWSIZE_WID-1:0]   AWSIZEsi22mi;  
    input   [AWBURST_WID-1:0]  AWBURSTsi22mi; 
    input   [AWLOCK_WID-1:0]   AWLOCKsi22mi;  
    input   [AWCACHE_WID-1:0]  AWCACHEsi22mi; 
    input   [AWPROT_WID-1:0]   AWPROTsi22mi; 

    //M3
    input   [ID_WID-1:0]       AWIDsi32mi;    
    input   [ADDR_WID-1:0]     AWADDRsi32mi;
    input   [AWLEN_WID-1:0]    AWLENsi32mi;
    input   [AWSIZE_WID-1:0]   AWSIZEsi32mi;  
    input   [AWBURST_WID-1:0]  AWBURSTsi32mi; 
    input   [AWLOCK_WID-1:0]   AWLOCKsi32mi;  
    input   [AWCACHE_WID-1:0]  AWCACHEsi32mi; 
    input   [AWPROT_WID-1:0]   AWPROTsi32mi; 

    input   [MASTER_NUM-1:0]    AWVALIDsi2mi;
    output  [MASTER_NUM-1:0]    AWREADYmi2si;

    //Write data channel
    //Master 0
    input   [ID_WID-1:0]   WIDsi02mi;     
    input   [BUS_WID-1:0]  WDATAsi02mi;   
    input   [WSTRB_WID-1:0]WSTRBsi02mi;   

    //Master 1
    input   [ID_WID-1:0]   WIDsi12mi;     
    input   [BUS_WID-1:0]  WDATAsi12mi;   
    input   [WSTRB_WID-1:0]WSTRBsi12mi;   

    //Master 2
    input   [ID_WID-1:0]   WIDsi22mi;     
    input   [BUS_WID-1:0]  WDATAsi22mi;   
    input   [WSTRB_WID-1:0]WSTRBsi22mi;   

    //Master 3
    input   [ID_WID-1:0]   WIDsi32mi;     
    input   [BUS_WID-1:0]  WDATAsi32mi;   
    input   [WSTRB_WID-1:0]WSTRBsi32mi;   

    input   [MASTER_NUM-1:0]WLASTsi2mi;   
    input   [MASTER_NUM-1:0]WVALIDsi2mi;  
    output  [MASTER_NUM-1:0]WREADYmi2si;  

    //Write response channel
    output   [ID_WID-1:0]    BIDmi2si;     
    output   [BRESP_WID-1:0] BRESPmi2si;   
    output   [MASTER_NUM-1:0]BVALIDmi2si;  
    input    [MASTER_NUM-1:0]BREADYsi2mi;    
    //Lock signal
    input    Lock2Wrmi;
    input    UnLock2Wrmi;
    input    ARVALID;
    input    DataCntEmptyRdmi2Wrmi;
    input    [MASTER_NUM-1:0]LockPort;

    output   [MASTER_WID-1:0]CtlDataWrite2Lock;
    output   ReadIntEmptyWrmi2Rdmi;

    output   Lock2Rdmi;
    output   UnLock2Rdmi;
    //_______________________________________________________________


//_______________________________________________
//Register Slice for Address write channel

    //for regiter slince
    wire   [(ID_WID+MASTER_WID-1):0]       wAWIDmi2s;    
    wire   [ADDR_WID-1:0]     wAWADDRmi2s;
    wire   [AWLEN_WID-1:0]    wAWLENmi2s;
    wire   [AWSIZE_WID-1:0]   wAWSIZEmi2s;  
    wire   [AWBURST_WID-1:0]  wAWBURSTmi2s; 
    wire   [AWLOCK_WID-1:0]   wAWLOCKmi2s;  
    wire   [AWCACHE_WID-1:0]  wAWCACHEmi2s; 
    wire   [AWPROT_WID-1:0]   wAWPROTmi2s;  

    wire   wAWVALIDmi2s; 
    wire   wAWREADYs2mi; 

    //for regiter slince
    wire   [(ID_WID+MASTER_WID-1):0]       wWIDmi2s;     
    wire   [BUS_WID-1:0]      wWDATAmi2s;   
    wire   [WSTRB_WID-1:0]    wWSTRBmi2s;   
    wire   wWLASTmi2s;   
    wire   wWVALIDmi2s;  
    wire   wWREADYs2mi; 

    //for regiter slince
    wire   [(ID_WID+MASTER_WID-1):0]      wBIDs2mi;     
    wire   [BRESP_WID-1:0]   wBRESPs2mi;   
    wire   wBVALIDs2mi;  
    wire   wBREADYmi2s;  

//ADDRESS Write channel
AWmi_fully_registered AWmi0_fully_registered 
(
		.ACLK         (ACLK         ), 
		.ARESETn      (ARESETn      ), 

		.INFORMATION_S({wAWIDmi2s, wAWADDRmi2s, wAWLENmi2s, wAWSIZEmi2s,  wAWBURSTmi2s, 
                        wAWLOCKmi2s, wAWCACHEmi2s, wAWPROTmi2s  }),

		.VALID_S      (wAWVALIDmi2s),
		.READY_S      (wAWREADYs2mi),

		.INFORMATION_R({AWIDmi2s, AWADDRmi2s, AWLENmi2s, AWSIZEmi2s,  AWBURSTmi2s, 
                        AWLOCKmi2s, AWCACHEmi2s, AWPROTmi2s  }),

		.VALID_R      (AWVALIDmi2s),
		.READY_R      (AWREADYs2mi)
);

//Write DATA channel
WDmi_fully_registered WDmi0_fully_registered 
(
		.ACLK         (ACLK         ), 
		.ARESETn      (ARESETn      ), 
		.INFORMATION_R({WIDmi2s,WDATAmi2s,WSTRBmi2s,WLASTmi2s}),

		.VALID_R      (WVALIDmi2s),
		.READY_R      (WREADYs2mi),

		.INFORMATION_S({wWIDmi2s,wWDATAmi2s,wWSTRBmi2s,wWLASTmi2s}),

		.VALID_S      (wWVALIDmi2s),
		.READY_S      (wWREADYs2mi)
);

//Write Response channel
WRmi_fully_registered WRmi0_fully_registered 
(
		.ACLK         (ACLK         ), 
		.ARESETn      (ARESETn      ), 
		.INFORMATION_R({wBIDs2mi, wBRESPs2mi}), 

		.VALID_R      (wBVALIDs2mi),
		.READY_R      (wBREADYmi2s),
        
		.INFORMATION_S({BIDs2mi, BRESPs2mi}),

		.VALID_S      (BVALIDs2mi),
		.READY_S      (BREADYmi2s)
);

WriteChannelmi U0WriteChannelmi(
    //Global signal
    .ACLK    (ACLK    ),
    .ARESETn (ARESETn ),

    //For slave 
    //Write address channel
    .AWIDmi2s    (wAWIDmi2s    ),
    .AWADDRmi2s  (wAWADDRmi2s  ),
    .AWLENmi2s   (wAWLENmi2s   ),
    .AWSIZEmi2s  (wAWSIZEmi2s  ),
    .AWBURSTmi2s (wAWBURSTmi2s ),
    .AWLOCKmi2s  (wAWLOCKmi2s  ),
    .AWCACHEmi2s (wAWCACHEmi2s ),
    .AWPROTmi2s  (wAWPROTmi2s  ),

    .AWVALIDmi2s (wAWVALIDmi2s ),
    .AWREADYs2mi (wAWREADYs2mi ),

    //Write data channel
    .WIDmi2s     (wWIDmi2s     ),
    .WDATAmi2s   (wWDATAmi2s   ),
    .WSTRBmi2s   (wWSTRBmi2s   ),
    .WLASTmi2s   (wWLASTmi2s   ),
    .WVALIDmi2s  (wWVALIDmi2s  ),
    .WREADYs2mi  (wWREADYs2mi  ),

    //Write response channel
    .BIDs2mi     (wBIDs2mi     ),
    .BRESPs2mi   (wBRESPs2mi   ),
    .BVALIDs2mi  (wBVALIDs2mi  ),
    .BREADYmi2s  (wBREADYmi2s  ),

    //Slave interface signal

    //Write address channel
    //Master0
    .AWIDsi02mi    (AWIDsi02mi    ),
    .AWADDRsi02mi  (AWADDRsi02mi  ),
    .AWLENsi02mi   (AWLENsi02mi   ),
    .AWSIZEsi02mi  (AWSIZEsi02mi  ),
    .AWBURSTsi02mi (AWBURSTsi02mi ),
    .AWLOCKsi02mi  (AWLOCKsi02mi  ),
    .AWCACHEsi02mi (AWCACHEsi02mi ),
    .AWPROTsi02mi  (AWPROTsi02mi  ),

    //Master1
    .AWIDsi12mi    (AWIDsi12mi    ),
    .AWADDRsi12mi  (AWADDRsi12mi  ),
    .AWLENsi12mi   (AWLENsi12mi   ),
    .AWSIZEsi12mi  (AWSIZEsi12mi  ),
    .AWBURSTsi12mi (AWBURSTsi12mi ),
    .AWLOCKsi12mi  (AWLOCKsi12mi  ),
    .AWCACHEsi12mi (AWCACHEsi12mi ),
    .AWPROTsi12mi  (AWPROTsi12mi  ),

    //Master2
    .AWIDsi22mi    (AWIDsi22mi    ),
    .AWADDRsi22mi  (AWADDRsi22mi  ),
    .AWLENsi22mi   (AWLENsi22mi   ),
    .AWSIZEsi22mi  (AWSIZEsi22mi  ),
    .AWBURSTsi22mi (AWBURSTsi22mi ),
    .AWLOCKsi22mi  (AWLOCKsi22mi  ),
    .AWCACHEsi22mi (AWCACHEsi22mi ),
    .AWPROTsi22mi  (AWPROTsi22mi  ),

    //Master3
    .AWIDsi32mi    (AWIDsi32mi    ),
    .AWADDRsi32mi  (AWADDRsi32mi  ),
    .AWLENsi32mi   (AWLENsi32mi   ),
    .AWSIZEsi32mi  (AWSIZEsi32mi  ),
    .AWBURSTsi32mi (AWBURSTsi32mi ),
    .AWLOCKsi32mi  (AWLOCKsi32mi  ),
    .AWCACHEsi32mi (AWCACHEsi32mi ),
    .AWPROTsi32mi  (AWPROTsi32mi  ),

    //Master 0/1/2/3
    .AWVALIDsi2mi  (AWVALIDsi2mi  ),

    .AWREADYmi2si  (AWREADYmi2si  ),

    //Write data channel
    //Master 0
    .WIDsi02mi   (WIDsi02mi   ),     
    .WDATAsi02mi (WDATAsi02mi ),   
    .WSTRBsi02mi (WSTRBsi02mi ),   

    //Master 1
    .WIDsi12mi   (WIDsi12mi   ),     
    .WDATAsi12mi (WDATAsi12mi ),   
    .WSTRBsi12mi (WSTRBsi12mi ),   

    //Master 2
    .WIDsi22mi   (WIDsi22mi   ),     
    .WDATAsi22mi (WDATAsi22mi ),   
    .WSTRBsi22mi (WSTRBsi22mi ),   

    //Master 3
    .WIDsi32mi   (WIDsi32mi   ),     
    .WDATAsi32mi (WDATAsi32mi ),   
    .WSTRBsi32mi (WSTRBsi32mi ),   

    //Master 0/1/2/3
    .WLASTsi2mi   (WLASTsi2mi   ),
    .WVALIDsi2mi  (WVALIDsi2mi  ),

    //output 1port
    .WREADYmi2si  (WREADYmi2si  ),

    //Write response channel
    .BIDmi2si     (BIDmi2si     ),
    .BRESPmi2si   (BRESPmi2si   ),
    .BVALIDmi2si  (BVALIDmi2si  ),

    .BREADYsi2mi(BREADYsi2mi),

    //Lock control
    .Lock2Wrmi(Lock2Wrmi),
    .UnLock2Wrmi(UnLock2Wrmi),

    .Lock2Rdmi(Lock2Rdmi),
    .UnLock2Rdmi(UnLock2Rdmi),

    .ARVALID(ARVALID),

    .LockPort(LockPort),
    .ReadIntEmptyWrmi2Rdmi(ReadIntEmptyWrmi2Rdmi),
    .DataCntEmptyRdmi2Wrmi(DataCntEmptyRdmi2Wrmi),
    .CtlDataWrite2Lock    (CtlDataWrite2Lock    )
    );

endmodule

