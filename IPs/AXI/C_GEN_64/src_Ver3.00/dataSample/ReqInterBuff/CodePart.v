    
    input   ACLK;
    input   ARESETn;
    input   AWVALID;
    input   AWREADY;
    input   BVALID;
    input   BREADY;
    output  ReqFull;
    output  ReqEmpty;
    //Ver 2.1 added
    input   WLAST;
    input   WREADY;
    //Ver 1.7 added
    output  NxReqEmpty;
    input   [SELMASTER_WID -1:0] MASTERNUM;
    output  [SELMASTER_WID -1:0] CtlData;

    //_________________________________________________________
    //Request FIFO
//STATE00_START
        reg    [SELMASTER_WID -1:0] rREQBUFF??;
//STATE00_END
    //_________________________________________________________

    //_________________________________________________________
    //FIFO point
    reg     [Wr_REQDEPTH_WID-1:0] WrPoint;
    reg     [Wr_REQDEPTH_WID-1:0] RdPoint;
    //Ver2.4 added
    reg     [Wr_REQDEPTH_WID-1:0] IssuePoint;
    //_________________________________________________________

    wire    [SELMASTER_WID -1:0] CtlData;
    reg     [SELMASTER_WID -1:0] rREQBUFF;
    reg     ReqFull;
    reg     ReqEmpty;

    wire    WrPointUp = AWVALID & AWREADY;
    wire    RdPointUp = BVALID  & BREADY;

    //Ver2.4
    wire    IssuePointUp = WLAST  & WREADY;

    //Ver1.7 modified
    assign  CtlData = (ReqEmpty) ? MASTERNUM : rREQBUFF;

    //_________________________________________________________
    //CtlData update
    
    always @(
//STATE01_START
                rREQBUFF?? or 
//STATE01_END
                IssuePoint
            )
    begin
        case(IssuePoint)
//STATE02_START
            RdPointWID'd??:   rREQBUFF <= rREQBUFF??;
//STATE02_END
        endcase
    end
    //_________________________________________________________

    //_________________________________________________________
    //FIFO Conuter gen.
    
    wire     [Wr_REQDEPTH_WID-1:0] NxWrPoint = WrPoint + 1;
    wire     [Wr_REQDEPTH_WID-1:0] NxRdPoint = RdPoint + 1;
    wire     [Wr_REQDEPTH_WID-1:0] NxIssuePoint = IssuePoint + 1;

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

    always @(posedge ACLK or negedge ARESETn) //Ver2.1
    begin
        if(!ARESETn)
            IssuePoint <= 0;
        else if(IssuePointUp)
            IssuePoint <= NxIssuePoint;
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
        begin//Ver 1.4
            if(WrPointUp & RdPointUp)
                ReqFull <= ReqFull;
            else if(WrPointUp && (NxWrPoint == RdPoint))
                ReqFull <= 1'b1;
            else if(RdPointUp & ReqFull )//& (WrPoint != NxRdPoint))
                ReqFull <= 1'b0;
        end
    end

    //_________________________________________________________
    //Request Empty gen.
    assign  NxReqEmpty = (WrPoint == NxRdPoint) ? 1'b1 : 1'b0;
    always  @(posedge ACLK or negedge ARESETn)
    begin
        if(!ARESETn)
        begin
            ReqEmpty  <= 1'b1;
        end
        else
        begin // Ver 1.4
            if(RdPointUp & WrPointUp)
                ReqEmpty <= ReqEmpty;
            else if(RdPointUp && (WrPoint == NxRdPoint))
                ReqEmpty <= 1'b1;
            else if(WrPointUp & ReqEmpty)//(NxWrPoint != RdPoint))
                ReqEmpty <= 1'b0;
        end
    end


    //_________________________________________________________
    //Request FIFO Update
//STATE03_START
    always @(posedge ACLK or negedge ARESETn)
    begin
        if(!ARESETn)
            rREQBUFF?? <= 0;
        else
        begin
            if(WrPointUp & !ReqFull && (WrPoint == RdPointWID'd??))
                rREQBUFF?? <= MASTERNUM;
        end
    end
//STATE03_END
    //_________________________________________________________
    
endmodule 
//Code_END
