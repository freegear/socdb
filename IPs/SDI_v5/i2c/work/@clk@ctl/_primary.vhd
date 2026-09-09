library verilog;
use verilog.vl_types.all;
entity ClkCtl is
    port(
        CLK             : in     vl_logic;
        NRST            : in     vl_logic;
        ClkEnab         : in     vl_logic;
        MaClkEnab       : in     vl_logic;
        CntrlEnab       : in     vl_logic;
        SoftReset       : in     vl_logic;
        MastMode        : in     vl_logic;
        IFLG            : in     vl_logic;
        IntSCL          : in     vl_logic;
        BusClkEnab      : in     vl_logic;
        ErrCond         : in     vl_logic;
        GoToIdle        : in     vl_logic;
        flagrs          : in     vl_logic;
        StartTFer       : in     vl_logic;
        TxData          : in     vl_logic;
        enopenab2       : in     vl_logic;
        OSCL            : out    vl_logic;
        Step            : out    vl_logic;
        OpClkData       : out    vl_logic;
        Ready           : out    vl_logic;
        openab2         : out    vl_logic
    );
end ClkCtl;
