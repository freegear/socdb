
    //Arbiter
    //_______________________________________________________________
    reg    [SELMASTER_WID-1:0] CtlData2RdchMux;
    wire   ReqFull;
    wire   [SELMASTER_WID-1:0]CtlDataRead2Lock = CtlData2RdchMux;

//ARBITER_GEN_START
//Define_START
02
ACLK
ARESETn
CtlData2RdchMux
ARVALIDsi2mi
//END
//ARBITER_GEN_END
    //_______________________________________________________________


    //_______________________________________________________________
    // Arbiter Mux to Lock control
    reg     ARVALID2s;
    reg     [ARLOCK_WID-1:0]   ARLOCK2s;

   //Syn :: modify ELAB-292(senstivelist)
    always @(ARVALIDsi2mi or 
             
//STATE00_START
             ARLOCKsi??2mi or
//STATE_END

             CtlData2RdchMux 
         )   
    begin
        case(CtlData2RdchMux)
            // synopsys parallel_case 
//STATE01_START
            ?WID?'d??: 
            begin
                ARVALID2s <= ARVALIDsi2mi[??]; 
                ARLOCK2s  <= ARLOCKsi??2mi;
            end
//STATE_END
        endcase
    end
    //________________________________________________________

    // ADDRESS Channel Mux Demux
    //_______________________________________________________________
    wire   [SLAVEID_WID-1:0]  ARIDmi2s;    
    reg    [ADDR_WID-1:0]     ARADDRmi2s;
    reg    [ARLEN_WID-1:0]    ARLENmi2s;
    reg    [ARSIZE_WID-1:0]   ARSIZEmi2s;  
    reg    [ARBURST_WID-1:0]  ARBURSTmi2s; 
    reg    [ARLOCK_WID-1:0]   ARLOCKmi2s;  
    reg    [ARCACHE_WID-1:0]  ARCACHEmi2s; 
    reg    [ARPROT_WID-1:0]   ARPROTmi2s;  

    reg    [MASTER_NUM-1:0]    ARREADYmi2si;
    reg    ARVALIDmi2s;     

//MUX_GEN_START
//Define_START
02
CtlData2RdchMux 
ARREADYs2mi 
SLAVE_WID
ARREADYmi2si
EnARREADYMUXn
//END
//MUX_END

    always @(//0
             ARVALIDsi2mi or    
             EnARMUXn or
             CtlData2RdchMux
            )
    begin
        case({EnARMUXn, CtlData2RdchMux})
            // synopsys parallel_case full_case
//STATE02_START
            ?WID?'d??:   ARVALIDmi2s <= ARVALIDsi2mi[??]; 
//STATE_END
            default:   
                    ARVALIDmi2s <= 1'b0; 
        endcase
    end

    always @(//1
//STATE03_START
             ARADDRsi??2mi or    
//STATE_END
             EnARMUXn or
             CtlData2RdchMux
            )
    begin
        case({EnARMUXn, CtlData2RdchMux})
            // synopsys parallel_case full_case
//STATE04_START
            ?WID?'d??:   ARADDRmi2s  <= ARADDRsi??2mi;
//STATE_END
            default:
                    ARADDRmi2s  <= 0;
        endcase
    end

    always @(//2
//STATE05_START
             ARLENsi??2mi or    
//STATE_END
             EnARMUXn or
             CtlData2RdchMux
            )
    begin
        case({EnARMUXn, CtlData2RdchMux})
            // synopsys parallel_case full_case
//STATE06_START
            ?WID?'d??:   ARLENmi2s  <= ARLENsi??2mi;
//STATE_END
            default:
                    ARLENmi2s  <= 0;
        endcase
    end

    always @(//3
//STATE07_START
             ARSIZEsi??2mi or    
//STATE_END
             EnARMUXn or
             CtlData2RdchMux
            )
    begin
        case({EnARMUXn, CtlData2RdchMux})
            // synopsys parallel_case full_case
//STATE08_START
            ?WID?'d??:   ARSIZEmi2s  <= ARSIZEsi??2mi;
//STATE_END
            default:
                    ARSIZEmi2s  <= 0;
        endcase
    end    

    always @(//4
//STATE09_START
             ARBURSTsi??2mi or    
//STATE_END
             EnARMUXn or
             CtlData2RdchMux
            )
    begin
        case({EnARMUXn, CtlData2RdchMux})
            // synopsys parallel_case full_case
//STATE10_START
            ?WID?'d??:   ARBURSTmi2s  <= ARBURSTsi??2mi;
//STATE_END
            default:
                    ARBURSTmi2s  <= 0;
        endcase
    end    

    always @(//5
//STATE11_START
             ARLOCKsi??2mi or    
//STATE_END
             EnARMUXn or
             CtlData2RdchMux
            )
    begin
        case({EnARMUXn, CtlData2RdchMux})
            // synopsys parallel_case full_case
//STATE12_START
            ?WID?'d??:   ARLOCKmi2s  <= ARLOCKsi??2mi;
//STATE_END
            default:
                    ARLOCKmi2s  <= 0;
        endcase
    end        

    always @(//6
//STATE13_START
             ARCACHEsi??2mi    or    
//STATE_END
             EnARMUXn or
             CtlData2RdchMux
            )
    begin
        case({EnARMUXn, CtlData2RdchMux})
            // synopsys parallel_case full_case
//STATE14_START
            ?WID?'d??:   ARCACHEmi2s  <= ARCACHEsi??2mi;
//STATE_END
            default:
                    ARCACHEmi2s  <= 0;
        endcase
    end        

    always @(//7
//STATE15_START
             ARPROTsi??2mi    or    
//STATE_END
             EnARMUXn or
             CtlData2RdchMux
            )
    begin
        case({EnARMUXn, CtlData2RdchMux})
            // synopsys parallel_case full_case
//STATE16_START
            ?WID?'d??:   ARPROTmi2s  <= ARPROTsi??2mi;
//STATE_END
            default:
                    ARPROTmi2s  <= 0;
        endcase
    end        



    reg     [MASTERID_WID-1:0]  regARIDmi2s;
    assign  ARIDmi2s = {regARIDmi2s, CtlData2RdchMux};

    always @(//8
//STATE17_START
             ARIDsi??2mi    or    
//STATE_END
             EnARMUXn or
             CtlData2RdchMux
            )
    begin
        case({EnARMUXn, CtlData2RdchMux})
            // synopsys parallel_case full_case
//STATE18_START
            ?WID?'d??:   regARIDmi2s  <= ARIDsi??2mi;
//STATE_END
            default:
                    regARIDmi2s  <= 0;
        endcase
    end        

    //_______________________________________________________________
        

    // Read data Channel Mux Demux
    //_______________________________________________________________
    

    reg   [MASTER_NUM-1:0]  RVALIDmi2si;  
    reg   [MASTER_NUM-1:0]  RLASTmi2si;  
    reg   RREADYmi2s; 

//STATE19_START
    //Number ??
    wire  [MASTERID_WID-1:0]RIDmi2si??;     
    wire  [RRESP_WID-1:0]   RRESPmi2si??;   
    wire  [BUS_WID-1:0]     RDATAmi2si??;

    assign  RIDmi2si?? = RIDs2mi[(SLAVEID_WID-1):SELMASTER_WID];    
    assign  RRESPmi2si?? = RRESPs2mi;
    assign  RDATAmi2si?? = RDATAs2mi;

//STATE_END

    //0
    always  @( RIDs2mi[(SELMASTER_WID-1):0] or
               RREADYsi2mi 
             )
    begin
        case(RIDs2mi[(SELMASTER_WID-1):0])
            // synopsys parallel_case full_case
//STATE20_START
            ?WID?'d??:   RREADYmi2s <= RREADYsi2mi[??]; //0
//STATE_END
            default:     RREADYmi2s <= 1'b0;
        endcase
    end

//1
//MUX_GEN_START

//Define_START
01
RIDs2mi[(SELMASTER_WID-1):0] 
RVALIDs2mi 
MASTER_WID
RVALIDmi2si
//END
//MUX_END

//2
//MUX_GEN_START

//Define_START
01
RIDs2mi[(SELMASTER_WID-1):0] 
RLASTs2mi 
MASTER_WID
RLASTmi2si
//END
//MUX_END

    //_______________________________________________________________
    

    //Request Counter block
    //_______________________________________________________________


    wire    ARREADY2ReqCnt = (EnARREADYMUXn == 1'b0) ? ARREADYs2mi:1'b0;
    ?NAME?_ReqCnt U0ReqCnt(

    .ACLK(ACLK),
    .ARESETn(ARESETn),

    .ARVALID(ARVALIDmi2s),
    .ARREADY(ARREADY2ReqCnt),

    .RVALID(RVALIDs2mi),
    .RREADY(RREADYmi2s),
    .RLAST(RLASTs2mi),

    .DataCNTEmpty(DataCntEmptyRdmi2Wrmi),
    .DataCNTFull(ReqFull)
);

    //_______________________________________________________________


    //Locked access control block
    //_______________________________________________________________
    
    
?NAME?_LockCtlRdmi
U0LockCtlRdmi(

        .ACLK(ACLK),
        .ARESETn(ARESETn),

        .ReqIntEmpty(ReadIntEmptyWrmi2Rdmi),
        .DataCntEmptyRdmi2Wrmi(DataCntEmptyRdmi2Wrmi),

        .ALOCK(ARLOCK2s),
        .AVALID(ARVALID2s),
        .OVALID(AWVALID),

        .LockPort(LockPort),

        .Lock_in(Lock2Rdmi),
        .UnLock_in(UnLock2Rdmi),

        .Lock_out(Lock2Wrmi),
        .UnLock_out(UnLock2Wrmi),

        .CtlData(CtlData2RdchMux),
        //WriteChannel mux CtlData2WrchMux
        //ReadChannel  mux CtlData2RdchMux

        .EnAMUXn(EnARMUXn),
        .EnAREADYMUXn(EnARREADYMUXn),
        .LockArbiter(LockArbiter)

        );
    //_______________________________________________________________

    
endmodule
//Code_END
