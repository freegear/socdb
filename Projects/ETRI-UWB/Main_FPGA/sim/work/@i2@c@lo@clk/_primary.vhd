library verilog;
use verilog.vl_types.all;
entity I2CLoClk is
    port(
        PCLK            : in     vl_logic;
        PRESETn         : in     vl_logic;
        SW_RST          : in     vl_logic;
        Start           : in     vl_logic;
        Stop            : in     vl_logic;
        IntPendFlag     : in     vl_logic;
        DataTrans       : in     vl_logic;
        StartDet        : in     vl_logic;
        StopDet         : in     vl_logic;
        BusErrorDet     : in     vl_logic;
        ArbitLostDet    : in     vl_logic;
        ClkEn           : in     vl_logic;
        TxPre           : in     vl_logic_vector(11 downto 0);
        WaitCnt         : in     vl_logic;
        CntRst          : in     vl_logic;
        SCLWait         : in     vl_logic;
        CntIsZero       : out    vl_logic;
        RepeatStart     : in     vl_logic;
        SendStop        : in     vl_logic;
        out_clk         : out    vl_logic
    );
end I2CLoClk;
