library verilog;
use verilog.vl_types.all;
entity I2CClkCtrl is
    port(
        PCLK            : in     vl_logic;
        PRESETn         : in     vl_logic;
        StartDet        : in     vl_logic;
        StopDet         : in     vl_logic;
        ArbitLostDet    : in     vl_logic;
        DSCL_in         : in     vl_logic;
        DDSCL_in        : in     vl_logic;
        DSCL_o          : in     vl_logic;
        ReadUpd         : out    vl_logic;
        WriteUpd        : out    vl_logic;
        WaitCnt         : out    vl_logic;
        CntRst          : out    vl_logic;
        ClkEn           : out    vl_logic
    );
end I2CClkCtrl;
