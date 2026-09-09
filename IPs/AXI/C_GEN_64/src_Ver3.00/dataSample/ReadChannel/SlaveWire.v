
//Slave module ??    
//_____________________________________________________________________

?NAME?_RS_ReadChannelmi
?NAME?_RS_ReadChannelmi(

    //Global signal
    .ACLK    (ACLK),
    .ARESETn (ARESETn),

    //For slave 
    //////////////////////////////////////////////
    //Read address channel
    .ARIDmi2s    (ARIDmi??2s??),
    .ARADDRmi2s  (ARADDRmi??2s??),
    .ARLENmi2s   (ARLENmi??2s??),
    .ARSIZEmi2s  (ARSIZEmi??2s??),
    .ARBURSTmi2s (ARBURSTmi??2s??),
//ENABLE_LOCK
    .ARLOCKmi2s  (ARLOCKmi??2s??),
//ENABLE_CACHE
    .ARCACHEmi2s (ARCACHEmi??2s??),
//ENABLE_PROT
    .ARPROTmi2s  (ARPROTmi??2s??),

    .ARVALIDmi2s (ARVALIDmi??2s??),
    .ARREADYs2mi (ARREADYs??2mi??),

    //Read data channel
    .RIDs2mi     (RIDs??2mi??),
    .RRESPs2mi   (RRESPs??2mi??),
    .RDATAs2mi   (RDATAs??2mi??),
    .RVALIDs2mi  (RVALIDs??2mi??),
    .RLASTs2mi   (RLASTs??2mi??),
    .RREADYmi2s  (RREADYmi??2s??),
    //////////////////////////////////////////////


//STATE00_START
    //Master Number ??
    .ARIDsi?1?2mi    (wARIDsi??2mi?W?[SLAVE_MASTERID?W?_WID-1:0]),
    .ARADDRsi?1?2mi  (ARADDRsi??2mi?W?),
    .ARLENsi?1?2mi   (ARLENsi??2mi?W?),
    .ARSIZEsi?1?2mi  (ARSIZEsi??2mi?W?),
    .ARBURSTsi?1?2mi (ARBURSTsi??2mi?W?),
    .ARLOCKsi?1?2mi  (ARLOCKsi??2mi?W?),
    .ARCACHEsi?1?2mi (ARCACHEsi??2mi?W?),
    .ARPROTsi?1?2mi  (ARPROTsi??2mi?W?),


    //Read data channel
    .RIDmi2si?1?     (RIDmi?W?2si??),
    .RRESPmi2si?1?   (RRESPmi?W?2si??),
    .RDATAmi2si?1?   (RDATAmi?W?2si??),

//STATE_END
    
    .RVALIDmi2si  (RVALIDmi??2si),
    .RLASTmi2si   (RLASTmi??2si),
    .RREADYsi2mi  (RREADYsi2mi??),

    //Lock access
    ////////////////////////////////////////

    .Lock2Rdmi      (Lock2rdmi??),
    .UnLock2Rdmi    (UnLock2rdmi??),

    .Lock2Wrmi      (Lock2wrmi??),
    .UnLock2Wrmi    (UnLock2wrmi??),

    .AWVALID        (AWVALIDmi??2s??),
    .LockPort       (LockPort2rdmi??),
    .ReadIntEmptyWrmi2Rdmi  (ReadIntEmptyWrmi??2Rdmi??),
    .DataCntEmptyRdmi2Wrmi  (DataCntEmptyRdmi??2Wrmi??),
    .CtlDataRead2Lock       (CtlDataRead2Lock??),

    ////////////////////////////////////////
    
    //Master 0/1/2/3 and so on...
    .ARVALIDsi2mi  (ARVALIDsi2mi??),
    .ARREADYmi2si  (ARREADYmi??2si)
);
//Code_END
