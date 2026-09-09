library verilog;
use verilog.vl_types.all;
entity I2cBusFlt is
    port(
        CLK             : in     vl_logic;
        NRST            : in     vl_logic;
        ClkEnab         : in     vl_logic;
        ISCL            : in     vl_logic;
        ISDA            : in     vl_logic;
        IntSCL          : out    vl_logic;
        IntSDA          : out    vl_logic;
        SRClkEnab       : out    vl_logic
    );
end I2cBusFlt;
