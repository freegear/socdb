    
//STATE00_START

//_______________________________________RS Number = ??
//
    //for register slice
    wire   [MASTERID_WID-1:0] w??AWIDm2si;    
    wire   [ADDR_WID-1:0]     w??AWADDRm2si;
    wire   [AWLEN_WID-1:0]    w??AWLENm2si;
    wire   [AWSIZE_WID-1:0]   w??AWSIZEm2si;  
    wire   [AWBURST_WID-1:0]  w??AWBURSTm2si; 
    wire   [AWLOCK_WID-1:0]   w??AWLOCKm2si;  
    wire   [AWCACHE_WID-1:0]  w??AWCACHEm2si; 
    wire   [AWPROT_WID-1:0]   w??AWPROTm2si;  
    wire   w??AWVALIDm2si; 
    wire   w??AWREADYsi2m; 

    //for register slice
    wire   [MASTERID_WID-1:0] w??WIDm2si;     
    wire   [BUS_WID-1:0]      w??WDATAm2si;   
    wire   [WSTRB_WID-1:0]    w??WSTRBm2si;   
    wire   w??WLASTm2si;   
    wire   w??WVALIDm2si;  
    wire   w??WREADYsi2m;  

    //for register slice
    wire   [MASTERID_WID-1:0]w??BIDsi2m;     
    wire   [BRESP_WID-1:0]   w??BRESPsi2m;   
    wire   w??BVALIDsi2m;  
    wire   w??BREADYm2si;  


//STATE_END


//STATE01_START
//Mater to Slave interface register slice 
//Number == ??
//_________________________________________
?NAME?_AWSIm2si_registered
?NAME?_?NUM?_AWSIm2si_registered
(
	.ACLK         (ACLK         ), 
    .ARESETn      (ARESETn      ), 

    .INFORMATION_S({?0?AWIDm2si, 
                    ?0?AWLENm2si, 
                    ?0?AWSIZEm2si, 
                    ?0?AWBURSTm2si, 
//ENABLE_LOCK
                    ?0?AWLOCKm2si, 
//ENABLE_CACHE
                    ?0?AWCACHEm2si, 
//ENABLE_PROT
                    ?0?AWPROTm2si,
                    ?0?AWADDRm2si 
                    }),

    .VALID_S      (?0?AWVALIDm2si  ),
    .READY_S      (?0?AWREADYsi2m  ),

    .INFORMATION_R({?1?AWIDm2si, 
                    ?1?AWLENm2si ,
                    ?1?AWSIZEm2si, 
                    ?1?AWBURSTm2si, 
//ENABLE_LOCK
                    ?1?AWLOCKm2si, 
//ENABLE_CACHE
                    ?1?AWCACHEm2si, 
//ENABLE_PROT
                    ?1?AWPROTm2si,
                    ?1?AWADDRm2si 
                    }),

    .VALID_R      (?1?AWVALIDm2si ),
    .READY_R      (?1?AWREADYsi2m )
);


?NAME?_WDSIm2si_registered
?NAME?_?NUM?_WDSIm2si_registered
(
	.ACLK         (ACLK         ), 
	.ARESETn      (ARESETn      ), 
	.INFORMATION_S({?0?WIDm2si, 
                    ?0?WDATAm2si, 
//ENABLE_WSTRB
                    ?0?WSTRBm2si, 
                    ?0?WLASTm2si
                    }), 

	.VALID_S      (?0?WVALIDm2si  ),
	.READY_S      (?0?WREADYsi2m  ),

	.INFORMATION_R({?1?WIDm2si, 
                    ?1?WDATAm2si, 
//ENABLE_WSTRB
                    ?1?WSTRBm2si, 
                    ?1?WLASTm2si}),

	.VALID_R      (?1?WVALIDm2si ),
	.READY_R      (?1?WREADYsi2m )
);

?NAME?_WRSIm2si_registered
?NAME?_?NUM?_WRSIm2si_registered
(
	.ACLK         (ACLK         ), 
    .ARESETn      (ARESETn      ), 
    .INFORMATION_S({?1?BIDsi2m, ?1?BRESPsi2m}), 

	.VALID_S      (?1?BVALIDsi2m),
	.READY_S      (?1?BREADYm2si),
        
	.INFORMATION_R({?0?BIDsi2m, ?0?BRESPsi2m}),

	.VALID_R      (?0?BVALIDsi2m),
	.READY_R      (?0?BREADYm2si)
);


//STATE_END

//////////////////////////////////////////////////

//STATE02_START
    //For Master interface
    //Write address channel
    //Register Slice Number == w??
    //SlaveInterface to MasterIsterface Num == ??
    wire  [MASTERID_WID-1:0]    w??AWIDsi2mi??;    
    wire  [ADDR_WID-1:0]        w??AWADDRsi2mi??;  
    wire  [AWLEN_WID-1:0]       w??AWLENsi2mi??;   
    wire  [AWSIZE_WID-1:0]      w??AWSIZEsi2mi??;  
    wire  [AWBURST_WID-1:0]     w??AWBURSTsi2mi??; 
//ENABLE_LOCK
    wire  [AWLOCK_WID-1:0]      w??AWLOCKsi2mi??;  
//ENABLE_CACHE
    wire  [AWCACHE_WID-1:0]     w??AWCACHEsi2mi??; 
//ENABLE_PROT
    wire  [AWPROT_WID-1:0]      w??AWPROTsi2mi??;  

    //Write data channel
    wire  [MASTERID_WID-1:0]    w??WIDsi2mi??;     
    wire  [BUS_WID-1:0]         w??WDATAsi2mi??;   
//ENABLE_WSTRB
    wire  [WSTRB_WID-1:0]       w??WSTRBsi2mi??;   

    wire  [MASTERID_WID-1:0]    w??BIDmi??2si;     
    wire  [BRESP_WID-1:0]       w??BRESPmi??2si;   


//STATE_END


//////////////////////////////////////////////////
//STATE03_START
    //number w??
    wire  [SLAVE_NUM-1:0]w??AWVALIDsi2mi; 
    wire  [SLAVE_NUM-1:0]w??AWREADYmi2si; 

    wire  [SLAVE_NUM-1:0]w??WLASTsi2mi;   
    wire  [SLAVE_NUM-1:0]w??WVALIDsi2mi;  
    wire  [SLAVE_NUM-1:0]w??WREADYmi2si;  

    wire  [SLAVE_NUM-1:0]w??BVALIDmi2si;  
    wire  [SLAVE_NUM-1:0]w??BREADYsi2mi;

//STATE_END



//STATE04_START
//Write address channel
//Register Slice Number == ?1?
//SlaveInterface to MasterIsterface Num == ??
?NAME?_AWSIsi2mi_registered
?NAME?_?NUM?_??_AWSIsi2mi_registered
(
	.ACLK         (ACLK         ), 
    .ARESETn      (ARESETn      ), 
    .INFORMATION_S({
                    ?1?AWIDsi2mi??,
                    ?1?AWADDRsi2mi??,  
                    ?1?AWLENsi2mi??,   
                    ?1?AWSIZEsi2mi??,  
//ENABLE_LOCK
                    ?1?AWLOCKsi2mi??,  
//ENABLE_CACHE
                    ?1?AWCACHEsi2mi??, 
//ENABLE_PROT
                    ?1?AWPROTsi2mi??,
                    ?1?AWBURSTsi2mi?? 
                  }), 

	.VALID_S      (?1?AWVALIDsi2mi[??]),
	.READY_S      (?1?AWREADYmi2si[??]),
        
	.INFORMATION_R({
                    ?0?AWIDsi2mi??,
                    ?0?AWADDRsi2mi??,  
                    ?0?AWLENsi2mi??,   
                    ?0?AWSIZEsi2mi??,  
//ENABLE_LOCK
                    ?0?AWLOCKsi2mi??,  
//ENABLE_CACHE
                    ?0?AWCACHEsi2mi??, 
//ENABLE_PROT
                    ?0?AWPROTsi2mi??,
                    ?0?AWBURSTsi2mi?? 

                  }),

	.VALID_R      (?0?AWVALIDsi2mi[??]),
	.READY_R      (?0?AWREADYmi2si[??])
);

?NAME?_WDSIsi2mi_registered
?NAME?_?NUM?_??_WDSIsi2mi_registered
(
	.ACLK         (ACLK         ), 
	.ARESETn      (ARESETn      ), 
	.INFORMATION_S({?1?WIDsi2mi??, 
                    ?1?WDATAsi2mi??, 
//ENABLE_WSTRB
                    ?1?WSTRBsi2mi??, 
                    ?1?WLASTsi2mi[??]
                    }), 

	.VALID_S      (?1?WVALIDsi2mi[??]  ),
	.READY_S      (?1?WREADYmi2si[??]  ),

	.INFORMATION_R({?0?WIDsi2mi??, 
                    ?0?WDATAsi2mi??, 
//ENABLE_WSTRB
                    ?0?WSTRBsi2mi??, 
                    ?0?WLASTsi2mi[??]}),

	.VALID_R      (?0?WVALIDsi2mi[??] ),
	.READY_R      (?0?WREADYmi2si[??] )
);

?NAME?_WRSIsi2mi_registered
?NAME?_?NUM?_??_WRSIsi2mi_registered
(
	.ACLK         (ACLK         ), 
    .ARESETn      (ARESETn      ), 
    .INFORMATION_S({?0?BIDmi??2si, ?0?BRESPmi??2si}), 

	.VALID_S      (?0?BVALIDmi2si[??]),
	.READY_S      (?0?BREADYsi2mi[??]),
        
	.INFORMATION_R({?1?BIDmi??2si, ?1?BRESPmi??2si}),

	.VALID_R      (?1?BVALIDmi2si[??]),
	.READY_R      (?1?BREADYsi2mi[??])
);


//STATE_END


//STATE05_START
//Master module     
//__________________________________________________

?NAME?_WriteChannelsi
?NAME?_WriteChannelsi(

    //For Master
    //Write address channel
    ///////////////////////////////////////////////
//ENABLE_ID
    .AWIDm2si    (?0?AWIDm2si),
    .AWADDRm2si  (?0?AWADDRm2si),
    .AWLENm2si   (?0?AWLENm2si),
    .AWSIZEm2si  (?0?AWSIZEm2si),
    .AWBURSTm2si (?0?AWBURSTm2si),
//ENABLE_LOCK
    .AWLOCKm2si  (?0?AWLOCKm2si),
//ENABLE_CACHE
    .AWCACHEm2si (?0?AWCACHEm2si),
//ENABLE_PROT
    .AWPROTm2si  (?0?AWPROTm2si),

    .AWVALIDm2si (?0?AWVALIDm2si),
    .AWREADYsi2m (?0?AWREADYsi2m),

    //Write data channel
    .WIDm2si     (?0?WIDm2si),
    .WDATAm2si   (?0?WDATAm2si),
//ENABLE_WSTRB
    .WSTRBm2si   (?0?WSTRBm2si),
    .WLASTm2si   (?0?WLASTm2si),
    .WVALIDm2si  (?0?WVALIDm2si),
    .WREADYsi2m  (?0?WREADYsi2m),

    //Write response channel
    .BIDsi2m     (?0?BIDsi2m),
    .BRESPsi2m   (?0?BRESPsi2m),
    .BVALIDsi2m  (?0?BVALIDsi2m),
    .BREADYm2si  (?0?BREADYm2si),


    .AWVALIDsi2mi (?1?AWVALIDsi2mi),
    .AWREADYmi2si (?1?AWREADYmi2si),

    .WLASTsi2mi   (?1?WLASTsi2mi),
    .WVALIDsi2mi  (?1?WVALIDsi2mi),
    .WREADYmi2si  (?1?WREADYmi2si),

    .BVALIDmi2si    (?1?BVALIDmi2si),
    .BREADYsi2mi    (?1?BREADYsi2mi),

//STATE_END

//STATE06_START
    ///////////////////////////////////////////////
    //For Master interface  slave Number = ??
    //Write address channel
    .AWIDsi2mi??    (?0?AWIDsi2mi??),
    .AWADDRsi2mi??  (?0?AWADDRsi2mi??),
    .AWLENsi2mi??   (?0?AWLENsi2mi??),
    .AWSIZEsi2mi??  (?0?AWSIZEsi2mi??),
    .AWBURSTsi2mi?? (?0?AWBURSTsi2mi??),
//ENABLE_LOCK_Write
    .AWLOCKsi2mi??  (?0?AWLOCKsi2mi??),
//ENABLE_CACHE_Write
    .AWCACHEsi2mi?? (?0?AWCACHEsi2mi??),
//ENABLE_PROT_Write
    .AWPROTsi2mi??  (?0?AWPROTsi2mi??),

    //Write data channel
    .WIDsi2mi??     (?0?WIDsi2mi??),
    .WDATAsi2mi??   (?0?WDATAsi2mi??),
//ENABLE_WSTRB_Write
    .WSTRBsi2mi??   (?0?WSTRBsi2mi??),

    //Write response channel

    //Slave Number ??
    .BIDmi??2si     (?0?BIDmi??2si),
    .BRESPmi??2si   (?0?BRESPmi??2si),
//STATE_END

    //Global signal
    .ACLK    (ACLK),
    .ARESETn (ARESETn),
    .SelMAP1 (SelMAP1)
);
endmodule
//STATE_END
//Code_END
