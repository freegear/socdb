
//Code_START
input   ACLK;
input   ARESETn;
input   AREADY;
input   LAST;
input   AVALID;
input   RVALID;
input   [MASTERID_WID-1:0]    SID;  
input   [MASTERID_WID-1:0]    LID;  
input   [MASTERID_WID-1:0]    WID;  

input   [SLAVE_WID-1:0] SlaveNum;
input   READY;  

output  [SLAVE_WID  :0] CtlData2datach;
output  [SLAVE_WID  :0] CtlData2writech;

input   WREADY;
input   WVALID;
input   WLAST;

//BUFFER 
//STATE00_START
reg [SLAVE_WID-1:0] ID??SlaveBuffer;
//STATE00_END

//STATE01_START
reg [SLAVECNTWID-1:0]   ID??SlaveCnt;
//STATE01_END
reg [SLAVECNTWID-1:0]  WIDSlaveCnt; //don't move code




//Arbiter Mask signal
reg     [SLAVE_WID-1:0] WIDSlaveBuffer;

wire    EnWIDSlaveCnt = (WIDSlaveCnt > 0) ? 1'b1 : 1'b0;

//ver 1.9
//STATE_START
wire   ID??SlaveCntFull = (ID??SlaveCnt == {SLAVECNTWID{1'b1}}) ? 1'b1 : 1'b0;
//STATE_END


//________________________________________________________________________
//Control Data channel 

always  @(
//STATE02_START
            ID??SlaveBuffer or
//STATE02_END
            WID
        )
begin
    case(WID)
    //synopsys parallel_case full_case
//STATE03_START
    MASTER_WID'd??:   WIDSlaveBuffer = ID??SlaveBuffer;
//STATE03_END
    endcase
end

//Bug Fixed______2006/7/12
always  @(
//STATE02_START
            ID??SlaveCnt or
//STATE02_END
            WID
        )
begin
    case(WID)
    //synopsys parallel_case full_case
//STATE03_START
    MASTER_WID'd??:   WIDSlaveCnt = ID??SlaveCnt;
//STATE03_END
    endcase
end


//________________________________________________________________________

// 2^MASTER_WID -> ID0 ~ ID15
//________________________________________________________________________
//STATE04_START
//SlaveBuffer update ID?? 
always @(posedge ACLK or negedge ARESETn)
begin
    if(!ARESETn)
    begin
        ID??SlaveBuffer <= 0;
    end
    else
    begin
        if(ID??SlaveCnt == 0 && AVALID)
            ID??SlaveBuffer <= SlaveNum;
    end
end
//STATE04_END


//________________________________________________________________________
//SlaveCnt
//Enable
//STATE05_START
wire    ID??EnCNTup = ((SID == ??) && (SlaveNum == ID??SlaveBuffer)) ? 1'b1 : 1'b0;
//STATE05_END
//STATE06_START
wire    ID??EnCNTdn =  (LID == ??) ? 1'b1 : 1'b0;
//STATE06_END

//________________________________________________________________________

wire    CNTup = (AREADY & AVALID);
wire    CNTdn = (LAST   & READY & RVALID);

/*
reg     CNTdn_1p;

always @(posedge ACLK or negedge ARESETn)
begin
    if(!ARESETn)
        CNTdn_1p <= 1'b0;
    else
        CNTdn_1p <= CNTdn;
end
*/


//________________________________________________________________________
//STATE07_START
//ID?? Slave Counter
always @(posedge ACLK or negedge ARESETn)
begin
    if(!ARESETn)
    begin
        ID??SlaveCnt <= 0;
    end
    else
    begin
        if(CNTup & ID??EnCNTup & CNTdn & ID??EnCNTdn)
            ID??SlaveCnt <= ID??SlaveCnt;
        else if(CNTup & ID??EnCNTup & !ID??SlaveCntFull)
            ID??SlaveCnt <= ID??SlaveCnt + 1;
        else if(CNTdn & ID??EnCNTdn)
            ID??SlaveCnt <= ID??SlaveCnt - 1;
    end
end

//STATE07_END
//________________________________________________________________________


//MUX state

reg     InMUX;

always  @(
//STATE08_START
            ID??EnCNTup or
//STATE08_END
            AVALID  
        )
begin
    if(AVALID & (
//STATE09_START
            ID??EnCNTup ??
//STATE09_END
       ))
        InMUX <= 1'b1;
    else
        InMUX <= 1'b0;
end

//MUX 
reg     [SLAVE_WID-1:0] SIDSlaveBuffer;
//Ver 1.9
reg     SIDSlaveFull;
wire    EnData;
//Ver 1.9
assign  CtlData2writech[SLAVE_WID]     = SIDSlaveFull ? 1'b0 : InMUX; 
assign  CtlData2writech[SLAVE_WID-1:0] = SIDSlaveBuffer;

assign  CtlData2datach[SLAVE_WID-1:0]  = WIDSlaveBuffer[SLAVE_WID-1:0];
assign  CtlData2datach[SLAVE_WID]      = EnData;

reg [2:0]StateWID;
reg [2:0]NxStateWID;


//Ver 2.4
parameter WR_WID    = 1,
          HOLD_WID  = 2,
          WAIT_WID  = 0;

assign  EnData = StateWID[WR_WID];
always @(posedge ACLK or negedge ARESETn)
begin
    if(!ARESETn)
    begin
        StateWID[WR_WID]    <= 1'b0;
        StateWID[HOLD_WID]  <= 1'b0;
        StateWID[WAIT_WID]  <= 1'b1;
    end
    else
    begin
        StateWID <= NxStateWID;
    end
end

//Ver 1.6 Wdata permit control modified
always @(
            //CNTdn_1p or
            EnWIDSlaveCnt or
            WREADY or WVALID or WLAST or CNTup or
            WID or SID or StateWID
        )
begin
    NxStateWID <= 0;
    case(1'b1)

        StateWID[WAIT_WID]:
            if(EnWIDSlaveCnt)
                NxStateWID[WR_WID]  <= 1'b1;
            else if(!EnWIDSlaveCnt && (SID==WID) && CNTup) //Ver 2.4
                NxStateWID[WR_WID]  <= 1'b1;
            else
                NxStateWID[WAIT_WID]  <= 1'b1;

        StateWID[WR_WID]:
            if(WREADY & WVALID & WLAST)
                NxStateWID[HOLD_WID]<= 1'b1;
            else
                NxStateWID[WR_WID]  <= 1'b1;

        StateWID[HOLD_WID]:
            if(EnWIDSlaveCnt)       //==> Ver2.4 
                NxStateWID[WR_WID]  <= 1'b1;
            else if(!EnWIDSlaveCnt) //==> Ver2.4
                NxStateWID[WAIT_WID]  <= 1'b1;
            else
                NxStateWID[HOLD_WID]<= 1'b1;

        default:
                NxStateWID[WR_WID]  <= 1'b1;
    endcase
end

always  @(
//STATE10_START
            ID??SlaveBuffer or
//STATE10_END
            SID
        )
begin
    case(SID)
    //synopsys parallel_case full_case
//STATE11_START
        MASTER_WID'd??:   SIDSlaveBuffer = ID??SlaveBuffer;
//STATE11_END
    endcase
end

//Ver 1.9
always  @(
//STATE_START
            ID??SlaveCntFull or
//STATE_END
            SID
        )
begin
    case(SID)
    //synopsys parallel_case full_case
//STATE_START
        MASTER_WID'd??:   SIDSlaveFull = ID??SlaveCntFull;
//STATE_END
    endcase
end


endmodule
//Code_END



