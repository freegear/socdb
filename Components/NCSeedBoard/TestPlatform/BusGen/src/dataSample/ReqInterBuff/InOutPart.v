//notice :: don't modify this code
`timescale 1 ns/ 10ps
module  ?NAME?_ReqInterBuff(
    ACLK,
    ARESETn,

    AWVALID,
    AWREADY,
    MASTERNUM,
    BVALID,
    BREADY,
    CtlData,

    ReqFull,
    ReqEmpty,
    //Ver 1.6 added
    NxReqEmpty
);
