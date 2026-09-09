
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
    input   [MASTER_WID -1:0] MASTERNUM;
    output  [MASTER_WID -1:0] CtlData;
    output  ReqEmpty;

    reg    ReqFull;
    reg    [MASTER_WID -1:0] rREQBUFF;

    wire  [MASTER_WID -1:0] CtlData;
    wire    ReqEmpty = !ReqFull;

    assign  CtlData = rREQBUFF;

    always  @(posedge ACLK or negedge ARESETn)
    begin
        if(!ARESETn)
        begin
            ReqFull   <= 1'b0;
            rREQBUFF  <= {MASTER_WID{1'b0}};
        end
        else
        begin
            //if(AWVALID & AWREADY)
            if(AWVALID & !ReqFull)
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

endmodule
