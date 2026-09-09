//notice :: don't modify this code
`timescale 1 ns/ 10ps
module  ?NAME?_LockCtlRdmi(

        ACLK,
        ARESETn,

        ReqIntEmpty,
        DataCntEmptyRdmi2Wrmi,

        ALOCK,
        AVALID,
        OVALID,

        LockPort,

        Lock_in,
        UnLock_in,

        Lock_out,
        UnLock_out,

        CtlData,
        //WriteChannel mux CtlData2WrchMux
        //ReadChannel  mux CtlData2RdchMux
        
        EnAMUXn,
        EnAREADYMUXn,
        LockArbiter
);
//STATE_END
