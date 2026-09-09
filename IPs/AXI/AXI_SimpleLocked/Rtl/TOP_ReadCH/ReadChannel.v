
module  ReadChannel(

    ACLK    ,
    ARESETn ,

    //_______________________________________________________________
    //For Master 0
    //Read address channel
    ARIDm02si0    ,
    ARADDRm02si0  ,
    ARLENm02si0   ,
    ARSIZEm02si0  ,
    ARBURSTm02si0 ,
    ARLOCKm02si0  ,
    ARCACHEm02si0 ,
    ARPROTm02si0  ,

    ARVALIDm02si0 ,
    ARREADYsi02m0 ,

    //Read data channel
    RIDsi02m0     ,
    RRESPsi02m0   ,
    RDATAsi02m0   ,
    RLASTsi02m0   ,
    RVALIDsi02m0  ,
    RREADYm02si0  ,


    //_______________________________________________________________
    //For Master 1
    //Read address channel
    ARIDm12si1    ,
    ARADDRm12si1  ,
    ARLENm12si1   ,
    ARSIZEm12si1  ,
    ARBURSTm12si1 ,
    ARLOCKm12si1  ,
    ARCACHEm12si1 ,
    ARPROTm12si1  ,

    ARVALIDm12si1 ,
    ARREADYsi12m1 ,

    //Read data channel
    RIDsi12m1     ,
    RRESPsi12m1   ,
    RDATAsi12m1   ,
    RLASTsi12m1   ,
    RVALIDsi12m1  ,
    RREADYm12si1  ,

    //_______________________________________________________________
    //For Master 2
    //Read address channel
    ARIDm22si2    ,
    ARADDRm22si2  ,
    ARLENm22si2   ,
    ARSIZEm22si2  ,
    ARBURSTm22si2 ,
    ARLOCKm22si2  ,
    ARCACHEm22si2 ,
    ARPROTm22si2  ,

    ARVALIDm22si2 ,
    ARREADYsi22m2 ,

    //Read data channel
    RIDsi22m2     ,
    RRESPsi22m2   ,
    RDATAsi22m2   ,
    RLASTsi22m2   ,
    RVALIDsi22m2  ,
    RREADYm22si2  ,


    //_______________________________________________________________
    //For Master 3
    //Read address channel
    ARIDm32si3    ,
    ARADDRm32si3  ,
    ARLENm32si3   ,
    ARSIZEm32si3  ,
    ARBURSTm32si3 ,
    ARLOCKm32si3  ,
    ARCACHEm32si3 ,
    ARPROTm32si3  ,

    ARVALIDm32si3 ,
    ARREADYsi32m3 ,

    //Read data channel
    RIDsi32m3     ,
    RRESPsi32m3   ,
    RDATAsi32m3   ,
    RLASTsi32m3   ,
    RVALIDsi32m3  ,
    RREADYm32si3  ,
    

 
    //_______________________________________________________________
    //For Slave 0
    //Read address channel
    ARIDmi02s0    ,
    ARADDRmi02s0  ,
    ARLENmi02s0   ,
    ARSIZEmi02s0  ,
    ARBURSTmi02s0 ,
    ARLOCKmi02s0  ,
    ARCACHEmi02s0 ,
    ARPROTmi02s0  ,

    ARVALIDmi02s0 ,
    ARREADYs02mi0 ,

    //Read data channel
    RIDs02mi0     ,
    RRESPs02mi0   ,
    RDATAs02mi0  ,
    RLASTs02mi0  ,
    RVALIDs02mi0  ,
    RREADYmi02s0  ,


    //_______________________________________________________________

    //For Slave 1
    //Read address channel
    ARIDmi12s1    ,
    ARADDRmi12s1  ,
    ARLENmi12s1   ,
    ARSIZEmi12s1  ,
    ARBURSTmi12s1 ,
    ARLOCKmi12s1  ,
    ARCACHEmi12s1 ,
    ARPROTmi12s1  ,

    ARVALIDmi12s1 ,
    ARREADYs12mi1 ,

    //Read data channel
    RIDs12mi1     ,
    RRESPs12mi1   ,
    RDATAs12mi1  ,
    RLASTs12mi1  ,
    RVALIDs12mi1  ,
    RREADYmi12s1  ,
    
    //_______________________________________________________________


    //For Slave 2
    //Read address channel
    ARIDmi22s2    ,
    ARADDRmi22s2  ,
    ARLENmi22s2   ,
    ARSIZEmi22s2  ,
    ARBURSTmi22s2 ,
    ARLOCKmi22s2  ,
    ARCACHEmi22s2 ,
    ARPROTmi22s2  ,

    ARVALIDmi22s2 ,
    ARREADYs22mi2 ,

    //Read data channel
    RIDs22mi2     ,
    RRESPs22mi2   ,
    RDATAs22mi2  ,
    RLASTs22mi2  ,
    RVALIDs22mi2  ,
    RREADYmi22s2  ,

    
    //_______________________________________________________________
    
    
    //For Slave 3
    //Read address channel
    ARIDmi32s3    ,
    ARADDRmi32s3  ,
    ARLENmi32s3   ,
    ARSIZEmi32s3  ,
    ARBURSTmi32s3 ,
    ARLOCKmi32s3  ,
    ARCACHEmi32s3 ,
    ARPROTmi32s3  ,

    ARVALIDmi32s3 ,
    ARREADYs32mi3 ,

    //Read data channel
    RIDs32mi3     ,
    RRESPs32mi3   ,
    RDATAs32mi3  ,
    RLASTs32mi3  ,
    RVALIDs32mi3  ,
    RREADYmi32s3  ,
    
    
    //_______________________________________________________________
    
    //For Slave 4
    //Read address channel
    ARIDmi42s4    ,
    ARADDRmi42s4  ,
    ARLENmi42s4   ,
    ARSIZEmi42s4  ,
    ARBURSTmi42s4 ,
    ARLOCKmi42s4  ,
    ARCACHEmi42s4 ,
    ARPROTmi42s4  ,

    ARVALIDmi42s4 ,
    ARREADYs42mi4 ,

    //Read data channel
    RIDs42mi4     ,
    RRESPs42mi4   ,
    RDATAs42mi4   ,    
    RLASTs42mi4   ,
    RVALIDs42mi4  ,
    RREADYmi42s4  ,
    
    //_______________________________________________________________
    
    
    //For Slave 5
    //Read address channel
    ARIDmi52s5    ,
    ARADDRmi52s5  ,
    ARLENmi52s5   ,
    ARSIZEmi52s5  ,
    ARBURSTmi52s5 ,
    ARLOCKmi52s5  ,
    ARCACHEmi52s5 ,
    ARPROTmi52s5  ,

    ARVALIDmi52s5 ,
    ARREADYs52mi5 ,

    //Read data channel
    RIDs52mi5     ,
    RRESPs52mi5   ,
    RDATAs52mi5   ,    
    RLASTs52mi5   ,
    RVALIDs52mi5  ,
    RREADYmi52s5  , 

    //Lock signal
    Lock2rdmi0  ,
    Lock2rdmi1  ,
    Lock2rdmi2  ,
    Lock2rdmi3  ,
    Lock2rdmi4  ,
    Lock2rdmi5  ,

    Lock2wrmi0  ,
    Lock2wrmi1  ,
    Lock2wrmi2  ,
    Lock2wrmi3  ,
    Lock2wrmi4  ,
    Lock2wrmi5  ,
    
    UnLock2rdmi0 ,
    UnLock2rdmi1 ,
    UnLock2rdmi2 ,
    UnLock2rdmi3 ,
    UnLock2rdmi4 ,
    UnLock2rdmi5 ,

    UnLock2wrmi0 ,
    UnLock2wrmi1 ,
    UnLock2wrmi2 ,
    UnLock2wrmi3 ,
    UnLock2wrmi4 ,
    UnLock2wrmi5 ,

    AWVALIDmi02s0,
    AWVALIDmi12s1,
    AWVALIDmi22s2,
    AWVALIDmi32s3,
    AWVALIDmi42s4,
    AWVALIDmi52s5,

    LockPort2rdmi0,
    LockPort2rdmi1,
    LockPort2rdmi2,
    LockPort2rdmi3,
    LockPort2rdmi4,
    LockPort2rdmi5,

    ReadIntEmptyWrmi02Rdmi0,
    ReadIntEmptyWrmi12Rdmi1,
    ReadIntEmptyWrmi22Rdmi2,
    ReadIntEmptyWrmi32Rdmi3,
    ReadIntEmptyWrmi42Rdmi4,
    ReadIntEmptyWrmi52Rdmi5,

    DataCntEmptyRdmi02Wrmi0,
    DataCntEmptyRdmi12Wrmi1,
    DataCntEmptyRdmi22Wrmi2,
    DataCntEmptyRdmi32Wrmi3,
    DataCntEmptyRdmi42Wrmi4,
    DataCntEmptyRdmi52Wrmi5,

    CtlDataRead2Lock0      ,
    CtlDataRead2Lock1      ,
    CtlDataRead2Lock2      ,
    CtlDataRead2Lock3      ,
    CtlDataRead2Lock4      ,
    CtlDataRead2Lock5      

    //_______________________________________________________________
);
`include "Def.v"

    //Lock signal
    input    Lock2rdmi0 ;
    input    Lock2rdmi1 ;
    input    Lock2rdmi2 ;
    input    Lock2rdmi3 ;
    input    Lock2rdmi4 ;
    input    Lock2rdmi5 ;

    input    UnLock2rdmi0 ;
    input    UnLock2rdmi1 ;
    input    UnLock2rdmi2 ;
    input    UnLock2rdmi3 ;
    input    UnLock2rdmi4 ;
    input    UnLock2rdmi5 ;

    input    AWVALIDmi02s0;
    input    AWVALIDmi12s1;
    input    AWVALIDmi22s2;
    input    AWVALIDmi32s3;
    input    AWVALIDmi42s4;
    input    AWVALIDmi52s5;
    
    output  Lock2wrmi0  ;
    output  Lock2wrmi1  ;
    output  Lock2wrmi2  ;
    output  Lock2wrmi3  ;
    output  Lock2wrmi4  ;
    output  Lock2wrmi5  ;
    
    output  UnLock2wrmi0 ;
    output  UnLock2wrmi1 ;
    output  UnLock2wrmi2 ;
    output  UnLock2wrmi3 ;
    output  UnLock2wrmi4 ;
    output  UnLock2wrmi5 ;


    input    [MASTER_NUM-1:0]LockPort2rdmi0;
    input    [MASTER_NUM-1:0]LockPort2rdmi1;
    input    [MASTER_NUM-1:0]LockPort2rdmi2;
    input    [MASTER_NUM-1:0]LockPort2rdmi3;
    input    [MASTER_NUM-1:0]LockPort2rdmi4;
    input    [MASTER_NUM-1:0]LockPort2rdmi5;

    input   ReadIntEmptyWrmi02Rdmi0;
    input   ReadIntEmptyWrmi12Rdmi1;
    input   ReadIntEmptyWrmi22Rdmi2;
    input   ReadIntEmptyWrmi32Rdmi3;
    input   ReadIntEmptyWrmi42Rdmi4;
    input   ReadIntEmptyWrmi52Rdmi5;

    output  DataCntEmptyRdmi02Wrmi0;
    output  DataCntEmptyRdmi12Wrmi1;
    output  DataCntEmptyRdmi22Wrmi2;
    output  DataCntEmptyRdmi32Wrmi3;
    output  DataCntEmptyRdmi42Wrmi4;
    output  DataCntEmptyRdmi52Wrmi5;

    output   [MASTER_WID-1:0]CtlDataRead2Lock0;     
    output   [MASTER_WID-1:0]CtlDataRead2Lock1;     
    output   [MASTER_WID-1:0]CtlDataRead2Lock2;     
    output   [MASTER_WID-1:0]CtlDataRead2Lock3;     
    output   [MASTER_WID-1:0]CtlDataRead2Lock4;     
    output   [MASTER_WID-1:0]CtlDataRead2Lock5;     


    input   ACLK;   
    input   ARESETn;

    //_______________________________________________________________
    //For Master 0
    //Read address channel
    input   [ID_WID-1:0]       ARIDm02si0;    
    input   [ADDR_WID-1:0]     ARADDRm02si0;
    input   [ARLEN_WID-1:0]    ARLENm02si0;
    input   [ARSIZE_WID-1:0]   ARSIZEm02si0;  
    input   [ARBURST_WID-1:0]  ARBURSTm02si0; 
    input   [ARLOCK_WID-1:0]   ARLOCKm02si0;  
    input   [ARCACHE_WID-1:0]  ARCACHEm02si0; 
    input   [ARPROT_WID-1:0]   ARPROTm02si0;  

    input   ARVALIDm02si0; 
    output  ARREADYsi02m0; 

    //Read data channel
    output   [ID_WID-1:0]      RIDsi02m0;     
    output   [BRESP_WID-1:0]   RRESPsi02m0;   
    output   [BUS_WID-1:0]     RDATAsi02m0;
    output   RLASTsi02m0;
    output   RVALIDsi02m0;  
    input    RREADYm02si0;  


    //_______________________________________________________________
    //For Master 1
    //Read address channel
    input   [ID_WID-1:0]       ARIDm12si1;    
    input   [ADDR_WID-1:0]     ARADDRm12si1;
    input   [ARLEN_WID-1:0]    ARLENm12si1;
    input   [ARSIZE_WID-1:0]   ARSIZEm12si1;  
    input   [ARBURST_WID-1:0]  ARBURSTm12si1; 
    input   [ARLOCK_WID-1:0]   ARLOCKm12si1;  
    input   [ARCACHE_WID-1:0]  ARCACHEm12si1; 
    input   [ARPROT_WID-1:0]   ARPROTm12si1;  

    input   ARVALIDm12si1; 
    output  ARREADYsi12m1; 

    //Read data channel
    output   [ID_WID-1:0]      RIDsi12m1;     
    output   [BRESP_WID-1:0]   RRESPsi12m1;   
    output   [BUS_WID-1:0]     RDATAsi12m1;
    output   RLASTsi12m1;
    output   RVALIDsi12m1;  
    input    RREADYm12si1;  


    //_______________________________________________________________
    //For Master 2
    //Read address channel
    input   [ID_WID-1:0]       ARIDm22si2;    
    input   [ADDR_WID-1:0]     ARADDRm22si2;
    input   [ARLEN_WID-1:0]    ARLENm22si2;
    input   [ARSIZE_WID-1:0]   ARSIZEm22si2;  
    input   [ARBURST_WID-1:0]  ARBURSTm22si2; 
    input   [ARLOCK_WID-1:0]   ARLOCKm22si2;  
    input   [ARCACHE_WID-1:0]  ARCACHEm22si2; 
    input   [ARPROT_WID-1:0]   ARPROTm22si2;  

    input   ARVALIDm22si2; 
    output  ARREADYsi22m2; 

    //Read data channel
    output   [ID_WID-1:0]      RIDsi22m2;     
    output   [BRESP_WID-1:0]   RRESPsi22m2;   
    output   [BUS_WID-1:0]     RDATAsi22m2;
    output   RLASTsi22m2;
    output   RVALIDsi22m2;  
    input    RREADYm22si2;  


    //_______________________________________________________________
    //For Master 3
    //Read address channel
    input   [ID_WID-1:0]       ARIDm32si3;    
    input   [ADDR_WID-1:0]     ARADDRm32si3;
    input   [ARLEN_WID-1:0]    ARLENm32si3;
    input   [ARSIZE_WID-1:0]   ARSIZEm32si3;  
    input   [ARBURST_WID-1:0]  ARBURSTm32si3; 
    input   [ARLOCK_WID-1:0]   ARLOCKm32si3;  
    input   [ARCACHE_WID-1:0]  ARCACHEm32si3; 
    input   [ARPROT_WID-1:0]   ARPROTm32si3;  

    input   ARVALIDm32si3; 
    output  ARREADYsi32m3; 

    //Read data channel
    output   [ID_WID-1:0]      RIDsi32m3;     
    output   [BRESP_WID-1:0]   RRESPsi32m3;   
    output   [BUS_WID-1:0]     RDATAsi32m3;
    output   RLASTsi32m3;
    output   RVALIDsi32m3;  
    input    RREADYm32si3;  



    //_______________________________________________________________
    // For slave 0
    // Read address channel
    output   [(ID_WID+MASTER_WID-1):0]       ARIDmi02s0;    
    output   [ADDR_WID-1:0]     ARADDRmi02s0;
    output   [ARLEN_WID-1:0]    ARLENmi02s0;
    output   [ARSIZE_WID-1:0]   ARSIZEmi02s0;  
    output   [ARBURST_WID-1:0]  ARBURSTmi02s0; 
    output   [ARLOCK_WID-1:0]   ARLOCKmi02s0;  
    output   [ARCACHE_WID-1:0]  ARCACHEmi02s0; 
    output   [ARPROT_WID-1:0]   ARPROTmi02s0;  

    output   ARVALIDmi02s0; 
    input    ARREADYs02mi0; 
    

    //Read data channel
    input   [(ID_WID+MASTER_WID-1):0]      RIDs02mi0;     
    input   [RRESP_WID-1:0]   RRESPs02mi0;   
    input   [BUS_WID-1:0]RDATAs02mi0;  
    input   RLASTs02mi0;  
    input   RVALIDs02mi0;  
    output  RREADYmi02s0;  

    
    // For slave 1
    // Read address channel
    output   [(ID_WID+MASTER_WID-1):0]       ARIDmi12s1;    
    output   [ADDR_WID-1:0]     ARADDRmi12s1;
    output   [ARLEN_WID-1:0]    ARLENmi12s1;
    output   [ARSIZE_WID-1:0]   ARSIZEmi12s1;  
    output   [ARBURST_WID-1:0]  ARBURSTmi12s1; 
    output   [ARLOCK_WID-1:0]   ARLOCKmi12s1;  
    output   [ARCACHE_WID-1:0]  ARCACHEmi12s1; 
    output   [ARPROT_WID-1:0]   ARPROTmi12s1;  

    output   ARVALIDmi12s1; 
    input    ARREADYs12mi1; 
    
    //Read data channel
    input   [(ID_WID+MASTER_WID-1):0]      RIDs12mi1;     
    input   [RRESP_WID-1:0]   RRESPs12mi1;   
    input   [BUS_WID-1:0]RDATAs12mi1;  
    input   RLASTs12mi1;  
    input   RVALIDs12mi1;  
    output  RREADYmi12s1;  



    // For Slave 2
    // Wriet address channel
    output   [(ID_WID+MASTER_WID-1):0]       ARIDmi22s2;    
    output   [ADDR_WID-1:0]     ARADDRmi22s2;
    output   [ARLEN_WID-1:0]    ARLENmi22s2;
    output   [ARSIZE_WID-1:0]   ARSIZEmi22s2;  
    output   [ARBURST_WID-1:0]  ARBURSTmi22s2; 
    output   [ARLOCK_WID-1:0]   ARLOCKmi22s2;  
    output   [ARCACHE_WID-1:0]  ARCACHEmi22s2; 
    output   [ARPROT_WID-1:0]   ARPROTmi22s2;  

    output   ARVALIDmi22s2; 
    input    ARREADYs22mi2; 
    
    //Read data channel
    input   [(ID_WID+MASTER_WID-1):0]      RIDs22mi2;     
    input   [RRESP_WID-1:0]   RRESPs22mi2;   
    input   [BUS_WID-1:0]RDATAs22mi2;  
    input   RLASTs22mi2;  
    input   RVALIDs22mi2;  
    output  RREADYmi22s2;  


    // For slave 3
    // Wriet address channel
    output   [(ID_WID+MASTER_WID-1):0]       ARIDmi32s3;    
    output   [ADDR_WID-1:0]     ARADDRmi32s3;
    output   [ARLEN_WID-1:0]    ARLENmi32s3;
    output   [ARSIZE_WID-1:0]   ARSIZEmi32s3;  
    output   [ARBURST_WID-1:0]  ARBURSTmi32s3; 
    output   [ARLOCK_WID-1:0]   ARLOCKmi32s3;  
    output   [ARCACHE_WID-1:0]  ARCACHEmi32s3; 
    output   [ARPROT_WID-1:0]   ARPROTmi32s3;  

    output   ARVALIDmi32s3; 
    input    ARREADYs32mi3; 
    
    //Read data channel
    input   [(ID_WID+MASTER_WID-1):0]      RIDs32mi3;     
    input   [RRESP_WID-1:0]   RRESPs32mi3;   
    input   [BUS_WID-1:0]RDATAs32mi3;  
    input   RLASTs32mi3;  
    input   RVALIDs32mi3;  
    output  RREADYmi32s3;  


    // For slave 4
    // Wriet address channel
    output   [(ID_WID+MASTER_WID-1):0]       ARIDmi42s4;    
    output   [ADDR_WID-1:0]     ARADDRmi42s4;
    output   [ARLEN_WID-1:0]    ARLENmi42s4;
    output   [ARSIZE_WID-1:0]   ARSIZEmi42s4;  
    output   [ARBURST_WID-1:0]  ARBURSTmi42s4; 
    output   [ARLOCK_WID-1:0]   ARLOCKmi42s4;  
    output   [ARCACHE_WID-1:0]  ARCACHEmi42s4; 
    output   [ARPROT_WID-1:0]   ARPROTmi42s4;  

    output   ARVALIDmi42s4; 
    input    ARREADYs42mi4; 
    
    //Read data channel
    input   [(ID_WID+MASTER_WID-1):0]      RIDs42mi4;     
    input   [RRESP_WID-1:0]   RRESPs42mi4;   
    input   [BUS_WID-1:0]RDATAs42mi4;  
    input   RLASTs42mi4;  
    input   RVALIDs42mi4;  
    output  RREADYmi42s4;  

    // For slave 5
    // Wriet address channel
    output   [(ID_WID+MASTER_WID-1):0]       ARIDmi52s5;    
    output   [ADDR_WID-1:0]     ARADDRmi52s5;
    output   [ARLEN_WID-1:0]    ARLENmi52s5;
    output   [ARSIZE_WID-1:0]   ARSIZEmi52s5;  
    output   [ARBURST_WID-1:0]  ARBURSTmi52s5; 
    output   [ARLOCK_WID-1:0]   ARLOCKmi52s5;  
    output   [ARCACHE_WID-1:0]  ARCACHEmi52s5; 
    output   [ARPROT_WID-1:0]   ARPROTmi52s5;  

    output   ARVALIDmi52s5; 
    input    ARREADYs52mi5; 
    
    //Read data channel
    input   [(ID_WID+MASTER_WID-1):0]      RIDs52mi5;     
    input   [RRESP_WID-1:0]   RRESPs52mi5;   
    input   [BUS_WID-1:0]RDATAs52mi5;  
    input   RLASTs52mi5;  
    input   RVALIDs52mi5;  
    output  RREADYmi52s5;  


//Master module 0    
//___________________________________________________________________________

    wire  [ID_WID-1:0] ARIDsi02mi;    
    wire  [ADDR_WID-1:0] ARADDRsi02mi;  
    wire  [ARLEN_WID-1:0] ARLENsi02mi;   
    wire  [ARSIZE_WID-1:0] ARSIZEsi02mi;  
    wire  [ARBURST_WID-1:0] ARBURSTsi02mi; 
    wire  [ARLOCK_WID-1:0] ARLOCKsi02mi;  
    wire  [ARCACHE_WID-1:0] ARCACHEsi02mi; 
    wire  [ARPROT_WID-1:0] ARPROTsi02mi;
    
    wire   [ID_WID-1:0] RIDmi02si;     
    wire   [RRESP_WID-1:0] RRESPmi02si;   
    wire   [BUS_WID-1:0]   RDATAmi02si;

    wire   [ID_WID-1:0] RIDmi12si;     
    wire   [RRESP_WID-1:0] RRESPmi12si;   
    wire   [BUS_WID-1:0]   RDATAmi12si;

    wire   [ID_WID-1:0] RIDmi22si;     
    wire   [RRESP_WID-1:0] RRESPmi22si;   
    wire   [BUS_WID-1:0]   RDATAmi22si;

    wire   [ID_WID-1:0] RIDmi32si;     
    wire   [RRESP_WID-1:0] RRESPmi32si;   
    wire   [BUS_WID-1:0]   RDATAmi32si;

    wire   [ID_WID-1:0] RIDmi42si;     
    wire   [RRESP_WID-1:0] RRESPmi42si;   
    wire   [BUS_WID-1:0]   RDATAmi42si;

    wire   [ID_WID-1:0] RIDmi52si;     
    wire   [RRESP_WID-1:0] RRESPmi52si;   
    wire   [BUS_WID-1:0]   RDATAmi52si;

    wire    [SLAVE_NUM-1:0]  ARVALIDsi02mi;
    wire    [SLAVE_NUM-1:0] ARREADYmi2si0;
    wire    [SLAVE_NUM-1:0] RVALIDmi2si0;
    wire    [SLAVE_NUM-1:0] RLASTmi2si0;
    wire    [SLAVE_NUM-1:0]  RREADYsi02mi;	
//___________________________________________________________________________


//Master module 1    
//___________________________________________________________________________

    wire  [ID_WID-1:0] ARIDsi12mi;    
    wire  [ADDR_WID-1:0] ARADDRsi12mi;  
    wire  [ARLEN_WID-1:0] ARLENsi12mi;   
    wire  [ARSIZE_WID-1:0] ARSIZEsi12mi;  
    wire  [ARBURST_WID-1:0] ARBURSTsi12mi; 
    wire  [ARLOCK_WID-1:0] ARLOCKsi12mi;  
    wire  [ARCACHE_WID-1:0] ARCACHEsi12mi; 
    wire  [ARPROT_WID-1:0] ARPROTsi12mi;
    
    /*
    wire   [ID_WID-1:0] RIDmi02si;     
    wire   [RRESP_WID-1:0] RRESPmi02si;   
    wire   [BUS_WID-1:0]   RDATAmi02si;

    wire   [ID_WID-1:0] RIDmi12si;     
    wire   [RRESP_WID-1:0] RRESPmi12si;   
    wire   [BUS_WID-1:0]   RDATAmi12si;

    wire   [ID_WID-1:0] RIDmi22si;     
    wire   [RRESP_WID-1:0] RRESPmi22si;   
    wire   [BUS_WID-1:0]   RDATAmi22si;

    wire   [ID_WID-1:0] RIDmi32si;     
    wire   [RRESP_WID-1:0] RRESPmi32si;   
    wire   [BUS_WID-1:0]   RDATAmi32si;

    wire   [ID_WID-1:0] RIDmi42si;     
    wire   [RRESP_WID-1:0] RRESPmi42si;   
    wire   [BUS_WID-1:0]   RDATAmi42si;

    wire   [ID_WID-1:0] RIDmi52si;     
    wire   [RRESP_WID-1:0] RRESPmi52si;   
    wire   [BUS_WID-1:0]   RDATAmi52si;
    */

    wire    [SLAVE_NUM-1:0]  ARVALIDsi12mi;
    wire    [SLAVE_NUM-1:0] ARREADYmi2si1;
    wire    [SLAVE_NUM-1:0] RVALIDmi2si1;
    wire    [SLAVE_NUM-1:0] RLASTmi2si1;
    wire    [SLAVE_NUM-1:0]  RREADYsi12mi;	
//___________________________________________________________________________


//Master module 2    
//___________________________________________________________________________

    wire  [ID_WID-1:0] ARIDsi22mi;    
    wire  [ADDR_WID-1:0] ARADDRsi22mi;  
    wire  [ARLEN_WID-1:0] ARLENsi22mi;   
    wire  [ARSIZE_WID-1:0] ARSIZEsi22mi;  
    wire  [ARBURST_WID-1:0] ARBURSTsi22mi; 
    wire  [ARLOCK_WID-1:0] ARLOCKsi22mi;  
    wire  [ARCACHE_WID-1:0] ARCACHEsi22mi; 
    wire  [ARPROT_WID-1:0] ARPROTsi22mi;
    
    /*
    wire   [ID_WID-1:0] RIDmi02si;     
    wire   [RRESP_WID-1:0] RRESPmi02si;   
    wire   [BUS_WID-1:0]   RDATAmi02si;

    wire   [ID_WID-1:0] RIDmi12si;     
    wire   [RRESP_WID-1:0] RRESPmi12si;   
    wire   [BUS_WID-1:0]   RDATAmi12si;

    wire   [ID_WID-1:0] RIDmi22si;     
    wire   [RRESP_WID-1:0] RRESPmi22si;   
    wire   [BUS_WID-1:0]   RDATAmi22si;

    wire   [ID_WID-1:0] RIDmi32si;     
    wire   [RRESP_WID-1:0] RRESPmi32si;   
    wire   [BUS_WID-1:0]   RDATAmi32si;

    wire   [ID_WID-1:0] RIDmi42si;     
    wire   [RRESP_WID-1:0] RRESPmi42si;   
    wire   [BUS_WID-1:0]   RDATAmi42si;

    wire   [ID_WID-1:0] RIDmi52si;     
    wire   [RRESP_WID-1:0] RRESPmi52si;   
    wire   [BUS_WID-1:0]   RDATAmi52si;
    */

    wire    [SLAVE_NUM-1:0]  ARVALIDsi22mi;
    wire    [SLAVE_NUM-1:0] ARREADYmi2si2;
    wire    [SLAVE_NUM-1:0] RVALIDmi2si2;
    wire    [SLAVE_NUM-1:0] RLASTmi2si2;
    wire    [SLAVE_NUM-1:0]  RREADYsi22mi;	
//___________________________________________________________________________


//Master module 3    
//___________________________________________________________________________

    wire  [ID_WID-1:0] ARIDsi32mi;    
    wire  [ADDR_WID-1:0] ARADDRsi32mi;  
    wire  [ARLEN_WID-1:0] ARLENsi32mi;   
    wire  [ARSIZE_WID-1:0] ARSIZEsi32mi;  
    wire  [ARBURST_WID-1:0] ARBURSTsi32mi; 
    wire  [ARLOCK_WID-1:0] ARLOCKsi32mi;  
    wire  [ARCACHE_WID-1:0] ARCACHEsi32mi; 
    wire  [ARPROT_WID-1:0] ARPROTsi32mi;
    
    /*
    wire   [ID_WID-1:0] RIDmi02si;     
    wire   [RRESP_WID-1:0] RRESPmi02si;   
    wire   [BUS_WID-1:0]   RDATAmi02si;

    wire   [ID_WID-1:0] RIDmi12si;     
    wire   [RRESP_WID-1:0] RRESPmi12si;   
    wire   [BUS_WID-1:0]   RDATAmi12si;

    wire   [ID_WID-1:0] RIDmi22si;     
    wire   [RRESP_WID-1:0] RRESPmi22si;   
    wire   [BUS_WID-1:0]   RDATAmi22si;

    wire   [ID_WID-1:0] RIDmi32si;     
    wire   [RRESP_WID-1:0] RRESPmi32si;   
    wire   [BUS_WID-1:0]   RDATAmi32si;

    wire   [ID_WID-1:0] RIDmi42si;     
    wire   [RRESP_WID-1:0] RRESPmi42si;   
    wire   [BUS_WID-1:0]   RDATAmi42si;

    wire   [ID_WID-1:0] RIDmi52si;     
    wire   [RRESP_WID-1:0] RRESPmi52si;   
    wire   [BUS_WID-1:0]   RDATAmi52si;
    */

    wire    [SLAVE_NUM-1:0]  ARVALIDsi32mi;
    wire    [SLAVE_NUM-1:0] ARREADYmi2si3;
    wire    [SLAVE_NUM-1:0] RVALIDmi2si3;
    wire    [SLAVE_NUM-1:0] RLASTmi2si3;
    wire    [SLAVE_NUM-1:0]  RREADYsi32mi;	
//___________________________________________________________________________



//Slave module 0    
//___________________________________________________________________________

wire    [MASTER_NUM-1:0] ARVALIDsi2mi0;
wire    [MASTER_NUM-1:0] ARREADYmi02si;
wire    [MASTER_NUM-1:0] RVALIDmi02si;
wire    [MASTER_NUM-1:0] RLASTmi02si;
wire    [MASTER_NUM-1:0] RREADYsi2mi0;


//Slave module 1    
//___________________________________________________________________________

wire    [MASTER_NUM-1:0]  ARVALIDsi2mi1;
wire    [MASTER_NUM-1:0] ARREADYmi12si;
wire    [MASTER_NUM-1:0] RVALIDmi12si;
wire    [MASTER_NUM-1:0] RLASTmi12si;
wire    [MASTER_NUM-1:0] RREADYsi2mi1;


//Slave module 2    
//___________________________________________________________________________

wire    [MASTER_NUM-1:0]  ARVALIDsi2mi2;
wire    [MASTER_NUM-1:0] ARREADYmi22si;
wire    [MASTER_NUM-1:0] RVALIDmi22si;
wire    [MASTER_NUM-1:0] RLASTmi22si;
wire    [MASTER_NUM-1:0] RREADYsi2mi2;


//Slave module 3    
//___________________________________________________________________________

wire    [MASTER_NUM-1:0]  ARVALIDsi2mi3;
wire    [MASTER_NUM-1:0] ARREADYmi32si;
wire    [MASTER_NUM-1:0] RVALIDmi32si;
wire    [MASTER_NUM-1:0] RLASTmi32si;
wire    [MASTER_NUM-1:0] RREADYsi2mi3;


//Slave module 4    
//___________________________________________________________________________

wire    [MASTER_NUM-1:0]  ARVALIDsi2mi4;
wire    [MASTER_NUM-1:0] ARREADYmi42si;
wire    [MASTER_NUM-1:0] RVALIDmi42si;
wire    [MASTER_NUM-1:0] RLASTmi42si;
wire    [MASTER_NUM-1:0] RREADYsi2mi4;


//Slave module 5    
//___________________________________________________________________________

wire    [MASTER_NUM-1:0]  ARVALIDsi2mi5;
wire    [MASTER_NUM-1:0] ARREADYmi52si;
wire    [MASTER_NUM-1:0] RVALIDmi52si;
wire    [MASTER_NUM-1:0] RLASTmi52si;

wire    [MASTER_NUM-1:0] RREADYsi2mi5;

assign  RVALIDmi2si0 ={ RVALIDmi52si[0], RVALIDmi42si[0], RVALIDmi32si[0], RVALIDmi22si[0], RVALIDmi12si[0], RVALIDmi02si[0] };
assign  RVALIDmi2si1 ={ RVALIDmi52si[1], RVALIDmi42si[1], RVALIDmi32si[1], RVALIDmi22si[1], RVALIDmi12si[1], RVALIDmi02si[1] };
assign  RVALIDmi2si2 ={ RVALIDmi52si[2], RVALIDmi42si[2], RVALIDmi32si[2], RVALIDmi22si[2], RVALIDmi12si[2], RVALIDmi02si[2] };
assign  RVALIDmi2si3 ={ RVALIDmi52si[3], RVALIDmi42si[3], RVALIDmi32si[3], RVALIDmi22si[3], RVALIDmi12si[3], RVALIDmi02si[3] };

assign  RLASTmi2si0 ={ RLASTmi52si[0], RLASTmi42si[0], RLASTmi32si[0], RLASTmi22si[0], RLASTmi12si[0], RLASTmi02si[0] };
assign  RLASTmi2si1 ={ RLASTmi52si[1], RLASTmi42si[1], RLASTmi32si[1], RLASTmi22si[1], RLASTmi12si[1], RLASTmi02si[1] };
assign  RLASTmi2si2 ={ RLASTmi52si[2], RLASTmi42si[2], RLASTmi32si[2], RLASTmi22si[2], RLASTmi12si[2], RLASTmi02si[2] };
assign  RLASTmi2si3 ={ RLASTmi52si[3], RLASTmi42si[3], RLASTmi32si[3], RLASTmi22si[3], RLASTmi12si[3], RLASTmi02si[3] };

assign  RREADYsi2mi0 = { RREADYsi32mi[0], RREADYsi22mi[0], RREADYsi12mi[0], RREADYsi02mi[0] };
assign  RREADYsi2mi1 = { RREADYsi32mi[1], RREADYsi22mi[1], RREADYsi12mi[1], RREADYsi02mi[1] };
assign  RREADYsi2mi2 = { RREADYsi32mi[2], RREADYsi22mi[2], RREADYsi12mi[2], RREADYsi02mi[2] };
assign  RREADYsi2mi3 = { RREADYsi32mi[3], RREADYsi22mi[3], RREADYsi12mi[3], RREADYsi02mi[3] };
assign  RREADYsi2mi4 = { RREADYsi32mi[4], RREADYsi22mi[4], RREADYsi12mi[4], RREADYsi02mi[4] };
assign  RREADYsi2mi5 = { RREADYsi32mi[5], RREADYsi22mi[5], RREADYsi12mi[5], RREADYsi02mi[5] };

assign  ARVALIDsi2mi0 = { ARVALIDsi32mi[0], ARVALIDsi22mi[0], ARVALIDsi12mi[0], ARVALIDsi02mi[0] };
assign  ARVALIDsi2mi1 = { ARVALIDsi32mi[1], ARVALIDsi22mi[1], ARVALIDsi12mi[1], ARVALIDsi02mi[1] };
assign  ARVALIDsi2mi2 = { ARVALIDsi32mi[2], ARVALIDsi22mi[2], ARVALIDsi12mi[2], ARVALIDsi02mi[2] };
assign  ARVALIDsi2mi3 = { ARVALIDsi32mi[3], ARVALIDsi22mi[3], ARVALIDsi12mi[3], ARVALIDsi02mi[3] };
assign  ARVALIDsi2mi4 = { ARVALIDsi32mi[4], ARVALIDsi22mi[4], ARVALIDsi12mi[4], ARVALIDsi02mi[4] };
assign  ARVALIDsi2mi5 = { ARVALIDsi32mi[5], ARVALIDsi22mi[5], ARVALIDsi12mi[5], ARVALIDsi02mi[5] };

assign  ARREADYmi2si0 = { ARREADYmi52si[0], ARREADYmi42si[0], ARREADYmi32si[0], ARREADYmi22si[0],  ARREADYmi12si[0], ARREADYmi02si[0] };
assign  ARREADYmi2si1 = { ARREADYmi52si[1], ARREADYmi42si[1], ARREADYmi32si[1], ARREADYmi22si[1],  ARREADYmi12si[1], ARREADYmi02si[1] };
assign  ARREADYmi2si2 = { ARREADYmi52si[2], ARREADYmi42si[2], ARREADYmi32si[2], ARREADYmi22si[2],  ARREADYmi12si[2], ARREADYmi02si[2] };
assign  ARREADYmi2si3 = { ARREADYmi52si[3], ARREADYmi42si[3], ARREADYmi32si[3], ARREADYmi22si[3],  ARREADYmi12si[3], ARREADYmi02si[3] };

//Master module 0    
//___________________________________________________________________________

ReadChannelsi 
U0ReadChannelsi(

    //Global signal
    .ACLK    (ACLK),
    .ARESETn (ARESETn),

    //Read address channel
    .ARIDm2si    (ARIDm02si0),
    .ARADDRm2si  (ARADDRm02si0),
    .ARLENm2si   (ARLENm02si0),
    .ARSIZEm2si  (ARSIZEm02si0),
    .ARBURSTm2si (ARBURSTm02si0),
    .ARLOCKm2si  (ARLOCKm02si0),
    .ARCACHEm2si (ARCACHEm02si0),
    .ARPROTm2si  (ARPROTm02si0),

    .ARVALIDm2si (ARVALIDm02si0),
    .ARREADYsi2m (ARREADYsi02m0),

    //Read data channel
    .RIDsi2m     (RIDsi02m0),
    .RRESPsi2m   (RRESPsi02m0),
    .RVALIDsi2m  (RVALIDsi02m0),
    .RDATAsi2m   (RDATAsi02m0),
    .RREADYm2si  (RREADYm02si0),
    .RLASTsi2m   (RLASTsi02m0),


    //For Master interface
    //Read address channel
    .ARIDsi2mi    (ARIDsi02mi),
    .ARADDRsi2mi  (ARADDRsi02mi),
    .ARLENsi2mi   (ARLENsi02mi),
    .ARSIZEsi2mi  (ARSIZEsi02mi),
    .ARBURSTsi2mi (ARBURSTsi02mi),
    .ARLOCKsi2mi  (ARLOCKsi02mi),
    .ARCACHEsi2mi (ARCACHEsi02mi),
    .ARPROTsi2mi  (ARPROTsi02mi),
    .ARVALIDsi2mi (ARVALIDsi02mi),
    .ARREADYmi2si (ARREADYmi2si0),


    //Read data channel
    .RIDmi02si     (RIDmi02si),
    .RRESPmi02si   (RRESPmi02si),
    .RDATAmi02si   (RDATAmi02si),

    .RIDmi12si     (RIDmi12si),
    .RRESPmi12si   (RRESPmi12si),
    .RDATAmi12si   (RDATAmi12si),

    .RIDmi22si     (RIDmi22si),
    .RRESPmi22si   (RRESPmi22si),
    .RDATAmi22si   (RDATAmi22si),
    
    .RIDmi32si     (RIDmi32si),
    .RRESPmi32si   (RRESPmi32si),
    .RDATAmi32si   (RDATAmi32si),

    .RIDmi42si     (RIDmi42si),
    .RRESPmi42si   (RRESPmi42si),
    .RDATAmi42si   (RDATAmi42si),

    .RIDmi52si     (RIDmi52si),
    .RRESPmi52si   (RRESPmi52si),
    .RDATAmi52si   (RDATAmi52si),

    .RVALIDmi2si  (RVALIDmi2si0),
    .RREADYsi2mi  (RREADYsi02mi),
    .RLASTmi2si	  (RLASTmi2si0)


);

//Master module 1    
//___________________________________________________________________________

ReadChannelsi 
U1ReadChannelsi(

    //Global signal
    .ACLK    (ACLK),
    .ARESETn (ARESETn),

    //Read address channel
    .ARIDm2si    (ARIDm12si1),
    .ARADDRm2si  (ARADDRm12si1),
    .ARLENm2si   (ARLENm12si1),
    .ARSIZEm2si  (ARSIZEm12si1),
    .ARBURSTm2si (ARBURSTm12si1),
    .ARLOCKm2si  (ARLOCKm12si1),
    .ARCACHEm2si (ARCACHEm12si1),
    .ARPROTm2si  (ARPROTm12si1),

    .ARVALIDm2si (ARVALIDm12si1),
    .ARREADYsi2m (ARREADYsi12m1),

    //Read data channel
    .RIDsi2m     (RIDsi12m1),
    .RRESPsi2m   (RRESPsi12m1),
    .RVALIDsi2m  (RVALIDsi12m1),
    .RDATAsi2m   (RDATAsi12m1),
    .RREADYm2si  (RREADYm12si1),
    .RLASTsi2m   (RLASTsi12m1),


    //For Master interface
    //Read address channel
    .ARIDsi2mi    (ARIDsi12mi),
    .ARADDRsi2mi  (ARADDRsi12mi),
    .ARLENsi2mi   (ARLENsi12mi),
    .ARSIZEsi2mi  (ARSIZEsi12mi),
    .ARBURSTsi2mi (ARBURSTsi12mi),
    .ARLOCKsi2mi  (ARLOCKsi12mi),
    .ARCACHEsi2mi (ARCACHEsi12mi),
    .ARPROTsi2mi  (ARPROTsi12mi),
    .ARVALIDsi2mi (ARVALIDsi12mi),
    .ARREADYmi2si (ARREADYmi2si1),


    //Read data channel
    .RIDmi02si     (RIDmi02si),
    .RRESPmi02si   (RRESPmi02si),
    .RDATAmi02si   (RDATAmi02si),

    .RIDmi12si     (RIDmi12si),
    .RRESPmi12si   (RRESPmi12si),
    .RDATAmi12si   (RDATAmi12si),

    .RIDmi22si     (RIDmi22si),
    .RRESPmi22si   (RRESPmi22si),
    .RDATAmi22si   (RDATAmi22si),
    
    .RIDmi32si     (RIDmi32si),
    .RRESPmi32si   (RRESPmi32si),
    .RDATAmi32si   (RDATAmi32si),

    .RIDmi42si     (RIDmi42si),
    .RRESPmi42si   (RRESPmi42si),
    .RDATAmi42si   (RDATAmi42si),

    .RIDmi52si     (RIDmi52si),
    .RRESPmi52si   (RRESPmi52si),
    .RDATAmi52si   (RDATAmi52si),

    .RVALIDmi2si  (RVALIDmi2si1),
    .RREADYsi2mi  (RREADYsi12mi),
    .RLASTmi2si	  (RLASTmi2si1)
);

//Master module 2    
//___________________________________________________________________________

ReadChannelsi 
U2ReadChannelsi(

    //Global signal
    .ACLK    (ACLK),
    .ARESETn (ARESETn),

    //Read address channel
    .ARIDm2si    (ARIDm22si2),
    .ARADDRm2si  (ARADDRm22si2),
    .ARLENm2si   (ARLENm22si2),
    .ARSIZEm2si  (ARSIZEm22si2),
    .ARBURSTm2si (ARBURSTm22si2),
    .ARLOCKm2si  (ARLOCKm22si2),
    .ARCACHEm2si (ARCACHEm22si2),
    .ARPROTm2si  (ARPROTm22si2),

    .ARVALIDm2si (ARVALIDm22si2),
    .ARREADYsi2m (ARREADYsi22m2),

    //Read data channel
    .RIDsi2m     (RIDsi22m2),
    .RRESPsi2m   (RRESPsi22m2),
    .RVALIDsi2m  (RVALIDsi22m2),
    .RDATAsi2m   (RDATAsi22m2),
    .RREADYm2si  (RREADYm22si2),
    .RLASTsi2m   (RLASTsi22m2),


    //For Master interface
    //Read address channel
    .ARIDsi2mi    (ARIDsi22mi),
    .ARADDRsi2mi  (ARADDRsi22mi),
    .ARLENsi2mi   (ARLENsi22mi),
    .ARSIZEsi2mi  (ARSIZEsi22mi),
    .ARBURSTsi2mi (ARBURSTsi22mi),
    .ARLOCKsi2mi  (ARLOCKsi22mi),
    .ARCACHEsi2mi (ARCACHEsi22mi),
    .ARPROTsi2mi  (ARPROTsi22mi),
    .ARVALIDsi2mi (ARVALIDsi22mi),
    .ARREADYmi2si (ARREADYmi2si2),


    //Read data channel
    .RIDmi02si     (RIDmi02si),
    .RRESPmi02si   (RRESPmi02si),
    .RDATAmi02si   (RDATAmi02si),

    .RIDmi12si     (RIDmi12si),
    .RRESPmi12si   (RRESPmi12si),
    .RDATAmi12si   (RDATAmi12si),

    .RIDmi22si     (RIDmi22si),
    .RRESPmi22si   (RRESPmi22si),
    .RDATAmi22si   (RDATAmi22si),
    
    .RIDmi32si     (RIDmi32si),
    .RRESPmi32si   (RRESPmi32si),
    .RDATAmi32si   (RDATAmi32si),

    .RIDmi42si     (RIDmi42si),
    .RRESPmi42si   (RRESPmi42si),
    .RDATAmi42si   (RDATAmi42si),

    .RIDmi52si     (RIDmi52si),
    .RRESPmi52si   (RRESPmi52si),
    .RDATAmi52si   (RDATAmi52si),

    .RVALIDmi2si  (RVALIDmi2si2),
    .RREADYsi2mi  (RREADYsi22mi),
    .RLASTmi2si	  (RLASTmi2si2)
);


//Master module 3    
//___________________________________________________________________________

ReadChannelsi 
U3ReadChannelsi(

    //Global signal
    .ACLK    (ACLK),
    .ARESETn (ARESETn),

    //Read address channel
    .ARIDm2si    (ARIDm32si3),
    .ARADDRm2si  (ARADDRm32si3),
    .ARLENm2si   (ARLENm32si3),
    .ARSIZEm2si  (ARSIZEm32si3),
    .ARBURSTm2si (ARBURSTm32si3),
    .ARLOCKm2si  (ARLOCKm32si3),
    .ARCACHEm2si (ARCACHEm32si3),
    .ARPROTm2si  (ARPROTm32si3),

    .ARVALIDm2si (ARVALIDm32si3),
    .ARREADYsi2m (ARREADYsi32m3),

    //Read data channel
    .RIDsi2m     (RIDsi32m3),
    .RRESPsi2m   (RRESPsi32m3),
    .RVALIDsi2m  (RVALIDsi32m3),
    .RDATAsi2m   (RDATAsi32m3),
    .RREADYm2si  (RREADYm32si3),
    .RLASTsi2m   (RLASTsi32m3),


    //For Master interface
    //Read address channel
    .ARIDsi2mi    (ARIDsi32mi),
    .ARADDRsi2mi  (ARADDRsi32mi),
    .ARLENsi2mi   (ARLENsi32mi),
    .ARSIZEsi2mi  (ARSIZEsi32mi),
    .ARBURSTsi2mi (ARBURSTsi32mi),
    .ARLOCKsi2mi  (ARLOCKsi32mi),
    .ARCACHEsi2mi (ARCACHEsi32mi),
    .ARPROTsi2mi  (ARPROTsi32mi),
    .ARVALIDsi2mi (ARVALIDsi32mi),
    .ARREADYmi2si (ARREADYmi2si3),


    //Read data channel
    .RIDmi02si     (RIDmi02si),
    .RRESPmi02si   (RRESPmi02si),
    .RDATAmi02si   (RDATAmi02si),

    .RIDmi12si     (RIDmi12si),
    .RRESPmi12si   (RRESPmi12si),
    .RDATAmi12si   (RDATAmi12si),

    .RIDmi22si     (RIDmi22si),
    .RRESPmi22si   (RRESPmi22si),
    .RDATAmi22si   (RDATAmi22si),
    
    .RIDmi32si     (RIDmi32si),
    .RRESPmi32si   (RRESPmi32si),
    .RDATAmi32si   (RDATAmi32si),

    .RIDmi42si     (RIDmi42si),
    .RRESPmi42si   (RRESPmi42si),
    .RDATAmi42si   (RDATAmi42si),

    .RIDmi52si     (RIDmi52si),
    .RRESPmi52si   (RRESPmi52si),
    .RDATAmi52si   (RDATAmi52si),

    .RVALIDmi2si  (RVALIDmi2si3),
    .RREADYsi2mi  (RREADYsi32mi),
    .RLASTmi2si	  (RLASTmi2si3)
);

//Slave module 0    
//___________________________________________________________________________

ReadChannelmi 
U0ReadChannelmi(
    
    //Global signal
    .ACLK    (ACLK),
    .ARESETn (ARESETn),

    //For slave 
    //Read address channel
    .ARIDmi2s    (ARIDmi02s0),
    .ARADDRmi2s  (ARADDRmi02s0),
    .ARLENmi2s   (ARLENmi02s0),
    .ARSIZEmi2s  (ARSIZEmi02s0),
    .ARBURSTmi2s (ARBURSTmi02s0),
    .ARLOCKmi2s  (ARLOCKmi02s0),
    .ARCACHEmi2s (ARCACHEmi02s0),
    .ARPROTmi2s  (ARPROTmi02s0),

    .ARVALIDmi2s (ARVALIDmi02s0),
    .ARREADYs2mi (ARREADYs02mi0),

    //Read data channel
    .RIDs2mi     (RIDs02mi0),
    .RRESPs2mi   (RRESPs02mi0),
    .RDATAs2mi   (RDATAs02mi0),
    .RVALIDs2mi  (RVALIDs02mi0),
    .RLASTs2mi   (RLASTs02mi0),
    .RREADYmi2s  (RREADYmi02s0),


    //Slave interface signal

    //Read address channel
    //Master0
    .ARIDsi02mi    (ARIDsi02mi),
    .ARADDRsi02mi  (ARADDRsi02mi),
    .ARLENsi02mi   (ARLENsi02mi),
    .ARSIZEsi02mi  (ARSIZEsi02mi),
    .ARBURSTsi02mi (ARBURSTsi02mi),
    .ARLOCKsi02mi  (ARLOCKsi02mi),
    .ARCACHEsi02mi (ARCACHEsi02mi),
    .ARPROTsi02mi  (ARPROTsi02mi),

    //Master1
    .ARIDsi12mi    (ARIDsi12mi),
    .ARADDRsi12mi  (ARADDRsi12mi),
    .ARLENsi12mi   (ARLENsi12mi),
    .ARSIZEsi12mi  (ARSIZEsi12mi),
    .ARBURSTsi12mi (ARBURSTsi12mi),
    .ARLOCKsi12mi  (ARLOCKsi12mi),
    .ARCACHEsi12mi (ARCACHEsi12mi),
    .ARPROTsi12mi  (ARPROTsi12mi),

    //Master2
    .ARIDsi22mi    (ARIDsi22mi),
    .ARADDRsi22mi  (ARADDRsi22mi),
    .ARLENsi22mi   (ARLENsi22mi),
    .ARSIZEsi22mi  (ARSIZEsi22mi),
    .ARBURSTsi22mi (ARBURSTsi22mi),
    .ARLOCKsi22mi  (ARLOCKsi22mi),
    .ARCACHEsi22mi (ARCACHEsi22mi),
    .ARPROTsi22mi  (ARPROTsi22mi),

    //Master3
    .ARIDsi32mi    (ARIDsi32mi),
    .ARADDRsi32mi  (ARADDRsi32mi),
    .ARLENsi32mi   (ARLENsi32mi),
    .ARSIZEsi32mi  (ARSIZEsi32mi),
    .ARBURSTsi32mi (ARBURSTsi32mi),
    .ARLOCKsi32mi  (ARLOCKsi32mi),
    .ARCACHEsi32mi (ARCACHEsi32mi),
    .ARPROTsi32mi  (ARPROTsi32mi),

    //Master 0/1/2/3
    .ARVALIDsi2mi  (ARVALIDsi2mi0),

    .ARREADYmi2si  (ARREADYmi02si),

    //Read data channel
    .RIDmi2si     (RIDmi02si),
    .RRESPmi2si   (RRESPmi02si),
    .RDATAmi2si   (RDATAmi02si),
    
    .RVALIDmi2si  (RVALIDmi02si),
    .RLASTmi2si   (RLASTmi02si),
    .RREADYsi2mi  (RREADYsi2mi0),


    //Lock Access
    .Lock2Rdmi      (Lock2rdmi0),
    .UnLock2Rdmi    (UnLock2rdmi0),

    .Lock2Wrmi      (Lock2wrmi0),
    .UnLock2Wrmi    (UnLock2wrmi0),

    .AWVALID    (AWVALIDmi02s0),
    .LockPort   (LockPort2rdmi0),
    .ReadIntEmptyWrmi2Rdmi  (ReadIntEmptyWrmi02Rdmi0),
    .DataCntEmptyRdmi2Wrmi  (DataCntEmptyRdmi02Wrmi0),
    .CtlDataRead2Lock       (CtlDataRead2Lock0     )
);



//Slave module 1    
//___________________________________________________________________________

ReadChannelmi 
U1ReadChannelmi(
    
    //Global signal
    .ACLK    (ACLK),
    .ARESETn (ARESETn),

    //For slave 
    //Read address channel
    .ARIDmi2s    (ARIDmi12s1),
    .ARADDRmi2s  (ARADDRmi12s1),
    .ARLENmi2s   (ARLENmi12s1),
    .ARSIZEmi2s  (ARSIZEmi12s1),
    .ARBURSTmi2s (ARBURSTmi12s1),
    .ARLOCKmi2s  (ARLOCKmi12s1),
    .ARCACHEmi2s (ARCACHEmi12s1),
    .ARPROTmi2s  (ARPROTmi12s1),

    .ARVALIDmi2s (ARVALIDmi12s1),
    .ARREADYs2mi (ARREADYs12mi1),

    //Read data channel
    .RIDs2mi     (RIDs12mi1),
    .RRESPs2mi   (RRESPs12mi1),
    .RDATAs2mi   (RDATAs12mi1),
    .RVALIDs2mi  (RVALIDs12mi1),
    .RLASTs2mi   (RLASTs12mi1),
    .RREADYmi2s  (RREADYmi12s1),


    //Slave interface signal

    //Read address channel
    //Master0
    .ARIDsi02mi    (ARIDsi02mi),
    .ARADDRsi02mi  (ARADDRsi02mi),
    .ARLENsi02mi   (ARLENsi02mi),
    .ARSIZEsi02mi  (ARSIZEsi02mi),
    .ARBURSTsi02mi (ARBURSTsi02mi),
    .ARLOCKsi02mi  (ARLOCKsi02mi),
    .ARCACHEsi02mi (ARCACHEsi02mi),
    .ARPROTsi02mi  (ARPROTsi02mi),

    //Master1
    .ARIDsi12mi    (ARIDsi12mi),
    .ARADDRsi12mi  (ARADDRsi12mi),
    .ARLENsi12mi   (ARLENsi12mi),
    .ARSIZEsi12mi  (ARSIZEsi12mi),
    .ARBURSTsi12mi (ARBURSTsi12mi),
    .ARLOCKsi12mi  (ARLOCKsi12mi),
    .ARCACHEsi12mi (ARCACHEsi12mi),
    .ARPROTsi12mi  (ARPROTsi12mi),

    //Master2
    .ARIDsi22mi    (ARIDsi22mi),
    .ARADDRsi22mi  (ARADDRsi22mi),
    .ARLENsi22mi   (ARLENsi22mi),
    .ARSIZEsi22mi  (ARSIZEsi22mi),
    .ARBURSTsi22mi (ARBURSTsi22mi),
    .ARLOCKsi22mi  (ARLOCKsi22mi),
    .ARCACHEsi22mi (ARCACHEsi22mi),
    .ARPROTsi22mi  (ARPROTsi22mi),

    //Master3
    .ARIDsi32mi    (ARIDsi32mi),
    .ARADDRsi32mi  (ARADDRsi32mi),
    .ARLENsi32mi   (ARLENsi32mi),
    .ARSIZEsi32mi  (ARSIZEsi32mi),
    .ARBURSTsi32mi (ARBURSTsi32mi),
    .ARLOCKsi32mi  (ARLOCKsi32mi),
    .ARCACHEsi32mi (ARCACHEsi32mi),
    .ARPROTsi32mi  (ARPROTsi32mi),

    //Master 0/1/2/3
    .ARVALIDsi2mi  (ARVALIDsi2mi1),

    .ARREADYmi2si  (ARREADYmi12si),

    //Read data channel
    .RIDmi2si     (RIDmi12si),
    .RRESPmi2si   (RRESPmi12si),
    .RDATAmi2si   (RDATAmi12si),
    
    .RVALIDmi2si  (RVALIDmi12si),
    .RLASTmi2si   (RLASTmi12si),
    .RREADYsi2mi  (RREADYsi2mi1),

    //Lock Access
    .Lock2Rdmi      (Lock2rdmi1),
    .UnLock2Rdmi    (UnLock2rdmi1),

    .Lock2Wrmi      (Lock2wrmi1),
    .UnLock2Wrmi    (UnLock2wrmi1),
    
    .AWVALID    (AWVALIDmi12s1),
    .LockPort   (LockPort2rdmi1),
    .ReadIntEmptyWrmi2Rdmi  (ReadIntEmptyWrmi12Rdmi1),
    .DataCntEmptyRdmi2Wrmi  (DataCntEmptyRdmi12Wrmi1),
    .CtlDataRead2Lock       (CtlDataRead2Lock1     )
    
);



//Slave module 2    
//___________________________________________________________________________

ReadChannelmi 
U2ReadChannelmi(
    
    //Global signal
    .ACLK    (ACLK),
    .ARESETn (ARESETn),

    //For slave 
    //Read address channel
    .ARIDmi2s    (ARIDmi22s2),
    .ARADDRmi2s  (ARADDRmi22s2),
    .ARLENmi2s   (ARLENmi22s2),
    .ARSIZEmi2s  (ARSIZEmi22s2),
    .ARBURSTmi2s (ARBURSTmi22s2),
    .ARLOCKmi2s  (ARLOCKmi22s2),
    .ARCACHEmi2s (ARCACHEmi22s2),
    .ARPROTmi2s  (ARPROTmi22s2),

    .ARVALIDmi2s (ARVALIDmi22s2),
    .ARREADYs2mi (ARREADYs22mi2),

    //Read data channel
    .RIDs2mi     (RIDs22mi2),
    .RRESPs2mi   (RRESPs22mi2),
    .RDATAs2mi   (RDATAs22mi2),
    .RVALIDs2mi  (RVALIDs22mi2),
    .RLASTs2mi   (RLASTs22mi2),
    .RREADYmi2s  (RREADYmi22s2),


    //Slave interface signal

    //Read address channel
    //Master0
    .ARIDsi02mi    (ARIDsi02mi),
    .ARADDRsi02mi  (ARADDRsi02mi),
    .ARLENsi02mi   (ARLENsi02mi),
    .ARSIZEsi02mi  (ARSIZEsi02mi),
    .ARBURSTsi02mi (ARBURSTsi02mi),
    .ARLOCKsi02mi  (ARLOCKsi02mi),
    .ARCACHEsi02mi (ARCACHEsi02mi),
    .ARPROTsi02mi  (ARPROTsi02mi),

    //Master1
    .ARIDsi12mi    (ARIDsi12mi),
    .ARADDRsi12mi  (ARADDRsi12mi),
    .ARLENsi12mi   (ARLENsi12mi),
    .ARSIZEsi12mi  (ARSIZEsi12mi),
    .ARBURSTsi12mi (ARBURSTsi12mi),
    .ARLOCKsi12mi  (ARLOCKsi12mi),
    .ARCACHEsi12mi (ARCACHEsi12mi),
    .ARPROTsi12mi  (ARPROTsi12mi),

    //Master2
    .ARIDsi22mi    (ARIDsi22mi),
    .ARADDRsi22mi  (ARADDRsi22mi),
    .ARLENsi22mi   (ARLENsi22mi),
    .ARSIZEsi22mi  (ARSIZEsi22mi),
    .ARBURSTsi22mi (ARBURSTsi22mi),
    .ARLOCKsi22mi  (ARLOCKsi22mi),
    .ARCACHEsi22mi (ARCACHEsi22mi),
    .ARPROTsi22mi  (ARPROTsi22mi),

    //Master3
    .ARIDsi32mi    (ARIDsi32mi),
    .ARADDRsi32mi  (ARADDRsi32mi),
    .ARLENsi32mi   (ARLENsi32mi),
    .ARSIZEsi32mi  (ARSIZEsi32mi),
    .ARBURSTsi32mi (ARBURSTsi32mi),
    .ARLOCKsi32mi  (ARLOCKsi32mi),
    .ARCACHEsi32mi (ARCACHEsi32mi),
    .ARPROTsi32mi  (ARPROTsi32mi),

    //Master 0/1/2/3
    .ARVALIDsi2mi  (ARVALIDsi2mi2),

    .ARREADYmi2si  (ARREADYmi22si),

    //Read data channel
    .RIDmi2si     (RIDmi22si),
    .RRESPmi2si   (RRESPmi22si),
    .RDATAmi2si   (RDATAmi22si),
    
    .RVALIDmi2si  (RVALIDmi22si),
    .RLASTmi2si   (RLASTmi22si),
    .RREADYsi2mi  (RREADYsi2mi2),

    //Lock Access
    .Lock2Rdmi      (Lock2rdmi2),
    .UnLock2Rdmi    (UnLock2rdmi2),

    .Lock2Wrmi      (Lock2wrmi2),
    .UnLock2Wrmi    (UnLock2wrmi2),

    .AWVALID    (AWVALIDmi22s2),
    .LockPort   (LockPort2rdmi2),
    .ReadIntEmptyWrmi2Rdmi  (ReadIntEmptyWrmi22Rdmi2),
    .DataCntEmptyRdmi2Wrmi  (DataCntEmptyRdmi22Wrmi2),
    .CtlDataRead2Lock       (CtlDataRead2Lock2     )
    
);



//Slave module 3    
//___________________________________________________________________________

ReadChannelmi 
U3ReadChannelmi(
    
    //Global signal
    .ACLK    (ACLK),
    .ARESETn (ARESETn),

    //For slave 
    //Read address channel
    .ARIDmi2s    (ARIDmi32s3),
    .ARADDRmi2s  (ARADDRmi32s3),
    .ARLENmi2s   (ARLENmi32s3),
    .ARSIZEmi2s  (ARSIZEmi32s3),
    .ARBURSTmi2s (ARBURSTmi32s3),
    .ARLOCKmi2s  (ARLOCKmi32s3),
    .ARCACHEmi2s (ARCACHEmi32s3),
    .ARPROTmi2s  (ARPROTmi32s3),

    .ARVALIDmi2s (ARVALIDmi32s3),
    .ARREADYs2mi (ARREADYs32mi3),

    //Read data channel
    .RIDs2mi     (RIDs32mi3),
    .RRESPs2mi   (RRESPs32mi3),
    .RDATAs2mi   (RDATAs32mi3),
    .RVALIDs2mi  (RVALIDs32mi3),
    .RLASTs2mi   (RLASTs32mi3),
    .RREADYmi2s  (RREADYmi32s3),


    //Slave interface signal

    //Read address channel
    //Master0
    .ARIDsi02mi    (ARIDsi02mi),
    .ARADDRsi02mi  (ARADDRsi02mi),
    .ARLENsi02mi   (ARLENsi02mi),
    .ARSIZEsi02mi  (ARSIZEsi02mi),
    .ARBURSTsi02mi (ARBURSTsi02mi),
    .ARLOCKsi02mi  (ARLOCKsi02mi),
    .ARCACHEsi02mi (ARCACHEsi02mi),
    .ARPROTsi02mi  (ARPROTsi02mi),

    //Master1
    .ARIDsi12mi    (ARIDsi12mi),
    .ARADDRsi12mi  (ARADDRsi12mi),
    .ARLENsi12mi   (ARLENsi12mi),
    .ARSIZEsi12mi  (ARSIZEsi12mi),
    .ARBURSTsi12mi (ARBURSTsi12mi),
    .ARLOCKsi12mi  (ARLOCKsi12mi),
    .ARCACHEsi12mi (ARCACHEsi12mi),
    .ARPROTsi12mi  (ARPROTsi12mi),

    //Master2
    .ARIDsi22mi    (ARIDsi22mi),
    .ARADDRsi22mi  (ARADDRsi22mi),
    .ARLENsi22mi   (ARLENsi22mi),
    .ARSIZEsi22mi  (ARSIZEsi22mi),
    .ARBURSTsi22mi (ARBURSTsi22mi),
    .ARLOCKsi22mi  (ARLOCKsi22mi),
    .ARCACHEsi22mi (ARCACHEsi22mi),
    .ARPROTsi22mi  (ARPROTsi22mi),

    //Master3
    .ARIDsi32mi    (ARIDsi32mi),
    .ARADDRsi32mi  (ARADDRsi32mi),
    .ARLENsi32mi   (ARLENsi32mi),
    .ARSIZEsi32mi  (ARSIZEsi32mi),
    .ARBURSTsi32mi (ARBURSTsi32mi),
    .ARLOCKsi32mi  (ARLOCKsi32mi),
    .ARCACHEsi32mi (ARCACHEsi32mi),
    .ARPROTsi32mi  (ARPROTsi32mi),

    //Master 0/1/2/3
    .ARVALIDsi2mi  (ARVALIDsi2mi3),

    .ARREADYmi2si  (ARREADYmi32si),

    //Read data channel
    .RIDmi2si     (RIDmi32si),
    .RRESPmi2si   (RRESPmi32si),
    .RDATAmi2si   (RDATAmi32si),
    
    .RVALIDmi2si  (RVALIDmi32si),
    .RLASTmi2si   (RLASTmi32si),
    .RREADYsi2mi  (RREADYsi2mi3),

    //Lock Access
    .Lock2Rdmi      (Lock2rdmi3),
    .UnLock2Rdmi    (UnLock2rdmi3),

    .Lock2Wrmi      (Lock2wrmi3),
    .UnLock2Wrmi    (UnLock2wrmi3),

    .AWVALID    (AWVALIDmi32s3),
    .LockPort   (LockPort2rdmi3),
    .ReadIntEmptyWrmi2Rdmi  (ReadIntEmptyWrmi32Rdmi3),
    .DataCntEmptyRdmi2Wrmi  (DataCntEmptyRdmi32Wrmi3),
    .CtlDataRead2Lock       (CtlDataRead2Lock3     )
    
);



//Slave module 4    
//___________________________________________________________________________

ReadChannelmi 
U4ReadChannelmi(
    
    //Global signal
    .ACLK    (ACLK),
    .ARESETn (ARESETn),

    //For slave 
    //Read address channel
    .ARIDmi2s    (ARIDmi42s4),
    .ARADDRmi2s  (ARADDRmi42s4),
    .ARLENmi2s   (ARLENmi42s4),
    .ARSIZEmi2s  (ARSIZEmi42s4),
    .ARBURSTmi2s (ARBURSTmi42s4),
    .ARLOCKmi2s  (ARLOCKmi42s4),
    .ARCACHEmi2s (ARCACHEmi42s4),
    .ARPROTmi2s  (ARPROTmi42s4),

    .ARVALIDmi2s (ARVALIDmi42s4),
    .ARREADYs2mi (ARREADYs42mi4),

    //Read data channel
    .RIDs2mi     (RIDs42mi4),
    .RRESPs2mi   (RRESPs42mi4),
    .RDATAs2mi   (RDATAs42mi4),
    .RVALIDs2mi  (RVALIDs42mi4),
    .RLASTs2mi   (RLASTs42mi4),
    .RREADYmi2s  (RREADYmi42s4),


    //Slave interface signal

    //Read address channel
    //Master0
    .ARIDsi02mi    (ARIDsi02mi),
    .ARADDRsi02mi  (ARADDRsi02mi),
    .ARLENsi02mi   (ARLENsi02mi),
    .ARSIZEsi02mi  (ARSIZEsi02mi),
    .ARBURSTsi02mi (ARBURSTsi02mi),
    .ARLOCKsi02mi  (ARLOCKsi02mi),
    .ARCACHEsi02mi (ARCACHEsi02mi),
    .ARPROTsi02mi  (ARPROTsi02mi),

    //Master1
    .ARIDsi12mi    (ARIDsi12mi),
    .ARADDRsi12mi  (ARADDRsi12mi),
    .ARLENsi12mi   (ARLENsi12mi),
    .ARSIZEsi12mi  (ARSIZEsi12mi),
    .ARBURSTsi12mi (ARBURSTsi12mi),
    .ARLOCKsi12mi  (ARLOCKsi12mi),
    .ARCACHEsi12mi (ARCACHEsi12mi),
    .ARPROTsi12mi  (ARPROTsi12mi),

    //Master2
    .ARIDsi22mi    (ARIDsi22mi),
    .ARADDRsi22mi  (ARADDRsi22mi),
    .ARLENsi22mi   (ARLENsi22mi),
    .ARSIZEsi22mi  (ARSIZEsi22mi),
    .ARBURSTsi22mi (ARBURSTsi22mi),
    .ARLOCKsi22mi  (ARLOCKsi22mi),
    .ARCACHEsi22mi (ARCACHEsi22mi),
    .ARPROTsi22mi  (ARPROTsi22mi),

    //Master3
    .ARIDsi32mi    (ARIDsi32mi),
    .ARADDRsi32mi  (ARADDRsi32mi),
    .ARLENsi32mi   (ARLENsi32mi),
    .ARSIZEsi32mi  (ARSIZEsi32mi),
    .ARBURSTsi32mi (ARBURSTsi32mi),
    .ARLOCKsi32mi  (ARLOCKsi32mi),
    .ARCACHEsi32mi (ARCACHEsi32mi),
    .ARPROTsi32mi  (ARPROTsi32mi),

    //Master 0/1/2/3
    .ARVALIDsi2mi  (ARVALIDsi2mi4),

    .ARREADYmi2si  (ARREADYmi42si),

    //Read data channel
    .RIDmi2si     (RIDmi42si),
    .RRESPmi2si   (RRESPmi42si),
    .RDATAmi2si   (RDATAmi42si),
    
    .RVALIDmi2si  (RVALIDmi42si),
    .RLASTmi2si   (RLASTmi42si),
    .RREADYsi2mi  (RREADYsi2mi4),

    //Lock Access
    .Lock2Rdmi      (Lock2rdmi4),
    .UnLock2Rdmi    (UnLock2rdmi4),

    .Lock2Wrmi      (Lock2wrmi4),
    .UnLock2Wrmi    (UnLock2wrmi4),

    .AWVALID    (AWVALIDmi42s4),
    .LockPort   (LockPort2rdmi4),
    .ReadIntEmptyWrmi2Rdmi  (ReadIntEmptyWrmi42Rdmi4),
    .DataCntEmptyRdmi2Wrmi  (DataCntEmptyRdmi42Wrmi4),
    .CtlDataRead2Lock       (CtlDataRead2Lock4     )
    
);




//Slave module 5    
//___________________________________________________________________________

ReadChannelmi 
U5ReadChannelmi(
    
    //Global signal
    .ACLK    (ACLK),
    .ARESETn (ARESETn),

    //For slave 
    //Read address channel
    .ARIDmi2s    (ARIDmi52s5),
    .ARADDRmi2s  (ARADDRmi52s5),
    .ARLENmi2s   (ARLENmi52s5),
    .ARSIZEmi2s  (ARSIZEmi52s5),
    .ARBURSTmi2s (ARBURSTmi52s5),
    .ARLOCKmi2s  (ARLOCKmi52s5),
    .ARCACHEmi2s (ARCACHEmi52s5),
    .ARPROTmi2s  (ARPROTmi52s5),

    .ARVALIDmi2s (ARVALIDmi52s5),
    .ARREADYs2mi (ARREADYs52mi5),

    //Read data channel
    .RIDs2mi     (RIDs52mi5),
    .RRESPs2mi   (RRESPs52mi5),
    .RDATAs2mi   (RDATAs52mi5),
    .RVALIDs2mi  (RVALIDs52mi5),
    .RLASTs2mi   (RLASTs52mi5),
    .RREADYmi2s  (RREADYmi52s5),


    //Slave interface signal

    //Read address channel
    //Master0
    .ARIDsi02mi    (ARIDsi02mi),
    .ARADDRsi02mi  (ARADDRsi02mi),
    .ARLENsi02mi   (ARLENsi02mi),
    .ARSIZEsi02mi  (ARSIZEsi02mi),
    .ARBURSTsi02mi (ARBURSTsi02mi),
    .ARLOCKsi02mi  (ARLOCKsi02mi),
    .ARCACHEsi02mi (ARCACHEsi02mi),
    .ARPROTsi02mi  (ARPROTsi02mi),

    //Master1
    .ARIDsi12mi    (ARIDsi12mi),
    .ARADDRsi12mi  (ARADDRsi12mi),
    .ARLENsi12mi   (ARLENsi12mi),
    .ARSIZEsi12mi  (ARSIZEsi12mi),
    .ARBURSTsi12mi (ARBURSTsi12mi),
    .ARLOCKsi12mi  (ARLOCKsi12mi),
    .ARCACHEsi12mi (ARCACHEsi12mi),
    .ARPROTsi12mi  (ARPROTsi12mi),

    //Master2
    .ARIDsi22mi    (ARIDsi22mi),
    .ARADDRsi22mi  (ARADDRsi22mi),
    .ARLENsi22mi   (ARLENsi22mi),
    .ARSIZEsi22mi  (ARSIZEsi22mi),
    .ARBURSTsi22mi (ARBURSTsi22mi),
    .ARLOCKsi22mi  (ARLOCKsi22mi),
    .ARCACHEsi22mi (ARCACHEsi22mi),
    .ARPROTsi22mi  (ARPROTsi22mi),

    //Master3
    .ARIDsi32mi    (ARIDsi32mi),
    .ARADDRsi32mi  (ARADDRsi32mi),
    .ARLENsi32mi   (ARLENsi32mi),
    .ARSIZEsi32mi  (ARSIZEsi32mi),
    .ARBURSTsi32mi (ARBURSTsi32mi),
    .ARLOCKsi32mi  (ARLOCKsi32mi),
    .ARCACHEsi32mi (ARCACHEsi32mi),
    .ARPROTsi32mi  (ARPROTsi32mi),

    //Master 0/1/2/3
    .ARVALIDsi2mi  (ARVALIDsi2mi5),

    .ARREADYmi2si  (ARREADYmi52si),

    //Read data channel
    .RIDmi2si     (RIDmi52si),
    .RRESPmi2si   (RRESPmi52si),
    .RDATAmi2si   (RDATAmi52si),
    
    .RVALIDmi2si  (RVALIDmi52si),
    .RLASTmi2si   (RLASTmi52si),
    .RREADYsi2mi  (RREADYsi2mi5),

    //Lock Access
    .Lock2Rdmi      (Lock2rdmi5),
    .UnLock2Rdmi    (UnLock2rdmi5),

    .Lock2Wrmi      (Lock2wrmi5),
    .UnLock2Wrmi    (UnLock2wrmi5),

    .AWVALID    (AWVALIDmi52s5),
    .LockPort   (LockPort2rdmi5),
    .ReadIntEmptyWrmi2Rdmi  (ReadIntEmptyWrmi52Rdmi5),
    .DataCntEmptyRdmi2Wrmi  (DataCntEmptyRdmi52Wrmi5),
    .CtlDataRead2Lock       (CtlDataRead2Lock5     )
    
);

endmodule


