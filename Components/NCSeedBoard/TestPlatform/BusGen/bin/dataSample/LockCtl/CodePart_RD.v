        input   ACLK;
        input   ARESETn;
        input   [AWLOCK_WID-1:0] ALOCK;
        input   AVALID;
        input   OVALID;
        input   ReqIntEmpty;
        input   DataCntEmptyRdmi2Wrmi;
        input   Lock_in;
        input   UnLock_in;
        input   [SELMASTER_WID-1:0] CtlData; //modified 06/6/20

        //input   [SELMASTER_WID-1:0] LockPort; //modified 06/6/20
        //2006-9-8-ID-WID-FIXED
        input   [SELMASTER_WID:0] LockPort; 

        output  EnAMUXn;
        output  EnAREADYMUXn;
        output  [5:0]   LockArbiter;

        output  Lock_out;
        output  UnLock_out;

        wire  Lock_out;
        wire  UnLock_out;


    //State define
    reg [5:0]   StateLock;
    reg [5:0]   NxStateLock;

    parameter IDLE = 0, 
              FULL_MASK = 1, 
              MASK = 2, 
              LOCK = 3, 
              RELEASE = 4, 
              VMASK = 5; 

    //Lock State machine
    //_______________________________________________________________

    wire    LockAccess   = ( ALOCK[1] & !ALOCK[0]) & (AVALID);
    wire    UnLockAccess = (!ALOCK[1] & !ALOCK[0]) & (AVALID);
    wire    Empty = ReqIntEmpty & DataCntEmptyRdmi2Wrmi;
    wire    [5:0]   LockArbiter  = StateLock;

    assign  Lock_out   = LockAccess; 
    //assign  UnLock_out = UnLockAccess; 
    //assign  UnLock_out = (LockPort == CtlData) ?  UnLockAccess : 1'b0;

    //2006-9-8-ID-WID-FIXED
    assign  UnLock_out = (LockPort[SELMASTER_WID-1:0] == CtlData) ?  UnLockAccess : 1'b0;
    wire    EnAMUXn      = StateLock[FULL_MASK] | NxStateLock[MASK] |
                           StateLock[RELEASE] | NxStateLock[FULL_MASK] |
                           StateLock[MASK] | NxStateLock[VMASK];

    wire    EnAREADYMUXn = StateLock[FULL_MASK] | NxStateLock[MASK] |
                           StateLock[RELEASE] | NxStateLock[FULL_MASK] |
                           StateLock[MASK] | NxStateLock[VMASK];

    always @(posedge ACLK or negedge ARESETn)
    begin
        if(!ARESETn)
        begin
            StateLock[IDLE] <= 1'b1;
            StateLock[FULL_MASK] <= 1'b0;
            StateLock[MASK] <= 1'b0;
            StateLock[LOCK] <= 1'b0;
            StateLock[RELEASE] <= 1'b0;
            StateLock[VMASK] <= 1'b0;
        end
        else
        begin
            StateLock <= NxStateLock;
        end
    end

    always @(
        Empty or
        LockAccess or
        UnLockAccess or
        Lock_in or

        AVALID or
        OVALID or //ELAB-292
        UnLock_in or
        StateLock
    )
    begin
        NxStateLock <= 0;
        case(1'b1)

            StateLock[IDLE]:
                if(Lock_in & !AVALID) // First Priority
                    NxStateLock[FULL_MASK] <= 1'b1;
                else if(Lock_in & AVALID) // Last Priority
                    NxStateLock[VMASK] <= 1'b1;
                else if(LockAccess) // Last Priority
                    NxStateLock[MASK] <= 1'b1;
                else
                    NxStateLock[IDLE] <= 1'b1;

            StateLock[VMASK]:
                if(!AVALID)
                    NxStateLock[VMASK] <= 1'b1;
                else 
                    NxStateLock[FULL_MASK] <= 1'b1;

            StateLock[FULL_MASK]:
                if(!Empty)
                    NxStateLock[FULL_MASK] <= 1'b1;
                else 
                    NxStateLock[LOCK] <= 1'b1;

            StateLock[MASK]:
                if(!Empty & OVALID)
                    NxStateLock[MASK] <= 1'b1;
                else 
                    NxStateLock[LOCK] <= 1'b1;

            StateLock[LOCK]:
                if(UnLockAccess | UnLock_in)
                    NxStateLock[RELEASE] <= 1'b1;
                else 
                    NxStateLock[LOCK] <= 1'b1;

            StateLock[RELEASE]:
                if(Empty)
                    NxStateLock[IDLE] <= 1'b1;
                else
                    NxStateLock[RELEASE] <= 1'b1;
        endcase
    end

endmodule
