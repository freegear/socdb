
// ==================================================================
// ------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : TestSlaveBuffer.v
// File Revision       : 0.1
//  -----------------------------------------------------------------
//  Purpose            : This is behavioral model.
//                       (You cannot synthesize this)
//                       for testing AXI bus advanced mode
//  ==================================================================

`timescale 1ns/1ps

module  TestSlaveBuffer(
    
    //Global signal
    ACLK    ,
    ARESETn ,

    //For slave 
    //Write address channel
    AWIDts2s    ,
    AWADDRts2s  ,
    AWLENts2s   ,
    AWSIZEts2s  ,
    AWBURSTts2s ,
    AWLOCKts2s  ,
    AWCACHEts2s ,
    AWPROTts2s  ,

    AWVALIDts2s ,
    AWREADYs2ts ,

    //For test 
    //Write address channel
    AWIDmi2ts    ,
    AWADDRmi2ts  ,
    AWLENmi2ts   ,
    AWSIZEmi2ts  ,
    AWBURSTmi2ts ,
    AWLOCKmi2ts  ,
    AWCACHEmi2ts ,
    AWPROTmi2ts  ,

    AWVALIDmi2ts ,
    AWREADYts2mi ,

    BVALID,
    BREADY
);
`include "Def.v"

    input   ACLK;
    input   ARESETn;

    input   BVALID;
    input   BREADY;

    // For slave 
    // 2s (Slave)
    output   [(ID_WID+MASTER_WID-1):0]       AWIDts2s;    
    output   [ADDR_WID-1:0]     AWADDRts2s;
    output   [AWLEN_WID-1:0]    AWLENts2s;
    output   [AWSIZE_WID-1:0]   AWSIZEts2s;  
    output   [AWBURST_WID-1:0]  AWBURSTts2s; 
    output   [AWLOCK_WID-1:0]   AWLOCKts2s;  
    output   [AWCACHE_WID-1:0]  AWCACHEts2s; 
    output   [AWPROT_WID-1:0]   AWPROTts2s;  

    output   AWVALIDts2s; 
    wire     AWVALIDts2s; 
    input    AWREADYs2ts; 

    // For test 
    // 2ts (test)
    input   [(ID_WID+MASTER_WID-1):0]       AWIDmi2ts;    
    input   [ADDR_WID-1:0]     AWADDRmi2ts;
    input   [AWLEN_WID-1:0]    AWLENmi2ts;
    input   [AWSIZE_WID-1:0]   AWSIZEmi2ts;  
    input   [AWBURST_WID-1:0]  AWBURSTmi2ts; 
    input   [AWLOCK_WID-1:0]   AWLOCKmi2ts;  
    input   [AWCACHE_WID-1:0]  AWCACHEmi2ts; 
    input   [AWPROT_WID-1:0]   AWPROTmi2ts;  

    input   AWVALIDmi2ts; 
    output  AWREADYts2mi; 
    wire    AWREADYts2mi; 

    //_________________________________________________________
    //Request FIFO

    reg   [(ID_WID+MASTER_WID-1):0]       r0AWIDts2s;    
    reg   [(ID_WID+MASTER_WID-1):0]       r1AWIDts2s;    
    reg   [(ID_WID+MASTER_WID-1):0]       r2AWIDts2s;    
    reg   [(ID_WID+MASTER_WID-1):0]       r3AWIDts2s;    
    
    reg   [ADDR_WID-1:0]     r0AWADDRts2s;
    reg   [ADDR_WID-1:0]     r1AWADDRts2s;
    reg   [ADDR_WID-1:0]     r2AWADDRts2s;
    reg   [ADDR_WID-1:0]     r3AWADDRts2s;

    reg   [AWLEN_WID-1:0]    r0AWLENts2s;
    reg   [AWLEN_WID-1:0]    r1AWLENts2s;
    reg   [AWLEN_WID-1:0]    r2AWLENts2s;
    reg   [AWLEN_WID-1:0]    r3AWLENts2s;

    reg   [AWSIZE_WID-1:0]   r0AWSIZEts2s;  
    reg   [AWSIZE_WID-1:0]   r1AWSIZEts2s;  
    reg   [AWSIZE_WID-1:0]   r2AWSIZEts2s;  
    reg   [AWSIZE_WID-1:0]   r3AWSIZEts2s;  

    reg   [AWBURST_WID-1:0]  r0AWBURSTts2s; 
    reg   [AWBURST_WID-1:0]  r1AWBURSTts2s; 
    reg   [AWBURST_WID-1:0]  r2AWBURSTts2s; 
    reg   [AWBURST_WID-1:0]  r3AWBURSTts2s; 

    reg   [AWLOCK_WID-1:0]   r0AWLOCKts2s;  
    reg   [AWLOCK_WID-1:0]   r1AWLOCKts2s;  
    reg   [AWLOCK_WID-1:0]   r2AWLOCKts2s;  
    reg   [AWLOCK_WID-1:0]   r3AWLOCKts2s;  

    reg   [AWCACHE_WID-1:0]  r0AWCACHEts2s; 
    reg   [AWCACHE_WID-1:0]  r1AWCACHEts2s; 
    reg   [AWCACHE_WID-1:0]  r2AWCACHEts2s; 
    reg   [AWCACHE_WID-1:0]  r3AWCACHEts2s; 

    reg   [AWPROT_WID-1:0]   r0AWPROTts2s;  
    reg   [AWPROT_WID-1:0]   r1AWPROTts2s;  
    reg   [AWPROT_WID-1:0]   r2AWPROTts2s;  
    reg   [AWPROT_WID-1:0]   r3AWPROTts2s;  
    
    //_________________________________________________________

    //_________________________________________________________
    //FIFO point
    reg     [REQDEPTH_WID-1:0] WrPoint;
    reg     [REQDEPTH_WID-1:0] RdPoint;
    wire    [REQDEPTH_WID-1:0] NxWrPoint = WrPoint + 1;
    wire    [REQDEPTH_WID-1:0] NxRdPoint = RdPoint + 1;
    reg     ReqFull;
    reg     ReqEmpty;
    reg     rREADY;

    assign  AWREADYts2mi = !ReqFull & rREADY; 
    //assign  AWREADYts2mi = !ReqFull ;
    //assign  AWVALIDts2s  = !ReqEmpty & !rREADY; 
    assign  AWVALIDts2s  = !ReqEmpty ;

    always @( posedge ACLK or negedge ARESETn)
    begin
        if(!ARESETn)
        begin
            rREADY <= 1'b1;
        end
        else
        begin
            if(ReqFull)
                rREADY <= 1'b0;
            else if(ReqEmpty)
                rREADY <= 1'b1;
        end
    end

    //_________________________________________________________

    wire    WrPointUp = AWVALIDmi2ts & !ReqFull  & rREADY;
    wire    RdPointUp = AWREADYs2ts  & !ReqEmpty ;
    //wire    RdPointUp = BVALID  & BREADY;


    always @(posedge ACLK or negedge ARESETn)
    begin
        if(!ARESETn)
        begin
            WrPoint <= 0;
        end
        else
        begin
            if(WrPointUp & !ReqFull)
                WrPoint <= NxWrPoint;
            else
                WrPoint <= WrPoint;
        end
    end

    always @(posedge ACLK or negedge ARESETn)
    begin
        if(!ARESETn)
            RdPoint <= 0;
        else
            if(RdPointUp & !ReqEmpty) 
                RdPoint <= NxRdPoint;
            else
                RdPoint <= RdPoint;
    end

    //_________________________________________________________
    //Request full gen.
    always  @(posedge ACLK or negedge ARESETn)
    begin
        if(!ARESETn)
        begin
            ReqFull  <= 1'b0;
        end
        else
        begin
            if(RdPointUp & WrPointUp && (NxWrPoint == RdPoint))
                ReqFull <= 1'b1;
            else if(WrPointUp && (NxWrPoint == RdPoint))
                ReqFull <= 1'b1;
            else if(RdPointUp & ReqFull)//&& (WrPoint != NxRdPoint))
                ReqFull <= 1'b0;
        end
    end

    //_________________________________________________________
    //Request Empty gen.
    always  @(posedge ACLK or negedge ARESETn)
    begin
        if(!ARESETn)
        begin
            ReqEmpty  <= 1'b1;
        end
        else
        begin
            if(RdPointUp & WrPointUp && (WrPoint == NxRdPoint))
                ReqEmpty <= 1'b0;
            else if(RdPointUp && (WrPoint == NxRdPoint))
                ReqEmpty <= 1'b1;
            else if(WrPointUp & ReqEmpty)//&& (NxWrPoint != RdPoint))
                ReqEmpty <= 1'b0;
        end
    end

    //_________________________________________________________
    //Request FIFO Update

    always @(posedge ACLK or negedge ARESETn)
    begin
        if(!ARESETn)
        begin
            r0AWIDts2s <= 0;    
            r0AWADDRts2s <= 0;
            r0AWLENts2s <= 0;
            r0AWSIZEts2s <= 0;
            r0AWBURSTts2s <= 0;
            r0AWLOCKts2s <= 0;
            r0AWCACHEts2s <= 0;
            r0AWPROTts2s <= 0;
        end
        else
        begin
            if(WrPointUp & !ReqFull && (WrPoint == 2'd0))
            begin
                r0AWIDts2s <= AWIDmi2ts;    
                r0AWADDRts2s <= AWADDRmi2ts ;
                r0AWLENts2s <= AWLENmi2ts ;
                r0AWSIZEts2s <= AWSIZEmi2ts ;
                r0AWBURSTts2s <= AWBURSTmi2ts ;
                r0AWLOCKts2s <= AWLOCKmi2ts ;
                r0AWCACHEts2s <= AWCACHEmi2ts ;
                r0AWPROTts2s <= AWPROTmi2ts ;
            end
        end
    end

    always @(posedge ACLK or negedge ARESETn)
    begin
        if(!ARESETn)
        begin
            r1AWIDts2s <= 0;    
            r1AWADDRts2s <= 0;
            r1AWLENts2s <= 0;
            r1AWSIZEts2s <= 0;
            r1AWBURSTts2s <= 0;
            r1AWLOCKts2s <= 0;
            r1AWCACHEts2s <= 0;
            r1AWPROTts2s <= 0;
        end
        else
        begin
            if(WrPointUp & !ReqFull && (WrPoint == 2'd1))
            begin
                r1AWIDts2s <= AWIDmi2ts;    
                r1AWADDRts2s <= AWADDRmi2ts ;
                r1AWLENts2s <= AWLENmi2ts ;
                r1AWSIZEts2s <= AWSIZEmi2ts ;
                r1AWBURSTts2s <= AWBURSTmi2ts ;
                r1AWLOCKts2s <= AWLOCKmi2ts ;
                r1AWCACHEts2s <= AWCACHEmi2ts ;
                r1AWPROTts2s <= AWPROTmi2ts ;
            end
        end
    end

    always @(posedge ACLK or negedge ARESETn)
    begin
        if(!ARESETn)
        begin
            r2AWIDts2s <= 0;    
            r2AWADDRts2s <= 0;
            r2AWLENts2s <= 0;
            r2AWSIZEts2s <= 0;
            r2AWBURSTts2s <= 0;
            r2AWLOCKts2s <= 0;
            r2AWCACHEts2s <= 0;
            r2AWPROTts2s <= 0;
        end
        else
        begin
            if(WrPointUp & !ReqFull && (WrPoint == 2'd2))
            begin
                r2AWIDts2s <= AWIDmi2ts;    
                r2AWADDRts2s <= AWADDRmi2ts ;
                r2AWLENts2s <= AWLENmi2ts ;
                r2AWSIZEts2s <= AWSIZEmi2ts ;
                r2AWBURSTts2s <= AWBURSTmi2ts ;
                r2AWLOCKts2s <= AWLOCKmi2ts ;
                r2AWCACHEts2s <= AWCACHEmi2ts ;
                r2AWPROTts2s <= AWPROTmi2ts ;
            end
        end
    end

    always @(posedge ACLK or negedge ARESETn)
    begin
        if(!ARESETn)
        begin
            r3AWIDts2s <= 0;    
            r3AWADDRts2s <= 0;
            r3AWLENts2s <= 0;
            r3AWSIZEts2s <= 0;
            r3AWBURSTts2s <= 0;
            r3AWLOCKts2s <= 0;
            r3AWCACHEts2s <= 0;
            r3AWPROTts2s <= 0;
        end
        else
        begin
            if(WrPointUp & !ReqFull && (WrPoint == 2'd3))
            begin
                r3AWIDts2s <= AWIDmi2ts;    
                r3AWADDRts2s <= AWADDRmi2ts ;
                r3AWLENts2s <= AWLENmi2ts ;
                r3AWSIZEts2s <= AWSIZEmi2ts ;
                r3AWBURSTts2s <= AWBURSTmi2ts ;
                r3AWLOCKts2s <= AWLOCKmi2ts ;
                r3AWCACHEts2s <= AWCACHEmi2ts ;
                r3AWPROTts2s <= AWPROTmi2ts ;
            end
        end
    end

    //Read Point
    reg   [(ID_WID+MASTER_WID-1):0]       rAWIDts2s;    
    always @( RdPoint or
              r0AWIDts2s or
              r1AWIDts2s or
              r2AWIDts2s or
              r3AWIDts2s 
        )
    begin
        case(RdPoint)
            2'd0:   rAWIDts2s <= r0AWIDts2s ;
            2'd1:   rAWIDts2s <= r1AWIDts2s ;
            2'd2:   rAWIDts2s <= r2AWIDts2s ;
            2'd3:   rAWIDts2s <= r3AWIDts2s ;
        endcase
    end

    reg   [ADDR_WID-1:0]     rAWADDRts2s;
    always @( RdPoint or
              r0AWADDRts2s or
              r1AWADDRts2s or
              r2AWADDRts2s or
              r3AWADDRts2s 
          )
    begin
        case(RdPoint)
            2'd0:   rAWADDRts2s <= r0AWADDRts2s; 
            2'd1:   rAWADDRts2s <= r1AWADDRts2s; 
            2'd2:   rAWADDRts2s <= r2AWADDRts2s; 
            2'd3:   rAWADDRts2s <= r3AWADDRts2s; 
        endcase
    end

    reg   [AWLEN_WID-1:0]    rAWLENts2s;
    always  @( RdPoint or
               r0AWLENts2s or
               r1AWLENts2s or
               r2AWLENts2s or
               r3AWLENts2s )
    begin
        case(RdPoint)
            2'd0:   rAWLENts2s <= r0AWLENts2s; 
            2'd1:   rAWLENts2s <= r1AWLENts2s; 
            2'd2:   rAWLENts2s <= r2AWLENts2s; 
            2'd3:   rAWLENts2s <= r3AWLENts2s; 
        endcase
    end

    reg   [AWSIZE_WID-1:0]   rAWSIZEts2s;  
    always  @(RdPoint or
              r0AWSIZEts2s or
              r1AWSIZEts2s or
              r2AWSIZEts2s or
              r3AWSIZEts2s )
    begin
        case(RdPoint)
            2'd0:   rAWSIZEts2s <= r0AWSIZEts2s; 
            2'd1:   rAWSIZEts2s <= r1AWSIZEts2s; 
            2'd2:   rAWSIZEts2s <= r2AWSIZEts2s; 
            2'd3:   rAWSIZEts2s <= r3AWSIZEts2s; 
        endcase
    end

    reg   [AWBURST_WID-1:0]  rAWBURSTts2s; 
    always  @(RdPoint or
              r0AWBURSTts2s or
              r1AWBURSTts2s or
              r2AWBURSTts2s or
              r3AWBURSTts2s )
    begin
        case(RdPoint)
            2'd0:   rAWBURSTts2s <= r0AWBURSTts2s;
            2'd1:   rAWBURSTts2s <= r1AWBURSTts2s;
            2'd2:   rAWBURSTts2s <= r2AWBURSTts2s;
            2'd3:   rAWBURSTts2s <= r3AWBURSTts2s;
        endcase
    end


    reg   [AWLOCK_WID-1:0]   rAWLOCKts2s;  
    always  @(RdPoint or
              r0AWLOCKts2s or
              r1AWLOCKts2s or
              r2AWLOCKts2s or
              r3AWLOCKts2s )
    begin
        case(RdPoint)
            2'd0: rAWLOCKts2s <= r0AWLOCKts2s;
            2'd1: rAWLOCKts2s <= r1AWLOCKts2s;
            2'd2: rAWLOCKts2s <= r2AWLOCKts2s;
            2'd3: rAWLOCKts2s <= r3AWLOCKts2s;
        endcase
    end

    reg   [AWCACHE_WID-1:0]  rAWCACHEts2s; 
    always @(RdPoint or
             r0AWCACHEts2s or
             r1AWCACHEts2s or
             r2AWCACHEts2s or
             r3AWCACHEts2s )
    begin
        case(RdPoint)
            2'd0:   rAWCACHEts2s <= r0AWCACHEts2s;
            2'd1:   rAWCACHEts2s <= r1AWCACHEts2s;
            2'd2:   rAWCACHEts2s <= r2AWCACHEts2s;
            2'd3:   rAWCACHEts2s <= r3AWCACHEts2s;
        endcase
    end


    reg   [AWPROT_WID-1:0]   rAWPROTts2s;  
    always @(RdPoint or
             r0AWPROTts2s or
             r1AWPROTts2s or
             r2AWPROTts2s or
             r3AWPROTts2s )
    begin
        case(RdPoint)
            2'd0: rAWPROTts2s <= r0AWPROTts2s;
            2'd1: rAWPROTts2s <= r1AWPROTts2s;
            2'd2: rAWPROTts2s <= r2AWPROTts2s;
            2'd3: rAWPROTts2s <= r3AWPROTts2s;
        endcase
    end

    wire   [(ID_WID+MASTER_WID-1):0]       AWIDts2s = rAWIDts2s;    
    wire   [ADDR_WID-1:0]     AWADDRts2s= rAWADDRts2s;
    wire   [AWLEN_WID-1:0]    AWLENts2s=rAWLENts2s;
    wire   [AWSIZE_WID-1:0]   AWSIZEts2s=rAWSIZEts2s;  
    wire   [AWBURST_WID-1:0]  AWBURSTts2s=rAWBURSTts2s; 
    wire   [AWLOCK_WID-1:0]   AWLOCKts2s=rAWLOCKts2s;  
    wire   [AWCACHE_WID-1:0]  AWCACHEts2s=rAWCACHEts2s; 
    wire   [AWPROT_WID-1:0]   AWPROTts2s=rAWPROTts2s;  

endmodule
