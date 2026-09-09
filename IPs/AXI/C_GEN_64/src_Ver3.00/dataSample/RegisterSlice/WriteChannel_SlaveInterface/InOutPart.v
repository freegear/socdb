//notice :: don't modify this code
`timescale 1 ns/ 10ps
module  ?NAME?_WriteChannelsi(

    SelMAP1,

    //Global signal
    ACLK    ,
    ARESETn ,

    //For Master
    //Write address channel
    AWIDm2si    ,
    AWADDRm2si  ,
    AWLENm2si   ,
    AWSIZEm2si  ,
    AWBURSTm2si ,
    AWLOCKm2si  ,
    AWCACHEm2si ,
    AWPROTm2si  ,

    AWVALIDm2si ,
    AWREADYsi2m ,

    //Write data channel
    WIDm2si     ,
    WDATAm2si   ,
    WSTRBm2si   ,
    WLASTm2si   ,
    WVALIDm2si  ,
    WREADYsi2m  ,

    //Write response channel
    BIDsi2m     ,
    BRESPsi2m   ,
    BVALIDsi2m  ,
    BREADYm2si  ,

    //For Master interface
    //Write address channel
    AWIDsi2mi    ,
    AWADDRsi2mi  ,
    AWLENsi2mi   ,
    AWSIZEsi2mi  ,
    AWBURSTsi2mi ,
    AWLOCKsi2mi  ,
    AWCACHEsi2mi ,
    AWPROTsi2mi  ,
    AWVALIDsi2mi ,
    AWREADYmi2si ,

    //Write data channel
    WIDsi2mi     ,
    WDATAsi2mi   ,
    WSTRBsi2mi   ,
    WLASTsi2mi   ,
    WVALIDsi2mi  ,
    WREADYmi2si  ,

    //Write response channel

//INOUT_STATE00_START
    
    //Slave Number ??
    BIDmi??2si     ,
    BRESPmi??2si   ,
//STATE_END

    BVALIDmi2si  ,
    BREADYsi2mi
);
//DEF_STATE

    input   SelMAP1;
    input   ACLK;
    input   ARESETn;

    //For Master
    //Write address channel
    input   [MASTERID_WID-1:0] AWIDm2si;    
    input   [ADDR_WID-1:0]     AWADDRm2si;
    input   [AWLEN_WID-1:0]    AWLENm2si;
    input   [AWSIZE_WID-1:0]   AWSIZEm2si;  
    input   [AWBURST_WID-1:0]  AWBURSTm2si; 
    input   [AWLOCK_WID-1:0]   AWLOCKm2si;  
    input   [AWCACHE_WID-1:0]  AWCACHEm2si; 
    input   [AWPROT_WID-1:0]   AWPROTm2si;  

    input   AWVALIDm2si; 
    output  AWREADYsi2m; 

    //Write data channel
    input   [MASTERID_WID-1:0] WIDm2si;     
    input   [BUS_WID-1:0]      WDATAm2si;   
    input   [WSTRB_WID-1:0]    WSTRBm2si;   
    input   WLASTm2si;   
    input   WVALIDm2si;  
    output  WREADYsi2m;  

    //Write response channel
    output   [MASTERID_WID-1:0]BIDsi2m;     
    output   [BRESP_WID-1:0]   BRESPsi2m;   
    output   BVALIDsi2m;  
    input    BREADYm2si;  

    //For Master interface
    //Write address channel
    output  [MASTERID_WID-1:0] AWIDsi2mi;    
    output  [ADDR_WID-1:0] AWADDRsi2mi;  
    output  [AWLEN_WID-1:0] AWLENsi2mi;   
    output  [AWSIZE_WID-1:0] AWSIZEsi2mi;  
    output  [AWBURST_WID-1:0] AWBURSTsi2mi; 
    output  [AWLOCK_WID-1:0] AWLOCKsi2mi;  
    output  [AWCACHE_WID-1:0] AWCACHEsi2mi; 
    output  [AWPROT_WID-1:0] AWPROTsi2mi;  
    output  [SLAVE_NUM-1:0]AWVALIDsi2mi; 
    input   [SLAVE_NUM-1:0]AWREADYmi2si; 

    //Write data channel
    output  [MASTERID_WID-1:0] WIDsi2mi;     
    output  [BUS_WID-1:0] WDATAsi2mi;   
    output  [WSTRB_WID-1:0]WSTRBsi2mi;   
    output  [SLAVE_NUM-1:0]WLASTsi2mi;   
    output  [SLAVE_NUM-1:0]WVALIDsi2mi;  
    input   [SLAVE_NUM-1:0]WREADYmi2si;  

    //Write response channel
//INOUT_STATE01_START

    //Slave Number ??
    input   [MASTERID_WID-1:0] BIDmi??2si;     
    input   [BRESP_WID-1:0] BRESPmi??2si;   
//STATE_END
    
    input   [SLAVE_NUM-1:0]BVALIDmi2si;  
    output  [SLAVE_NUM-1:0]BREADYsi2mi;

//INOUT_END
