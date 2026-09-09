

module  WriteChannelmi(
    
    //Global signal
    ACLK    ,
    ARESETn ,

    //For slave 
    //Write address channel
    AWIDmi2s    ,
    AWADDRmi2s  ,
    AWLENmi2s   ,
    AWSIZEmi2s  ,
    AWBURSTmi2s ,
    AWLOCKmi2s  ,
    AWCACHEmi2s ,
    AWPROTmi2s  ,

    AWVALIDmi2s ,
    AWREADYs2mi ,

    //Write data channel
    WIDmi2s     ,
    WDATAmi2s   ,
    WSTRBmi2s   ,
    WLASTmi2s   ,
    WVALIDmi2s  ,
    WREADYs2mi  ,

    //Write response channel
    BIDs2mi     ,
    BRESPs2mi   ,
    BVALIDs2mi  ,
    BREADYmi2s  ,

    //Slave interface signal

    //Write address channel
    //Master0
    AWIDsi02mi    ,
    AWADDRsi02mi  ,
    AWLENsi02mi   ,
    AWSIZEsi02mi  ,
    AWBURSTsi02mi ,
    AWLOCKsi02mi  ,
    AWCACHEsi02mi ,
    AWPROTsi02mi  ,

    //Master1
    AWIDsi12mi    ,
    AWADDRsi12mi  ,
    AWLENsi12mi   ,
    AWSIZEsi12mi  ,
    AWBURSTsi12mi ,
    AWLOCKsi12mi  ,
    AWCACHEsi12mi ,
    AWPROTsi12mi  ,

    //Master2
    AWIDsi22mi    ,
    AWADDRsi22mi  ,
    AWLENsi22mi   ,
    AWSIZEsi22mi  ,
    AWBURSTsi22mi ,
    AWLOCKsi22mi  ,
    AWCACHEsi22mi ,
    AWPROTsi22mi  ,

    //Master3
    AWIDsi32mi    ,
    AWADDRsi32mi  ,
    AWLENsi32mi   ,
    AWSIZEsi32mi  ,
    AWBURSTsi32mi ,
    AWLOCKsi32mi  ,
    AWCACHEsi32mi ,
    AWPROTsi32mi  ,

    //Master 0/1/2/3
    AWVALIDsi2mi  ,

    AWREADYmi2si  ,

    //Write data channel
    //Master 0
    WIDsi02mi   ,     
    WDATAsi02mi ,   
    WSTRBsi02mi ,   

    //Master 1
    WIDsi12mi   ,     
    WDATAsi12mi ,   
    WSTRBsi12mi ,   

    //Master 2
    WIDsi22mi   ,     
    WDATAsi22mi ,   
    WSTRBsi22mi ,   

    //Master 3
    WIDsi32mi   ,     
    WDATAsi32mi ,   
    WSTRBsi32mi ,   

    //Master 0/1/2/3
    WLASTsi2mi   ,
    WVALIDsi2mi  ,

    //output 1port
    WREADYmi2si  ,

    //Write response channel
    BIDmi2si     ,
    BRESPmi2si   ,
    BVALIDmi2si  ,

    BREADYsi2mi,

    //Lock control
    Lock2Wrmi,
    UnLock2Wrmi,

    Lock2Rdmi,
    UnLock2Rdmi,

    ARVALID,

    LockPort,
    ReadIntEmptyWrmi2Rdmi,
    DataCntEmptyRdmi2Wrmi,
    CtlDataWrite2Lock

    );
`include "Def.v"

    input   ACLK;
    input   ARESETn;

    // For slave 
    // 2s (Slave)
    output   [(ID_WID+MASTER_WID-1):0]       AWIDmi2s;    
    output   [ADDR_WID-1:0]     AWADDRmi2s;
    output   [AWLEN_WID-1:0]    AWLENmi2s;
    output   [AWSIZE_WID-1:0]   AWSIZEmi2s;  
    output   [AWBURST_WID-1:0]  AWBURSTmi2s; 
    output   [AWLOCK_WID-1:0]   AWLOCKmi2s;  
    output   [AWCACHE_WID-1:0]  AWCACHEmi2s; 
    output   [AWPROT_WID-1:0]   AWPROTmi2s;  

    output   AWVALIDmi2s; 
    input    AWREADYs2mi; 
    

    //Write data channel
    output   [(ID_WID+MASTER_WID-1):0]       WIDmi2s;     
    output   [BUS_WID-1:0]      WDATAmi2s;   
    output   [WSTRB_WID-1:0]    WSTRBmi2s;   
    output   WLASTmi2s;   
    output   WVALIDmi2s;  
    input    WREADYs2mi; 

    //Write response channel
    input   [(ID_WID+MASTER_WID-1):0]      BIDs2mi;     
    input   [BRESP_WID-1:0]   BRESPs2mi;   
    input   BVALIDs2mi;  
    output  BREADYmi2s;  
    
    //From SI(slave interface)
    //M0
    input   [ID_WID-1:0]       AWIDsi02mi;    
    input   [ADDR_WID-1:0]     AWADDRsi02mi;
    input   [AWLEN_WID-1:0]    AWLENsi02mi;
    input   [AWSIZE_WID-1:0]   AWSIZEsi02mi;  
    input   [AWBURST_WID-1:0]  AWBURSTsi02mi; 
    input   [AWLOCK_WID-1:0]   AWLOCKsi02mi;  
    input   [AWCACHE_WID-1:0]  AWCACHEsi02mi; 
    input   [AWPROT_WID-1:0]   AWPROTsi02mi; 

    //M1
    input   [ID_WID-1:0]       AWIDsi12mi;    
    input   [ADDR_WID-1:0]     AWADDRsi12mi;
    input   [AWLEN_WID-1:0]    AWLENsi12mi;
    input   [AWSIZE_WID-1:0]   AWSIZEsi12mi;  
    input   [AWBURST_WID-1:0]  AWBURSTsi12mi; 
    input   [AWLOCK_WID-1:0]   AWLOCKsi12mi;  
    input   [AWCACHE_WID-1:0]  AWCACHEsi12mi; 
    input   [AWPROT_WID-1:0]   AWPROTsi12mi; 

    //M2
    input   [ID_WID-1:0]       AWIDsi22mi;    
    input   [ADDR_WID-1:0]     AWADDRsi22mi;
    input   [AWLEN_WID-1:0]    AWLENsi22mi;
    input   [AWSIZE_WID-1:0]   AWSIZEsi22mi;  
    input   [AWBURST_WID-1:0]  AWBURSTsi22mi; 
    input   [AWLOCK_WID-1:0]   AWLOCKsi22mi;  
    input   [AWCACHE_WID-1:0]  AWCACHEsi22mi; 
    input   [AWPROT_WID-1:0]   AWPROTsi22mi; 

    //M3
    input   [ID_WID-1:0]       AWIDsi32mi;    
    input   [ADDR_WID-1:0]     AWADDRsi32mi;
    input   [AWLEN_WID-1:0]    AWLENsi32mi;
    input   [AWSIZE_WID-1:0]   AWSIZEsi32mi;  
    input   [AWBURST_WID-1:0]  AWBURSTsi32mi; 
    input   [AWLOCK_WID-1:0]   AWLOCKsi32mi;  
    input   [AWCACHE_WID-1:0]  AWCACHEsi32mi; 
    input   [AWPROT_WID-1:0]   AWPROTsi32mi; 

    input   [MASTER_NUM-1:0]    AWVALIDsi2mi;
    output  [MASTER_NUM-1:0]    AWREADYmi2si;

    //Write data channel
    //Master 0
    input   [ID_WID-1:0]   WIDsi02mi;     
    input   [BUS_WID-1:0]  WDATAsi02mi;   
    input   [WSTRB_WID-1:0]WSTRBsi02mi;   

    //Master 1
    input   [ID_WID-1:0]   WIDsi12mi;     
    input   [BUS_WID-1:0]  WDATAsi12mi;   
    input   [WSTRB_WID-1:0]WSTRBsi12mi;   

    //Master 2
    input   [ID_WID-1:0]   WIDsi22mi;     
    input   [BUS_WID-1:0]  WDATAsi22mi;   
    input   [WSTRB_WID-1:0]WSTRBsi22mi;   

    //Master 3
    input   [ID_WID-1:0]   WIDsi32mi;     
    input   [BUS_WID-1:0]  WDATAsi32mi;   
    input   [WSTRB_WID-1:0]WSTRBsi32mi;   

    input   [MASTER_NUM-1:0]WLASTsi2mi;   
    input   [MASTER_NUM-1:0]WVALIDsi2mi;  
    output  [MASTER_NUM-1:0]WREADYmi2si;  

    //Write response channel
    output   [ID_WID-1:0]    BIDmi2si;     
    output   [BRESP_WID-1:0] BRESPmi2si;   
    output   [MASTER_NUM-1:0]BVALIDmi2si;  
    input    [MASTER_NUM-1:0]BREADYsi2mi;    
    //Lock signal
    input    Lock2Wrmi;
    input    UnLock2Wrmi;
    input    ARVALID;
    input    DataCntEmptyRdmi2Wrmi;
    input    [MASTER_NUM-1:0]LockPort;

    output   [MASTER_WID-1:0]CtlDataWrite2Lock;
    output   ReadIntEmptyWrmi2Rdmi;

    output   Lock2Rdmi;
    output   UnLock2Rdmi;

    wire     [MASTER_WID-1:0]   CtlDataWrite2Lock;
    wire     ReqFull;
    wire     EnAWMUXn      ;
    wire     EnAWREADYMUXn ;
    wire     ReadIntEmptyWrmi2Rdmi = !ReqFull;
    wire     [5:0]  LockArbiter   ; 


    wire     [BRESP_WID-1:0] BRESPmi2si;   
    assign   BRESPmi2si = BRESPs2mi;


    //Arbiter
    //_______________________________________________________________
    reg    [MASTER_WID-1:0] CtlData2WrchMux; 
    wire   [MASTER_WID-1:0] CtlData2DatachMux;

    assign  CtlDataWrite2Lock = CtlData2WrchMux; 

    always @(posedge ACLK or negedge ARESETn)
    begin
        if(!ARESETn)
        begin
            CtlData2WrchMux <= 0;
        end
        else if(LockArbiter[1] | LockArbiter[5]) // STATE --> FUll_MASK
        begin                                    // STATE --> VMASK
            CtlData2WrchMux <= LockPort;
        end
        else if(!AWVALIDsi2mi[CtlData2WrchMux] && 
                !ReqFull && LockArbiter[0] ) // STATE --> IDLE
        begin
            if(AWVALIDsi2mi[0])
                CtlData2WrchMux <= 4'd0;
            else if(AWVALIDsi2mi[1])
                CtlData2WrchMux <= 4'd1;
            else if(AWVALIDsi2mi[2])
                CtlData2WrchMux <= 4'd2;
            else if(AWVALIDsi2mi[3])
                CtlData2WrchMux <= 4'd3;
        end
        else
            CtlData2WrchMux <= CtlData2WrchMux;
    end

    //_______________________________________________________________
    // Arbiter Mux to Lock control
    reg     AWVALID2s;
    reg     [AWLOCK_WID-1:0]   AWLOCK2s;

    always @(AWVALIDsi2mi or CtlData2WrchMux)   
    begin
        case(CtlData2WrchMux)
            // synopsys parallel_case full_case
            4'd0: 
            begin
                AWVALID2s <= AWVALIDsi2mi[0]; 
                AWLOCK2s  <= AWLOCKsi02mi;
            end
            4'd1: 
            begin
                AWVALID2s <= AWVALIDsi2mi[1]; 
                AWLOCK2s  <= AWLOCKsi12mi;
            end
            4'd2:
            begin
                AWVALID2s <= AWVALIDsi2mi[2]; 
                AWLOCK2s  <= AWLOCKsi22mi;
            end
            4'd3:
            begin
                AWVALID2s <= AWVALIDsi2mi[3]; 
                AWLOCK2s  <= AWLOCKsi32mi;
            end
        endcase
    end
    //________________________________________________________


    // ADDRESS Channel Mux Demux
    //_______________________________________________________________
    reg    [(ID_WID+MASTER_WID-1):0]       AWIDmi2s;    
    reg    [ADDR_WID-1:0]     AWADDRmi2s;
    reg    [AWLEN_WID-1:0]    AWLENmi2s;
    reg    [AWSIZE_WID-1:0]   AWSIZEmi2s;  
    reg    [AWBURST_WID-1:0]  AWBURSTmi2s; 
    reg    [AWLOCK_WID-1:0]   AWLOCKmi2s;  
    reg    [AWCACHE_WID-1:0]  AWCACHEmi2s; 
    reg    [AWPROT_WID-1:0]   AWPROTmi2s;  

    reg    [MASTER_NUM-1:0]    AWREADYmi2si;
    reg    AWVALIDmi2s; 
    
    always  @(AWREADYs2mi or
              CtlData2WrchMux or
              EnAWREADYMUXn 
          )
    begin

        case({EnAWREADYMUXn, CtlData2WrchMux})
            //synopsys parallel_case full_case
            5'd0:
            begin
                AWREADYmi2si[0] <= AWREADYs2mi;
                AWREADYmi2si[1] <= 1'b0;
                AWREADYmi2si[2] <= 1'b0;
                AWREADYmi2si[3] <= 1'b0;
            end
            5'd1:
            begin
                AWREADYmi2si[0] <= 1'b0;
                AWREADYmi2si[1] <= AWREADYs2mi;
                AWREADYmi2si[2] <= 1'b0;
                AWREADYmi2si[3] <= 1'b0;
            end
            5'd2:
            begin
                AWREADYmi2si[0] <= 1'b0;
                AWREADYmi2si[1] <= 1'b0;
                AWREADYmi2si[2] <= AWREADYs2mi;
                AWREADYmi2si[3] <= 1'b0;
            end
            5'd3:
            begin
                AWREADYmi2si[0] <= 1'b0;
                AWREADYmi2si[1] <= 1'b0;
                AWREADYmi2si[2] <= 1'b0;
                AWREADYmi2si[3] <= AWREADYs2mi;
            end
            default:
            begin
                AWREADYmi2si[0] <= 1'b0;
                AWREADYmi2si[1] <= 1'b0;
                AWREADYmi2si[2] <= 1'b0;
                AWREADYmi2si[3] <= 1'b0;
            end

        endcase

    end

    
    always @(AWVALIDsi2mi or    
             AWADDRsi02mi or    AWADDRsi12mi or
             AWADDRsi22mi or    AWADDRsi32mi or 

             AWLENsi02mi or     AWLENsi12mi or
             AWLENsi22mi or     AWLENsi32mi or

             AWSIZEsi02mi or    AWSIZEsi12mi or
             AWSIZEsi22mi or    AWSIZEsi32mi or

             AWBURSTsi02mi or
             AWBURSTsi12mi or
             AWBURSTsi22mi or
             AWBURSTsi32mi or

             AWLOCKsi02mi or
             AWLOCKsi12mi or
             AWLOCKsi22mi or
             AWLOCKsi32mi or

             AWPROTsi02mi or
             AWPROTsi12mi or
             AWPROTsi22mi or
             AWPROTsi32mi or

             AWIDsi02mi or
             AWIDsi12mi or
             AWIDsi22mi or
             AWIDsi32mi or

             AWCACHEsi02mi or
             AWCACHEsi12mi or
             AWCACHEsi22mi or
             AWCACHEsi32mi or

             EnAWMUXn    or
             CtlData2WrchMux)
    begin
        case({EnAWMUXn, CtlData2WrchMux})
            // synopsys parallel_case full_case
            5'd0:
                begin
                    AWIDmi2s    <= {AWIDsi02mi, 4'd0};
                    AWADDRmi2s  <= AWADDRsi02mi;
                    AWLENmi2s   <= AWLENsi02mi;
                    AWSIZEmi2s  <= AWSIZEsi02mi;
                    AWBURSTmi2s <= AWBURSTsi02mi;
                    AWLOCKmi2s  <= AWLOCKsi02mi;
                    AWCACHEmi2s <= AWCACHEsi02mi;
                    AWPROTmi2s  <= AWPROTsi02mi;

                    AWVALIDmi2s <= AWVALIDsi2mi[0]; 
                end
            5'd1:
                begin
                    AWIDmi2s    <= {AWIDsi12mi, 4'd1};
                    AWADDRmi2s  <= AWADDRsi12mi;
                    AWLENmi2s   <= AWLENsi12mi;
                    AWSIZEmi2s  <= AWSIZEsi12mi;
                    AWBURSTmi2s <= AWBURSTsi12mi;
                    AWLOCKmi2s  <= AWLOCKsi12mi;
                    AWCACHEmi2s <= AWCACHEsi12mi;
                    AWPROTmi2s  <= AWPROTsi12mi;

                    AWVALIDmi2s <= AWVALIDsi2mi[1]; 
                end

            5'd2:
                begin
                    AWIDmi2s    <= {AWIDsi22mi, 4'd2};
                    AWADDRmi2s  <= AWADDRsi22mi;
                    AWLENmi2s   <= AWLENsi22mi;
                    AWSIZEmi2s  <= AWSIZEsi22mi;
                    AWBURSTmi2s <= AWBURSTsi22mi;
                    AWLOCKmi2s  <= AWLOCKsi22mi;
                    AWCACHEmi2s <= AWCACHEsi22mi;
                    AWPROTmi2s  <= AWPROTsi22mi;

                    AWVALIDmi2s <= AWVALIDsi2mi[2]; 
                end
            5'd3:
                begin
                    AWIDmi2s    <= {AWIDsi32mi, 4'd3};
                    AWADDRmi2s  <= AWADDRsi32mi;
                    AWLENmi2s   <= AWLENsi32mi;
                    AWSIZEmi2s  <= AWSIZEsi32mi;
                    AWBURSTmi2s <= AWBURSTsi32mi;
                    AWLOCKmi2s  <= AWLOCKsi32mi;
                    AWCACHEmi2s <= AWCACHEsi32mi;
                    AWPROTmi2s  <= AWPROTsi32mi;

                    AWVALIDmi2s <= AWVALIDsi2mi[3]; 
                end
            default:
                begin
                    AWIDmi2s    <= 0;
                    AWADDRmi2s  <= 0;
                    AWLENmi2s   <= 0;
                    AWSIZEmi2s  <= 0;
                    AWBURSTmi2s <= 0;
                    AWLOCKmi2s  <= 0;
                    AWCACHEmi2s <= 0;
                    AWPROTmi2s  <= 0;

                    AWVALIDmi2s <= 0;

                end

        endcase
    end
    //_______________________________________________________________
        


    // Write Data Channel Mux Demux
    //_______________________________________________________________

    //Write data channel
    reg   [(ID_WID+MASTER_WID-1):0]       WIDmi2s;     
    reg   [BUS_WID-1:0]      WDATAmi2s;   
    reg   [WSTRB_WID-1:0]    WSTRBmi2s;   
    reg   WLASTmi2s;   
    reg   WVALIDmi2s;  

    reg   [MASTER_NUM-1:0]   WREADYmi2si;
    

    always  @(WREADYmi2si or
              WREADYs2mi  or
              CtlData2DatachMux )
    begin

        case(CtlData2DatachMux)
            //synopsys full_case
            3'd0:
            begin
                WREADYmi2si[0] <= WREADYs2mi;
                WREADYmi2si[1] <= 1'b0;
                WREADYmi2si[2] <= 1'b0;
                WREADYmi2si[3] <= 1'b0;
            end
            3'd1:
            begin
                WREADYmi2si[0] <= 1'b0;
                WREADYmi2si[1] <= WREADYs2mi;
                WREADYmi2si[2] <= 1'b0;
                WREADYmi2si[3] <= 1'b0;
            end
            3'd2:
            begin
                WREADYmi2si[0] <= 1'b0;
                WREADYmi2si[1] <= 1'b0;
                WREADYmi2si[2] <= WREADYs2mi;
                WREADYmi2si[3] <= 1'b0;
            end
            3'd3:
            begin
                WREADYmi2si[0] <= 1'b0;
                WREADYmi2si[1] <= 1'b0;
                WREADYmi2si[2] <= 1'b0;
                WREADYmi2si[3] <= WREADYs2mi;
            end
            default:
            begin
                WREADYmi2si[0] <= 1'b0;
                WREADYmi2si[1] <= 1'b0;
                WREADYmi2si[2] <= 1'b0;
                WREADYmi2si[3] <= 1'b0;
            end
        endcase
       /*
       for(i=0; i <= MASTER_NUM-1 ; i=i+1)
       begin
           if(CtlData2DatachMux == i)
               WREADYmi2si[i] <= WREADYs2mi ;
           else
               WREADYmi2si[i] <= 1'b0 ;
       end
       */
    end

    
    always @(WVALIDsi2mi or

             WIDsi02mi   or
             WIDsi12mi   or
             WIDsi22mi   or
             WIDsi32mi   or

             WDATAsi02mi or
             WDATAsi12mi or
             WDATAsi22mi or
             WDATAsi32mi or

             WSTRBsi02mi or
             WSTRBsi12mi or
             WSTRBsi22mi or
             WSTRBsi32mi or

             WLASTsi2mi  or
             WVALIDsi2mi or

             CtlData2DatachMux )
    begin
        case(CtlData2DatachMux)
            //synopsys full_case
            2'd0:
                begin
                    WIDmi2s   <= {WIDsi02mi, CtlData2DatachMux};
                    WDATAmi2s <= WDATAsi02mi;
                    WSTRBmi2s <= WSTRBsi02mi;
                    WLASTmi2s <= WLASTsi2mi[0];
                    WVALIDmi2s <= WVALIDsi2mi[0];
                end
            2'd1:
                begin
                    WIDmi2s   <= {WIDsi12mi, CtlData2DatachMux};
                    WDATAmi2s <= WDATAsi12mi;
                    WSTRBmi2s <= WSTRBsi12mi;
                    WLASTmi2s <= WLASTsi2mi[1];
                    WVALIDmi2s <= WVALIDsi2mi[1];
                end
            2'd2:
                begin
                    WIDmi2s   <= {WIDsi22mi, CtlData2DatachMux};
                    WDATAmi2s <= WDATAsi22mi;
                    WSTRBmi2s <= WSTRBsi22mi;
                    WLASTmi2s <= WLASTsi2mi[2];
                    WVALIDmi2s <= WVALIDsi2mi[2];
                end
            2'd3:
                begin
                    WIDmi2s   <= {WIDsi32mi, CtlData2DatachMux};
                    WDATAmi2s <= WDATAsi32mi;
                    WSTRBmi2s <= WSTRBsi32mi;
                    WLASTmi2s <= WLASTsi2mi[3];
                    WVALIDmi2s <= WVALIDsi2mi[3];
                end
            default:
                begin
                    WIDmi2s   <= 0;
                    WDATAmi2s <= 0;
                    WSTRBmi2s <= 0;
                    WLASTmi2s <= 0;
                    WVALIDmi2s <= 0; 
                end
        endcase
    end
    
    //_______________________________________________________________


    // Write response Channel Mux Demux
    //_______________________________________________________________
    
    wire   [ID_WID-1:0]    BIDmi2si;     

    reg   [MASTER_NUM-1:0]BVALIDmi2si;  
    reg    BREADYmi2s; 

    assign  BIDmi2si = BIDs2mi[((ID_WID+MASTER_WID-1)):MASTER_WID];    

    always  @( BIDs2mi[(MASTER_WID-1):0] or
               BREADYsi2mi or
               BVALIDs2mi 
             )
    begin
        case(BIDs2mi[(MASTER_WID-1):0])
            //synopsys full_case
            4'd0:   
                begin
                    BREADYmi2s <= BREADYsi2mi[0];
                    BVALIDmi2si[0] <= BVALIDs2mi;
                    BVALIDmi2si[1] <= 1'b0;
                    BVALIDmi2si[2] <= 1'b0;
                    BVALIDmi2si[3] <= 1'b0;
                end
            4'd1:   
                begin
                    BREADYmi2s <= BREADYsi2mi[1];
                    BVALIDmi2si[1] <= BVALIDs2mi;
                    BVALIDmi2si[2] <= 1'b0;
                    BVALIDmi2si[3] <= 1'b0;
                    BVALIDmi2si[0] <= 1'b0;
                end
            4'd2:   
                begin
                    BREADYmi2s <= BREADYsi2mi[2];
                    BVALIDmi2si[2] <= BVALIDs2mi;
                    BVALIDmi2si[3] <= 1'b0;
                    BVALIDmi2si[0] <= 1'b0;
                    BVALIDmi2si[1] <= 1'b0;
                end
            4'd3:   
                begin
                    BREADYmi2s <= BREADYsi2mi[3];
                    BVALIDmi2si[3] <= BVALIDs2mi;
                    BVALIDmi2si[0] <= 1'b0;
                    BVALIDmi2si[1] <= 1'b0;
                    BVALIDmi2si[2] <= 1'b0;
                end
            default:
                begin
                    BREADYmi2s <= 0;
                    BVALIDmi2si[3] <= 0;
                    BVALIDmi2si[0] <= 1'b0;
                    BVALIDmi2si[1] <= 1'b0;
                    BVALIDmi2si[2] <= 1'b0;
                end
        endcase
    end
    
    //_______________________________________________________________
    
    //Request Interleaving buffer
    //_______________________________________________________________

    wire    AWREADY2ReqInter = (EnAWREADYMUXn == 1'b0) ? AWREADYs2mi:1'b0;
    ReqInterBuff 
    U0ReqInterBuff(
        .ACLK       (ACLK),
        .ARESETn    (ARESETn),

        .AWVALID    (AWVALIDmi2s),
        .AWREADY    (AWREADY2ReqInter),
        .MASTERNUM  (CtlData2WrchMux),

        .BVALID     (BVALIDs2mi),
        .BREADY     (BREADYmi2s),
        .CtlData    (CtlData2DatachMux),

        .ReqFull    (ReqFull)
    );

    //_______________________________________________________________


    //Locked access control block
    //_______________________________________________________________
    
    
LockCtlWrmi
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

endmodule

