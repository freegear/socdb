//notice :: don't modify this code

`timescale 1 ns/ 10ps
//INOUT_STATE00_0_START
module  ?BUSNAME?_WriteChannel(
//STATE_END

    SelMAP1,

//INOUT_STATE00_START
    //_______________________________________________________________
    //For Master ??
    //Write address channel
//ENABLE_ID
    AWIDm??2si??    ,
    AWADDRm??2si??  ,
    AWLENm??2si??   ,
    AWSIZEm??2si??  ,
    AWBURSTm??2si?? ,
//ENABLE_LOCK
    AWLOCKm??2si??  ,
//ENABLE_CACHE
    AWCACHEm??2si?? ,
//ENABLE_PROT
    AWPROTm??2si??  ,

    AWVALIDm??2si?? ,
    AWREADYsi??2m?? ,

    //Write data channel
//ENABLE_ID
    WIDm??2si??     ,
    WDATAm??2si??   ,
//ENABLE_WSTRB
    WSTRBm??2si??   ,
    WLASTm??2si??   ,
    WVALIDm??2si??  ,
    WREADYsi??2m??  ,

    //Write response channel
//ENABLE_ID
    BIDsi??2m??     ,
    BRESPsi??2m??   ,
    BVALIDsi??2m??  ,
    BREADYm??2si??  ,

//END_CH
//STATE_END

//INOUT_STATE01_START
    
    //_______________________________________________________________
    //For Slave ??
    //Write address channel
    AWIDmi??2s??    ,
    AWADDRmi??2s??  ,
    AWLENmi??2s??   ,
    AWSIZEmi??2s??  ,
    AWBURSTmi??2s?? ,
//ENABLE_LOCK
    AWLOCKmi??2s??  ,
//ENABLE_CACHE
    AWCACHEmi??2s?? ,
//ENABLE_PROT
    AWPROTmi??2s??  ,

    AWVALIDmi??2s?? ,
    AWREADYs??2mi?? ,

    //Write data channel
    WIDmi??2s??     ,
    WDATAmi??2s??   ,
//ENABLE_WSTRB
    WSTRBmi??2s??   ,
    WLASTmi??2s??   ,
    WVALIDmi??2s??  ,
    WREADYs??2mi??  ,

    //Write response channel
    BIDs??2mi??     ,
    BRESPs??2mi??   ,
    BVALIDs??2mi??  ,
    BREADYmi??2s??  ,
//STATE_END


    //Lock Access
    //_______________________________________________________________

//INOUT_STATE02_START
    Lock2wrmi??,
//STATE_END

//INOUT_STATE03_START
    Lock2rdmi??,
//STATE_END

//INOUT_STATE04_START
    UnLock2wrmi??,
//STATE_END

//INOUT_STATE05_START
    UnLock2rdmi??,
//STATE_END

//INOUT_STATE06_START
    ARVALIDmi??2s??,
//STATE_END

//INOUT_STATE07_START
    LockPort2wrmi??,
//STATE_END

//INOUT_STATE08_START
    ReadIntEmptyWrmi??2Rdmi??,
//STATE_END

//INOUT_STATE09_START
    DataCntEmptyRdmi??2Wrmi??,
//STATE_END

//INOUT_STATE10_START
    CtlDataWrite2Lock??,
//STATE_END

    ACLK    ,
    ARESETn 
);
//DEF_STATE
    


  parameter STRB_WIDTH = BUS_WID/8; // WSTRB width
  parameter STRB_MAX   = STRB_WIDTH; // WSTRB max index

    input   SelMAP1;
    input   ACLK;
    input   ARESETn;  

    //Lock Access
    //_______________________________________________________________

//INOUT_STATE11_START

    //Slave ??
    //_____________________________________
    input   Lock2wrmi??;
    input   UnLock2wrmi??;
    output  Lock2rdmi??;
    output  UnLock2rdmi??;
    input   ARVALIDmi??2s??;
    //2006-9-8-ID-WID-FIXED
    //input   [SELMASTER??_WID-1:0]LockPort2wrmi??;
    input   [SELMASTER??_WID:0]LockPort2wrmi??;

    output  ReadIntEmptyWrmi??2Rdmi??;
    input   DataCntEmptyRdmi??2Wrmi??;
    output  [SELMASTER??_WID-1:0]CtlDataWrite2Lock??;
//STATE_END
    //_______________________________________________________________

    //SlaveInterface
    //_______________________________________________________________

//INOUT_STATE12_START
    //For Master ??
    //Write address channel
//ENABLE_ID
    input   [MASTERID??_WID-1:0]    AWIDm??2si??;    
    input   [ADDR_WID-1:0]          AWADDRm??2si??;
    input   [AWLEN_WID-1:0]         AWLENm??2si??;
    input   [AWSIZE_WID-1:0]        AWSIZEm??2si??;  
    input   [AWBURST_WID-1:0]       AWBURSTm??2si??; 
//ENABLE_LOCK
    input   [AWLOCK_WID-1:0]        AWLOCKm??2si??;  
//ENABLE_CACHE
    input   [AWCACHE_WID-1:0]       AWCACHEm??2si??; 
//ENABLE_PROT
    input   [AWPROT_WID-1:0]        AWPROTm??2si??;  

    input   AWVALIDm??2si??; 
    output  AWREADYsi??2m??; 

    //Write data channel
//ENABLE_ID
    input   [MASTERID??_WID-1:0]   WIDm??2si??;     
    input   [BUS_WID-1:0]           WDATAm??2si??;   
//ENABLE_WSTRB
    input   [WSTRB_WID-1:0]         WSTRBm??2si??;   
    input   WLASTm??2si??;   
    input   WVALIDm??2si??;  
    output  WREADYsi??2m??;  

    //Write response channel
//ENABLE_ID
    output   [MASTERID??_WID-1:0]  BIDsi??2m??;     
    output   [BRESP_WID-1:0]        BRESPsi??2m??;   
    output   BVALIDsi??2m??;  
    input    BREADYm??2si??;  
//END_CH
//STATE_END


    //MasterInterface
    //_______________________________________________________________

//INOUT_STATE13_START
    // For slave ??
    //__________________________________________________
    //Write address channel
    output   [SLAVEID??_WID-1:0]AWIDmi??2s??;    
    output   [ADDR_WID-1:0]     AWADDRmi??2s??;
    output   [AWLEN_WID-1:0]    AWLENmi??2s??;
    output   [AWSIZE_WID-1:0]   AWSIZEmi??2s??;  
    output   [AWBURST_WID-1:0]  AWBURSTmi??2s??; 
//ENABLE_LOCK
    output   [AWLOCK_WID-1:0]   AWLOCKmi??2s??;  
//ENABLE_CACHE
    output   [AWCACHE_WID-1:0]  AWCACHEmi??2s??; 
//ENABLE_PROT
    output   [AWPROT_WID-1:0]   AWPROTmi??2s??;  

    output   AWVALIDmi??2s??; 
    input    AWREADYs??2mi??; 
    
    //Write data channel
    output   [SLAVEID??_WID-1:0]WIDmi??2s??;     
    output   [BUS_WID-1:0]      WDATAmi??2s??;   
//ENABLE_WSTRB
    output   [WSTRB_WID-1:0]    WSTRBmi??2s??;   
    output   WLASTmi??2s??;   
    output   WVALIDmi??2s??;  
    input    WREADYs??2mi??; 

    //Write response channel
    input   [SLAVEID??_WID-1:0] BIDs??2mi??;     
    input   [BRESP_WID-1:0]     BRESPs??2mi??;   
    input   BVALIDs??2mi??;  
    output  BREADYmi??2s??;  

//STATE_END

//INOUT_END
