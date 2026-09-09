
//Master module ??    
//________________________________________________________________________

?NAME?_RS_WriteChannelsi
?NAME?_RS_WriteChannelsi(

    //For Master
    //Write address channel
    ///////////////////////////////////////////////
//ENABLE_ID
    .AWIDm2si    (AWIDm??2si??),
    .AWADDRm2si  (AWADDRm??2si??),
    .AWLENm2si   (AWLENm??2si??),
    .AWSIZEm2si  (AWSIZEm??2si??),
    .AWBURSTm2si (AWBURSTm??2si??),
//ENABLE_LOCK
    .AWLOCKm2si  (AWLOCKm??2si??),
//ENABLE_CACHE
    .AWCACHEm2si (AWCACHEm??2si??),
//ENABLE_PROT
    .AWPROTm2si  (AWPROTm??2si??),

    .AWVALIDm2si (AWVALIDm??2si??),
    .AWREADYsi2m (AWREADYsi??2m??),

    //Write data channel
//ENABLE_ID
    .WIDm2si     (WIDm??2si??),
    .WDATAm2si   (WDATAm??2si??),
//ENABLE_WSTRB
    .WSTRBm2si   (WSTRBm??2si??),
    .WLASTm2si   (WLASTm??2si??),
    .WVALIDm2si  (WVALIDm??2si??),
    .WREADYsi2m  (WREADYsi??2m??),

    //Write response channel
//ENABLE_ID
    .BIDsi2m     (BIDsi??2m??),
    .BRESPsi2m   (BRESPsi??2m??),
    .BVALIDsi2m  (BVALIDsi??2m??),
    .BREADYm2si  (BREADYm??2si??),

//STATE00_START
    ///////////////////////////////////////////////
    //For Master interface
    //Write address channel
    .AWIDsi2mi??    (AWIDsi?W?2mi??),
    .AWADDRsi2mi??  (AWADDRsi?W?2mi??),
    .AWLENsi2mi??   (AWLENsi?W?2mi??),
    .AWSIZEsi2mi??  (AWSIZEsi?W?2mi??),
    .AWBURSTsi2mi?? (AWBURSTsi?W?2mi??),
    .AWLOCKsi2mi??  (AWLOCKsi?W?2mi??),
    .AWCACHEsi2mi?? (AWCACHEsi?W?2mi??),
    .AWPROTsi2mi??  (AWPROTsi?W?2mi??),

    //Write data channel
    .WIDsi2mi??     (WIDsi?W?2mi??),
    .WDATAsi2mi??   (WDATAsi?W?2mi??),
    .WSTRBsi2mi??   (WSTRBsi?W?2mi??),

    //Write response channel

    //Slave Number ??
    .BIDmi??2si     (BIDmi??2si?W?[MASTERID?W?_WID-1:0]),
    .BRESPmi??2si   (BRESPmi??2si?W?),
//STATE_END

    .AWVALIDsi2mi (AWVALIDsi??2mi),
    .AWREADYmi2si (AWREADYmi2si??),

    .WLASTsi2mi   (WLASTsi??2mi),
    .WVALIDsi2mi  (WVALIDsi??2mi),
    .WREADYmi2si  (WREADYmi2si??),

    .BVALIDmi2si    (BVALIDmi2si??),
    .BREADYsi2mi    (BREADYsi??2mi),

    //Global signal
    .ACLK    (ACLK),
    .ARESETn (ARESETn)
);
//Code_END


