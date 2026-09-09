
//Master module ??    
//_____________________________________________________________________

?NAME?_RS_ReadChannelsi
?NAME?_RS_ReadChannelsi(

    ///////////////////////////////////////////////
    //Read address channel
//ENABLE_ID
    .ARIDm2si    (ARIDm??2si??),
    .ARADDRm2si  (ARADDRm??2si??),
    .ARLENm2si   (ARLENm??2si??),
    .ARSIZEm2si  (ARSIZEm??2si??),
    .ARBURSTm2si (ARBURSTm??2si??),
//ENABLE_LOCK
    .ARLOCKm2si  (ARLOCKm??2si??),
//ENABLE_CACHE
    .ARCACHEm2si (ARCACHEm??2si??),
//ENABLE_PROT
    .ARPROTm2si  (ARPROTm??2si??),

    .ARVALIDm2si (ARVALIDm??2si??),
    .ARREADYsi2m (ARREADYsi??2m??),

    //Read data channel
//ENABLE_ID
    .RIDsi2m     (RIDsi??2m??),
    .RRESPsi2m   (RRESPsi??2m??),
    .RVALIDsi2m  (RVALIDsi??2m??),
    .RDATAsi2m   (RDATAsi??2m??),
    .RREADYm2si  (RREADYm??2si??),
    .RLASTsi2m   (RLASTsi??2m??),


//STATE00_START
    
    ///////////////////////////////////////////////
    //For Master interface
    //Read address channel
    .ARIDsi2mi??    (ARIDsi?W?2mi??),
    .ARADDRsi2mi??  (ARADDRsi?W?2mi??),
    .ARLENsi2mi??   (ARLENsi?W?2mi??),
    .ARSIZEsi2mi??  (ARSIZEsi?W?2mi??),
    .ARBURSTsi2mi?? (ARBURSTsi?W?2mi??),
    .ARLOCKsi2mi??  (ARLOCKsi?W?2mi??),
    .ARCACHEsi2mi?? (ARCACHEsi?W?2mi??),
    .ARPROTsi2mi??  (ARPROTsi?W?2mi??),


    //Slave Number ??
    .RIDmi??2si     (RIDmi??2si?W?[MASTERID?W?_WID-1:0]),
    .RRESPmi??2si   (RRESPmi??2si?W?),
    .RDATAmi??2si   (RDATAmi??2si?W?),
//STATE_END

    .ARVALIDsi2mi (ARVALIDsi??2mi),
    .ARREADYmi2si (ARREADYmi2si??),

    .RVALIDmi2si  (RVALIDmi2si??),
    .RREADYsi2mi  (RREADYsi??2mi),
    .RLASTmi2si	  (RLASTmi2si??),

    //Global signal
    .ACLK    (ACLK),
    .ARESETn (ARESETn)
);
//Code_END
