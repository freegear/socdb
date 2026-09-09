//notice :: don't modify this code


`timescale 1 ns/ 10ps
//INOUT_STATE00_START
module ?BUSNAME?(
//STATE_END

//Write channel signal
//INOUT_STATE01_START
    //_______________________________________________________________
    //For Master ?? :: ?NAME?
    //Write address channel
    AWIDm?NAME?2si??    ,
    AWADDRm?NAME?2si??  ,
    AWLENm?NAME?2si??   ,
    AWSIZEm?NAME?2si??  ,
    AWBURSTm?NAME?2si?? ,
    AWLOCKm?NAME?2si??  ,
    AWCACHEm?NAME?2si?? ,
    AWPROTm?NAME?2si??  ,

    AWVALIDm?NAME?2si?? ,
    AWREADYsi??2m?NAME? ,

    //Write data channel
    WIDm?NAME?2si??     ,
    WDATAm?NAME?2si??   ,
    WSTRBm?NAME?2si??   ,
    WLASTm?NAME?2si??   ,
    WVALIDm?NAME?2si??  ,
    WREADYsi??2m?NAME?  ,

    //Write response channel
    BIDsi??2m?NAME?     ,
    BRESPsi??2m?NAME?   ,
    BVALIDsi??2m?NAME?  ,
    BREADYm?NAME?2si??  ,
//STATE_END

//INOUT_STATE02_START
    //_______________________________________________________________
    //For Slave ?? :: ?NAME?
    //Write address channel
    AWIDmi??2s?NAME?    ,
    AWADDRmi??2s?NAME?  ,
    AWLENmi??2s?NAME?   ,
    AWSIZEmi??2s?NAME?  ,
    AWBURSTmi??2s?NAME? ,
    AWLOCKmi??2s?NAME?  ,
    AWCACHEmi??2s?NAME? ,
    AWPROTmi??2s?NAME?  ,
    AWVALIDmi??2s?NAME? ,
    AWREADYs?NAME?2mi?? ,

    //Write data channel
    WIDmi??2s?NAME?     ,
    WDATAmi??2s?NAME?   ,
    WSTRBmi??2s?NAME?   ,
    WLASTmi??2s?NAME?   ,
    WVALIDmi??2s?NAME?  ,
    WREADYs?NAME?2mi??  ,

    //Write response channel
    BIDs?NAME?2mi??     ,
    BRESPs?NAME?2mi??   ,
    BVALIDs?NAME?2mi??  ,
    BREADYmi??2s?NAME?  ,
//STATE_END


//Read channel signal
//INOUT_STATE03_START
    //_______________________________________________________________
    //For Master ?? :: ?NAME?
    //Read address channel
    ARIDm?NAME?2si??    ,
    ARADDRm?NAME?2si??  ,
    ARLENm?NAME?2si??   ,
    ARSIZEm?NAME?2si??  ,
    ARBURSTm?NAME?2si?? ,
    ARLOCKm?NAME?2si??  ,
    ARCACHEm?NAME?2si?? ,
    ARPROTm?NAME?2si??  ,

    ARVALIDm?NAME?2si?? ,
    ARREADYsi??2m?NAME? ,

    //Read data channel
    RIDsi??2m?NAME?     ,
    RRESPsi??2m?NAME?   ,
    RDATAsi??2m?NAME?   ,
    RLASTsi??2m?NAME?   ,
    RVALIDsi??2m?NAME?  ,
    RREADYm?NAME?2si??  ,
//STATE_END
    
//INOUT_STATE04_START
    //_______________________________________________________________
    //For Slave ?? :: ?NAME?
    ARIDmi??2s?NAME?    ,
    ARADDRmi??2s?NAME?  ,
    ARLENmi??2s?NAME?   ,
    ARSIZEmi??2s?NAME?  ,
    ARBURSTmi??2s?NAME? ,
    ARLOCKmi??2s?NAME?  ,
    ARCACHEmi??2s?NAME? ,
    ARPROTmi??2s?NAME?  ,

    ARVALIDmi??2s?NAME? ,
    ARREADYs?NAME?2mi?? ,

    //Read data channel
    RIDs?NAME?2mi??     ,
    RRESPs?NAME?2mi??   ,
    RDATAs?NAME?2mi??  ,
    RLASTs?NAME?2mi??  ,
    RVALIDs?NAME?2mi??  ,
    RREADYmi??2s?NAME?  ,
//STATE_END

    ACLK    ,
    ARESETn 
);
//DEF_STATE

    input   ACLK;
    input   ARESETn;

    //Write Channel SlaveInterface
    //_______________________________________________________________
//INOUT_STATE05_START
    
    //For Master ?? :: ?NAME?
    //Write address channel
    input   [WRITECHID??_WID-1:0]   AWIDm?NAME?2si??;    
    input   [ADDR_WID-1:0]          AWADDRm?NAME?2si??;
    input   [AWLEN_WID-1:0]         AWLENm?NAME?2si??;
    input   [AWSIZE_WID-1:0]        AWSIZEm?NAME?2si??;  
    input   [AWBURST_WID-1:0]       AWBURSTm?NAME?2si??; 
    input   [AWLOCK_WID-1:0]        AWLOCKm?NAME?2si??;  
    input   [AWCACHE_WID-1:0]       AWCACHEm?NAME?2si??; 
    input   [AWPROT_WID-1:0]        AWPROTm?NAME?2si??;  

    input   AWVALIDm?NAME?2si??; 
    output  AWREADYsi??2m?NAME?; 

    //Write data channel
    input   [WRITECHID??_WID-1:0]    WIDm?NAME?2si??;     
    input   [BUS_WID-1:0]           WDATAm?NAME?2si??;   
    input   [WSTRB_WID-1:0]         WSTRBm?NAME?2si??;   
    input   WLASTm?NAME?2si??;   
    input   WVALIDm?NAME?2si??;  
    output  WREADYsi??2m?NAME?;  

    //Write response channel
    output   [WRITECHID??_WID-1:0]   BIDsi??2m?NAME?;     
    output   [BRESP_WID-1:0]        BRESPsi??2m?NAME?;   
    output   BVALIDsi??2m?NAME?;  
    input    BREADYm?NAME?2si??;  
//STATE_END


    //Write Channel MasterInterface
    //_______________________________________________________________
//INOUT_STATE06_START
   
    // For slave ?? :: ?NAME?
    //__________________________________________________
    //Write address channel
    output   [WR_SLAVEID??_WID-1:0]AWIDmi??2s?NAME?;    
    output   [ADDR_WID-1:0]     AWADDRmi??2s?NAME?;
    output   [AWLEN_WID-1:0]    AWLENmi??2s?NAME?;
    output   [AWSIZE_WID-1:0]   AWSIZEmi??2s?NAME?;  
    output   [AWBURST_WID-1:0]  AWBURSTmi??2s?NAME?; 
    output   [AWLOCK_WID-1:0]   AWLOCKmi??2s?NAME?;  
    output   [AWCACHE_WID-1:0]  AWCACHEmi??2s?NAME?; 
    output   [AWPROT_WID-1:0]   AWPROTmi??2s?NAME?;  

    output   AWVALIDmi??2s?NAME?; 
    input    AWREADYs?NAME?2mi??; 
    
    //Write data channel
    output   [WR_SLAVEID??_WID-1:0]WIDmi??2s?NAME?;     
    output   [BUS_WID-1:0]      WDATAmi??2s?NAME?;   
    output   [WSTRB_WID-1:0]    WSTRBmi??2s?NAME?;   
    output   WLASTmi??2s?NAME?;   
    output   WVALIDmi??2s?NAME?;  
    input    WREADYs?NAME?2mi??; 

    //Write response channel
    input   [WR_SLAVEID??_WID-1:0] BIDs?NAME?2mi??;     
    input   [BRESP_WID-1:0]     BRESPs?NAME?2mi??;   
    input   BVALIDs?NAME?2mi??;  
    output  BREADYmi??2s?NAME?;  
//STATE_END


    //Read Channel SlaveInterface
    //_______________________________________________________________
//INOUT_STATE07_START
    
    //For Master ?? :: ?NAME?
    //Read address channel
    input   [READCHID??_WID-1:0]ARIDm?NAME?2si??;    
    input   [ADDR_WID-1:0]     ARADDRm?NAME?2si??;
    input   [ARLEN_WID-1:0]    ARLENm?NAME?2si??;
    input   [ARSIZE_WID-1:0]   ARSIZEm?NAME?2si??;  
    input   [ARBURST_WID-1:0]  ARBURSTm?NAME?2si??; 
    input   [ARLOCK_WID-1:0]   ARLOCKm?NAME?2si??;  
    input   [ARCACHE_WID-1:0]  ARCACHEm?NAME?2si??; 
    input   [ARPROT_WID-1:0]   ARPROTm?NAME?2si??;  

    input   ARVALIDm?NAME?2si??; 
    output  ARREADYsi??2m?NAME?; 

    //Read data channel
    output   [READCHID??_WID-1:0]RIDsi??2m?NAME?;     
    output   [BRESP_WID-1:0]   RRESPsi??2m?NAME?;   
    output   [BUS_WID-1:0]     RDATAsi??2m?NAME?;
    output   RLASTsi??2m?NAME?;
    output   RVALIDsi??2m?NAME?;  
    input    RREADYm?NAME?2si??;  

//STATE_END


    //MasterInterface
    //_______________________________________________________________
//INOUT_STATE08_START
    
    // For slave ??
    //__________________________________________________

    // Read address channel
    output   [RD_SLAVEID??_WID-1:0]ARIDmi??2s?NAME?;    
    output   [ADDR_WID-1:0]     ARADDRmi??2s?NAME?;
    output   [ARLEN_WID-1:0]    ARLENmi??2s?NAME?;
    output   [ARSIZE_WID-1:0]   ARSIZEmi??2s?NAME?;  
    output   [ARBURST_WID-1:0]  ARBURSTmi??2s?NAME?; 
    output   [ARLOCK_WID-1:0]   ARLOCKmi??2s?NAME?;  
    output   [ARCACHE_WID-1:0]  ARCACHEmi??2s?NAME?; 
    output   [ARPROT_WID-1:0]   ARPROTmi??2s?NAME?;  

    output   ARVALIDmi??2s?NAME?; 
    input    ARREADYs?NAME?2mi??; 
    

    //Read data channel
    input   [RD_SLAVEID??_WID-1:0] RIDs?NAME?2mi??;     
    input   [RRESP_WID-1:0]     RRESPs?NAME?2mi??;   
    input   [BUS_WID-1:0]       RDATAs?NAME?2mi??;  
    input   RLASTs?NAME?2mi??;  
    input   RVALIDs?NAME?2mi??;  
    output  RREADYmi??2s?NAME?;  

//STATE_END
    //_______________________________________________________________
//INOUT_END
