
//STATE00_START
//Master module wire were generated
//Master module ?0? - ?1?   
//_____________________________________________________________________

    wire  [MASTERID?0?_WID-1:0]ARIDsi?0?2mi?1?;    
    wire  [MAXMASTERID_WID-1:0]wARIDsi?0?2mi?1? =    
//Zero
?3?
            {{BLANKMASTERID?0?_WID{1'b0}},ARIDsi?0?2mi?1?};    
                                          ARIDsi?0?2mi?1?;    
    wire  [ADDR_WID-1:0]    ARADDRsi?0?2mi?1?;  
    wire  [ARLEN_WID-1:0]   ARLENsi?0?2mi?1?;   
    wire  [ARSIZE_WID-1:0]  ARSIZEsi?0?2mi?1?;  
    wire  [ARBURST_WID-1:0] ARBURSTsi?0?2mi?1?; 
    wire  [ARLOCK_WID-1:0]  ARLOCKsi?0?2mi?1?;  
    wire  [ARCACHE_WID-1:0] ARCACHEsi?0?2mi?1?; 
    wire  [ARPROT_WID-1:0]  ARPROTsi?0?2mi?1?;

//STATE_END
    
//STATE00_START
    wire  [SLAVE_NUM-1:0]   ARVALIDsi??2mi;
    wire  [SLAVE_NUM-1:0]   ARREADYmi2si??;
    wire  [SLAVE_NUM-1:0]   RVALIDmi2si??;
    wire  [SLAVE_NUM-1:0]   RLASTmi2si??;
    wire  [SLAVE_NUM-1:0]   RREADYsi??2mi;	
//STATE_END
//_____________________________________________________________________

//STATE01_START
    //Slave Number ?0?(master interface) to ?1? (slave interface)
    wire   [SLAVE_MASTERID?0?_WID-1:0] RIDmi?0?2si?1?;     
    wire   [RRESP_WID-1:0]            RRESPmi?0?2si?1?;   
    wire   [BUS_WID-1:0]              RDATAmi?0?2si?1?;
//STATE_END

//STATE02_START
//Slave module wire were generated
//Slave module ??    
//_____________________________________________________________________

    wire    [MASTER_NUM-1:0] ARVALIDsi2mi??;
    wire    [MASTER_NUM-1:0] ARREADYmi??2si;
    wire    [MASTER_NUM-1:0] RVALIDmi??2si;
    wire    [MASTER_NUM-1:0] RLASTmi??2si;
    wire    [MASTER_NUM-1:0] RREADYsi2mi??;

    wire    [MASTER_NUM-1:0] SetARREADYmi??2si;
    wire    [MASTER_NUM-1:0] SetRVALIDmi??2si;
    wire    [MASTER_NUM-1:0] SetRLASTmi??2si;
//STATE_END
//_____________________________________________________________________

//MaserInterface to SlaveInterface Setting
//_____________________________________________________________________
//STATE03_START
    assign SetARREADYmi??2si[?W0?] = ARREADYmi??2si[?W1?]; 
//STATE_END

//STATE04_START
    assign SetRVALIDmi??2si[?W0?]  = RVALIDmi??2si[?W1?];
//STATE_END

//STATE05_START
    assign SetRLASTmi??2si[?W0?]  = RLASTmi??2si[?W1?];
//STATE_END

//ARREADYmi2si///////////////////////
//STATE06_START
    assign  ARREADYmi2si??[?W0?] = SetARREADYmi?W0?2si[??];
//STATE_END

//RVALIDmi2si////////////////////////
//STATE07_START
    assign  RVALIDmi2si??[?W0?] = SetRVALIDmi?W0?2si[??];
//STATE_END

//RLASTmi2si////////////////////////
//STATE08_START
    assign  RLASTmi2si??[?W0?] = SetRLASTmi?W0?2si[??];
//STATE_END


//SlaveInterface to MasterInterface Setting
//_____________________________________________________________________

//ARVALIDsi2mi////////////////////////
//STATE09_START
    assign  ARVALIDsi2mi?0?[?W0?] = ARVALIDsi?1?2mi[?0?];
//STATE_END

//RREADYsi2mi////////////////////////
//STATE10_START
    assign  RREADYsi2mi?0?[?W0?] = RREADYsi?1?2mi[?0?];
//STATE_END


//MASTER_MODULE_GEN
//SLAVE_MODULE_GEN

endmodule
//Zero
//END
//Code_END
