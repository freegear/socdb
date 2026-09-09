//notice :: don't modify this code
`timescale 1 ns/ 10ps
module  ?NAME?_ReadChannelsi(

    //Global signal
    ACLK    ,
    ARESETn ,

    //Read address channel
//ENABLE_ID
    ARIDm2si    ,
    ARADDRm2si  ,
    ARLENm2si   ,
    ARSIZEm2si  ,
    ARBURSTm2si ,
//ENABLE_LOCK
    ARLOCKm2si  ,
//ENABLE_CACHE
    ARCACHEm2si ,
//ENABLE_PROT
    ARPROTm2si  ,

    ARVALIDm2si ,
    ARREADYsi2m ,

    //Read data channel
//ENABLE_ID
    RIDsi2m     ,
    RRESPsi2m   ,
    RVALIDsi2m  ,
    RDATAsi2m   ,
    RREADYm2si  ,
    RLASTsi2m   ,

//INOUT_STATE00_START
    
    //For Master interface slave Number = ??
    //Read address channel
    ARIDsi2mi??    ,
    ARADDRsi2mi??  ,
    ARLENsi2mi??   ,
    ARSIZEsi2mi??  ,
    ARBURSTsi2mi?? ,
    ARLOCKsi2mi??  ,
    ARCACHEsi2mi?? ,
    ARPROTsi2mi??  ,
//STATE_END

    ARVALIDsi2mi ,
    ARREADYmi2si ,

    //Slave interface signal
    /////////////////////////////////////////////////////////////

//INOUT_STATE00_START
    
    //Slave??
    //Read data channel
    //____________________________________
    RIDmi??2si     ,
    RRESPmi??2si   ,
    RDATAmi??2si   ,

//STATE_END

    RVALIDmi2si  ,
    RREADYsi2mi  ,
    RLASTmi2si
);

//DEF_STATE

    input   ACLK;
    input   ARESETn;

    //Read Address channel
    input   [ADDR_WID-1:0]     ARADDRm2si;
    input   [ARLEN_WID-1:0]    ARLENm2si;
    input   [ARSIZE_WID-1:0]   ARSIZEm2si;  
    input   [ARBURST_WID-1:0]  ARBURSTm2si; 
//ENABLE_ID
    input   [MASTERID_WID-1:0] ARIDm2si;    
//ENABLE_LOCK
    input   [ARLOCK_WID-1:0]   ARLOCKm2si;  
//ENABLE_CACHE
    input   [ARCACHE_WID-1:0]  ARCACHEm2si; 
//ENABLE_PROT
    input   [ARPROT_WID-1:0]   ARPROTm2si;  

    input   ARVALIDm2si; 
    output  ARREADYsi2m; 

    //Read data channel
//ENABLE_ID
    output   [MASTERID_WID-1:0]RIDsi2m;     
    output   [RRESP_WID-1:0]   RRESPsi2m;   
    output   [BUS_WID-1:0]     RDATAsi2m;
    output   RVALIDsi2m;  
    input    RREADYm2si;  
    output   RLASTsi2m;   

//INOUT_STATE01_START
    //For Master interface SlaveNum = ??
    //Write address channel
    output  [MASTERID_WID-1:0] ARIDsi2mi??;    
    output  [ADDR_WID-1:0] ARADDRsi2mi??;  
    output  [ARLEN_WID-1:0] ARLENsi2mi??;   
    output  [ARSIZE_WID-1:0] ARSIZEsi2mi??;  
    output  [ARBURST_WID-1:0] ARBURSTsi2mi??; 
//ENABLE_LOCK_ReadOutput
    output  [ARLOCK_WID-1:0] ARLOCKsi2mi??;  
//ENABLE_CACHE_ReadOutput
    output  [ARCACHE_WID-1:0] ARCACHEsi2mi??; 
//ENABLE_PROT_ReadOutput
    output  [ARPROT_WID-1:0] ARPROTsi2mi??;  

//STATE_END

    output  [SLAVE_NUM-1:0]ARVALIDsi2mi; 
    input   [SLAVE_NUM-1:0]ARREADYmi2si; 

    //From SI(slave interface)
//INOUT_STATE01_START
    
    //Slave??
    //__________________________________________________
    input   [MASTERID_WID-1:0]    RIDmi??2si;     
    input   [RRESP_WID-1:0] RRESPmi??2si;   
    input   [BUS_WID-1:0]   RDATAmi??2si;

//STATE_END

    input   [SLAVE_NUM-1:0] RVALIDmi2si;  
    input   [SLAVE_NUM-1:0] RLASTmi2si;  
    output  [SLAVE_NUM-1:0] RREADYsi2mi;    

//INOUT_END
