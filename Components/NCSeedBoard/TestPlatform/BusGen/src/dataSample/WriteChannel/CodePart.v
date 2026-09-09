
//STATE00_START
//Master module wire were generated
//Master module ?0? - ?1?
//_____________________________________________________________________

    wire  [MASTERID?0?_WID-1:0]  AWIDsi?0?2mi?1?;    
    wire  [MAXMASTERID_WID-1:0] wAWIDsi?0?2mi?1? = 
             {{BLANKMASTERID?0?_WID{1'b0}},AWIDsi?0?2mi?1?};    
    wire  [ADDR_WID-1:0]        AWADDRsi?0?2mi?1?;  
    wire  [AWLEN_WID-1:0]       AWLENsi?0?2mi?1?;   
    wire  [AWSIZE_WID-1:0]      AWSIZEsi?0?2mi?1?;  
    wire  [AWBURST_WID-1:0]     AWBURSTsi?0?2mi?1?; 
    wire  [AWLOCK_WID-1:0]      AWLOCKsi?0?2mi?1?;  
    wire  [AWCACHE_WID-1:0]     AWCACHEsi?0?2mi?1?; 
    wire  [AWPROT_WID-1:0]      AWPROTsi?0?2mi?1?;
    
    wire  [MASTERID?0?_WID-1:0]  WIDsi?0?2mi?1?;     
    wire  [MAXMASTERID_WID-1:0] wWIDsi?0?2mi?1? =
             {{BLANKMASTERID?0?_WID{1'b0}},WIDsi?0?2mi?1?};    
    wire  [BUS_WID-1:0]         WDATAsi?0?2mi?1?;   
    wire  [WSTRB_WID-1:0]       WSTRBsi?0?2mi?1?;  

//STATE_END


//STATE00_START
    wire    [SLAVE_NUM-1:0]     AWVALIDsi??2mi;
    wire    [SLAVE_NUM-1:0]     AWREADYmi2si??;
    wire    [SLAVE_NUM-1:0]     WLASTsi??2mi;
    wire    [SLAVE_NUM-1:0]     WVALIDsi??2mi;
    wire    [SLAVE_NUM-1:0]     WREADYmi2si??;
    wire    [SLAVE_NUM-1:0]     BVALIDmi2si??;
    wire    [SLAVE_NUM-1:0]     BREADYsi??2mi;
//STATE_END
//_____________________________________________________________________

//STATE01_START
    //Slave Number ?0?(slave interface) to ?1? (master interface)
    wire   [SLAVE_MASTERID?0?_WID-1:0]   BIDmi?0?2si?1?;     
    wire   [BRESP_WID-1:0]               BRESPmi?0?2si?1?; 
//STATE_END

//STATE02_START
//Slave module wire were generated
//Slave module ??    
//_____________________________________________________________________

    wire  [MASTER_NUM-1:0]    AWREADYmi??2si;
    wire  [MASTER_NUM-1:0]    WREADYmi??2si;  
    wire  [MASTER_NUM-1:0]    BVALIDmi??2si;

    wire  [MASTER_NUM-1:0]    AWVALIDsi2mi??;
    wire  [MASTER_NUM-1:0]    WVALIDsi2mi??;
    wire  [MASTER_NUM-1:0]    WLASTsi2mi??;
    wire  [MASTER_NUM-1:0]    BREADYsi2mi??;

    wire  [MASTER_NUM-1:0]    SetAWREADYmi??2si;
    wire  [MASTER_NUM-1:0]    SetWREADYmi??2si;  
    wire  [MASTER_NUM-1:0]    SetBVALIDmi??2si;

//STATE_END

//MaserInterface to SlaveInterface Setting
//_____________________________________________________________________
//STATE03_START
    assign SetAWREADYmi??2si[?W0?] = AWREADYmi??2si[?W1?]; 
//STATE_END

//STATE04_START
    assign  SetWREADYmi??2si[?W0?] = WREADYmi??2si[?W1?];   
//STATE_END

//STATE05_START
    assign SetBVALIDmi??2si[?W0?]  = BVALIDmi??2si[?W1?];
//STATE_END

//AWREADYmi2si///////////////////////
//STATE06_START
    assign  AWREADYmi2si??[?W0?] = SetAWREADYmi?W0?2si[??];
//STATE_END

//BVALIDmi2si////////////////////////
//STATE07_START
    assign  BVALIDmi2si??[?W0?] = SetBVALIDmi?W0?2si[??];
//STATE_END

//WREADYmi2si////////////////////////
//STATE08_START
    assign  WREADYmi2si??[?W0?] = SetWREADYmi?W0?2si[??];
//STATE_END

//_____________________________________________________________________


//SlaveInterface to MasterInterface Setting
//_____________________________________________________________________

//AWVALIDsi2mi////////////////////////
//STATE09_START
    assign  AWVALIDsi2mi?0?[?W0?] = AWVALIDsi?1?2mi[?0?];
//STATE_END

//WVALIDsi2mi////////////////////////
//STATE10_START
    assign  WVALIDsi2mi?0?[?W0?] = WVALIDsi?1?2mi[?0?];
//STATE_END

//WLASTsi2mi////////////////////////
//STATE11_START
    assign  WLASTsi2mi?0?[?W0?] = WLASTsi?1?2mi[?0?];
//STATE_END

//BREADYsi2mi////////////////////////
//STATE12_START
    assign  BREADYsi2mi?0?[?W0?] = BREADYsi?1?2mi[?0?];
//STATE_END

//_____________________________________________________________________


//MASTER_MODULE_GEN
//SLAVE_MODULE_GEN

endmodule
//Code_END
