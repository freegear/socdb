
//STATE00_START
//_______________________________________________
//Register Slice for Address write channel
//RS Number = ??

    //for regiter slince
    wire   [SLAVEID_WID-1:0]  w??AWIDmi2s;    
    wire   [ADDR_WID-1:0]     w??AWADDRmi2s;
    wire   [AWLEN_WID-1:0]    w??AWLENmi2s;
    wire   [AWSIZE_WID-1:0]   w??AWSIZEmi2s;  
    wire   [AWBURST_WID-1:0]  w??AWBURSTmi2s; 
//ENABLE_LOCK
    wire   [AWLOCK_WID-1:0]   w??AWLOCKmi2s;  
//ENABLE_CACHE
    wire   [AWCACHE_WID-1:0]  w??AWCACHEmi2s; 
//ENABLE_PROT
    wire   [AWPROT_WID-1:0]   w??AWPROTmi2s;  

    wire   w??AWVALIDmi2s; 
    wire   w??AWREADYs2mi; 

    //for regiter slince
    wire   [SLAVEID_WID-1:0]  w??WIDmi2s;     
    wire   [BUS_WID-1:0]      w??WDATAmi2s;   
//ENABLE_WSTRB
    wire   [WSTRB_WID-1:0]    w??WSTRBmi2s;   
    wire   w??WLASTmi2s;   
    wire   w??WVALIDmi2s;  
    wire   w??WREADYs2mi; 

    //for regiter slince
    wire   [SLAVEID_WID-1:0] w??BIDs2mi;     
    wire   [BRESP_WID-1:0]   w??BRESPs2mi;   
    wire   w??BVALIDs2mi;  
    wire   w??BREADYmi2s;  

//STATE_END

//STATE01_START
//Mater to Slave interface register slice 
//Number == ?NUM?
//_________________________________________
?NAME?_AWMImi2s_registered
?NAME?_?NUM?_AWMImi2s_registered
(
	.ACLK         (ACLK         ), 
    .ARESETn      (ARESETn      ), 

    .INFORMATION_S({?1?AWIDmi2s, 
                    ?1?AWLENmi2s, 
                    ?1?AWSIZEmi2s,  
                    ?1?AWBURSTmi2s, 
//ENABLE_LOCK
                    ?1?AWLOCKmi2s, 
//ENABLE_CACHE
                    ?1?AWCACHEmi2s, 
//ENABLE_PROT
                    ?1?AWPROTmi2s,  
                    ?1?AWADDRmi2s 
                    }),

	.VALID_S      (?1?AWVALIDmi2s),
	.READY_S      (?1?AWREADYs2mi),

	.INFORMATION_R({?0?AWIDmi2s, 
                    ?0?AWLENmi2s, 
                    ?0?AWSIZEmi2s,  
                    ?0?AWBURSTmi2s, 
//ENABLE_LOCK
                    ?0?AWLOCKmi2s, 
//ENABLE_CACHE
                    ?0?AWCACHEmi2s, 
//ENABLE_PROT
                    ?0?AWPROTmi2s,
                    ?0?AWADDRmi2s 
                    }),

	.VALID_R      (?0?AWVALIDmi2s),
	.READY_R      (?0?AWREADYs2mi)
);



?NAME?_WDMImi2s_registered
?NAME?_?NUM?_WDMImi2s_registered
(
		.ACLK         (ACLK         ), 
		.ARESETn      (ARESETn      ), 
		.INFORMATION_R({?0?WIDmi2s,
                        ?0?WDATAmi2s,
//ENABLE_WSTRB
                        ?0?WSTRBmi2s,
                        ?0?WLASTmi2s
                        }),

		.VALID_R      (?0?WVALIDmi2s),
		.READY_R      (?0?WREADYs2mi),

		.INFORMATION_S({?1?WIDmi2s,
                        ?1?WDATAmi2s,
//ENABLE_WSTRB
                        ?1?WSTRBmi2s,
                        ?1?WLASTmi2s
                        }),

		.VALID_S      (?1?WVALIDmi2s),
		.READY_S      (?1?WREADYs2mi)
);


?NAME?_WRMImi2s_registered
?NAME?_?NUM?_WRMImi2s_registered
(
		.ACLK         (ACLK         ), 
		.ARESETn      (ARESETn      ), 
		.INFORMATION_R({?1?BIDs2mi, ?1?BRESPs2mi}), 

		.VALID_R      (?1?BVALIDs2mi),
		.READY_R      (?1?BREADYmi2s),
        
		.INFORMATION_S({?0?BIDs2mi, ?0?BRESPs2mi}),

		.VALID_S      (?0?BVALIDs2mi),
		.READY_S      (?0?BREADYmi2s)
);

//STATE_END

//////////////////////////////////////////////////

//STATE02_START
    //For Master interface
    //Write address channel
    //Register Slice Number == w??
    //SlaveInterface to MasterIsterface Num == ??
    wire   [MASTERID_WID-1:0] w??AWIDsi??2mi;    
    wire   [ADDR_WID-1:0]     w??AWADDRsi??2mi;
    wire   [AWLEN_WID-1:0]    w??AWLENsi??2mi;
    wire   [AWSIZE_WID-1:0]   w??AWSIZEsi??2mi;  
    wire   [AWBURST_WID-1:0]  w??AWBURSTsi??2mi; 
//ENABLE_LOCK
    wire   [AWLOCK_WID-1:0]   w??AWLOCKsi??2mi;  
//ENABLE_CACHE
    wire   [AWCACHE_WID-1:0]  w??AWCACHEsi??2mi; 
//ENABLE_PROT
    wire   [AWPROT_WID-1:0]   w??AWPROTsi??2mi; 

    //Write data channel
    wire   [MASTERID_WID-1:0] w??WIDsi??2mi;     
    wire   [BUS_WID-1:0]      w??WDATAsi??2mi;   
//ENABLE_WSTRB
    wire   [WSTRB_WID-1:0]    w??WSTRBsi??2mi;

    //Write response channel
    wire   [MASTERID_WID-1:0] w??BIDmi2si??;
    wire   [BRESP_WID-1:0]    w??BRESPmi2si??;   


//STATE_END
//////////////////////////////////////////////////

//STATE03_START
    //number w??
    wire  [MASTER_NUM-1:0]w??AWVALIDsi2mi; 
    wire  [MASTER_NUM-1:0]w??AWREADYmi2si; 

    wire  [MASTER_NUM-1:0]w??WLASTsi2mi;   
    wire  [MASTER_NUM-1:0]w??WVALIDsi2mi;  
    wire  [MASTER_NUM-1:0]w??WREADYmi2si;  

    wire  [MASTER_NUM-1:0]w??BVALIDmi2si;  
    wire  [MASTER_NUM-1:0]w??BREADYsi2mi;

//STATE_END


//STATE04_START
//Write address channel
//Register Slice Number == ?1?
//SlaveInterface to MasterIsterface Num == ??
?NAME?_AWMIsi2mi_registered
?NAME?_?NUM?_??_AWMIsi2mi_registered
(
	.ACLK         (ACLK         ), 
    .ARESETn      (ARESETn      ), 
    .INFORMATION_S({
                    ?0?AWIDsi??2mi,
                    ?0?AWADDRsi??2mi,  
                    ?0?AWLENsi??2mi,   
                    ?0?AWSIZEsi??2mi,  
//ENABLE_LOCK
                    ?0?AWLOCKsi??2mi,  
//ENABLE_CACHE
                    ?0?AWCACHEsi??2mi, 
//ENABLE_PROT
                    ?0?AWPROTsi??2mi,
                    ?0?AWBURSTsi??2mi 
                  }), 

	.VALID_S      (?0?AWVALIDsi2mi[??]),
	.READY_S      (?0?AWREADYmi2si[??]),
        
	.INFORMATION_R({
                    ?1?AWIDsi??2mi,
                    ?1?AWADDRsi??2mi,  
                    ?1?AWLENsi??2mi,   
                    ?1?AWSIZEsi??2mi,  
//ENABLE_LOCK
                    ?1?AWLOCKsi??2mi,  
//ENABLE_CACHE
                    ?1?AWCACHEsi??2mi, 
//ENABLE_PROT
                    ?1?AWPROTsi??2mi,
                    ?1?AWBURSTsi??2mi 

                  }),

	.VALID_R      (?1?AWVALIDsi2mi[??]),
	.READY_R      (?1?AWREADYmi2si[??])
);

?NAME?_WDMIsi2mi_registered
?NAME?_?NUM?_??_WDMIsi2mi_registered
(
	.ACLK         (ACLK         ), 
	.ARESETn      (ARESETn      ), 
	.INFORMATION_S({?0?WIDsi??2mi, 
                    ?0?WDATAsi??2mi, 
//ENABLE_WSTRB
                    ?0?WSTRBsi??2mi, 
                    ?0?WLASTsi2mi[??]
                    }), 

	.VALID_S      (?0?WVALIDsi2mi[??]  ),
	.READY_S      (?0?WREADYmi2si[??]  ),

	.INFORMATION_R({?1?WIDsi??2mi, 
                    ?1?WDATAsi??2mi, 
//ENABLE_WSTRB
                    ?1?WSTRBsi??2mi, 
                    ?1?WLASTsi2mi[??]}),

	.VALID_R      (?1?WVALIDsi2mi[??] ),
	.READY_R      (?1?WREADYmi2si[??] )
);

?NAME?_WRMIsi2mi_registered
?NAME?_?NUM?_??_WRMIsi2mi_registered
(
	.ACLK         (ACLK         ), 
    .ARESETn      (ARESETn      ), 
    .INFORMATION_S({?1?BIDmi2si??, ?1?BRESPmi2si??}), 

	.VALID_S      (?1?BVALIDmi2si[??]),
	.READY_S      (?1?BREADYsi2mi[??]),
        
	.INFORMATION_R({?0?BIDmi2si??, ?0?BRESPmi2si??}),

	.VALID_R      (?0?BVALIDmi2si[??]),
	.READY_R      (?0?BREADYsi2mi[??])
);
//STATE_END

//STATE05_START
//Master module     
//__________________________________________________

?NAME?_WriteChannelmi
?NAME?_WriteChannelmi(

    //Global signal
    .ACLK    (ACLK    ),
    .ARESETn (ARESETn ),

    //For slave 
    //Write address channel
    .AWIDmi2s    (?0?AWIDmi2s    ),
    .AWADDRmi2s  (?0?AWADDRmi2s  ),
    .AWLENmi2s   (?0?AWLENmi2s   ),
    .AWSIZEmi2s  (?0?AWSIZEmi2s  ),
    .AWBURSTmi2s (?0?AWBURSTmi2s ),
//ENABLE_LOCK
    .AWLOCKmi2s  (?0?AWLOCKmi2s  ),
//ENABLE_CACHE
    .AWCACHEmi2s (?0?AWCACHEmi2s ),
//ENABLE_PROT
    .AWPROTmi2s  (?0?AWPROTmi2s  ),

    .AWVALIDmi2s (?0?AWVALIDmi2s ),
    .AWREADYs2mi (?0?AWREADYs2mi ),

    //Write data channel
    .WIDmi2s     (?0?WIDmi2s     ),
    .WDATAmi2s   (?0?WDATAmi2s   ),
//ENABLE_WSTRB
    .WSTRBmi2s   (?0?WSTRBmi2s   ),
    .WLASTmi2s   (?0?WLASTmi2s   ),
    .WVALIDmi2s  (?0?WVALIDmi2s  ),
    .WREADYs2mi  (?0?WREADYs2mi  ),

    //Write response channel
    .BIDs2mi     (?0?BIDs2mi     ),
    .BRESPs2mi   (?0?BRESPs2mi   ),
    .BVALIDs2mi  (?0?BVALIDs2mi  ),
    .BREADYmi2s  (?0?BREADYmi2s  ),

    //Slave interface signal
    //Master 0/1/2/3
    .AWVALIDsi2mi  (?1?AWVALIDsi2mi  ),
    .AWREADYmi2si  (?1?AWREADYmi2si  ),

    //Master 0/1/2/3
    .WLASTsi2mi   (?1?WLASTsi2mi   ),
    .WVALIDsi2mi  (?1?WVALIDsi2mi  ),

    //output 1port
    .WREADYmi2si  (?1?WREADYmi2si  ),

    .BVALIDmi2si  (?1?BVALIDmi2si  ),
    .BREADYsi2mi  (?1?BREADYsi2mi),

//STATE_END

//STATE06_START
    ///////////////////////////////////////////////
    //For Master interface  Master Number = ??
    //Write address channel
    .AWIDsi??2mi    (?0?AWIDsi??2mi    ),
    .AWADDRsi??2mi  (?0?AWADDRsi??2mi  ),
    .AWLENsi??2mi   (?0?AWLENsi??2mi   ),
    .AWSIZEsi??2mi  (?0?AWSIZEsi??2mi  ),
    .AWBURSTsi??2mi (?0?AWBURSTsi??2mi ),
//ENABLE_LOCK_Write
    .AWLOCKsi??2mi  (?0?AWLOCKsi??2mi  ),
//ENABLE_CACHE_Write
    .AWCACHEsi??2mi (?0?AWCACHEsi??2mi ),
//ENABLE_PROT_Write
    .AWPROTsi??2mi  (?0?AWPROTsi??2mi  ),

    //Write data channel
    .WIDsi??2mi   (?0?WIDsi??2mi   ),     
    .WDATAsi??2mi (?0?WDATAsi??2mi ),   
//ENABLE_WSTRB_Write
    .WSTRBsi??2mi (?0?WSTRBsi??2mi ),   

    //Write response channel
    .BIDmi2si??     (?0?BIDmi2si??     ),
    .BRESPmi2si??   (?0?BRESPmi2si??   ),

//STATE_END

    //Lock control
    .Lock2Wrmi(Lock2Wrmi),
    .UnLock2Wrmi(UnLock2Wrmi),

    .Lock2Rdmi(Lock2Rdmi),
    .UnLock2Rdmi(UnLock2Rdmi),

    .ARVALID(ARVALID),

    .LockPort(LockPort),
    .ReadIntEmptyWrmi2Rdmi(ReadIntEmptyWrmi2Rdmi),
    .DataCntEmptyRdmi2Wrmi(DataCntEmptyRdmi2Wrmi),
    .CtlDataWrite2Lock    (CtlDataWrite2Lock    )
    );
endmodule
//STATE_END
//Code_END
