


module  ReqCnt(

    ACLK,
    ARESETn,

    ARVALID,
    ARREADY,

    RVALID,
    RREADY,
    RLAST,

    DataCNTEmpty,
    DataCNTFull
);
`include "Def.v"
parameter   RQCNT_WID = 3;
parameter   RQCNT_MAX = 1;

    input   ACLK;
    input   ARESETn;

    input   ARVALID;
    input   ARREADY;
    input   RVALID;
    input   RREADY;
    input   RLAST;

    output  DataCNTEmpty;
    output  DataCNTFull;

    wire    DataCNTEmpty;
    wire    DataCNTFull;

    reg     [RQCNT_WID-1:0] CNT;

    assign DataCNTFull  = (CNT == RQCNT_MAX) ? 1'b1 : 1'b0; 
    assign DataCNTEmpty = (CNT == 0) ? 1'b1 : 1'b0;

    wire    CntUp = ARVALID & ARREADY;
    wire    CntDn = RVALID & RREADY & RLAST;

    always @(posedge ACLK or negedge ARESETn)
    begin
        if(!ARESETn)
        begin
            CNT <= 0;
        end
        else
        begin
            if(CntUp)
                CNT <= CNT + 1;
            else if(CntDn)
                CNT <= CNT - 1;
        end
    end
    
endmodule
