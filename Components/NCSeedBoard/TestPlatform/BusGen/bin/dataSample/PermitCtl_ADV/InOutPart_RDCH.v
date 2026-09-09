//notice :: don't modify this code
`timescale 1 ns/ 10ps
module  RDCH_?NAME?_PermitCtl(

    ACLK    ,
    ARESETn ,
    SlaveNum,

    SID,
    AREADY,
    AVALID,

    WID,
    WREADY,
    WVALID,
    WLAST,

    LID,
    LAST, 
    READY,
    RVALID,

    CtlData2datach  ,
    CtlData2writech 
    //Mask2resch

);
