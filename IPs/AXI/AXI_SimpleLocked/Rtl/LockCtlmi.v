
module  LockCtlmi(

        ACLK,
        ARESETn,

        ReqIntEmpty,
        DataCntEmptyRdmi2Wrmi,

        ALOCK,
        AVALID,
        Lock,
        LockPort,
        ArbiterMask,
        CtlData,
        //WriteChannel mux CtlData2WrchMux
        //ReadChannel  mux CtlData2RdchMux

        //ReadIntEmptyWrmi2Rdmi,
        
        EnAMUXn,
        EnAREADYMUXn,
        LockArbiter

        );
`include "Def.v"

        input   ACLK;
        input   ARESETn;
        input   [AWLOCK_WID-1:0] ALOCK;
        input   AVALID;
        input   ReqIntEmpty;
        //input   ReadIntEmptyWrmi2Rdmi;
        input   DataCntEmptyRdmi2Wrmi;
        input   Lock;
        input   [MASTER_NUM-1:0] LockPort;
        input   [MASTER_WID-1:0] CtlData; 

        output  [MASTER_WID-1:0] ArbiterMask;
        output  EnAMUXn;
        output  EnAREADYMUXn;
        output  LockArbiter;


    //State define
    reg [4:0]   StateLock;
    reg [4:0]   NxStateLock;
    reg [MASTER_WID-1:0]    ArbiterMask;

    parameter IDLE = 0, FULL_MASK = 1, MASK = 2, LOCK = 3, RELEASE = 4; 

    wire    EnAMUXn      = StateLock[FULL_MASK] | StateLock[RELEASE] | StateLock[MASK];
    wire    EnAREADYMUXn = StateLock[FULL_MASK] | StateLock[RELEASE] | StateLock[MASK];
    wire    LockArbiter  = StateLock[LOCK];


    //Lock State machine
    //_______________________________________________________________

    wire    LockAccess   = ( ALOCK[1] & !ALOCK[0]) & (AVALID);
    wire    UnLockAccess = (!ALOCK[1] & !ALOCK[0]) & (AVALID);
    wire    Empty = ReqIntEmpty & DataCntEmptyRdmi2Wrmi;


    always @(posedge ACLK or negedge ARESETn)
    begin
        if(!ARESETn)
        begin
            ArbiterMask <= 0;
        end
        else
        begin
            if(LockAccess)
                ArbiterMask <= CtlData; 
            else if(Lock)
                ArbiterMask <= LockPort; 

        end
    end

    always @(posedge ACLK or negedge ARESETn)
    begin
        if(!ARESETn)
        begin
            StateLock[IDLE] <= 1'b1;
            StateLock[FULL_MASK] <= 1'b0;
            StateLock[MASK] <= 1'b0;
            StateLock[LOCK] <= 1'b0;
            StateLock[RELEASE] <= 1'b0;
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
        Lock or

        AVALID or
        StateLock
    )
    begin
        NxStateLock <= 0;
        case(1'b1)
            // synopsys parallel_case full_case

            StateLock[IDLE]:
                if(LockAccess & !Empty)
                    NxStateLock[MASK] <= 1'b1;
                else if(Lock & !AVALID)
                    NxStateLock[FULL_MASK] <= 1'b1;
                else if(LockAccess & Empty)
                    NxStateLock[LOCK] <= 1'b1;
                else
                    NxStateLock[IDLE] <= 1'b1;

            StateLock[FULL_MASK]:
                if(!Empty)
                    NxStateLock[FULL_MASK] <= 1'b1;
                else 
                    NxStateLock[LOCK] <= 1'b1;

            StateLock[MASK]:
                if(!Empty)
                    NxStateLock[MASK] <= 1'b1;
                else 
                    NxStateLock[LOCK] <= 1'b1;

            StateLock[LOCK]:
                if(UnLockAccess | !Lock)
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
