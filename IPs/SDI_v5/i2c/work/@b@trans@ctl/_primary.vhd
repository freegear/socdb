library verilog;
use verilog.vl_types.all;
entity BTransCtl is
    port(
        CLK             : in     vl_logic;
        NRST            : in     vl_logic;
        ClkEnab         : in     vl_logic;
        SoftReset       : in     vl_logic;
        StartTFer       : in     vl_logic;
        ClearTFer       : in     vl_logic;
        Step            : in     vl_logic;
        IFLG            : in     vl_logic;
        IntSCL          : in     vl_logic;
        TFerData        : out    vl_logic;
        TFerAck         : out    vl_logic;
        TFerComp        : out    vl_logic;
        SampAddr        : out    vl_logic;
        enopenab2       : out    vl_logic
    );
end BTransCtl;
