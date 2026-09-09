library verilog;
use verilog.vl_types.all;
entity StartCtl is
    port(
        CLK             : in     vl_logic;
        NRST            : in     vl_logic;
        ClkEnab         : in     vl_logic;
        SoftReset       : in     vl_logic;
        SendStart       : in     vl_logic;
        IFLG            : in     vl_logic;
        Ready           : in     vl_logic;
        IntSCL          : in     vl_logic;
        ClearSTA        : out    vl_logic;
        StartComp       : out    vl_logic;
        AssertDA_S      : out    vl_logic
    );
end StartCtl;
