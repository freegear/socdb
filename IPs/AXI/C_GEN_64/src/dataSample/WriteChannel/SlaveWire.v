
//Slave module ??    
//___________________________________________________________________________

?NAME?_RS_WriteChannelmi
?NAME?_RS_WriteChannelmi(

    //Global signal
    .ACLK    (ACLK),
    .ARESETn (ARESETn),

    //For slave 
    //////////////////////////////////////////////
    //Write address channel
    .AWIDmi2s    (AWIDmi??2s??),
    .AWADDRmi2s  (AWADDRmi??2s??),
    .AWLENmi2s   (AWLENmi??2s??),
    .AWSIZEmi2s  (AWSIZEmi??2s??),
    .AWBURSTmi2s (AWBURSTmi??2s??),
//ENABLE_LOCK
    .AWLOCKmi2s  (AWLOCKmi??2s??),
//ENABLE_CACHE
    .AWCACHEmi2s (AWCACHEmi??2s??),
//ENABLE_PROT
    .AWPROTmi2s  (AWPROTmi??2s??),

    .AWVALIDmi2s (AWVALIDmi??2s??),
    .AWREADYs2mi (AWREADYs??2mi??),

    //Write data channel
    .WIDmi2s     (WIDmi??2s??),
    .WDATAmi2s   (WDATAmi??2s??),
//ENABLE_WSTRB
    .WSTRBmi2s   (WSTRBmi??2s??),
    .WLASTmi2s   (WLASTmi??2s??),
    .WVALIDmi2s  (WVALIDmi??2s??),
    .WREADYs2mi  (WREADYs??2mi??),

    //Write response channel
    .BIDs2mi     (BIDs??2mi??),
    .BRESPs2mi   (BRESPs??2mi??),
    .BVALIDs2mi  (BVALIDs??2mi??),
    .BREADYmi2s  (BREADYmi??2s??),

    //////////////////////////////////////////////

//STATE00_START
    //Master Number ??
    //Write address channel
    .AWIDsi?1?2mi    (wAWIDsi??2mi?W?[SLAVE_MASTERID?W?_WID-1:0]),
    .AWADDRsi?1?2mi  (AWADDRsi??2mi?W?),
    .AWLENsi?1?2mi   (AWLENsi??2mi?W?),
    .AWSIZEsi?1?2mi  (AWSIZEsi??2mi?W?),
    .AWBURSTsi?1?2mi (AWBURSTsi??2mi?W?),
    .AWLOCKsi?1?2mi  (AWLOCKsi??2mi?W?),
    .AWCACHEsi?1?2mi (AWCACHEsi??2mi?W?),
    .AWPROTsi?1?2mi  (AWPROTsi??2mi?W?),

    //Write data channel
    .WIDsi?1?2mi   (wWIDsi??2mi?W?[SLAVE_MASTERID?W?_WID-1:0]),     
    .WDATAsi?1?2mi (WDATAsi??2mi?W?),   
    .WSTRBsi?1?2mi (WSTRBsi??2mi?W?),   

    //Write response channel
    .BIDmi2si?1?     (BIDmi?W?2si??),
    .BRESPmi2si?1?   (BRESPmi?W?2si??),
//STATE_END

    .BVALIDmi2si  (BVALIDmi??2si),
    .BREADYsi2mi   (BREADYsi2mi??),
    //////////////////////////////////////////////
    
    //Master 0/1/2/3 and so on...
    .AWVALIDsi2mi  (AWVALIDsi2mi??),
    .AWREADYmi2si  (AWREADYmi??2si),
    .WLASTsi2mi    (WLASTsi2mi??),
    .WVALIDsi2mi   (WVALIDsi2mi??),
    .WREADYmi2si   (WREADYmi??2si),

    //Lock access
    ////////////////////////////////////////
    .Lock2Wrmi(Lock2wrmi??),
    .UnLock2Wrmi(UnLock2wrmi??),

    .Lock2Rdmi(Lock2rdmi??),
    .UnLock2Rdmi(UnLock2rdmi??),

    .ARVALID(ARVALIDmi??2s??),
    .LockPort(LockPort2wrmi??),
    .ReadIntEmptyWrmi2Rdmi(ReadIntEmptyWrmi??2Rdmi??),
    .DataCntEmptyRdmi2Wrmi(DataCntEmptyRdmi??2Wrmi??),
    .CtlDataWrite2Lock(CtlDataWrite2Lock??)
    ////////////////////////////////////////

    );
//Code_END


