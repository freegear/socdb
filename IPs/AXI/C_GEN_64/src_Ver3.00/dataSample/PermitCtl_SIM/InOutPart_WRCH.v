//notice :: don't modify this code
`timescale 1 ns/ 10ps
module  WRCH_?NAME?_PermitCtl(

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
