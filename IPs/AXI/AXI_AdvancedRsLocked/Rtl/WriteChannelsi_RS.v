module  WriteChannelsi_RS(

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
    BIDmi02si     ,
    BRESPmi02si   ,

    BIDmi12si     ,
    BRESPmi12si   ,

    BIDmi22si     ,
    BRESPmi22si   ,
    
    BIDmi32si     ,
    BRESPmi32si   ,

    BIDmi42si     ,
    BRESPmi42si   ,

    BIDmi52si     ,
    BRESPmi52si   ,

    BVALIDmi2si  ,
    BREADYsi2mi
);
`include "Def.v"

    input   ACLK;
    input   ARESETn;
    //_________________________________________________________________
    //For Master
    //Write address channel
    input   [ID_WID-1:0]       AWIDm2si;    
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
    input   [ID_WID-1:0]       WIDm2si;     
    input   [BUS_WID-1:0]      WDATAm2si;   
    input   [WSTRB_WID-1:0]    WSTRBm2si;   
    input   WLASTm2si;   
    input   WVALIDm2si;  
    output  WREADYsi2m;  

    //Write response channel
    output   [ID_WID-1:0]      BIDsi2m;     
    output   [BRESP_WID-1:0]   BRESPsi2m;   
    output   BVALIDsi2m;  
    input    BREADYm2si;  


    //_________________________________________________________________





    //For Master interface
    //Write address channel
    output  [ID_WID-1:0] AWIDsi2mi;    
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
    output  [ID_WID-1:0] WIDsi2mi;     
    output  [BUS_WID-1:0] WDATAsi2mi;   
    output  [WSTRB_WID-1:0]WSTRBsi2mi;   
    output  [SLAVE_NUM-1:0]WLASTsi2mi;   
    output  [SLAVE_NUM-1:0]WVALIDsi2mi;  
    input   [SLAVE_NUM-1:0]WREADYmi2si;  

    //Write response channel
    input   [ID_WID-1:0] BIDmi02si;     
    input   [BRESP_WID-1:0] BRESPmi02si;   

    input   [ID_WID-1:0] BIDmi12si;     
    input   [BRESP_WID-1:0] BRESPmi12si;   

    input   [ID_WID-1:0] BIDmi22si;     
    input   [BRESP_WID-1:0] BRESPmi22si;   

    input   [ID_WID-1:0] BIDmi32si;     
    input   [BRESP_WID-1:0] BRESPmi32si;   

    input   [ID_WID-1:0] BIDmi42si;     
    input   [BRESP_WID-1:0] BRESPmi42si;   

    input   [ID_WID-1:0] BIDmi52si;     
    input   [BRESP_WID-1:0] BRESPmi52si;   

    input   [SLAVE_NUM-1:0]BVALIDmi2si;  
    output  [SLAVE_NUM-1:0]BREADYsi2mi;    

//_______________________________________________
//Register Slice for Address write channel

    //for register slice
    wire   [ID_WID-1:0]       wAWIDm2si;    
    wire   [ADDR_WID-1:0]     wAWADDRm2si;
    wire   [AWLEN_WID-1:0]    wAWLENm2si;
    wire   [AWSIZE_WID-1:0]   wAWSIZEm2si;  
    wire   [AWBURST_WID-1:0]  wAWBURSTm2si; 
    wire   [AWLOCK_WID-1:0]   wAWLOCKm2si;  
    wire   [AWCACHE_WID-1:0]  wAWCACHEm2si; 
    wire   [AWPROT_WID-1:0]   wAWPROTm2si;  
    wire   wAWVALIDm2si; 
    wire   wAWREADYsi2m; 

    //for register slice
    wire   [ID_WID-1:0]       wWIDm2si;     
    wire   [BUS_WID-1:0]      wWDATAm2si;   
    wire   [WSTRB_WID-1:0]    wWSTRBm2si;   
    wire   wWLASTm2si;   
    wire   wWVALIDm2si;  
    wire   wWREADYsi2m;  

    //for register slice
    wire   [ID_WID-1:0]      wBIDsi2m;     
    wire   [BRESP_WID-1:0]   wBRESPsi2m;   
    wire   wBVALIDsi2m;  
    wire   wBREADYm2si;  


//ADDRESS Write channel
AW_fully_registered AW0_fully_registered 
(
		.ACLK         (ACLK         ), 
		.ARESETn      (ARESETn      ), 
		.INFORMATION_S({AWIDm2si, AWADDRm2si, AWLENm2si, AWSIZEm2si, 
                        AWBURSTm2si, AWLOCKm2si, AWCACHEm2si, AWPROTm2si}),
		.VALID_S      (AWVALIDm2si  ),
		.READY_S      (AWREADYsi2m  ),

		.INFORMATION_R({wAWIDm2si, wAWADDRm2si, wAWLENm2si, wAWSIZEm2si, 
                        wAWBURSTm2si, wAWLOCKm2si, wAWCACHEm2si, wAWPROTm2si}),

		.VALID_R      (wAWVALIDm2si ),
		.READY_R      (wAWREADYsi2m )
);

//Write DATA channel
WD_fully_registered WD0_fully_registered 
(
		.ACLK         (ACLK         ), 
		.ARESETn      (ARESETn      ), 
		.INFORMATION_S({WIDm2si, WDATAm2si, WSTRBm2si, WLASTm2si}), 

		.VALID_S      (WVALIDm2si  ),
		.READY_S      (WREADYsi2m  ),

		.INFORMATION_R({wWIDm2si, wWDATAm2si, wWSTRBm2si, wWLASTm2si}),

		.VALID_R      (wWVALIDm2si ),
		.READY_R      (wWREADYsi2m )
);

//Write Response channel
WR_fully_registered WR0_fully_registered 
(
		.ACLK         (ACLK         ), 
		.ARESETn      (ARESETn      ), 
		.INFORMATION_S({wBIDsi2m, wBRESPsi2m}), 

		.VALID_S      (wBVALIDsi2m),
		.READY_S      (wBREADYm2si),
        
		.INFORMATION_R({BIDsi2m, BRESPsi2m}),

		.VALID_R      (BVALIDsi2m),
		.READY_R      (BREADYm2si)
);


WriteChannelsi  U0WriteChannelsi(

    //Global signal
    .ACLK    (ACLK    ),
    .ARESETn (ARESETn ),

    //_________________________________________________________________
    //For Master
    //Write address channel
    .AWIDm2si    (wAWIDm2si    ),
    .AWADDRm2si  (wAWADDRm2si  ),
    .AWLENm2si   (wAWLENm2si   ),
    .AWSIZEm2si  (wAWSIZEm2si  ),
    .AWBURSTm2si (wAWBURSTm2si ),
    .AWLOCKm2si  (wAWLOCKm2si  ),
    .AWCACHEm2si (wAWCACHEm2si ),
    .AWPROTm2si  (wAWPROTm2si  ),

    .AWVALIDm2si (wAWVALIDm2si ),
    .AWREADYsi2m (wAWREADYsi2m ),

    //Write data channel
    .WIDm2si     (wWIDm2si     ),
    .WDATAm2si   (wWDATAm2si   ),
    .WSTRBm2si   (wWSTRBm2si   ),
    .WLASTm2si   (wWLASTm2si   ),
    .WVALIDm2si  (wWVALIDm2si  ),
    .WREADYsi2m  (wWREADYsi2m  ),

    //Write response channel
    .BIDsi2m     (wBIDsi2m     ),
    .BRESPsi2m   (wBRESPsi2m   ),
    .BVALIDsi2m  (wBVALIDsi2m  ),
    .BREADYm2si  (wBREADYm2si  ),


    //_________________________________________________________________

    //For Master interface
    //Write address channel
    .AWIDsi2mi    (AWIDsi2mi    ),
    .AWADDRsi2mi  (AWADDRsi2mi  ),
    .AWLENsi2mi   (AWLENsi2mi   ),
    .AWSIZEsi2mi  (AWSIZEsi2mi  ),
    .AWBURSTsi2mi (AWBURSTsi2mi ),
    .AWLOCKsi2mi  (AWLOCKsi2mi  ),
    .AWCACHEsi2mi (AWCACHEsi2mi ),
    .AWPROTsi2mi  (AWPROTsi2mi  ),
    .AWVALIDsi2mi (AWVALIDsi2mi ),
    .AWREADYmi2si (AWREADYmi2si ),

    //Write data channel
    .WIDsi2mi     (WIDsi2mi     ),
    .WDATAsi2mi   (WDATAsi2mi   ),
    .WSTRBsi2mi   (WSTRBsi2mi   ),
    .WLASTsi2mi   (WLASTsi2mi   ),
    .WVALIDsi2mi  (WVALIDsi2mi  ),
    .WREADYmi2si  (WREADYmi2si  ),

    //Write response channel
    .BIDmi02si     (BIDmi02si     ),
    .BRESPmi02si   (BRESPmi02si   ),

    .BIDmi12si     (BIDmi12si     ),
    .BRESPmi12si   (BRESPmi12si   ),

    .BIDmi22si     (BIDmi22si     ),
    .BRESPmi22si   (BRESPmi22si   ),
    
    .BIDmi32si     (BIDmi32si     ),
    .BRESPmi32si   (BRESPmi32si   ),

    .BIDmi42si     (BIDmi42si     ),
    .BRESPmi42si   (BRESPmi42si   ),

    .BIDmi52si     (BIDmi52si     ),
    .BRESPmi52si   (BRESPmi52si   ),

    .BVALIDmi2si   (BVALIDmi2si   ),
    .BREADYsi2mi   (BREADYsi2mi   )
);

endmodule
