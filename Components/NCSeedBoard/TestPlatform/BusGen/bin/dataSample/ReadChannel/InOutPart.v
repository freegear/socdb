//notice :: don't modify this code

`timescale 1 ns/ 10ps
module  ReadChannel(

//INOUT_STATE00_START
    //_______________________________________________________________
    //For Master ??
    //Read address channel
//ENABLE_ID
    ARIDm??2si??    ,
    ARADDRm??2si??  ,
    ARLENm??2si??   ,
    ARSIZEm??2si??  ,
    ARBURSTm??2si?? ,
//ENABLE_LOCK
    ARLOCKm??2si??  ,
//ENABLE_CACHE
    ARCACHEm??2si?? ,
//ENABLE_PROT
    ARPROTm??2si??  ,

    ARVALIDm??2si?? ,
    ARREADYsi??2m?? ,

    //Read data channel
//ENABLE_ID
    RIDsi??2m??     ,
    RRESPsi??2m??   ,
    RDATAsi??2m??   ,
    RLASTsi??2m??   ,
    RVALIDsi??2m??  ,
    RREADYm??2si??  ,

//END_CH
//STATE_END


//INOUT_STATE01_START
    //_______________________________________________________________
    //For Slave ??
    //Read address channel
    ARIDmi??2s??    ,
    ARADDRmi??2s??  ,
    ARLENmi??2s??   ,
    ARSIZEmi??2s??  ,
    ARBURSTmi??2s?? ,
//ENABLE_LOCK
    ARLOCKmi??2s??  ,
//ENABLE_CACHE
    ARCACHEmi??2s?? ,
//ENABLE_PROT
    ARPROTmi??2s??  ,

    ARVALIDmi??2s?? ,
    ARREADYs??2mi?? ,

    //Read data channel
    RIDs??2mi??     ,
    RRESPs??2mi??   ,
    RDATAs??2mi??  ,
    RLASTs??2mi??  ,
    RVALIDs??2mi??  ,
    RREADYmi??2s??  ,
//STATE_END

    //Lock Access
    //_______________________________________________________________

//INOUT_STATE02_START
    Lock2rdmi??  ,
//STATE_END

//INOUT_STATE03_START
    Lock2wrmi??  ,
//STATE_END

//INOUT_STATE04_START
    UnLock2rdmi?? ,
//STATE_END

//INOUT_STATE05_START
    UnLock2wrmi?? ,
//STATE_END

//INOUT_STATE06_START
    AWVALIDmi??2s??,
//STATE_END

//INOUT_STATE07_START
    LockPort2rdmi??,
//STATE_END

//INOUT_STATE08_START
    ReadIntEmptyWrmi??2Rdmi??,
//STATE_END

//INOUT_STATE09_START
    DataCntEmptyRdmi??2Wrmi??,
//STATE_END

//INOUT_STATE10_START
    CtlDataRead2Lock??      ,
//STATE_END

    ACLK    ,
    ARESETn 
);
//DEF_STATE
    

    input   ACLK;
    input   ARESETn;  

    //Lock Access
    //_______________________________________________________________

//INOUT_STATE11_START

    //Slave ??
    //_____________________________________

    input    Lock2rdmi?? ;
    input    UnLock2rdmi?? ;
    input    AWVALIDmi??2s??;
    input    Lock2wrmi??;
    output   UnLock2wrmi?? ;
    input    ReadIntEmptyWrmi??2Rdmi??;
    output   DataCntEmptyRdmi??2Wrmi??;
    output   [SELMASTER??_WID-1:0]CtlDataRead2Lock??;     
    //2006-9-8-ID-WID-FIXED
    //input    [SELMASTER??_WID-1:0]LockPort2rdmi??;
    input    [SELMASTER??_WID:0]LockPort2rdmi??;
//STATE_END
    //_______________________________________________________________


    //SlaveInterface
    //_______________________________________________________________

//INOUT_STATE12_START
    //For Master ??
    //Read address channel
//ENABLE_ID
    input   [MASTERID??_WID-1:0]ARIDm??2si??;    
    input   [ADDR_WID-1:0]     ARADDRm??2si??;
    input   [ARLEN_WID-1:0]    ARLENm??2si??;
    input   [ARSIZE_WID-1:0]   ARSIZEm??2si??;  
    input   [ARBURST_WID-1:0]  ARBURSTm??2si??; 
//ENABLE_LOCK
    input   [ARLOCK_WID-1:0]   ARLOCKm??2si??;  
//ENABLE_CACHE
    input   [ARCACHE_WID-1:0]  ARCACHEm??2si??; 
//ENABLE_PROT
    input   [ARPROT_WID-1:0]   ARPROTm??2si??;  

    input   ARVALIDm??2si??; 
    output  ARREADYsi??2m??; 

    //Read data channel
//ENABLE_ID
    output   [MASTERID??_WID-1:0]RIDsi??2m??;     
    output   [BRESP_WID-1:0]   RRESPsi??2m??;   
    output   [BUS_WID-1:0]     RDATAsi??2m??;
    output   RLASTsi??2m??;
    output   RVALIDsi??2m??;  
    input    RREADYm??2si??;  

//END_CH
//STATE_END
    //_______________________________________________________________


    //MasterInterface
    //_______________________________________________________________

//INOUT_STATE13_START
    // For slave ??
    //__________________________________________________

    // Read address channel
    output   [SLAVEID??_WID-1:0]ARIDmi??2s??;    
    output   [ADDR_WID-1:0]     ARADDRmi??2s??;
    output   [ARLEN_WID-1:0]    ARLENmi??2s??;
    output   [ARSIZE_WID-1:0]   ARSIZEmi??2s??;  
    output   [ARBURST_WID-1:0]  ARBURSTmi??2s??; 
//ENABLE_LOCK
    output   [ARLOCK_WID-1:0]   ARLOCKmi??2s??;  
//ENABLE_CACHE
    output   [ARCACHE_WID-1:0]  ARCACHEmi??2s??; 
//ENABLE_PROT
    output   [ARPROT_WID-1:0]   ARPROTmi??2s??;  

    output   ARVALIDmi??2s??; 
    input    ARREADYs??2mi??; 
    

    //Read data channel
    input   [SLAVEID??_WID-1:0] RIDs??2mi??;     
    input   [RRESP_WID-1:0]     RRESPs??2mi??;   
    input   [BUS_WID-1:0]       RDATAs??2mi??;  
    input   RLASTs??2mi??;  
    input   RVALIDs??2mi??;  
    output  RREADYmi??2s??;  

//STATE_END
    
    //_______________________________________________________________
//INOUT_END
