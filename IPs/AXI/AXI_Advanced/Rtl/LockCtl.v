
module  LockCtl(

    //Global signal
    ACLK    ,
    ARESETn ,

    AWLOCK,
    AWVALID,
    ARLOCK,
    ARVALID,

    CtlDataWrite2Lock,
    CtlDataRead2Lock,

    Lock2wrmi,
    Lock2rdmi,

    LockPort2wrmi,
    LockPort2rdmi
);
`include "Def.v"
    

input   ACLK;
input   ARESETn;
input   [AWLOCK_WID-1:0]    AWLOCK;
input   AWVALID;
input   [ARLOCK_WID-1:0]    ARLOCK;
input   ARVALID;
input   [MASTER_WID-1:0]    CtlDataWrite2Lock;
input   [MASTER_WID-1:0]    CtlDataRead2Lock;

output  Lock2wrmi;
output  Lock2rdmi;
output  [MASTER_WID-1:0]    LockPort2wrmi;
output  [MASTER_WID-1:0]    LockPort2rdmi;

wire  Lock2wrmi;
wire  Lock2rdmi;

wire  [MASTER_WID-1:0]    LockPort2wrmi;
wire  [MASTER_WID-1:0]    LockPort2rdmi;

reg   Lock;
reg   [MASTER_WID-1:0]    LockPort;
wire  [MASTER_WID-1:0]    WireLockPort;

assign  LockPort2wrmi = LockPort;
assign  LockPort2rdmi = LockPort;

assign  Lock2wrmi = Lock;
assign  Lock2rdmi = Lock;

wire    WrLock    = ((AWLOCK == 2'b10) && AWVALID);
wire    UnWrLock  = ((AWLOCK == 2'b00) && AWVALID && (LockPort == CtlDataWrite2Lock));
wire    RdLock    = ((ARLOCK == 2'b10) && ARVALID);
wire    UnRdLock  = ((ARLOCK == 2'b00) && ARVALID && (LockPort == CtlDataRead2Lock) );

assign  WireLockPort =  (WrLock) ? CtlDataWrite2Lock : 
                       ((RdLock) ? CtlDataRead2Lock  : 0 );
 

always @(posedge ACLK or negedge ARESETn)
begin
    if(!ARESETn)
    begin
        Lock <= 1'b0;
        LockPort <= {MASTER_WID{1'b0}};
    end
    else
    begin
        if((WrLock | RdLock) & !Lock)
        begin
            Lock <= 1'b1;
            LockPort <= WireLockPort; 
        end
        else if((UnRdLock | UnWrLock) & Lock) 
        begin
            Lock <= 1'b0;
            LockPort <= {MASTER_WID{1'b0}};
        end
    end
end

endmodule
