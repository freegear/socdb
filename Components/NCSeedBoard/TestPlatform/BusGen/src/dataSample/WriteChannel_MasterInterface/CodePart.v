
    wire     [SELMASTER_WID-1:0]   CtlDataWrite2Lock;
    wire     ReqFull;
    wire     ReqEmpty;
    wire     EnAWMUXn      ;
    wire     EnAWREADYMUXn ;
    wire     ReadIntEmptyWrmi2Rdmi =  ReqEmpty;
    wire     [5:0]  LockArbiter   ; 



    //Arbiter
    //_______________________________________________________________
    reg    [SELMASTER_WID-1:0] CtlData2WrchMux; 
    wire   [SELMASTER_WID-1:0] CtlData2DatachMux;
    assign CtlDataWrite2Lock = CtlData2WrchMux; 

//ARBITER_GEN_START
//Define_START
02
ACLK
ARESETn
CtlData2WrchMux
AWVALIDsi2mi
//END
//ARBITER_GEN_END
    
    //_______________________________________________________________
    // Arbiter Mux to Lock control
    reg     AWVALID2s;
    reg     [AWLOCK_WID-1:0]   AWLOCK2s;

    // Syn 309 :: modify ELAB-292(senstivelist)
    always @(
             AWVALIDsi2mi or 
//STATE_START
             AWLOCKsi??2mi or
//STATE_END
             CtlData2WrchMux 
            )   
    begin
        case(CtlData2WrchMux)
            // synopsys parallel_case 
//STATE_START
            ?WID?'d??: 
            begin
                AWVALID2s <= AWVALIDsi2mi[??]; 
                AWLOCK2s  <= AWLOCKsi??2mi;
            end
//STATE_END
        endcase
    end
    //________________________________________________________


    // ADDRESS Channel Mux Demux
    //_______________________________________________________________
    reg    [ADDR_WID-1:0]     AWADDRmi2s;
    reg    [AWLEN_WID-1:0]    AWLENmi2s;
    reg    [AWSIZE_WID-1:0]   AWSIZEmi2s;  
    reg    [AWBURST_WID-1:0]  AWBURSTmi2s; 
    reg    [AWLOCK_WID-1:0]   AWLOCKmi2s;  
    reg    [AWCACHE_WID-1:0]  AWCACHEmi2s; 
    reg    [AWPROT_WID-1:0]   AWPROTmi2s;  

    reg    [MASTER_NUM-1:0]   AWREADYmi2si;
    reg    AWVALIDmi2s; 
    reg    [MASTERID_WID-1:0] regAWIDmi2s;
    wire   [SELMASTER_WID-1:0]wireMASTERNUM;

    assign  AWIDmi2s = {regAWIDmi2s, wireMASTERNUM};

    // if ReqFull , the WriteChannelmi don't send READYmi2si
    wire   WireEnAWREADYMUXn = ReqFull |  EnAWREADYMUXn ;

//MUX_GEN_START
//Define_START
02
CtlData2WrchMux 
AWREADYs2mi 
SLAVE_WID
AWREADYmi2si
WireEnAWREADYMUXn
//END
//MUX_END

    // if ReqFull , the WriteChannelmi don't send  AWVALIDmi2s
    wire   WireEnAWMUXn = ReqFull | EnAWMUXn;
    assign wireMASTERNUM = (WireEnAWMUXn == 1'b0) ? 
                            CtlData2WrchMux : {SELMASTER_WID{1'b0}};
    always @(//0
             AWVALIDsi2mi or    
             WireEnAWMUXn or
             CtlData2WrchMux
            )
    begin
        case({WireEnAWMUXn, CtlData2WrchMux})
            // synopsys parallel_case full_case
//STATE_START
            ?WID?'d??:   AWVALIDmi2s <= AWVALIDsi2mi[??]; 
//STATE_END
            default:   
                    AWVALIDmi2s <= 1'b0; 
        endcase
    end

    always @(//1
//STATE_START
             AWADDRsi??2mi or    
//STATE_END
             WireEnAWMUXn or
             CtlData2WrchMux
            )
    begin
        case({WireEnAWMUXn, CtlData2WrchMux})
            // synopsys parallel_case full_case
//STATE_START
            ?WID?'d??:   AWADDRmi2s  <= AWADDRsi??2mi;
//STATE_END
            default:
                    AWADDRmi2s  <= 0;
        endcase
    end


    always @(//2
//STATE_START
             AWLENsi??2mi or    
//STATE_END

             WireEnAWMUXn or
             CtlData2WrchMux
            )
    begin
        case({WireEnAWMUXn, CtlData2WrchMux})
            // synopsys parallel_case full_case
//STATE_START
            ?WID?'d??:   AWLENmi2s   <= AWLENsi??2mi;
//STATE_END
            default:   
                    AWLENmi2s   <= 0;
        endcase
    end

    always @(//3
//STATE_START
             AWSIZEsi??2mi or    
//STATE_END
             WireEnAWMUXn or
             CtlData2WrchMux
            )
    begin
        case({WireEnAWMUXn, CtlData2WrchMux})
            // synopsys parallel_case full_case
//STATE_START
            ?WID?'d??:   AWSIZEmi2s  <= AWSIZEsi??2mi;
//STATE_END
            default:
                    AWSIZEmi2s  <= 0;
        endcase
    end

    always @(//4
//STATE_START
             AWBURSTsi??2mi or    
//STATE_END
             WireEnAWMUXn or
             CtlData2WrchMux
            )
    begin
        case({WireEnAWMUXn, CtlData2WrchMux})
            // synopsys parallel_case full_case
//STATE_START
            ?WID?'d??:   AWBURSTmi2s <= AWBURSTsi??2mi;
//STATE_END
            default:
                    AWBURSTmi2s <= 0;
        endcase
    end

    always @(//5
//STATE_START
             AWLOCKsi??2mi or    
//STATE_END
             WireEnAWMUXn or
             CtlData2WrchMux
            )
    begin
        case({WireEnAWMUXn, CtlData2WrchMux})
            // synopsys parallel_case full_case
//STATE_START
            ?WID?'d??:   AWLOCKmi2s  <= AWLOCKsi??2mi;
//STATE_END
            default:
                    AWLOCKmi2s  <= 0;
        endcase
    end

    always @(//6
//STATE_START
             AWPROTsi??2mi or    
//STATE_END

             WireEnAWMUXn or
             CtlData2WrchMux
            )
    begin
        case({WireEnAWMUXn, CtlData2WrchMux})
            // synopsys parallel_case full_case
//STATE_START
            ?WID?'d??:   AWPROTmi2s  <= AWPROTsi??2mi;
//STATE_END
            default:
                    AWPROTmi2s  <= 0;
        endcase
    end

    always @(//7
//STATE_START
             AWIDsi??2mi or    
//STATE_END
             WireEnAWMUXn or
             CtlData2WrchMux
            )
    begin
        case({WireEnAWMUXn, CtlData2WrchMux})
            // synopsys parallel_case full_case
//STATE_START
            ?WID?'d??:   regAWIDmi2s    <= AWIDsi??2mi;
//STATE_END
            default:
                    regAWIDmi2s    <= 0;
        endcase
    end

    always @(//8
//STATE_START
             AWCACHEsi??2mi or    
//STATE_END

             WireEnAWMUXn or
             CtlData2WrchMux
            )
    begin
        case({WireEnAWMUXn, CtlData2WrchMux})
            // synopsys parallel_case full_case
//STATE_START
            ?WID?'d??:   AWCACHEmi2s <= AWCACHEsi??2mi;
//STATE_END
            default:
                    AWCACHEmi2s <= 0;
        endcase
    end
    //_______________________________________________________________
        


    // Write Data Channel Mux Demux
    //_______________________________________________________________

    //Write data channel
    reg   [SLAVEID_WID-1:0]       WIDmi2s;     
    reg   [BUS_WID-1:0]      WDATAmi2s;   
    reg   [WSTRB_WID-1:0]    WSTRBmi2s;   
    reg   WLASTmi2s;   
    reg   WVALIDmi2s;  

    reg   [MASTER_NUM-1:0]   WREADYmi2si;

    //Ver 1.7 (NxReqEmpty)
    wire  NxReqEmpty;
    //Ver 1.2 modified (WENn)
    reg   rWENn;
    wire  AVALID_EMPTY = !(AWVALIDmi2s & ReqEmpty);  // Ver 1.8
    wire  WENn = (rWENn | ReqEmpty) & AVALID_EMPTY;  //Ver1.7
    always @(posedge ACLK or negedge ARESETn)
    begin
        if(!ARESETn)
        begin
            rWENn <= 1'b0;
        end
        else if(WVALIDmi2s & WLASTmi2s & WREADYs2mi & NxReqEmpty)
        begin
            rWENn <= 1'b1;
        end
        else if(WVALIDmi2s & WLASTmi2s & WREADYs2mi & !NxReqEmpty)
        begin
            rWENn <= 1'b0;
        end
        else if( BVALIDs2mi & BREADYmi2s) //Ver 1.7 modified
        begin
            rWENn <= 1'b0;
        end

    end

//MUX_GEN_START
//Define_START
02
CtlData2DatachMux 
WREADYs2mi 
MASTER_WID
WREADYmi2si
WENn
//END
//MUX_END


    always @(//1
//STATE_START
             WIDsi??2mi   or
//STATE_END
             CtlData2DatachMux or
             WENn // Ver 1.2
            )
    begin
        case({WENn, CtlData2DatachMux})
            //synopsys full_case
//STATE_START
            ?WID?'d??:   WIDmi2s   <= {WIDsi??2mi, CtlData2DatachMux};
//STATE_END
            default:
                    WIDmi2s   <= 0;
        endcase
    end

    always @(//2
//STATE_START
             WDATAsi??2mi or
//STATE_END
             CtlData2DatachMux or
             WENn // Ver 1.2
            )
    begin
        case({WENn, CtlData2DatachMux})
            //synopsys full_case
//STATE_START
            ?WID?'d??:   WDATAmi2s <= WDATAsi??2mi;
//STATE_END
            default:
                    WDATAmi2s <= 0;
        endcase
    end

    always @(//3
//STATE_START
             WSTRBsi??2mi or
//STATE_END
             CtlData2DatachMux or
             WENn // Ver 1.2
            )
    begin
        case({WENn, CtlData2DatachMux})
            //synopsys full_case
//STATE_START
            ?WID?'d??:   WSTRBmi2s <= WSTRBsi??2mi;
//STATE_END
            default:
                    WSTRBmi2s <= 0;
        endcase
    end    

    always @(//4
             WLASTsi2mi  or
             CtlData2DatachMux or
             WENn // Ver 1.2
            )
    begin
        case({WENn, CtlData2DatachMux})
            //synopsys full_case
//STATE_START
            ?WID?'d??:   WLASTmi2s <= WLASTsi2mi[??];
//STATE_END
            default:
                    WLASTmi2s <= 1'b0;
        endcase
    end        

    always @(//5
             WVALIDsi2mi or
             CtlData2DatachMux or
             WENn // Ver 1.2
            )
    begin
        case({WENn, CtlData2DatachMux})
            //synopsys full_case
//STATE_START
            ?WID?'d??:   WVALIDmi2s <= WVALIDsi2mi[??];
//STATE_END
            default:
                    WVALIDmi2s <= 0;
        endcase
    end        
    //_______________________________________________________________


    // Write response Channel Mux Demux
    //_______________________________________________________________
    
    reg    BREADYmi2s; 
    reg    [MASTER_NUM-1:0]BVALIDmi2si;  


    always  @( BIDs2mi[(SELMASTER_WID-1):0] or
               BREADYsi2mi 
             )
    begin
        case(BIDs2mi[(SELMASTER_WID-1):0])
            //synopsys full_case
//STATE_START
            ?WID?'d??:   BREADYmi2s <= BREADYsi2mi[??];
//STATE_END
            default:     BREADYmi2s <= 0;
        endcase
    end
                        
//MUX_GEN_START
//Define_START
01
BIDs2mi[(SELMASTER_WID-1):0] 
BVALIDs2mi 
MASTER_WID
BVALIDmi2si
//END
//MUX_END

    //_______________________________________________________________
    
    //Request Interleaving buffer
    //_______________________________________________________________

    wire    AWREADY2ReqInter = (EnAWREADYMUXn | ReqFull) ? 1'b0:AWREADYs2mi;
    ?NAME?_ReqInterBuff 
    U0ReqInterBuff(
        .ACLK       (ACLK),
        .ARESETn    (ARESETn),

        .AWVALID    (AWVALIDmi2s),
        .AWREADY    (AWREADY2ReqInter),
        .MASTERNUM  (CtlData2WrchMux),

        .BVALID     (BVALIDs2mi),
        .BREADY     (BREADYmi2s),
        .CtlData    (CtlData2DatachMux),

        .ReqFull    (ReqFull),
        .ReqEmpty   (ReqEmpty),
        //Ver 1.7 added
        .NxReqEmpty (NxReqEmpty) 
    );

    //_______________________________________________________________


    //Locked access control block
    //_______________________________________________________________
    
?NAME?_LockCtlWrmi
U0LockCtlWrmi(

        .ACLK(ACLK),
        .ARESETn(ARESETn),

        .ReqIntEmpty(ReadIntEmptyWrmi2Rdmi),
        .DataCntEmptyRdmi2Wrmi(DataCntEmptyRdmi2Wrmi),

        .ALOCK(AWLOCK2s),
        .AVALID(AWVALID2s),
        .OVALID(ARVALID),

        .LockPort(LockPort),

        .Lock_in(Lock2Wrmi),
        .UnLock_in(UnLock2Wrmi),

        .Lock_out(Lock2Rdmi),
        .UnLock_out(UnLock2Rdmi),

        .CtlData(CtlData2WrchMux),
        //WriteChannel mux CtlData2WrchMux
        //ReadChannel  mux CtlData2RdchMux

        .EnAMUXn(EnAWMUXn),
        .EnAREADYMUXn(EnAWREADYMUXn),
        .LockArbiter(LockArbiter)

        );
    //_______________________________________________________________

//STATE_START
    
    //MASTER ??
    wire   [MASTERID_WID-1:0]   BIDmi2si??;     
    wire   [BRESP_WID-1:0]      BRESPmi2si??;   
    assign BIDmi2si?? = BIDs2mi[(SLAVEID_WID-1):SELMASTER_WID];   
    assign BRESPmi2si?? = BRESPs2mi;
//STATE_END

endmodule
//Code_END
