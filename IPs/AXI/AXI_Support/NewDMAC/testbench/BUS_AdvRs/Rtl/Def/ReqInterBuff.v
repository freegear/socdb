
module  ReqInterBuff(
    ACLK,
    ARESETn,

    AWVALID,
    AWREADY,
    MASTERNUM,
    BVALID,
    BREADY,
    CtlData,

    ReqFull,
    ReqEmpty
);
`include "Def.v"

    input   ACLK;
    input   ARESETn;
    input   AWVALID;
    input   AWREADY;
    input   BVALID;
    input   BREADY;
    output  ReqFull;
    output  ReqEmpty;
    input   [MASTER_WID -1:0] MASTERNUM;
    output  [MASTER_WID -1:0] CtlData;



    //_________________________________________________________
    //Request FIFO
    reg    [MASTER_WID -1:0] rREQBUFF00;
    reg    [MASTER_WID -1:0] rREQBUFF01;
    reg    [MASTER_WID -1:0] rREQBUFF02;
    reg    [MASTER_WID -1:0] rREQBUFF03;
    //_________________________________________________________


    //_________________________________________________________
    //FIFO point
    reg     [REQDEPTH_WID-1:0] WrPoint;
    reg     [REQDEPTH_WID-1:0] WrPoint;
    //_________________________________________________________

    wire    [MASTER_WID -1:0] CtlData;
    reg     [MASTER_WID -1:0] rREQBUFF;
    reg     ReqFull;
    reg     ReqEmpty;

    wire    WrPointUp = AWVALID & AWREADY;
    wire    RdPointUp = BVALID  & BREADY;

    assign  CtlData = rREQBUFF;

    //_________________________________________________________
    //CtlData update
    
    always @(rREQBUFF00 or rREQBUFF01 or
             rREQBUFF02 or rREQBUFF03 or RdPoint)
    begin
        case(RdPoint)
            2'd0:   rREQBUFF <= rREQBUFF00;
            2'd1:   rREQBUFF <= rREQBUFF01;
            2'd2:   rREQBUFF <= rREQBUFF02;
            2'd3:   rREQBUFF <= rREQBUFF03;
        endcase
    end
    
    //_________________________________________________________
    
    
    //_________________________________________________________
    //FIFO Conuter gen.
    
    wire     [REQDEPTH_WID-1:0] NxWrPoint = WrPoint + 1;
    wire     [REQDEPTH_WID-1:0] NxRdPoint = RdPoint + 1;

    always @(posedge ACLK or negedge ARESETn)
    begin
        if(!ARESETn)
            WrPoint <= 0;
        else if(WrPointUp)
            WrPoint <= NxWrPoint;
    end
    always @(posedge ACLK or negedge ARESETn)
    begin
        if(!ARESETn)
            RdPoint <= 0;
        else if(RdPointUp)
            RdPoint <= NxRdPoint;
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
            if(WrPointUp && (NxWrPoint == RdPoint))
                ReqFull <= 1'b1;
            else if(RdPointUp & ReqFull )//& (WrPoint != NxRdPoint))
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
            if(RdPointUp && (WrPoint == NxRdPoint))
                ReqEmpty <= 1'b1;
            else if(WrPointUp & ReqEmpty)//(NxWrPoint != RdPoint))
                ReqEmpty <= 1'b0;
        end
    end



    //_________________________________________________________
    //Request FIFO Update
    always @(posedge ACLK or negedge ARESETn)
    begin
        if(!ARESETn)
            rREQBUFF00 <= 0;
        else
        begin
            if(WrPointUp & !ReqFull && (WrPoint == 2'd0))
                rREQBUFF00 <= MASTERNUM;
        end
    end

    always @(posedge ACLK or negedge ARESETn)
    begin
        if(!ARESETn)
            rREQBUFF01 <= 0;
        else
        begin
            if(WrPointUp & !ReqFull && (WrPoint == 2'd1))
                rREQBUFF01 <= MASTERNUM;
        end
    end

    always @(posedge ACLK or negedge ARESETn)
    begin
        if(!ARESETn)
            rREQBUFF02 <= 0;
        else
        begin
            if(WrPointUp & !ReqFull && (WrPoint == 2'd2))
                rREQBUFF02 <= MASTERNUM;
        end
    end

    always @(posedge ACLK or negedge ARESETn)
    begin
        if(!ARESETn)
            rREQBUFF03 <= 0;
        else
        begin
            if(WrPointUp & !ReqFull && (WrPoint == 2'd3))
                rREQBUFF03 <= MASTERNUM;
        end
    end
    //_________________________________________________________
    
    
    /*
    always  @(posedge ACLK or negedge ARESETn)
    begin
        if(!ARESETn)
        begin
            rREQBUFF  <= {MASTER_WID{1'b0}};
        end
        else
        begin
            if(AWVALID & !ReqFull & AWREADY)
            begin
                rREQBUFF <= MASTERNUM;
                ReqFull  <= 1'b1;
            end
            else if(BVALID & BREADY)
            begin
                ReqFull  <= 1'b0;
                rREQBUFF <= {MASTER_WID{1'b1}};
            end
        end
    end
    */

endmodule
