
module  PermitCtl(

    ACLK    ,
    ARESETn ,
    SlaveNum,

    SID,
    AREADY,
    AVALID,

    WID,

    LID,
    LAST, 
    READY,
    RVALID,

    CtlData2datach  ,
    CtlData2writech 
    //Mask2resch

    );
`include "Def.v"

input   ACLK;
input   ARESETn;
input   AREADY;
input   LAST;
input   AVALID;
input   RVALID;
input   [ID_WID-1:0]    SID;  
input   [ID_WID-1:0]    LID;  
input   [ID_WID-1:0]    WID;  

input   [SLAVE_WID-1:0] SlaveNum;
input   READY;  

output  [SLAVE_WID-1:0] CtlData2datach;
output  [SLAVE_WID  :0] CtlData2writech;
//output  [SLAVE_NUM  :0] Mask2resch; 

//BUFFER 2^ID_WID
reg [SLAVE_WID-1:0]     ID0SlaveBuffer, ID5SlaveBuffer, ID10SlaveBuffer, ID15SlaveBuffer,
                        ID1SlaveBuffer, ID6SlaveBuffer, ID11SlaveBuffer,
                        ID2SlaveBuffer, ID7SlaveBuffer, ID12SlaveBuffer,
                        ID3SlaveBuffer, ID8SlaveBuffer, ID13SlaveBuffer,
                        ID4SlaveBuffer, ID9SlaveBuffer, ID14SlaveBuffer;

reg [SLAVECNTWID-1:0]   ID0SlaveCnt, ID5SlaveCnt, ID10SlaveCnt, ID15SlaveCnt,
                        ID1SlaveCnt, ID6SlaveCnt, ID11SlaveCnt,
                        ID2SlaveCnt, ID7SlaveCnt, ID12SlaveCnt,
                        ID3SlaveCnt, ID8SlaveCnt, ID13SlaveCnt,
                        ID4SlaveCnt, ID9SlaveCnt, ID14SlaveCnt;


//Arbiter Mask signal
//reg     [SLAVE_NUM  :0] Mask2resch; 
reg     [SLAVE_WID-1:0] WIDSlaveBuffer;

assign  CtlData2datach   = WIDSlaveBuffer;

/*
assign  CtlData2rddatach[SLAVE_WID]     = {SlaveCnt == 0} ? 1'b0 : 1'b1; //1
assign  CtlData2rddatach[SLAVE_WID-1:0] = SlaveBuffer;
*/



//________________________________________________________________________
//Mask signal Gen.


/*
assign  Mask2resch[0] = (ID0SlaveCnt == 0) ? 1'b0 : 1'b1;
assign  Mask2resch[1] = (ID0SlaveCnt == 1) ? 1'b0 : 1'b1;
assign  Mask2resch[2] = (ID0SlaveCnt == 2) ? 1'b0 : 1'b1;
assign  Mask2resch[3] = (ID0SlaveCnt == 3) ? 1'b0 : 1'b1;
assign  Mask2resch[4] = (ID0SlaveCnt == 4) ? 1'b0 : 1'b1;
*/


//________________________________________________________________________










//________________________________________________________________________
//Control Data channel 

always  @(
            ID0SlaveBuffer or
            ID1SlaveBuffer or
            ID2SlaveBuffer or
            ID3SlaveBuffer or
            ID4SlaveBuffer or
            ID5SlaveBuffer or
            ID6SlaveBuffer or
            ID7SlaveBuffer or
            ID8SlaveBuffer or
            ID9SlaveBuffer or
            ID10SlaveBuffer or
            ID11SlaveBuffer or
            ID12SlaveBuffer or
            ID13SlaveBuffer or
            ID14SlaveBuffer or
            ID15SlaveBuffer or
            WID
        )
begin
    case(WID)
    //synopsys parallel_case full_case
        4'd0:   WIDSlaveBuffer = ID0SlaveBuffer;
        4'd1:   WIDSlaveBuffer = ID1SlaveBuffer;
        4'd2:   WIDSlaveBuffer = ID2SlaveBuffer;
        4'd3:   WIDSlaveBuffer = ID3SlaveBuffer;
        4'd4:   WIDSlaveBuffer = ID4SlaveBuffer;
        4'd5:   WIDSlaveBuffer = ID5SlaveBuffer;
        4'd6:   WIDSlaveBuffer = ID6SlaveBuffer;
        4'd7:   WIDSlaveBuffer = ID7SlaveBuffer;
        4'd8:   WIDSlaveBuffer = ID8SlaveBuffer;
        4'd9:   WIDSlaveBuffer = ID9SlaveBuffer;
        4'd10:  WIDSlaveBuffer = ID10SlaveBuffer;
        4'd11:  WIDSlaveBuffer = ID11SlaveBuffer;
        4'd12:  WIDSlaveBuffer = ID12SlaveBuffer;
        4'd13:  WIDSlaveBuffer = ID13SlaveBuffer;
        4'd14:  WIDSlaveBuffer = ID14SlaveBuffer;
        4'd15:  WIDSlaveBuffer = ID15SlaveBuffer;
    endcase
end

//________________________________________________________________________




// 2^ID_WID -> ID0 ~ ID15
//________________________________________________________________________
//SlaveBuffer update ID0 
always @(posedge ACLK or negedge ARESETn)
begin
    if(!ARESETn)
    begin
        ID0SlaveBuffer <= 0;
    end
    else
    begin
        if(ID0SlaveCnt == 0 && AVALID)
            ID0SlaveBuffer <= SlaveNum;
    end
end


//SlaveBuffer update ID1 
always @(posedge ACLK or negedge ARESETn)
begin
    if(!ARESETn)
    begin
        ID1SlaveBuffer <= 0;
    end
    else
    begin
        if(ID1SlaveCnt == 0 && AVALID)
            ID1SlaveBuffer <= SlaveNum;
    end
end

//SlaveBuffer update ID2 
always @(posedge ACLK or negedge ARESETn)
begin
    if(!ARESETn)
    begin
        ID2SlaveBuffer <= 0;
    end
    else
    begin
        if(ID2SlaveCnt == 0 && AVALID)
            ID2SlaveBuffer <= SlaveNum;
    end
end


//SlaveBuffer update ID3 
always @(posedge ACLK or negedge ARESETn)
begin
    if(!ARESETn)
    begin
        ID3SlaveBuffer <= 0;
    end
    else
    begin
        if(ID3SlaveCnt == 0 && AVALID)
            ID3SlaveBuffer <= SlaveNum;
    end
end



//SlaveBuffer update ID4 
always @(posedge ACLK or negedge ARESETn)
begin
    if(!ARESETn)
    begin
        ID4SlaveBuffer <= 0;
    end
    else
    begin
        if(ID4SlaveCnt == 0 && AVALID)
            ID4SlaveBuffer <= SlaveNum;
    end
end


//SlaveBuffer update ID5 
always @(posedge ACLK or negedge ARESETn)
begin
    if(!ARESETn)
    begin
        ID5SlaveBuffer <= 0;
    end
    else
    begin
        if(ID5SlaveCnt == 0 && AVALID)
            ID5SlaveBuffer <= SlaveNum;
    end
end

//SlaveBuffer update ID6 
always @(posedge ACLK or negedge ARESETn)
begin
    if(!ARESETn)
    begin
        ID6SlaveBuffer <= 0;
    end
    else
    begin
        if(ID6SlaveCnt == 0 && AVALID)
            ID6SlaveBuffer <= SlaveNum;
    end
end

//SlaveBuffer update ID7 
always @(posedge ACLK or negedge ARESETn)
begin
    if(!ARESETn)
    begin
        ID7SlaveBuffer <= 0;
    end
    else
    begin
        if(ID7SlaveCnt == 0 && AVALID)
            ID7SlaveBuffer <= SlaveNum;
    end
end

//SlaveBuffer update ID8 
always @(posedge ACLK or negedge ARESETn)
begin
    if(!ARESETn)
    begin
        ID8SlaveBuffer <= 0;
    end
    else
    begin
        if(ID8SlaveCnt == 0 && AVALID)
            ID8SlaveBuffer <= SlaveNum;
    end
end

//SlaveBuffer update ID9 
always @(posedge ACLK or negedge ARESETn)
begin
    if(!ARESETn)
    begin
        ID9SlaveBuffer <= 0;
    end
    else
    begin
        if(ID9SlaveCnt == 0 && AVALID)
            ID9SlaveBuffer <= SlaveNum;
    end
end

//SlaveBuffer update ID10 
always @(posedge ACLK or negedge ARESETn)
begin
    if(!ARESETn)
    begin
        ID10SlaveBuffer <= 0;
    end
    else
    begin
        if(ID10SlaveCnt == 0 && AVALID)
            ID10SlaveBuffer <= SlaveNum;
    end
end

//SlaveBuffer update ID11 
always @(posedge ACLK or negedge ARESETn)
begin
    if(!ARESETn)
    begin
        ID11SlaveBuffer <= 0;
    end
    else
    begin
        if(ID11SlaveCnt == 0 && AVALID)
            ID11SlaveBuffer <= SlaveNum;
    end
end

//SlaveBuffer update ID12 
always @(posedge ACLK or negedge ARESETn)
begin
    if(!ARESETn)
    begin
        ID12SlaveBuffer <= 0;
    end
    else
    begin
        if(ID12SlaveCnt == 0 && AVALID)
            ID12SlaveBuffer <= SlaveNum;
    end
end

//SlaveBuffer update ID13 
always @(posedge ACLK or negedge ARESETn)
begin
    if(!ARESETn)
    begin
        ID13SlaveBuffer <= 0;
    end
    else
    begin
        if(ID13SlaveCnt == 0 && AVALID)
            ID13SlaveBuffer <= SlaveNum;
    end
end

//SlaveBuffer update ID14 
always @(posedge ACLK or negedge ARESETn)
begin
    if(!ARESETn)
    begin
        ID14SlaveBuffer <= 0;
    end
    else
    begin
        if(ID14SlaveCnt == 0 && AVALID)
            ID14SlaveBuffer <= SlaveNum;
    end
end

//SlaveBuffer update ID15 
always @(posedge ACLK or negedge ARESETn)
begin
    if(!ARESETn)
    begin
        ID15SlaveBuffer <= 0;
    end
    else
    begin
        if(ID15SlaveCnt == 0 && AVALID)
            ID15SlaveBuffer <= SlaveNum;
    end
end

//________________________________________________________________________
//SlaveCnt
//Enable
wire    ID0EnCNTup = ((SID == 0) && (SlaveNum == ID0SlaveBuffer)) ? 1'b1 : 1'b0;
wire    ID0EnCNTdn =  (LID == 0) ? 1'b1 : 1'b0;

wire    ID1EnCNTup = ((SID == 1) && (SlaveNum == ID1SlaveBuffer)) ? 1'b1 : 1'b0;
wire    ID1EnCNTdn =  (LID == 1) ? 1'b1 : 1'b0;

wire    ID2EnCNTup = ((SID == 2) && (SlaveNum == ID2SlaveBuffer)) ? 1'b1 : 1'b0;
wire    ID2EnCNTdn =  (LID == 2) ? 1'b1 : 1'b0;

wire    ID3EnCNTup = ((SID == 3) && (SlaveNum == ID3SlaveBuffer)) ? 1'b1 : 1'b0;
wire    ID3EnCNTdn =  (LID == 3) ? 1'b1 : 1'b0;

wire    ID4EnCNTup = ((SID == 4) && (SlaveNum == ID4SlaveBuffer)) ? 1'b1 : 1'b0;
wire    ID4EnCNTdn =  (LID == 4) ? 1'b1 : 1'b0;

wire    ID5EnCNTup = ((SID == 5) && (SlaveNum == ID5SlaveBuffer)) ? 1'b1 : 1'b0;
wire    ID5EnCNTdn =  (LID == 5) ? 1'b1 : 1'b0;

wire    ID6EnCNTup = ((SID == 6) && (SlaveNum == ID6SlaveBuffer)) ? 1'b1 : 1'b0;
wire    ID6EnCNTdn =  (LID == 6) ? 1'b1 : 1'b0;

wire    ID7EnCNTup = ((SID == 7) && (SlaveNum == ID7SlaveBuffer)) ? 1'b1 : 1'b0;
wire    ID7EnCNTdn =  (LID == 7) ? 1'b1 : 1'b0;

wire    ID8EnCNTup = ((SID == 8) && (SlaveNum == ID8SlaveBuffer)) ? 1'b1 : 1'b0;
wire    ID8EnCNTdn =  (LID == 8) ? 1'b1 : 1'b0;

wire    ID9EnCNTup = ((SID == 9) && (SlaveNum == ID9SlaveBuffer)) ? 1'b1 : 1'b0;
wire    ID9EnCNTdn =  (LID == 9) ? 1'b1 : 1'b0;

wire    ID10EnCNTup = ((SID == 10) && (SlaveNum == ID10SlaveBuffer)) ? 1'b1 : 1'b0;
wire    ID10EnCNTdn =  (LID == 10) ? 1'b1 : 1'b0;

wire    ID11EnCNTup = ((SID == 11) && (SlaveNum == ID11SlaveBuffer)) ? 1'b1 : 1'b0;
wire    ID11EnCNTdn =  (LID == 11) ? 1'b1 : 1'b0;

wire    ID12EnCNTup = ((SID == 12) && (SlaveNum == ID12SlaveBuffer)) ? 1'b1 : 1'b0;
wire    ID12EnCNTdn =  (LID == 12) ? 1'b1 : 1'b0;

wire    ID13EnCNTup = ((SID == 13) && (SlaveNum == ID13SlaveBuffer)) ? 1'b1 : 1'b0;
wire    ID13EnCNTdn =  (LID == 13) ? 1'b1 : 1'b0;

wire    ID14EnCNTup = ((SID == 14) && (SlaveNum == ID14SlaveBuffer)) ? 1'b1 : 1'b0;
wire    ID14EnCNTdn =  (LID == 14) ? 1'b1 : 1'b0;

wire    ID15EnCNTup = ((SID == 15) && (SlaveNum == ID15SlaveBuffer)) ? 1'b1 : 1'b0;
wire    ID15EnCNTdn =  (LID == 15) ? 1'b1 : 1'b0;

//________________________________________________________________________


wire    CNTup = (AREADY & AVALID);
wire    CNTdn = (LAST   & READY & RVALID);


//________________________________________________________________________

//ID0 Slave Counter
always @(posedge ACLK or negedge ARESETn)
begin
    if(!ARESETn)
    begin
        ID0SlaveCnt <= 0;
    end
    else
    begin
        if(CNTup & ID0EnCNTup & CNTdn & ID0EnCNTdn)
            ID0SlaveCnt <= ID0SlaveCnt;
        else if(CNTup & ID0EnCNTup)
            ID0SlaveCnt <= ID0SlaveCnt + 1;
        else if(CNTdn & ID0EnCNTdn)
            ID0SlaveCnt <= ID0SlaveCnt - 1;
    end
end


//ID1 Slave Counter
always @(posedge ACLK or negedge ARESETn)
begin
    if(!ARESETn)
    begin
        ID1SlaveCnt <= 0;
    end
    else
    begin
        if(CNTup & ID1EnCNTup & CNTdn & ID1EnCNTdn)
            ID1SlaveCnt <= ID1SlaveCnt;
        else if(CNTup & ID1EnCNTup)
            ID1SlaveCnt <= ID1SlaveCnt + 1;
        else if(CNTdn & ID1EnCNTdn)
            ID1SlaveCnt <= ID1SlaveCnt - 1;
    end
end


//ID2 Slave Counter
always @(posedge ACLK or negedge ARESETn)
begin
    if(!ARESETn)
    begin
        ID2SlaveCnt <= 0;
    end
    else
    begin
        if(CNTup & ID2EnCNTup & CNTdn & ID2EnCNTdn)
            ID2SlaveCnt <= ID2SlaveCnt;
        else if(CNTup & ID2EnCNTup)
            ID2SlaveCnt <= ID2SlaveCnt + 1;
        else if(CNTdn & ID2EnCNTdn)
            ID2SlaveCnt <= ID2SlaveCnt - 1;
    end
end

//ID3 Slave Counter
always @(posedge ACLK or negedge ARESETn)
begin
    if(!ARESETn)
    begin 
        ID3SlaveCnt <= 0;
    end
    else
    begin
        if(CNTup & ID3EnCNTup & CNTdn & ID3EnCNTdn)
            ID3SlaveCnt <= ID3SlaveCnt;
        else if(CNTup & ID3EnCNTup)
            ID3SlaveCnt <= ID3SlaveCnt + 1;
        else if(CNTdn & ID3EnCNTdn)
            ID3SlaveCnt <= ID3SlaveCnt - 1;
    end
end

//ID4 Slave Counter
always @(posedge ACLK or negedge ARESETn)
begin
    if(!ARESETn)
    begin 
        ID4SlaveCnt <= 0;
    end
    else
    begin
        if(CNTup & ID4EnCNTup & CNTdn & ID4EnCNTdn)
            ID4SlaveCnt <= ID4SlaveCnt;
        else if(CNTup & ID4EnCNTup)
            ID4SlaveCnt <= ID4SlaveCnt + 1;
        else if(CNTdn & ID4EnCNTdn)
            ID4SlaveCnt <= ID4SlaveCnt - 1;
    end
end


//ID5 Slave Counter
always @(posedge ACLK or negedge ARESETn)
begin
    if(!ARESETn)
    begin 
        ID5SlaveCnt <= 0;
    end
    else
    begin
        if(CNTup & ID5EnCNTup & CNTdn & ID5EnCNTdn)
            ID5SlaveCnt <= ID5SlaveCnt;
        else if(CNTup & ID5EnCNTup)
            ID5SlaveCnt <= ID5SlaveCnt + 1;
        else if(CNTdn & ID5EnCNTdn)
            ID5SlaveCnt <= ID5SlaveCnt - 1;
    end
end

//ID6 Slave Counter
always @(posedge ACLK or negedge ARESETn)
begin
    if(!ARESETn)
    begin 
        ID6SlaveCnt <= 0;
    end
    else
    begin
        if(CNTup & ID6EnCNTup & CNTdn & ID6EnCNTdn)
            ID6SlaveCnt <= ID6SlaveCnt;
        else if(CNTup & ID6EnCNTup)
            ID6SlaveCnt <= ID6SlaveCnt + 1;
        else if(CNTdn & ID6EnCNTdn)
            ID6SlaveCnt <= ID6SlaveCnt - 1;
    end
end

//ID7 Slave Counter
always @(posedge ACLK or negedge ARESETn)
begin
    if(!ARESETn)
    begin 
        ID7SlaveCnt <= 0;
    end
    else
    begin
        if(CNTup & ID7EnCNTup & CNTdn & ID7EnCNTdn)
            ID7SlaveCnt <= ID7SlaveCnt;
        else if(CNTup & ID7EnCNTup)
            ID7SlaveCnt <= ID7SlaveCnt + 1;
        else if(CNTdn & ID7EnCNTdn)
            ID7SlaveCnt <= ID7SlaveCnt - 1;
    end
end

//ID8 Slave Counter
always @(posedge ACLK or negedge ARESETn)
begin
    if(!ARESETn)
    begin 
        ID8SlaveCnt <= 0;
    end
    else
    begin
        if(CNTup & ID8EnCNTup & CNTdn & ID8EnCNTdn)
            ID8SlaveCnt <= ID8SlaveCnt;
        else if(CNTup & ID8EnCNTup)
            ID8SlaveCnt <= ID8SlaveCnt + 1;
        else if(CNTdn & ID8EnCNTdn)
            ID8SlaveCnt <= ID8SlaveCnt - 1;
    end
end

//ID9 Slave Counter
always @(posedge ACLK or negedge ARESETn)
begin
    if(!ARESETn)
    begin 
        ID9SlaveCnt <= 0;
    end
    else
    begin
        if(CNTup & ID9EnCNTup & CNTdn & ID9EnCNTdn)
            ID9SlaveCnt <= ID9SlaveCnt;
        else if(CNTup & ID9EnCNTup)
            ID9SlaveCnt <= ID9SlaveCnt + 1;
        else if(CNTdn & ID9EnCNTdn)
            ID9SlaveCnt <= ID9SlaveCnt - 1;
    end
end

//ID10 Slave Counter
always @(posedge ACLK or negedge ARESETn)
begin
    if(!ARESETn)
    begin 
        ID10SlaveCnt <= 0;
    end
    else
    begin
        if(CNTup & ID10EnCNTup & CNTdn & ID10EnCNTdn)
            ID10SlaveCnt <= ID10SlaveCnt;
        else if(CNTup & ID10EnCNTup)
            ID10SlaveCnt <= ID10SlaveCnt + 1;
        else if(CNTdn & ID10EnCNTdn)
            ID10SlaveCnt <= ID10SlaveCnt - 1;
    end
end

//ID11 Slave Counter
always @(posedge ACLK or negedge ARESETn)
begin
    if(!ARESETn)
    begin 
        ID11SlaveCnt <= 0;
    end
    else
    begin
        if(CNTup & ID11EnCNTup & CNTdn & ID11EnCNTdn)
            ID11SlaveCnt <= ID11SlaveCnt;
        else if(CNTup & ID11EnCNTup)
            ID11SlaveCnt <= ID11SlaveCnt + 1;
        else if(CNTdn & ID11EnCNTdn)
            ID11SlaveCnt <= ID11SlaveCnt - 1;
    end
end

//ID12 Slave Counter
always @(posedge ACLK or negedge ARESETn)
begin
    if(!ARESETn)
    begin 
        ID12SlaveCnt <= 0;
    end
    else
    begin
        if(CNTup & ID12EnCNTup & CNTdn & ID12EnCNTdn)
            ID12SlaveCnt <= ID12SlaveCnt;
        else if(CNTup & ID12EnCNTup)
            ID12SlaveCnt <= ID12SlaveCnt + 1;
        else if(CNTdn & ID12EnCNTdn)
           ID12SlaveCnt <= ID12SlaveCnt - 1;
    end
end


//ID13 Slave Counter
always @(posedge ACLK or negedge ARESETn)
begin
    if(!ARESETn)
    begin 
        ID13SlaveCnt <= 0;
    end
    else
    begin
        if(CNTup & ID13EnCNTup & CNTdn & ID13EnCNTdn)
            ID13SlaveCnt <= ID13SlaveCnt;
        else if(CNTup & ID13EnCNTup)
            ID13SlaveCnt <= ID13SlaveCnt + 1;
        else if(CNTdn & ID13EnCNTdn)
           ID13SlaveCnt <= ID13SlaveCnt - 1;
    end
end

//ID14 Slave Counter
always @(posedge ACLK or negedge ARESETn)
begin
    if(!ARESETn)
    begin 
        ID14SlaveCnt <= 0;
    end
    else
    begin
        if(CNTup & ID14EnCNTup & CNTdn & ID14EnCNTdn)
            ID14SlaveCnt <= ID14SlaveCnt;
        else if(CNTup & ID14EnCNTup)
            ID14SlaveCnt <= ID14SlaveCnt + 1;
        else if(CNTdn & ID14EnCNTdn)
           ID14SlaveCnt <= ID14SlaveCnt - 1;
    end
end


//ID15 Slave Counter
always @(posedge ACLK or negedge ARESETn)
begin
    if(!ARESETn)
    begin 
        ID15SlaveCnt <= 0;
    end
    else
    begin
        if(CNTup & ID15EnCNTup & CNTdn & ID15EnCNTdn)
            ID15SlaveCnt <= ID15SlaveCnt;
        else if(CNTup & ID15EnCNTup)
            ID15SlaveCnt <= ID15SlaveCnt + 1;
        else if(CNTdn & ID15EnCNTdn)
           ID15SlaveCnt <= ID15SlaveCnt - 1;
    end
end

//________________________________________________________________________
//MUX state

reg     InMUX;
wire    EnMUX =
            ID0EnCNTup |
            ID1EnCNTup |
            ID2EnCNTup |
            ID3EnCNTup |
            ID4EnCNTup |
            ID5EnCNTup |
            ID6EnCNTup |
            ID7EnCNTup |
            ID8EnCNTup |
            ID9EnCNTup |
            ID10EnCNTup |
            ID11EnCNTup |
            ID12EnCNTup |
            ID13EnCNTup |
            ID14EnCNTup |
            ID15EnCNTup ;

always  @(
            ID0EnCNTup or
            ID1EnCNTup or
            ID2EnCNTup or
            ID3EnCNTup or
            ID4EnCNTup or
            ID5EnCNTup or
            ID6EnCNTup or
            ID7EnCNTup or
            ID8EnCNTup or
            ID9EnCNTup or
            ID10EnCNTup or
            ID11EnCNTup or
            ID12EnCNTup or
            ID13EnCNTup or
            ID14EnCNTup or
            ID15EnCNTup or
            AVALID  or
            EnMUX
        )
begin

    if(AVALID & EnMUX)
        InMUX <= 1'b1;
    else
        InMUX <= 1'b0;
end


//MUX 
reg     [SLAVE_WID-1:0] SIDSlaveBuffer;
assign  CtlData2writech[SLAVE_WID]     = InMUX;  // 1-> action
assign  CtlData2writech[SLAVE_WID-1:0] = SIDSlaveBuffer;

always  @(
            ID0SlaveBuffer or
            ID1SlaveBuffer or
            ID2SlaveBuffer or
            ID3SlaveBuffer or
            ID4SlaveBuffer or
            ID5SlaveBuffer or
            ID6SlaveBuffer or
            ID7SlaveBuffer or
            ID8SlaveBuffer or
            ID9SlaveBuffer or
            ID10SlaveBuffer or
            ID11SlaveBuffer or
            ID12SlaveBuffer or
            ID13SlaveBuffer or
            ID14SlaveBuffer or
            ID15SlaveBuffer or
            SID
        )
begin
    case(SID)
    //synopsys parallel_case full_case
        4'd0:   SIDSlaveBuffer = ID0SlaveBuffer;
        4'd1:   SIDSlaveBuffer = ID1SlaveBuffer;
        4'd2:   SIDSlaveBuffer = ID2SlaveBuffer;
        4'd3:   SIDSlaveBuffer = ID3SlaveBuffer;
        4'd4:   SIDSlaveBuffer = ID4SlaveBuffer;
        4'd5:   SIDSlaveBuffer = ID5SlaveBuffer;
        4'd6:   SIDSlaveBuffer = ID6SlaveBuffer;
        4'd7:   SIDSlaveBuffer = ID7SlaveBuffer;
        4'd8:   SIDSlaveBuffer = ID8SlaveBuffer;
        4'd9:   SIDSlaveBuffer = ID9SlaveBuffer;
        4'd10:  SIDSlaveBuffer = ID10SlaveBuffer;
        4'd11:  SIDSlaveBuffer = ID11SlaveBuffer;
        4'd12:  SIDSlaveBuffer = ID12SlaveBuffer;
        4'd13:  SIDSlaveBuffer = ID13SlaveBuffer;
        4'd14:  SIDSlaveBuffer = ID14SlaveBuffer;
        4'd15:  SIDSlaveBuffer = ID15SlaveBuffer;
    endcase
end


/*
always  @(AVALID or SlaveBuffer or
          SlaveNum
      )
begin

    if( AVALID &&
        (SlaveBuffer == SlaveNum))
        InMUX <= 1'b1;
    else
        InMUX <= 1'b0;
end
*/

endmodule
