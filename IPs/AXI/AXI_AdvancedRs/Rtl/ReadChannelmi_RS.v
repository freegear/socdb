
module  ReadChannelmi_RS(
    
    //Global signal
    ACLK    ,
    ARESETn ,

    //For slave 
    //Read address channel
    ARIDmi2s    ,
    ARADDRmi2s  ,
    ARLENmi2s   ,
    ARSIZEmi2s  ,
    ARBURSTmi2s ,
    ARLOCKmi2s  ,
    ARCACHEmi2s ,
    ARPROTmi2s  ,

    ARVALIDmi2s ,
    ARREADYs2mi ,

    //Read data channel
    RIDs2mi     ,
    RRESPs2mi   ,
    RDATAs2mi   ,
    RVALIDs2mi  ,
    RLASTs2mi   ,
    RREADYmi2s  ,


    //Slave interface signal

    //Read address channel
    //Master0
    ARIDsi02mi    ,
    ARADDRsi02mi  ,
    ARLENsi02mi   ,
    ARSIZEsi02mi  ,
    ARBURSTsi02mi ,
    ARLOCKsi02mi  ,
    ARCACHEsi02mi ,
    ARPROTsi02mi  ,

    //Master1
    ARIDsi12mi    ,
    ARADDRsi12mi  ,
    ARLENsi12mi   ,
    ARSIZEsi12mi  ,
    ARBURSTsi12mi ,
    ARLOCKsi12mi  ,
    ARCACHEsi12mi ,
    ARPROTsi12mi  ,

    //Master2
    ARIDsi22mi    ,
    ARADDRsi22mi  ,
    ARLENsi22mi   ,
    ARSIZEsi22mi  ,
    ARBURSTsi22mi ,
    ARLOCKsi22mi  ,
    ARCACHEsi22mi ,
    ARPROTsi22mi  ,

    //Master3
    ARIDsi32mi    ,
    ARADDRsi32mi  ,
    ARLENsi32mi   ,
    ARSIZEsi32mi  ,
    ARBURSTsi32mi ,
    ARLOCKsi32mi  ,
    ARCACHEsi32mi ,
    ARPROTsi32mi  ,

    //Master 0/1/2/3
    ARVALIDsi2mi  ,

    ARREADYmi2si  ,

    //Read data channel
    RIDmi2si     ,
    RRESPmi2si   ,
    RDATAmi2si   ,
    RVALIDmi2si  ,
    RLASTmi2si  ,
    RREADYsi2mi,

    //Lock Access
    Lock2Rdmi,
    UnLock2Rdmi,

    Lock2Wrmi,
    UnLock2Wrmi,

    AWVALID,

    LockPort,
    ReadIntEmptyWrmi2Rdmi,
    DataCntEmptyRdmi2Wrmi,
    CtlDataRead2Lock

);
`include "Def.v"



    input   ACLK;
    input   ARESETn;

    // For slave 
    // 2s (Slave)
    output   [(ID_WID+MASTER_WID-1):0]       ARIDmi2s;    
    output   [ADDR_WID-1:0]     ARADDRmi2s;
    output   [ARLEN_WID-1:0]    ARLENmi2s;
    output   [ARSIZE_WID-1:0]   ARSIZEmi2s;  
    output   [ARBURST_WID-1:0]  ARBURSTmi2s; 
    output   [ARLOCK_WID-1:0]   ARLOCKmi2s;  
    output   [ARCACHE_WID-1:0]  ARCACHEmi2s; 
    output   [ARPROT_WID-1:0]   ARPROTmi2s;  

    output   ARVALIDmi2s; 
    input    ARREADYs2mi; 
    
    //Read data channel
    input   [(ID_WID+MASTER_WID-1):0]      RIDs2mi;     
    input   [RRESP_WID-1:0]   RRESPs2mi;   
    input   [BUS_WID-1:0]     RDATAs2mi;
    input   RLASTs2mi;
    input   RVALIDs2mi;  
    output  RREADYmi2s;  

    //From SI(slave interface)
    //M0
    input   [ID_WID-1:0]       ARIDsi02mi;    
    input   [ADDR_WID-1:0]     ARADDRsi02mi;
    input   [ARLEN_WID-1:0]    ARLENsi02mi;
    input   [ARSIZE_WID-1:0]   ARSIZEsi02mi;  
    input   [ARBURST_WID-1:0]  ARBURSTsi02mi; 
    input   [ARLOCK_WID-1:0]   ARLOCKsi02mi;  
    input   [ARCACHE_WID-1:0]  ARCACHEsi02mi; 
    input   [ARPROT_WID-1:0]   ARPROTsi02mi; 

    //M1
    input   [ID_WID-1:0]       ARIDsi12mi;    
    input   [ADDR_WID-1:0]     ARADDRsi12mi;
    input   [ARLEN_WID-1:0]    ARLENsi12mi;
    input   [ARSIZE_WID-1:0]   ARSIZEsi12mi;  
    input   [ARBURST_WID-1:0]  ARBURSTsi12mi; 
    input   [ARLOCK_WID-1:0]   ARLOCKsi12mi;  
    input   [ARCACHE_WID-1:0]  ARCACHEsi12mi; 
    input   [ARPROT_WID-1:0]   ARPROTsi12mi; 

    //M2
    input   [ID_WID-1:0]       ARIDsi22mi;    
    input   [ADDR_WID-1:0]     ARADDRsi22mi;
    input   [ARLEN_WID-1:0]    ARLENsi22mi;
    input   [ARSIZE_WID-1:0]   ARSIZEsi22mi;  
    input   [ARBURST_WID-1:0]  ARBURSTsi22mi; 
    input   [ARLOCK_WID-1:0]   ARLOCKsi22mi;  
    input   [ARCACHE_WID-1:0]  ARCACHEsi22mi; 
    input   [ARPROT_WID-1:0]   ARPROTsi22mi; 

    //M3
    input   [ID_WID-1:0]       ARIDsi32mi;    
    input   [ADDR_WID-1:0]     ARADDRsi32mi;
    input   [ARLEN_WID-1:0]    ARLENsi32mi;
    input   [ARSIZE_WID-1:0]   ARSIZEsi32mi;  
    input   [ARBURST_WID-1:0]  ARBURSTsi32mi; 
    input   [ARLOCK_WID-1:0]   ARLOCKsi32mi;  
    input   [ARCACHE_WID-1:0]  ARCACHEsi32mi; 
    input   [ARPROT_WID-1:0]   ARPROTsi32mi; 

    input   [MASTER_NUM-1:0]    ARVALIDsi2mi;
    output  [MASTER_NUM-1:0]   ARREADYmi2si;

    //Read data channel
    output   [ID_WID-1:0]         RIDmi2si;     
    output   [RRESP_WID-1:0]      RRESPmi2si;   
    output   [BUS_WID-1:0]        RDATAmi2si;

    output   [MASTER_NUM-1:0]   RVALIDmi2si;  
    output   [MASTER_NUM-1:0]   RLASTmi2si;  
    input    [MASTER_NUM-1:0]   RREADYsi2mi;    
    

    //Lock signal
    
    input    Lock2Rdmi;
    input    UnLock2Rdmi;
    input    AWVALID;
    input    [MASTER_NUM-1:0]LockPort;
    input    ReadIntEmptyWrmi2Rdmi;

    output   [MASTER_WID-1:0]CtlDataRead2Lock;
    output   DataCntEmptyRdmi2Wrmi;

    output   Lock2Wrmi;
    output   UnLock2Wrmi;

//_______________________________________________
//Register Slice 
    // Read Address channel
    wire   [(ID_WID+MASTER_WID-1):0]       wARIDmi2s;    
    wire   [ADDR_WID-1:0]     wARADDRmi2s;
    wire   [ARLEN_WID-1:0]    wARLENmi2s;
    wire   [ARSIZE_WID-1:0]   wARSIZEmi2s;  
    wire   [ARBURST_WID-1:0]  wARBURSTmi2s; 
    wire   [ARLOCK_WID-1:0]   wARLOCKmi2s;  
    wire   [ARCACHE_WID-1:0]  wARCACHEmi2s; 
    wire   [ARPROT_WID-1:0]   wARPROTmi2s;  

    wire   wARVALIDmi2s; 
    wire   wARREADYs2mi; 

    //Read data channel
    wire    [(ID_WID+MASTER_WID-1):0]      wRIDs2mi;     
    wire    [RRESP_WID-1:0]   wRRESPs2mi;   
    wire    [BUS_WID-1:0]     wRDATAs2mi;
    wire    wRLASTs2mi;
    wire    wRVALIDs2mi;  
    wire    wRREADYmi2s;  

//ADDRESS Read channel
ARmi_fully_registered AR0_fully_registered 
(
		.ACLK         (ACLK         ), 
		.ARESETn      (ARESETn      ), 
		.INFORMATION_S({wARIDmi2s, wARADDRmi2s, wARLENmi2s, wARSIZEmi2s,  wARBURSTmi2s, wARLOCKmi2s,  
                        wARCACHEmi2s, wARPROTmi2s }),

		.VALID_S      (wARVALIDmi2s),
		.READY_S      (wARREADYs2mi),

		.INFORMATION_R({ARIDmi2s, ARADDRmi2s, ARLENmi2s, ARSIZEmi2s,  ARBURSTmi2s, ARLOCKmi2s,  
                        ARCACHEmi2s, ARPROTmi2s }),

		.VALID_R      (ARVALIDmi2s),
		.READY_R      (ARREADYs2mi)
);

//Read data channel
RDmi_fully_registered RD0_fully_registered 
(
		.ACLK         (ACLK         ), 
		.ARESETn      (ARESETn      ), 

		.INFORMATION_R({wRIDs2mi, wRRESPs2mi, wRDATAs2mi,
                        wRLASTs2mi}),

		.VALID_R      (wRVALIDs2mi),
		.READY_R      (wRREADYmi2s),

		.INFORMATION_S({RIDs2mi, RRESPs2mi, RDATAs2mi,
                        RLASTs2mi}),

		.VALID_S      (RVALIDs2mi),
		.READY_S      (RREADYmi2s)
);

ReadChannelmi U0ReadChannelmi(
    
    //Global signal
    .ACLK    (ACLK    ),
    .ARESETn (ARESETn ),

    //For slave 
    //Read address channel
    .ARIDmi2s    (wARIDmi2s    ),
    .ARADDRmi2s  (wARADDRmi2s  ),
    .ARLENmi2s   (wARLENmi2s   ),
    .ARSIZEmi2s  (wARSIZEmi2s  ),
    .ARBURSTmi2s (wARBURSTmi2s ),
    .ARLOCKmi2s  (wARLOCKmi2s  ),
    .ARCACHEmi2s (wARCACHEmi2s ),
    .ARPROTmi2s  (wARPROTmi2s  ),

    .ARVALIDmi2s (wARVALIDmi2s ),
    .ARREADYs2mi (wARREADYs2mi ),

    //Read data channel
    .RIDs2mi     (wRIDs2mi     ),
    .RRESPs2mi   (wRRESPs2mi   ),
    .RDATAs2mi   (wRDATAs2mi   ),
    .RVALIDs2mi  (wRVALIDs2mi  ),
    .RLASTs2mi   (wRLASTs2mi   ),
    .RREADYmi2s  (wRREADYmi2s  ),


    //Slave interface signal

    //Read address channel
    //Master0
    .ARIDsi02mi    (ARIDsi02mi    ),
    .ARADDRsi02mi  (ARADDRsi02mi  ),
    .ARLENsi02mi   (ARLENsi02mi   ),
    .ARSIZEsi02mi  (ARSIZEsi02mi  ),
    .ARBURSTsi02mi (ARBURSTsi02mi ),
    .ARLOCKsi02mi  (ARLOCKsi02mi  ),
    .ARCACHEsi02mi (ARCACHEsi02mi ),
    .ARPROTsi02mi  (ARPROTsi02mi  ),

    //Master1
    .ARIDsi12mi    (ARIDsi12mi    ),
    .ARADDRsi12mi  (ARADDRsi12mi  ),
    .ARLENsi12mi   (ARLENsi12mi   ),
    .ARSIZEsi12mi  (ARSIZEsi12mi  ),
    .ARBURSTsi12mi (ARBURSTsi12mi ),
    .ARLOCKsi12mi  (ARLOCKsi12mi  ),
    .ARCACHEsi12mi (ARCACHEsi12mi ),
    .ARPROTsi12mi  (ARPROTsi12mi  ),

    //Master2
    .ARIDsi22mi    (ARIDsi22mi    ),
    .ARADDRsi22mi  (ARADDRsi22mi  ),
    .ARLENsi22mi   (ARLENsi22mi   ),
    .ARSIZEsi22mi  (ARSIZEsi22mi  ),
    .ARBURSTsi22mi (ARBURSTsi22mi ),
    .ARLOCKsi22mi  (ARLOCKsi22mi  ),
    .ARCACHEsi22mi (ARCACHEsi22mi ),
    .ARPROTsi22mi  (ARPROTsi22mi  ),

    //Master3
    .ARIDsi32mi    (ARIDsi32mi    ),
    .ARADDRsi32mi  (ARADDRsi32mi  ),
    .ARLENsi32mi   (ARLENsi32mi   ),
    .ARSIZEsi32mi  (ARSIZEsi32mi  ),
    .ARBURSTsi32mi (ARBURSTsi32mi ),
    .ARLOCKsi32mi  (ARLOCKsi32mi  ),
    .ARCACHEsi32mi (ARCACHEsi32mi ),
    .ARPROTsi32mi  (ARPROTsi32mi  ),

    //Master 0/1/2/3
    .ARVALIDsi2mi  (ARVALIDsi2mi  ),

    .ARREADYmi2si  (ARREADYmi2si  ),

    //Read data channel
    .RIDmi2si     (RIDmi2si     ),
    .RRESPmi2si   (RRESPmi2si   ),
    .RDATAmi2si   (RDATAmi2si   ),
    .RVALIDmi2si  (RVALIDmi2si  ),
    .RLASTmi2si      (RLASTmi2si      ),
    .RREADYsi2mi     (RREADYsi2mi     ),

    //Lock Access
    .Lock2Rdmi       (Lock2Rdmi       ),
    .UnLock2Rdmi     (UnLock2Rdmi     ),

    .Lock2Wrmi       (Lock2Wrmi       ),
    .UnLock2Wrmi     (UnLock2Wrmi     ),

    .AWVALID         (AWVALID         ),

    .LockPort        (LockPort        ),
    .ReadIntEmptyWrmi2Rdmi(ReadIntEmptyWrmi2Rdmi),
    .DataCntEmptyRdmi2Wrmi(DataCntEmptyRdmi2Wrmi),
    .CtlDataRead2Lock     (CtlDataRead2Lock    )
);

endmodule
