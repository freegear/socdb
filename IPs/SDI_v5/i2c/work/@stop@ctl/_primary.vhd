library verilog;
use verilog.vl_types.all;
entity StopCtl is
    port(
        CLK             : in     vl_logic;
        NRST            : in     vl_logic;
        ClkEnab         : in     vl_logic;
        SoftReset       : in     vl_logic;
        SendStop        : in     vl_logic;
        IntSCL          : in     vl_logic;
        ClearSTP        : out    vl_logic;
        AssertDA_P      : out    vl_logic;
        ReleaseDA       : out    vl_logic
    );
end StopCtl;
