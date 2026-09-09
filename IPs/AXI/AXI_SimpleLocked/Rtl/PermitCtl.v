
module  PermitCtl(

    ACLK    ,
    ARESETn ,
    SlaveNum,

    AREADY,
    AVALID,

    LAST, 
    READY,
    RVALID,

    CtlData2datach  ,
    CtlData2resch   ,
    CtlData2writech ,
    CtlData2rddatach

    );
`include "Def.v"

input   ACLK;
input   ARESETn;
input   AREADY;
input   LAST;
input   AVALID;
input   RVALID;

input   [SLAVE_WID-1:0] SlaveNum;
input   READY;  

output  [SLAVE_WID-1:0] CtlData2datach;
output  [SLAVE_WID-1:0] CtlData2resch;
output  [SLAVE_WID  :0] CtlData2writech;
output  [SLAVE_WID  :0] CtlData2rddatach;

//BUFFER
reg [SLAVE_WID-1:0]     SlaveBuffer;
reg [SLAVECNTWID-1:0]  SlaveCnt;

assign  CtlData2resch    = SlaveBuffer;
assign  CtlData2datach   = SlaveBuffer;
//assign  CtlData2rddatach[SLAVE_WID]     = {SlaveCnt == 0} ? {SLAVE_WID{1'b1}} : SlaveBuffer;
assign  CtlData2rddatach[SLAVE_WID]     = {SlaveCnt == 0} ? 1'b0 : 1'b1; //1
assign  CtlData2rddatach[SLAVE_WID-1:0] = SlaveBuffer;


//SlaveBuffer update
always @(posedge ACLK or negedge ARESETn)
begin
    if(!ARESETn)
    begin
        SlaveBuffer <= 0;
    end
    else
    begin
        if(SlaveCnt == 0 && AVALID)
            SlaveBuffer <= SlaveNum;
    end
end

//SlaveCnt
wire    CNTup = ((AREADY) && AVALID && (SlaveNum == SlaveBuffer)) ? 1'b1 : 1'b0;
wire    CNTdn = (LAST & READY & RVALID);

always @(posedge ACLK or negedge ARESETn)
begin
    if(!ARESETn)
    begin
        SlaveCnt <= 0;
    end
    else
    begin
        if(CNTup)
            SlaveCnt <= SlaveCnt + 1;
        else if(CNTdn)
            SlaveCnt <= SlaveCnt - 1;
    end
end

//MUX state


reg InMUX;

always  @(AVALID or SlaveBuffer or
          SlaveNum
      )
begin

    //if(rADDR != ADDR) && AVALID &&
    if( AVALID &&
        (SlaveBuffer == SlaveNum))
        InMUX <= 1'b1;
    else
        InMUX <= 1'b0;
end

//MUX 
assign  CtlData2writech[SLAVE_WID]     = InMUX;  // 1-> action
assign  CtlData2writech[SLAVE_WID-1:0] =  SlaveBuffer;

endmodule

