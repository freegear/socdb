//notice :: don't modify this code
//Syn 253:: modify ELAB-292(senstivelist)

`timescale 1 ns/ 10ps
module  ?NAME?_ReadChannelmi(
    
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
//ENABLE_LOCK
    ARLOCKmi2s  ,
//ENABLE_CACHE
    ARCACHEmi2s ,
//ENABLE_PROT
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
    /////////////////////////////////////////////////////////////

//INOUT_STATE00_START
    //Master??
    //Read address channel
    //____________________________________
    ARIDsi??2mi    ,
    ARADDRsi??2mi  ,
    ARLENsi??2mi   ,
    ARSIZEsi??2mi  ,
    ARBURSTsi??2mi ,
    ARLOCKsi??2mi  ,
    ARCACHEsi??2mi ,
    ARPROTsi??2mi  ,

//STATE_END

    //Master 0/1/2/3 etc...
    ARVALIDsi2mi  ,
    ARREADYmi2si  ,

    //Read data channel
//INOUT_STATE00_START
    RIDmi2si??     ,
    RRESPmi2si??   ,
    RDATAmi2si??   ,
//STATE_END

    RVALIDmi2si  ,
    RLASTmi2si  ,
    RREADYsi2mi,

//LOCKSig_START
    //Lock control
    //____________________________________
    
    Lock2Rdmi,
    UnLock2Rdmi,
    Lock2Wrmi,
    UnLock2Wrmi,
    AWVALID,
    LockPort,
    ReadIntEmptyWrmi2Rdmi,
    DataCntEmptyRdmi2Wrmi,
    CtlDataRead2Lock
    
    //____________________________________
//LOCKSig_END

    );
//DEF_STATE

    input   ACLK;
    input   ARESETn;

    // For slave 
    // 2s (Slave)
    output   [SLAVEID_WID-1:0]  ARIDmi2s;    
    output   [ADDR_WID-1:0]     ARADDRmi2s;
    output   [ARLEN_WID-1:0]    ARLENmi2s;
    output   [ARSIZE_WID-1:0]   ARSIZEmi2s;  
    output   [ARBURST_WID-1:0]  ARBURSTmi2s; 
//ENABLE_LOCK
    output   [ARLOCK_WID-1:0]   ARLOCKmi2s;  
//ENABLE_CACHE
    output   [ARCACHE_WID-1:0]  ARCACHEmi2s; 
//ENABLE_PROT
    output   [ARPROT_WID-1:0]   ARPROTmi2s;  

    output   ARVALIDmi2s; 
    input    ARREADYs2mi; 
    
    //Read data channel
    input   [SLAVEID_WID-1:0] RIDs2mi;     
    input   [RRESP_WID-1:0]   RRESPs2mi;   
    input   [BUS_WID-1:0]     RDATAs2mi;
    input   RLASTs2mi;
    input   RVALIDs2mi;  
    output  RREADYmi2s;  

    //From SI(slave interface)
//INOUT_STATE01_START
    
    //Master??
    //__________________________________________________
    input   [MASTERID_WID-1:0]  ARIDsi??2mi;    
    input   [ADDR_WID-1:0]     ARADDRsi??2mi;
    input   [ARLEN_WID-1:0]    ARLENsi??2mi;
    input   [ARSIZE_WID-1:0]   ARSIZEsi??2mi;  
    input   [ARBURST_WID-1:0]  ARBURSTsi??2mi; 
    input   [ARLOCK_WID-1:0]   ARLOCKsi??2mi;  
    input   [ARCACHE_WID-1:0]  ARCACHEsi??2mi; 
    input   [ARPROT_WID-1:0]   ARPROTsi??2mi; 

//STATE_END


    input   [MASTER_NUM-1:0]    ARVALIDsi2mi;
    output  [MASTER_NUM-1:0]    ARREADYmi2si;

    //Read data channel
//INOUT_STATE01_START
    output   [MASTERID_WID-1:0] RIDmi2si??;     
    output   [RRESP_WID-1:0]    RRESPmi2si??;   
    output   [BUS_WID-1:0]      RDATAmi2si??;

//STATE_END

    output   [MASTER_NUM-1:0]   RVALIDmi2si;  
    output   [MASTER_NUM-1:0]   RLASTmi2si;  
    input    [MASTER_NUM-1:0]   RREADYsi2mi;    
    

//LOCKSig_START
    //Lock signal
    input    Lock2Rdmi;
    input    UnLock2Rdmi;
    input    AWVALID;
    //2006-9-8-ID-WID-FIXED
    //input    [SELMASTER_WID-1:0]LockPort;
    input    [SELMASTER_WID:0]LockPort;
    input    ReadIntEmptyWrmi2Rdmi;

    //output   [MASTER_WID-1:0]CtlDataRead2Lock;
    output   [SELMASTER_WID-1:0]CtlDataRead2Lock;
    output   DataCntEmptyRdmi2Wrmi;

    output   Lock2Wrmi;
    output   UnLock2Wrmi;

    wire    DataCntEmptyRdmi2Wrmi;
    wire    EnARMUXn      ;
    wire    EnARREADYMUXn ;
    wire    [5:0]   LockArbiter   ;
//LOCKSig_END

//INOUT_END
