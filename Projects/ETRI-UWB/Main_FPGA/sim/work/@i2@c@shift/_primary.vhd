library verilog;
use verilog.vl_types.all;
entity I2CShift is
    port(
        PCLK            : in     vl_logic;
        PRESETn         : in     vl_logic;
        SW_RST          : in     vl_logic;
        AckEn           : in     vl_logic;
        OpMode          : in     vl_logic;
        Start           : in     vl_logic;
        Stop            : in     vl_logic;
        IntPendFlag     : in     vl_logic;
        DataTrans       : in     vl_logic;
        StartDet        : in     vl_logic;
        StopDet         : in     vl_logic;
        ArbitLostDet    : in     vl_logic;
        ClkEn           : in     vl_logic;
        IDSRo           : in     vl_logic_vector(7 downto 0);
        ReadData        : out    vl_logic_vector(7 downto 0);
        AckValue        : out    vl_logic;
        ReadUpd         : in     vl_logic;
        WriteUpd        : in     vl_logic;
        SDAErrorDet     : out    vl_logic;
        SCLWait         : out    vl_logic;
        CntIsZero       : in     vl_logic;
        TxCompInt       : out    vl_logic;
        RepeatStart     : out    vl_logic;
        SendStop        : out    vl_logic;
        ArbitCheck      : out    vl_logic;
        SDA_IN          : in     vl_logic;
        nSDA_En         : out    vl_logic
    );
end I2CShift;
