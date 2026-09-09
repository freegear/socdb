
//STATE00_START
//_______________________________________________
//Register Slice for Address write channel
//RS Number = ??


    //for regiter slince
    //Read address channel
    wire   [SLAVEID_WID-1:0]  w??ARIDmi2s;    
    wire   [ADDR_WID-1:0]     w??ARADDRmi2s;
    wire   [ARLEN_WID-1:0]    w??ARLENmi2s;
    wire   [ARSIZE_WID-1:0]   w??ARSIZEmi2s;  
    wire   [ARBURST_WID-1:0]  w??ARBURSTmi2s; 
//ENABLE_LOCK
    wire   [ARLOCK_WID-1:0]   w??ARLOCKmi2s;  
//ENABLE_CACHE
    wire   [ARCACHE_WID-1:0]  w??ARCACHEmi2s; 
//ENABLE_PROT
    wire   [ARPROT_WID-1:0]   w??ARPROTmi2s;  

    wire   w??ARVALIDmi2s; 
    wire   w??ARREADYs2mi; 
    
    //for regiter slince
    //Read data channel
    wire   [SLAVEID_WID-1:0] w??RIDs2mi;     
    wire   [RRESP_WID-1:0]   w??RRESPs2mi;   
    wire   [BUS_WID-1:0]     w??RDATAs2mi;
    wire   w??RLASTs2mi;
    wire   w??RVALIDs2mi;  
    wire   w??RREADYmi2s; 

//STATE_END

//STATE01_START
//Mater to Slave interface register slice 
//Number == ??
//_________________________________________

?NAME?_ARMImi2s_registered
?NAME?_?NUM?_ARMImi2s_registered
(
		.ACLK         (ACLK         ), 
		.ARESETn      (ARESETn      ), 
		.INFORMATION_S({?1?ARIDmi2s, 
                        ?1?ARLENmi2s, 
                        ?1?ARSIZEmi2s,  
                        ?1?ARBURSTmi2s, 
//ENABLE_LOCK
                        ?1?ARLOCKmi2s,  
//ENABLE_CACHE
                        ?1?ARCACHEmi2s, 
//ENABLE_PROT
                        ?1?ARPROTmi2s,
                        ?1?ARADDRmi2s 
                        }),

		.VALID_S      (?1?ARVALIDmi2s),
		.READY_S      (?1?ARREADYs2mi),

		.INFORMATION_R({?0?ARIDmi2s, 
                        ?0?ARLENmi2s, 
                        ?0?ARSIZEmi2s,  
                        ?0?ARBURSTmi2s, 
//ENABLE_LOCK
                        ?0?ARLOCKmi2s,  
//ENABLE_CACHE
                        ?0?ARCACHEmi2s, 
//ENABLE_PROT
                        ?0?ARPROTmi2s,
                        ?0?ARADDRmi2s 
                        }),

		.VALID_R      (?0?ARVALIDmi2s),
		.READY_R      (?0?ARREADYs2mi)
);

//Read data channel
?NAME?_RDMImi2s_registered
?NAME?_?NUM?_RDMImi2s_registered
(
		.ACLK         (ACLK         ), 
		.ARESETn      (ARESETn      ), 

		.INFORMATION_R({?1?RIDs2mi, 
                        ?1?RRESPs2mi, 
                        ?1?RDATAs2mi, 
                        ?1?RLASTs2mi }),

		.VALID_R      (?1?RVALIDs2mi),
		.READY_R      (?1?RREADYmi2s),

		.INFORMATION_S({?0?RIDs2mi, 
                        ?0?RRESPs2mi, 
                        ?0?RDATAs2mi, 
                        ?0?RLASTs2mi }), 

		.VALID_S      (?0?RVALIDs2mi),
		.READY_S      (?0?RREADYmi2s)
);

//STATE_END
//////////////////////////////////////////////////

//STATE02_START
    //For Master interface
    //Write address channel
    //Register Slice Number == w??
    //SlaveInterface to MasterIsterface Num == ??

    wire   [MASTERID_WID-1:0] w??ARIDsi??2mi;    
    wire   [ADDR_WID-1:0]     w??ARADDRsi??2mi;
    wire   [ARLEN_WID-1:0]    w??ARLENsi??2mi;
    wire   [ARSIZE_WID-1:0]   w??ARSIZEsi??2mi;  
    wire   [ARBURST_WID-1:0]  w??ARBURSTsi??2mi; 
//ENABLE_LOCK
    wire   [ARLOCK_WID-1:0]   w??ARLOCKsi??2mi;  
//ENABLE_CACHE
    wire   [ARCACHE_WID-1:0]  w??ARCACHEsi??2mi; 
//ENABLE_PROT
    wire   [ARPROT_WID-1:0]   w??ARPROTsi??2mi; 

    wire   [MASTERID_WID-1:0] w??RIDmi2si??;     
    wire   [RRESP_WID-1:0]    w??RRESPmi2si??;   
    wire   [BUS_WID-1:0]      w??RDATAmi2si??;

//STATE_END
//////////////////////////////////////////////////

//STATE03_START
    //number w??


    wire  [MASTER_NUM-1:0] w??ARVALIDsi2mi; 
    wire  [MASTER_NUM-1:0] w??ARREADYmi2si; 

    wire  [MASTER_NUM-1:0] w??RVALIDmi2si;  
    wire  [MASTER_NUM-1:0] w??RLASTmi2si;  
    wire  [MASTER_NUM-1:0] w??RREADYsi2mi;    

//STATE_END


//STATE04_START
//Write address channel
//Register Slice Number == ?1?
//SlaveInterface to MasterIsterface Num == ??

?NAME?_ARMIsi2mi_registered
?NAME?_?NUM?_??_ARMIsi2mi_registered
(
	.ACLK         (ACLK         ), 
    .ARESETn      (ARESETn      ), 
    .INFORMATION_S({
                    ?0?ARIDsi??2mi,
                    ?0?ARADDRsi??2mi,  
                    ?0?ARLENsi??2mi,   
                    ?0?ARSIZEsi??2mi,  
//ENABLE_LOCK
                    ?0?ARLOCKsi??2mi,  
//ENABLE_CACHE
                    ?0?ARCACHEsi??2mi, 
//ENABLE_PROT
                    ?0?ARPROTsi??2mi,
                    ?0?ARBURSTsi??2mi 
                  }), 

	.VALID_S      (?0?ARVALIDsi2mi[??]),
	.READY_S      (?0?ARREADYmi2si[??]),
        
	.INFORMATION_R({
                    ?1?ARIDsi??2mi,
                    ?1?ARADDRsi??2mi,  
                    ?1?ARLENsi??2mi,   
                    ?1?ARSIZEsi??2mi,  
//ENABLE_LOCK
                    ?1?ARLOCKsi??2mi,  
//ENABLE_CACHE
                    ?1?ARCACHEsi??2mi, 
//ENABLE_PROT
                    ?1?ARPROTsi??2mi,
                    ?1?ARBURSTsi??2mi 

                  }),

	.VALID_R      (?1?ARVALIDsi2mi[??]),
	.READY_R      (?1?ARREADYmi2si[??])
);


?NAME?_RDMIsi2mi_registered
?NAME?_?NUM?_??_RDMIsi2mi_registered
(
	.ACLK         (ACLK         ), 
    .ARESETn      (ARESETn      ), 
    .INFORMATION_S({?1?RIDmi2si??, 
                    ?1?RDATAmi2si??,
                    ?1?RLASTmi2si[??],
                    ?1?RRESPmi2si??
                    }), 

	.VALID_S      (?1?RVALIDmi2si[??]),
	.READY_S      (?1?RREADYsi2mi[??]),
        
	.INFORMATION_R({?0?RIDmi2si??, 
                    ?0?RDATAmi2si??,
                    ?0?RLASTmi2si[??],
                    ?0?RRESPmi2si??
                    }),

	.VALID_R      (?0?RVALIDmi2si[??]),
	.READY_R      (?0?RREADYsi2mi[??])
);


//STATE_END

//STATE05_START
//Master module     
//__________________________________________________

?NAME?_ReadChannelmi
?NAME?_ReadChannelmi(

    //Global signal
    .ACLK    (ACLK    ),
    .ARESETn (ARESETn ),

    //For slave 
    //Read address channel
    .ARIDmi2s    (?0?ARIDmi2s    ),
    .ARADDRmi2s  (?0?ARADDRmi2s  ),
    .ARLENmi2s   (?0?ARLENmi2s   ),
    .ARSIZEmi2s  (?0?ARSIZEmi2s  ),
    .ARBURSTmi2s (?0?ARBURSTmi2s ),
//ENABLE_LOCK
    .ARLOCKmi2s  (?0?ARLOCKmi2s  ),
//ENABLE_CACHE
    .ARCACHEmi2s (?0?ARCACHEmi2s ),
//ENABLE_PROT
    .ARPROTmi2s  (?0?ARPROTmi2s  ),

    .ARVALIDmi2s (?0?ARVALIDmi2s ),
    .ARREADYs2mi (?0?ARREADYs2mi ),

    //Read data channel
    .RIDs2mi     (?0?RIDs2mi     ),
    .RRESPs2mi   (?0?RRESPs2mi   ),
    .RDATAs2mi   (?0?RDATAs2mi   ),

    .RVALIDs2mi  (?0?RVALIDs2mi  ),
    .RLASTs2mi   (?0?RLASTs2mi   ),
    .RREADYmi2s  (?0?RREADYmi2s  ),

    //Master 0/1/2/3
    .ARVALIDsi2mi(?1?ARVALIDsi2mi  ),
    .ARREADYmi2si(?1?ARREADYmi2si  ),

    .RVALIDmi2si (?1?RVALIDmi2si  ),
    .RLASTmi2si  (?1?RLASTmi2si   ),
    .RREADYsi2mi (?1?RREADYsi2mi  ),


//STATE_END

//STATE06_START
    ///////////////////////////////////////////////
    //For Master interface  Master Number = ??
    //Write address channel

    .ARIDsi??2mi    (?0?ARIDsi??2mi    ),
    .ARADDRsi??2mi  (?0?ARADDRsi??2mi  ),
    .ARLENsi??2mi   (?0?ARLENsi??2mi   ),
    .ARSIZEsi??2mi  (?0?ARSIZEsi??2mi  ),
    .ARBURSTsi??2mi (?0?ARBURSTsi??2mi ),
//ENABLE_LOCK_Read
    .ARLOCKsi??2mi  (?0?ARLOCKsi??2mi  ),
//ENABLE_CACHE_Read
    .ARCACHEsi??2mi (?0?ARCACHEsi??2mi ),
//ENABLE_PROT_Read
    .ARPROTsi??2mi  (?0?ARPROTsi??2mi  ),

    .RIDmi2si??    (?0?RIDmi2si??    ),
    .RRESPmi2si??  (?0?RRESPmi2si??  ),
    .RDATAmi2si??  (?0?RDATAmi2si??  ),

//STATE_END

//Lock control
    .Lock2Wrmi(Lock2Wrmi),
    .UnLock2Wrmi(UnLock2Wrmi),

    .Lock2Rdmi(Lock2Rdmi),
    .UnLock2Rdmi(UnLock2Rdmi),

    .AWVALID(AWVALID),

    .LockPort(LockPort),
    .ReadIntEmptyWrmi2Rdmi(ReadIntEmptyWrmi2Rdmi),
    .DataCntEmptyRdmi2Wrmi(DataCntEmptyRdmi2Wrmi),
    .CtlDataRead2Lock    (CtlDataRead2Lock    )
    );
endmodule
//Code_END
