
//Syn 253:: modify ELAB-292(senstivelist)

module  ReadChannelmi(
    
    //Global signal
    ACLK    ,
    ARESETn ,

    //For slave 
    //Read address channel
    ARIDmi2s    ,
    ARADDRmi2s  ,
    ARLENmi2s   ,
    ARSIZEmi2s  ,
    ARBURSTmi2s ,
    ARLOCKmi2s  ,
    ARCACHEmi2s ,
    ARPROTmi2s  ,

    ARVALIDmi2s ,
    ARREADYs2mi ,

    //Read data channel
    RIDs2mi     ,
    RRESPs2mi   ,
    RDATAs2mi   ,
    RVALIDs2mi  ,
    RLASTs2mi   ,
    RREADYmi2s  ,


    //Slave interface signal

    //Read address channel
    //Master0
    ARIDsi02mi    ,
    ARADDRsi02mi  ,
    ARLENsi02mi   ,
    ARSIZEsi02mi  ,
    ARBURSTsi02mi ,
    ARLOCKsi02mi  ,
    ARCACHEsi02mi ,
    ARPROTsi02mi  ,

    //Master1
    ARIDsi12mi    ,
    ARADDRsi12mi  ,
    ARLENsi12mi   ,
    ARSIZEsi12mi  ,
    ARBURSTsi12mi ,
    ARLOCKsi12mi  ,
    ARCACHEsi12mi ,
    ARPROTsi12mi  ,

    //Master2
    ARIDsi22mi    ,
    ARADDRsi22mi  ,
    ARLENsi22mi   ,
    ARSIZEsi22mi  ,
    ARBURSTsi22mi ,
    ARLOCKsi22mi  ,
    ARCACHEsi22mi ,
    ARPROTsi22mi  ,

    //Master3
    ARIDsi32mi    ,
    ARADDRsi32mi  ,
    ARLENsi32mi   ,
    ARSIZEsi32mi  ,
    ARBURSTsi32mi ,
    ARLOCKsi32mi  ,
    ARCACHEsi32mi ,
    ARPROTsi32mi  ,

    //Master 0/1/2/3
    ARVALIDsi2mi  ,

    ARREADYmi2si  ,

    //Read data channel
    RIDmi2si     ,
    RRESPmi2si   ,
    RDATAmi2si   ,
    RVALIDmi2si  ,
    RLASTmi2si  ,
    RREADYsi2mi,

    //Lock Access
    Lock2Rdmi,
    UnLock2Rdmi,

    Lock2Wrmi,
    UnLock2Wrmi,

    AWVALID,

    LockPort,
    ReadIntEmptyWrmi2Rdmi,
    DataCntEmptyRdmi2Wrmi,
    CtlDataRead2Lock

);
`include "Def_TEST.v"

parameter SELMASTER_WID= 3;

    input   ACLK;
    input   ARESETn;

    // For slave 
    // 2s (Slave)
    output   [(ID_WID+SELMASTER_WID-1):0]       ARIDmi2s;    
    output   [ADDR_WID-1:0]     ARADDRmi2s;
    output   [ARLEN_WID-1:0]    ARLENmi2s;
    output   [ARSIZE_WID-1:0]   ARSIZEmi2s;  
    output   [ARBURST_WID-1:0]  ARBURSTmi2s; 
    output   [ARLOCK_WID-1:0]   ARLOCKmi2s;  
    output   [ARCACHE_WID-1:0]  ARCACHEmi2s; 
    output   [ARPROT_WID-1:0]   ARPROTmi2s;  

    output   ARVALIDmi2s; 
    input    ARREADYs2mi; 
    
    //Read data channel
    input   [(ID_WID+SELMASTER_WID-1):0]      RIDs2mi;     
    input   [RRESP_WID-1:0]   RRESPs2mi;   
    input   [BUS_WID-1:0]     RDATAs2mi;
    input   RLASTs2mi;
    input   RVALIDs2mi;  
    output  RREADYmi2s;  

    //From SI(slave interface)
    //M0
    input   [ID_WID-1:0]       ARIDsi02mi;    
    input   [ADDR_WID-1:0]     ARADDRsi02mi;
    input   [ARLEN_WID-1:0]    ARLENsi02mi;
    input   [ARSIZE_WID-1:0]   ARSIZEsi02mi;  
    input   [ARBURST_WID-1:0]  ARBURSTsi02mi; 
    input   [ARLOCK_WID-1:0]   ARLOCKsi02mi;  
    input   [ARCACHE_WID-1:0]  ARCACHEsi02mi; 
    input   [ARPROT_WID-1:0]   ARPROTsi02mi; 

    //M1
    input   [ID_WID-1:0]       ARIDsi12mi;    
    input   [ADDR_WID-1:0]     ARADDRsi12mi;
    input   [ARLEN_WID-1:0]    ARLENsi12mi;
    input   [ARSIZE_WID-1:0]   ARSIZEsi12mi;  
    input   [ARBURST_WID-1:0]  ARBURSTsi12mi; 
    input   [ARLOCK_WID-1:0]   ARLOCKsi12mi;  
    input   [ARCACHE_WID-1:0]  ARCACHEsi12mi; 
    input   [ARPROT_WID-1:0]   ARPROTsi12mi; 

    //M2
    input   [ID_WID-1:0]       ARIDsi22mi;    
    input   [ADDR_WID-1:0]     ARADDRsi22mi;
    input   [ARLEN_WID-1:0]    ARLENsi22mi;
    input   [ARSIZE_WID-1:0]   ARSIZEsi22mi;  
    input   [ARBURST_WID-1:0]  ARBURSTsi22mi; 
    input   [ARLOCK_WID-1:0]   ARLOCKsi22mi;  
    input   [ARCACHE_WID-1:0]  ARCACHEsi22mi; 
    input   [ARPROT_WID-1:0]   ARPROTsi22mi; 

    //M3
    input   [ID_WID-1:0]       ARIDsi32mi;    
    input   [ADDR_WID-1:0]     ARADDRsi32mi;
    input   [ARLEN_WID-1:0]    ARLENsi32mi;
    input   [ARSIZE_WID-1:0]   ARSIZEsi32mi;  
    input   [ARBURST_WID-1:0]  ARBURSTsi32mi; 
    input   [ARLOCK_WID-1:0]   ARLOCKsi32mi;  
    input   [ARCACHE_WID-1:0]  ARCACHEsi32mi; 
    input   [ARPROT_WID-1:0]   ARPROTsi32mi; 

    input   [MASTER_NUM-1:0]    ARVALIDsi2mi;
    output  [MASTER_NUM-1:0]   ARREADYmi2si;

    //Read data channel
    output   [ID_WID-1:0]         RIDmi2si;     
    output   [RRESP_WID-1:0]      RRESPmi2si;   
    output   [BUS_WID-1:0]        RDATAmi2si;

    output   [MASTER_NUM-1:0]   RVALIDmi2si;  
    output   [MASTER_NUM-1:0]   RLASTmi2si;  
    input    [MASTER_NUM-1:0]   RREADYsi2mi;    
    

    //Lock signal
    
    input    Lock2Rdmi;
    input    UnLock2Rdmi;
    input    AWVALID;
    input    [SELMASTER_WID-1:0]LockPort;
    input    ReadIntEmptyWrmi2Rdmi;

    output   [MASTER_WID-1:0]CtlDataRead2Lock;
    output   DataCntEmptyRdmi2Wrmi;

    output   Lock2Wrmi;
    output   UnLock2Wrmi;


    wire    DataCntEmptyRdmi2Wrmi;
    wire    EnARMUXn      ;
    wire    EnARREADYMUXn ;
    wire    [5:0]   LockArbiter   ; 


    //Arbiter
    //_______________________________________________________________
    reg    [SELMASTER_WID-1:0] CtlData2RdchMux;
    wire   ReqFull;
    wire   [SELMASTER_WID-1:0]CtlDataRead2Lock = CtlData2RdchMux;

    always @(posedge ACLK or negedge ARESETn)
    begin
        if(!ARESETn)
        begin
            CtlData2RdchMux <= {SELMASTER_WID{1'b0}};
        end
        else if(LockArbiter[1] | LockArbiter[5]) // STATE --> FUll_MASK
        begin                                    // STATE --> VMASK
            CtlData2RdchMux <= LockPort;
        end
        else if(!ARVALIDsi2mi[CtlData2RdchMux] && 
                !ReqFull && LockArbiter[0] )
        begin
            if(ARVALIDsi2mi[0])
            begin
                CtlData2RdchMux <= 4'd0;
            end
            else if(ARVALIDsi2mi[1])
            begin
                CtlData2RdchMux <= 4'd1;
            end
            else if(ARVALIDsi2mi[2])
            begin
                CtlData2RdchMux <= 4'd2;
            end
            else if(ARVALIDsi2mi[3])
            begin
                CtlData2RdchMux <= 4'd3;
            end
        end
        else
            CtlData2RdchMux <= CtlData2RdchMux;
    end
    //_______________________________________________________________


    //_______________________________________________________________
    // Arbiter Mux to Lock control
    reg     ARVALID2s;
    reg     [ARLOCK_WID-1:0]   ARLOCK2s;

    //Syn :: modify ELAB-292(senstivelist)
    always @(ARVALIDsi2mi or 
             CtlData2RdchMux or 
             ARLOCKsi02mi or
             ARLOCKsi12mi or
             ARLOCKsi22mi or
             ARLOCKsi32mi 
         )   
    begin
        case(CtlData2RdchMux)
            // synopsys parallel_case full_case
            4'd0: 
            begin
                ARVALID2s <= ARVALIDsi2mi[0]; 
                ARLOCK2s  <= ARLOCKsi02mi;
            end
            4'd1: 
            begin
                ARVALID2s <= ARVALIDsi2mi[1]; 
                ARLOCK2s  <= ARLOCKsi12mi;
            end
            4'd2:
            begin
                ARVALID2s <= ARVALIDsi2mi[2]; 
                ARLOCK2s  <= ARLOCKsi22mi;
            end
            4'd3:
            begin
                ARVALID2s <= ARVALIDsi2mi[3]; 
                ARLOCK2s  <= ARLOCKsi32mi;
            end
        endcase
    end
    //________________________________________________________



    // ADDRESS Channel Mux Demux
    //_______________________________________________________________
    reg    [(ID_WID+SELMASTER_WID-1):0]       ARIDmi2s;    
    reg    [ADDR_WID-1:0]     ARADDRmi2s;
    reg    [ARLEN_WID-1:0]    ARLENmi2s;
    reg    [ARSIZE_WID-1:0]   ARSIZEmi2s;  
    reg    [ARBURST_WID-1:0]  ARBURSTmi2s; 
    reg    [ARLOCK_WID-1:0]   ARLOCKmi2s;  
    reg    [ARCACHE_WID-1:0]  ARCACHEmi2s; 
    reg    [ARPROT_WID-1:0]   ARPROTmi2s;  

    reg    [MASTER_NUM-1:0]    ARREADYmi2si;
    reg   ARVALIDmi2s; 
    
    always  @(ARREADYs2mi or
              CtlData2RdchMux or
              EnARREADYMUXn
          )
    begin

        case({EnARREADYMUXn,CtlData2RdchMux})
            //synopsys parallel_case full_case
            5'd0:
            begin
                ARREADYmi2si[0] <= ARREADYs2mi;
                ARREADYmi2si[1] <= 1'b0;
                ARREADYmi2si[2] <= 1'b0;
                ARREADYmi2si[3] <= 1'b0;
            end
            5'd1:
            begin
                ARREADYmi2si[0] <= 1'b0;
                ARREADYmi2si[1] <= ARREADYs2mi;
                ARREADYmi2si[2] <= 1'b0;
                ARREADYmi2si[3] <= 1'b0;
            end
            5'd2:
            begin
                ARREADYmi2si[0] <= 1'b0;
                ARREADYmi2si[1] <= 1'b0;
                ARREADYmi2si[2] <= ARREADYs2mi;
                ARREADYmi2si[3] <= 1'b0;
            end
            5'd3:
            begin
                ARREADYmi2si[0] <= 1'b0;
                ARREADYmi2si[1] <= 1'b0;
                ARREADYmi2si[2] <= 1'b0;
                ARREADYmi2si[3] <= ARREADYs2mi;
            end
            default:
            begin
                ARREADYmi2si[0] <= 1'b0;
                ARREADYmi2si[1] <= 1'b0;
                ARREADYmi2si[2] <= 1'b0;
                ARREADYmi2si[3] <= 1'b0;
            end

        endcase
    end

//STATE02_START
             //0
    always @(ARVALIDsi2mi or
             CtlData2RdchMux or
             //1
             ARADDRsi02mi   or
             ARADDRsi12mi   or
             ARADDRsi22mi   or
             ARADDRsi32mi   or
             //2
             ARLENsi02mi    or
             ARLENsi12mi    or
             ARLENsi22mi    or
             ARLENsi32mi    or
            //3
             ARSIZEsi02mi   or
             ARSIZEsi12mi   or
             ARSIZEsi22mi   or
             ARSIZEsi32mi   or
            //4
             ARBURSTsi02mi  or
             ARBURSTsi12mi  or
             ARBURSTsi22mi  or
             ARBURSTsi32mi  or
            //5
             ARLOCKsi02mi   or
             ARLOCKsi12mi   or
             ARLOCKsi22mi   or
             ARLOCKsi32mi   or
            //6
             ARCACHEsi02mi  or
             ARCACHEsi12mi  or
             ARCACHEsi22mi  or
             ARCACHEsi32mi  or
            //7
             ARPROTsi02mi   or
             ARPROTsi12mi   or
             ARPROTsi22mi   or
             ARPROTsi32mi   or
             //8
             ARIDsi02mi or
             ARIDsi12mi or
             ARIDsi22mi or
             ARIDsi32mi or 

             EnARMUXn

             )
    begin
        case({EnARMUXn, CtlData2RdchMux})
            // synopsys parallel_case full_case
            5'd0:
                begin
                    ARIDmi2s    <= {ARIDsi02mi, 3'd0};//TEST
                    ARADDRmi2s  <= ARADDRsi02mi;
                    ARLENmi2s   <= ARLENsi02mi;
                    ARSIZEmi2s  <= ARSIZEsi02mi;
                    ARBURSTmi2s <= ARBURSTsi02mi;
                    ARLOCKmi2s  <= ARLOCKsi02mi;
                    ARCACHEmi2s <= ARCACHEsi02mi;
                    ARPROTmi2s  <= ARPROTsi02mi;

                    ARVALIDmi2s <= ARVALIDsi2mi[0]; 
                end

            5'd1:
                begin
                    ARIDmi2s    <= {ARIDsi12mi, 3'd1};
                    ARADDRmi2s  <= ARADDRsi12mi;
                    ARLENmi2s   <= ARLENsi12mi;
                    ARSIZEmi2s  <= ARSIZEsi12mi;
                    ARBURSTmi2s <= ARBURSTsi12mi;
                    ARLOCKmi2s  <= ARLOCKsi12mi;
                    ARCACHEmi2s <= ARCACHEsi12mi;
                    ARPROTmi2s  <= ARPROTsi12mi;

                    ARVALIDmi2s <= ARVALIDsi2mi[1]; 
                end

            5'd2:
                begin
                    ARIDmi2s    <= {ARIDsi22mi, 3'd2};
                    ARADDRmi2s  <= ARADDRsi22mi;
                    ARLENmi2s   <= ARLENsi22mi;
                    ARSIZEmi2s  <= ARSIZEsi22mi;
                    ARBURSTmi2s <= ARBURSTsi22mi;
                    ARLOCKmi2s  <= ARLOCKsi22mi;
                    ARCACHEmi2s <= ARCACHEsi22mi;
                    ARPROTmi2s  <= ARPROTsi22mi;

                    ARVALIDmi2s <= ARVALIDsi2mi[2]; 
                end

            5'd3:
                begin
                    ARIDmi2s    <= {ARIDsi32mi, 3'd3};
                    ARADDRmi2s  <= ARADDRsi32mi;
                    ARLENmi2s   <= ARLENsi32mi;
                    ARSIZEmi2s  <= ARSIZEsi32mi;
                    ARBURSTmi2s <= ARBURSTsi32mi;
                    ARLOCKmi2s  <= ARLOCKsi32mi;
                    ARCACHEmi2s <= ARCACHEsi32mi;
                    ARPROTmi2s  <= ARPROTsi32mi;

                    ARVALIDmi2s <= ARVALIDsi2mi[3]; 
                end
            default:
                begin
                    ARIDmi2s    <= 0;
                    ARADDRmi2s  <= 0;
                    ARLENmi2s   <= 0;
                    ARSIZEmi2s  <= 0;
                    ARBURSTmi2s <= 0;
                    ARLOCKmi2s  <= 0;
                    ARCACHEmi2s <= 0;
                    ARPROTmi2s  <= 0;

                    ARVALIDmi2s <= 0;
                end
                

        endcase
    end
    //_______________________________________________________________
        

    // Read data Channel Mux Demux
    //_______________________________________________________________
    
    wire  [ID_WID-1:0]      RIDmi2si;     
    wire  [RRESP_WID-1:0]   RRESPmi2si;   
    wire  [BUS_WID-1:0]     RDATAmi2si;

    reg   [MASTER_NUM-1:0]  RVALIDmi2si;  
    reg   [MASTER_NUM-1:0]  RLASTmi2si;  
    reg   RREADYmi2s; 

    assign  RIDmi2si = RIDs2mi[(ID_WID+SELMASTER_WID-1):SELMASTER_WID];    
    assign  RRESPmi2si = RRESPs2mi;
    assign  RDATAmi2si = RDATAs2mi;

    always  @( RIDs2mi[(SELMASTER_WID-1):0] or
               RREADYsi2mi or

               RVALIDs2mi or
               RLASTs2mi
             )
    begin
        case(RIDs2mi[(SELMASTER_WID-1):0])
            // synopsys parallel_case full_case
            4'd0:   
                begin
                    RREADYmi2s <= RREADYsi2mi[0];
                    RVALIDmi2si[0] <= RVALIDs2mi;
                    RLASTmi2si[0]  <= RLASTs2mi;
                    RVALIDmi2si[1] <= 1'b0;
                    RVALIDmi2si[2] <= 1'b0;
                    RVALIDmi2si[3] <= 1'b0;
                    RLASTmi2si[1]  <= 1'b0;
                    RLASTmi2si[2]  <= 1'b0;
                    RLASTmi2si[3]  <= 1'b0;
                end
            4'd1:   
                begin
                    RREADYmi2s <= RREADYsi2mi[1];
                    RVALIDmi2si[1] <= RVALIDs2mi;
                    RLASTmi2si[1]  <= RLASTs2mi;
                    RVALIDmi2si[0] <= 1'b0;
                    RVALIDmi2si[2] <= 1'b0;
                    RVALIDmi2si[3] <= 1'b0;
                    RLASTmi2si[0]  <= 1'b0;
                    RLASTmi2si[2]  <= 1'b0;
                    RLASTmi2si[3]  <= 1'b0;
                end
            4'd2:   
                begin
                    RREADYmi2s <= RREADYsi2mi[2];
                    RVALIDmi2si[2] <= RVALIDs2mi;
                    RLASTmi2si[2]  <= RLASTs2mi;
                    RVALIDmi2si[1] <= 1'b0;
                    RVALIDmi2si[0] <= 1'b0;
                    RVALIDmi2si[3] <= 1'b0;
                    RLASTmi2si[1]  <= 1'b0;
                    RLASTmi2si[0]  <= 1'b0;
                    RLASTmi2si[3]  <= 1'b0;
                end
            4'd3:   
                begin
                    RREADYmi2s <= RREADYsi2mi[3];
                    RVALIDmi2si[3] <= RVALIDs2mi;
                    RLASTmi2si[3]  <= RLASTs2mi;

                    RVALIDmi2si[1] <= 1'b0;
                    RVALIDmi2si[2] <= 1'b0;
                    RVALIDmi2si[0] <= 1'b0;
                    RLASTmi2si[1]  <= 1'b0;
                    RLASTmi2si[2]  <= 1'b0;
                    RLASTmi2si[0]  <= 1'b0;
                end
            default:
                begin
                    RREADYmi2s <= 0; 
                    RVALIDmi2si[3] <= 0;
                    RLASTmi2si[3]  <= 0;

                    RVALIDmi2si[1] <= 1'b0;
                    RVALIDmi2si[2] <= 1'b0;
                    RVALIDmi2si[0] <= 1'b0;
                    RLASTmi2si[1]  <= 1'b0;
                    RLASTmi2si[2]  <= 1'b0;
                    RLASTmi2si[0]  <= 1'b0;
                end
        endcase
    end
    
    //_______________________________________________________________
    

    //Request Counter block
    //_______________________________________________________________


    wire    ARREADY2ReqCnt = (EnARREADYMUXn == 1'b0) ? ARREADYs2mi:1'b0;
    ReqCnt U0ReqCnt(

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
    
    
LockCtlRdmi
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
