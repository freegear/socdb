module  ReadChannelsi_RS(

    //Global signal
    ACLK    ,
    ARESETn ,

    //Read address channel
    ARIDm2si    ,
    ARADDRm2si  ,
    ARLENm2si   ,
    ARSIZEm2si  ,
    ARBURSTm2si ,
    ARLOCKm2si  ,
    ARCACHEm2si ,
    ARPROTm2si  ,

    ARVALIDm2si ,
    ARREADYsi2m ,

    //Read data channel
    RIDsi2m     ,
    RRESPsi2m   ,
    RVALIDsi2m  ,
    RDATAsi2m   ,
    RREADYm2si  ,
    RLASTsi2m   ,


    //For Master interface
    //Read address channel
    ARIDsi2mi    ,
    ARADDRsi2mi  ,
    ARLENsi2mi   ,
    ARSIZEsi2mi  ,
    ARBURSTsi2mi ,
    ARLOCKsi2mi  ,
    ARCACHEsi2mi ,
    ARPROTsi2mi  ,
    ARVALIDsi2mi ,
    ARREADYmi2si ,


    //Read data channel
    RIDmi02si     ,
    RRESPmi02si   ,
    RDATAmi02si   ,

    RIDmi12si     ,
    RRESPmi12si   ,
    RDATAmi12si   ,

    RIDmi22si     ,
    RRESPmi22si   ,
    RDATAmi22si   ,
    
    RIDmi32si     ,
    RRESPmi32si   ,
    RDATAmi32si   ,

    RIDmi42si     ,
    RRESPmi42si   ,
    RDATAmi42si   ,

    RIDmi52si     ,
    RRESPmi52si   ,
    RDATAmi52si   ,

    RVALIDmi2si  ,
    RREADYsi2mi  ,
    RLASTmi2si
);
`include "Def.v"

    input   ACLK;
    input   ARESETn;

    //____________________________________________________________________________
    //Read Address channel
    input   [ID_WID-1:0]       ARIDm2si;    
    input   [ADDR_WID-1:0]     ARADDRm2si;
    input   [ARLEN_WID-1:0]    ARLENm2si;
    input   [ARSIZE_WID-1:0]   ARSIZEm2si;  
    input   [ARBURST_WID-1:0]  ARBURSTm2si; 
    input   [ARLOCK_WID-1:0]   ARLOCKm2si;  
    input   [ARCACHE_WID-1:0]  ARCACHEm2si; 
    input   [ARPROT_WID-1:0]   ARPROTm2si;  

    input   ARVALIDm2si; 
    output  ARREADYsi2m; 


    //Read data channel
    output   [ID_WID-1:0]      RIDsi2m;     
    output   [RRESP_WID-1:0]   RRESPsi2m;   
    output   [BUS_WID-1:0]     RDATAsi2m;
    output   RVALIDsi2m;  
    input    RREADYm2si;  
    output   RLASTsi2m;   

    //____________________________________________________________________________
    //For Master interface
    //Write address channel
    output  [ID_WID-1:0] ARIDsi2mi;    
    output  [ADDR_WID-1:0] ARADDRsi2mi;  
    output  [ARLEN_WID-1:0] ARLENsi2mi;   
    output  [ARSIZE_WID-1:0] ARSIZEsi2mi;  
    output  [ARBURST_WID-1:0] ARBURSTsi2mi; 
    output  [ARLOCK_WID-1:0] ARLOCKsi2mi;  
    output  [ARCACHE_WID-1:0] ARCACHEsi2mi; 
    output  [ARPROT_WID-1:0] ARPROTsi2mi;  
    output  [SLAVE_NUM-1:0]ARVALIDsi2mi; 
    input   [SLAVE_NUM-1:0]ARREADYmi2si; 


    //Read data channel
    input   [ID_WID-1:0]    RIDmi02si;     
    input   [RRESP_WID-1:0] RRESPmi02si;   
    input   [BUS_WID-1:0]   RDATAmi02si;

    input   [ID_WID-1:0]    RIDmi12si;     
    input   [RRESP_WID-1:0] RRESPmi12si;   
    input   [BUS_WID-1:0]   RDATAmi12si;

    input   [ID_WID-1:0]    RIDmi22si;     
    input   [RRESP_WID-1:0] RRESPmi22si;   
    input   [BUS_WID-1:0]   RDATAmi22si;

    input   [ID_WID-1:0]    RIDmi32si;     
    input   [RRESP_WID-1:0] RRESPmi32si;   
    input   [BUS_WID-1:0]   RDATAmi32si;

    input   [ID_WID-1:0]    RIDmi42si;     
    input   [RRESP_WID-1:0] RRESPmi42si;   
    input   [BUS_WID-1:0]   RDATAmi42si;

    input   [ID_WID-1:0]    RIDmi52si;     
    input   [RRESP_WID-1:0] RRESPmi52si;   
    input   [BUS_WID-1:0]   RDATAmi52si;

    input   [SLAVE_NUM-1:0] RVALIDmi2si;  
    input   [SLAVE_NUM-1:0] RLASTmi2si;  

    output  [SLAVE_NUM-1:0] RREADYsi2mi;    
    //___________________________________________


//_______________________________________________
//Register Slice 

    //Read Address channel
    wire   [ID_WID-1:0]       wARIDm2si;    
    wire   [ADDR_WID-1:0]     wARADDRm2si;
    wire   [ARLEN_WID-1:0]    wARLENm2si;
    wire   [ARSIZE_WID-1:0]   wARSIZEm2si;  
    wire   [ARBURST_WID-1:0]  wARBURSTm2si; 
    wire   [ARLOCK_WID-1:0]   wARLOCKm2si;  
    wire   [ARCACHE_WID-1:0]  wARCACHEm2si; 
    wire   [ARPROT_WID-1:0]   wARPROTm2si;  
    wire   wARVALIDm2si; 
    wire   wARREADYsi2m; 

    //Read data channel
    wire   [ID_WID-1:0]      wRIDsi2m;     
    wire   [RRESP_WID-1:0]   wRRESPsi2m;   
    wire   [BUS_WID-1:0]     wRDATAsi2m;
    wire   wRLASTsi2m;   
    wire   wRVALIDsi2m;  
    wire   wRREADYm2si;  

//ADDRESS Read channel
AR_fully_registered AR0_fully_registered 
(
		.ACLK         (ACLK         ), 
		.ARESETn      (ARESETn      ), 
		.INFORMATION_S({ARIDm2si, ARADDRm2si, ARLENm2si, ARSIZEm2si,  
                        ARBURSTm2si, ARLOCKm2si,  ARCACHEm2si, ARPROTm2si}),

		.VALID_S      (ARVALIDm2si),
		.READY_S      (ARREADYsi2m),

		.INFORMATION_R({wARIDm2si, wARADDRm2si, wARLENm2si, wARSIZEm2si,  
                        wARBURSTm2si, wARLOCKm2si,  wARCACHEm2si, wARPROTm2si}),

		.VALID_R      (wARVALIDm2si),
		.READY_R      (wARREADYsi2m)
);

//Read data channel
RD_fully_registered RD0_fully_registered 
(
		.ACLK         (ACLK         ), 
		.ARESETn      (ARESETn      ), 

		.INFORMATION_R({RIDsi2m, RRESPsi2m, RDATAsi2m, RLASTsi2m }),

		.VALID_R      (RVALIDsi2m),
		.READY_R      (RREADYm2si),

		.INFORMATION_S({wRIDsi2m, wRRESPsi2m, wRDATAsi2m, wRLASTsi2m }), 

		.VALID_S      (wRVALIDsi2m),
		.READY_S      (wRREADYm2si)
);


    
//_______________________________________________

ReadChannelsi U0ReadChannelsi(

    //Global signal
    .ACLK    (ACLK    ),
    .ARESETn (ARESETn ),

    //Read address channel
    .ARIDm2si    (wARIDm2si    ),
    .ARADDRm2si  (wARADDRm2si  ),
    .ARLENm2si   (wARLENm2si   ),
    .ARSIZEm2si  (wARSIZEm2si  ),
    .ARBURSTm2si (wARBURSTm2si ),
    .ARLOCKm2si  (wARLOCKm2si  ),
    .ARCACHEm2si (wARCACHEm2si ),
    .ARPROTm2si  (wARPROTm2si  ),

    .ARVALIDm2si (wARVALIDm2si ),
    .ARREADYsi2m (wARREADYsi2m ),

    //Read data channel
    .RIDsi2m     (wRIDsi2m     ),
    .RRESPsi2m   (wRRESPsi2m   ),
    .RVALIDsi2m  (wRVALIDsi2m  ),
    .RDATAsi2m   (wRDATAsi2m   ),
    .RREADYm2si  (wRREADYm2si  ),
    .RLASTsi2m   (wRLASTsi2m   ),


    //For Master interface
    //Read address channel
    .ARIDsi2mi    (ARIDsi2mi    ),
    .ARADDRsi2mi  (ARADDRsi2mi  ),
    .ARLENsi2mi   (ARLENsi2mi   ),
    .ARSIZEsi2mi  (ARSIZEsi2mi  ),
    .ARBURSTsi2mi (ARBURSTsi2mi ),
    .ARLOCKsi2mi  (ARLOCKsi2mi  ),
    .ARCACHEsi2mi (ARCACHEsi2mi ),
    .ARPROTsi2mi  (ARPROTsi2mi  ),
    .ARVALIDsi2mi (ARVALIDsi2mi ),
    .ARREADYmi2si (ARREADYmi2si ),


    //Read data channel
    .RIDmi02si     (RIDmi02si     ),
    .RRESPmi02si   (RRESPmi02si   ),
    .RDATAmi02si   (RDATAmi02si   ),

    .RIDmi12si     (RIDmi12si     ),
    .RRESPmi12si   (RRESPmi12si   ),
    .RDATAmi12si   (RDATAmi12si   ),

    .RIDmi22si     (RIDmi22si     ),
    .RRESPmi22si   (RRESPmi22si   ),
    .RDATAmi22si   (RDATAmi22si   ),
    
    .RIDmi32si     (RIDmi32si     ),
    .RRESPmi32si   (RRESPmi32si   ),
    .RDATAmi32si   (RDATAmi32si   ),

    .RIDmi42si     (RIDmi42si     ),
    .RRESPmi42si   (RRESPmi42si   ),
    .RDATAmi42si   (RDATAmi42si   ),

    .RIDmi52si     (RIDmi52si     ),
    .RRESPmi52si   (RRESPmi52si   ),
    .RDATAmi52si   (RDATAmi52si   ),

    .RVALIDmi2si  (RVALIDmi2si  ),
    .RREADYsi2mi  (RREADYsi2mi  ),
    .RLASTmi2si   (RLASTmi2si   )
);

endmodule
