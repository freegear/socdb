//notice :: don't modify this code
// 531 :: Ver 1.2 inserting data channel mask signal  ( WENn )
// Syn 309 :: modify ELAB-292(senstivelist)

`timescale 1 ns/ 10ps
module  ?NAME?_WriteChannelmi(
    
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
    /////////////////////////////////////////////////////////////


//INOUT_STATE00_START
    //Master??
    //Write address channel
    //____________________________________
    AWIDsi??2mi    ,
    AWADDRsi??2mi  ,
    AWLENsi??2mi   ,
    AWSIZEsi??2mi  ,
    AWBURSTsi??2mi ,
    AWLOCKsi??2mi  ,
    AWCACHEsi??2mi ,
    AWPROTsi??2mi  ,
    //____________________________________
    //Write data channel
    WIDsi??2mi   ,     
    WDATAsi??2mi ,   
    WSTRBsi??2mi , 

//STATE_END
    //____________________________________
    //Write response channel
    BIDmi2si     ,
    BRESPmi2si   ,
    BVALIDmi2si  ,
    BREADYsi2mi,
    //____________________________________
    

//LOCKSig_START
    //Lock control
    //____________________________________
    Lock2Wrmi,
    UnLock2Wrmi,

    Lock2Rdmi,
    UnLock2Rdmi,
    ARVALID,

    LockPort,
    ReadIntEmptyWrmi2Rdmi,
    DataCntEmptyRdmi2Wrmi,
    CtlDataWrite2Lock,
    //____________________________________
//LOCKSig_END

    //Master 0/1/2/3
    AWVALIDsi2mi  ,
    AWREADYmi2si  ,

    //Master 0/1/2/3
    WLASTsi2mi   ,
    WVALIDsi2mi  ,

    //output 1port
    WREADYmi2si  
    );
//DEF_STATE


    input   ACLK;
    input   ARESETn;

    // For slave 
    // 2s (Slave)
    output   [SLAVEID_WID-1:0]  AWIDmi2s;    
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
    output   [SLAVEID_WID-1:0]       WIDmi2s;     
    output   [BUS_WID-1:0]      WDATAmi2s;   
    output   [WSTRB_WID-1:0]    WSTRBmi2s;   
    output   WLASTmi2s;   
    output   WVALIDmi2s;  
    input    WREADYs2mi; 

    //Write response channel
    input   [SLAVEID_WID-1:0]      BIDs2mi;     
    input   [BRESP_WID-1:0]   BRESPs2mi;   
    input   BVALIDs2mi;  
    output  BREADYmi2s;  

//INOUT_STATE01_START
    
    //Master??
    //Write address channel
    //__________________________________________________
    input   [MASTERID_WID-1:0]       AWIDsi??2mi;    
    input   [ADDR_WID-1:0]     AWADDRsi??2mi;
    input   [AWLEN_WID-1:0]    AWLENsi??2mi;
    input   [AWSIZE_WID-1:0]   AWSIZEsi??2mi;  
    input   [AWBURST_WID-1:0]  AWBURSTsi??2mi; 
    input   [AWLOCK_WID-1:0]   AWLOCKsi??2mi;  
    input   [AWCACHE_WID-1:0]  AWCACHEsi??2mi; 
    input   [AWPROT_WID-1:0]   AWPROTsi??2mi; 

    //Write data channel
    input   [MASTERID_WID-1:0]   WIDsi??2mi;     
    input   [BUS_WID-1:0]  WDATAsi??2mi;   
    input   [WSTRB_WID-1:0]WSTRBsi??2mi;   
    //__________________________________________________

//STATE_END

    input   [MASTER_NUM-1:0]AWVALIDsi2mi;
    output  [MASTER_NUM-1:0]AWREADYmi2si;

    input   [MASTER_NUM-1:0]WLASTsi2mi;   
    input   [MASTER_NUM-1:0]WVALIDsi2mi;  
    output  [MASTER_NUM-1:0]WREADYmi2si;  

    //Write response channel
    output   [MASTERID_WID-1:0]    BIDmi2si;     
    output   [BRESP_WID-1:0] BRESPmi2si;   
    output   [MASTER_NUM-1:0]BVALIDmi2si;  
    input    [MASTER_NUM-1:0]BREADYsi2mi;    
    //__________________________________________________


//LOCKSig_START
    //Lock signal
    input    Lock2Wrmi;
    input    UnLock2Wrmi;
    input    ARVALID;
    input    DataCntEmptyRdmi2Wrmi;
    input    [SELMASTER_WID-1:0]LockPort;

    output   [SELMASTER_WID-1:0]CtlDataWrite2Lock;
    output   ReadIntEmptyWrmi2Rdmi;

    output   Lock2Rdmi;
    output   UnLock2Rdmi;
//LOCKSig_END

//INOUT_END
