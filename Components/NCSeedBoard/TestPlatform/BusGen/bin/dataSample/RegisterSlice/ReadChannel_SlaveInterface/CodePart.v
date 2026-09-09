    
//STATE00_START
//_______________________________________RS Number = ??
//
    
    //for register slice
    wire   [MASTERID_WID-1:0] w??ARIDm2si;    
    wire   [ADDR_WID-1:0]     w??ARADDRm2si;
    wire   [ARLEN_WID-1:0]    w??ARLENm2si;
    wire   [ARSIZE_WID-1:0]   w??ARSIZEm2si;  
    wire   [ARBURST_WID-1:0]  w??ARBURSTm2si; 
    wire   [ARLOCK_WID-1:0]   w??ARLOCKm2si;  
    wire   [ARCACHE_WID-1:0]  w??ARCACHEm2si; 
    wire   [ARPROT_WID-1:0]   w??ARPROTm2si;  
    wire   w??ARVALIDm2si; 
    wire   w??ARREADYsi2m; 

    //Read data channel
    wire   [MASTERID_WID-1:0]w??RIDsi2m;     
    wire   [RRESP_WID-1:0]   w??RRESPsi2m;   
    wire   [BUS_WID-1:0]     w??RDATAsi2m;
    wire   w??RVALIDsi2m;  
    wire   w??RREADYm2si;  
    wire   w??RLASTsi2m;   

//STATE_END


//STATE01_START
//Mater to Slave interface register slice 
//Number == ??
//_________________________________________

?NAME?_ARSIm2si_registered
?NAME?_?NUM?_ARSIm2si_registered
(
		.ACLK         (ACLK         ), 
		.ARESETn      (ARESETn      ), 
		.INFORMATION_S({?0?ARIDm2si, 
                        ?0?ARLENm2si, 
                        ?0?ARSIZEm2si,  
                        ?0?ARBURSTm2si, 
//ENABLE_LOCK
                        ?0?ARLOCKm2si,  
//ENABLE_CACHE
                        ?0?ARCACHEm2si, 
//ENABLE_PROT
                        ?0?ARPROTm2si,
                        ?0?ARADDRm2si 
                        }),

		.VALID_S      (?0?ARVALIDm2si),
		.READY_S      (?0?ARREADYsi2m),

		.INFORMATION_R({?1?ARIDm2si, 
                        ?1?ARLENm2si, 
                        ?1?ARSIZEm2si,  
                        ?1?ARBURSTm2si, 
//ENABLE_LOCK
                        ?1?ARLOCKm2si,  
//ENABLE_CACHE
                        ?1?ARCACHEm2si, 
//ENABLE_PROT
                        ?1?ARPROTm2si,
                        ?1?ARADDRm2si 
                        }),

		.VALID_R      (?1?ARVALIDm2si),
		.READY_R      (?1?ARREADYsi2m)
);

//Read data channel
?NAME?_RDSIm2si_registered
?NAME?_?NUM?_RDSIm2si_registered
(
		.ACLK         (ACLK         ), 
		.ARESETn      (ARESETn      ), 

		.INFORMATION_R({?0?RIDsi2m, 
                        ?0?RRESPsi2m, 
                        ?0?RDATAsi2m, 
                        ?0?RLASTsi2m }),

		.VALID_R      (?0?RVALIDsi2m),
		.READY_R      (?0?RREADYm2si),

		.INFORMATION_S({?1?RIDsi2m, 
                        ?1?RRESPsi2m, 
                        ?1?RDATAsi2m, 
                        ?1?RLASTsi2m }), 

		.VALID_S      (?1?RVALIDsi2m),
		.READY_S      (?1?RREADYm2si)
);

//STATE_END
//////////////////////////////////////////////////


//STATE02_START
    //For Master interface
    //Write address channel
    //Register Slice Number == w??
    //SlaveInterface to MasterIsterface Num == ??
    wire  [MASTERID_WID-1:0]  w??ARIDsi2mi??;    
    wire  [ADDR_WID-1:0]      w??ARADDRsi2mi??;  
    wire  [ARLEN_WID-1:0]     w??ARLENsi2mi??;   
    wire  [ARSIZE_WID-1:0]    w??ARSIZEsi2mi??;  
    wire  [ARBURST_WID-1:0]   w??ARBURSTsi2mi??; 
//ENABLE_LOCK
    wire  [ARLOCK_WID-1:0]    w??ARLOCKsi2mi??;  
//ENABLE_CACHE
    wire  [ARCACHE_WID-1:0]   w??ARCACHEsi2mi??; 
//ENABLE_PROT
    wire  [ARPROT_WID-1:0]    w??ARPROTsi2mi??; 

    wire  [MASTERID_WID-1:0]  w??RIDmi??2si;     
    wire  [RRESP_WID-1:0]     w??RRESPmi??2si;   
    wire  [BUS_WID-1:0]       w??RDATAmi??2si;


//STATE_END

//////////////////////////////////////////////////
//STATE03_START
    //number w??
    wire  [SLAVE_NUM-1:0] w??ARVALIDsi2mi; 
    wire  [SLAVE_NUM-1:0] w??ARREADYmi2si; 

    wire  [SLAVE_NUM-1:0] w??RVALIDmi2si;  
    wire  [SLAVE_NUM-1:0] w??RLASTmi2si;  
    wire  [SLAVE_NUM-1:0] w??RREADYsi2mi;    

//STATE_END



//STATE04_START
//Write address channel
//Register Slice Number == ?1?
//SlaveInterface to MasterIsterface Num == ??
?NAME?_ARSIsi2mi_registered
?NAME?_?NUM?_??_ARSIsi2mi_registered
(
	.ACLK         (ACLK         ), 
    .ARESETn      (ARESETn      ), 
    .INFORMATION_S({
                    ?1?ARIDsi2mi??,
                    ?1?ARADDRsi2mi??,  
                    ?1?ARLENsi2mi??,   
                    ?1?ARSIZEsi2mi??,  
//ENABLE_LOCK
                    ?1?ARLOCKsi2mi??,  
//ENABLE_CACHE
                    ?1?ARCACHEsi2mi??, 
//ENABLE_PROT
                    ?1?ARPROTsi2mi??,
                    ?1?ARBURSTsi2mi?? 
                  }), 

	.VALID_S      (?1?ARVALIDsi2mi[??]),
	.READY_S      (?1?ARREADYmi2si[??]),
        
	.INFORMATION_R({
                    ?0?ARIDsi2mi??,
                    ?0?ARADDRsi2mi??,  
                    ?0?ARLENsi2mi??,   
                    ?0?ARSIZEsi2mi??,  
//ENABLE_LOCK
                    ?0?ARLOCKsi2mi??,  
//ENABLE_CACHE
                    ?0?ARCACHEsi2mi??, 
//ENABLE_PROT
                    ?0?ARPROTsi2mi??,
                    ?0?ARBURSTsi2mi?? 

                  }),

	.VALID_R      (?0?ARVALIDsi2mi[??]),
	.READY_R      (?0?ARREADYmi2si[??])
);


?NAME?_RDSIsi2mi_registered
?NAME?_?NUM?_??_RDSIsi2mi_registered
(
	.ACLK         (ACLK         ), 
    .ARESETn      (ARESETn      ), 
    .INFORMATION_S({?0?RIDmi??2si, 
                    ?0?RDATAmi??2si,
                    ?0?RLASTmi2si[??],
                    ?0?RRESPmi??2si
                    }), 

	.VALID_S      (?0?RVALIDmi2si[??]),
	.READY_S      (?0?RREADYsi2mi[??]),
        
	.INFORMATION_R({?1?RIDmi??2si, 
                    ?1?RDATAmi??2si,
                    ?1?RLASTmi2si[??],
                    ?1?RRESPmi??2si
                    }),

	.VALID_R      (?1?RVALIDmi2si[??]),
	.READY_R      (?1?RREADYsi2mi[??])
);


//STATE_END


//STATE05_START
//Master module     
//__________________________________________________

?NAME?_ReadChannelsi
?NAME?_ReadChannelsi(



    //Read address channel
//ENABLE_ID
    .ARIDm2si    (?0?ARIDm2si    ),
    .ARADDRm2si  (?0?ARADDRm2si  ),
    .ARLENm2si   (?0?ARLENm2si   ),
    .ARSIZEm2si  (?0?ARSIZEm2si  ),
    .ARBURSTm2si (?0?ARBURSTm2si ),
//ENABLE_LOCK
    .ARLOCKm2si  (?0?ARLOCKm2si  ),
//ENABLE_CACHE
    .ARCACHEm2si (?0?ARCACHEm2si ),
//ENABLE_PROT
    .ARPROTm2si  (?0?ARPROTm2si  ),

    .ARVALIDm2si (?0?ARVALIDm2si ),
    .ARREADYsi2m (?0?ARREADYsi2m ),

    //Read data channel
    .RIDsi2m     (?0?RIDsi2m     ),
    .RRESPsi2m   (?0?RRESPsi2m   ),
    .RVALIDsi2m  (?0?RVALIDsi2m  ),
    .RDATAsi2m   (?0?RDATAsi2m   ),
    .RREADYm2si  (?0?RREADYm2si  ),
    .RLASTsi2m   (?0?RLASTsi2m   ),

    .ARVALIDsi2mi (?1?ARVALIDsi2mi ),
    .ARREADYmi2si (?1?ARREADYmi2si ),
    .RVALIDmi2si  (?1?RVALIDmi2si  ),
    .RREADYsi2mi  (?1?RREADYsi2mi  ),
    .RLASTmi2si   (?1?RLASTmi2si   ),

//STATE_END
//STATE06_START
    ///////////////////////////////////////////////
    //For Master interface  slave Number = ??
    //Write address channel

    .ARIDsi2mi??    (?0?ARIDsi2mi??   ),
    .ARADDRsi2mi??  (?0?ARADDRsi2mi?? ),
    .ARLENsi2mi??   (?0?ARLENsi2mi??  ),
    .ARSIZEsi2mi??  (?0?ARSIZEsi2mi?? ),
    .ARBURSTsi2mi?? (?0?ARBURSTsi2mi??),
//ENABLE_LOCK_Read
    .ARLOCKsi2mi??  (?0?ARLOCKsi2mi?? ),
//ENABLE_CACHE_Read
    .ARCACHEsi2mi?? (?0?ARCACHEsi2mi??),
//ENABLE_PROT_Read
    .ARPROTsi2mi??  (?0?ARPROTsi2mi?? ),

    .RIDmi??2si     (?0?RIDmi??2si     ),
    .RRESPmi??2si   (?0?RRESPmi??2si   ),
    .RDATAmi??2si   (?0?RDATAmi??2si   ),

//STATE_END
    
    //Global signal
    .ACLK    (ACLK    ),
    .ARESETn (ARESETn )

);
endmodule
//STATE_END
//Code_END
