library verilog;
use verilog.vl_types.all;
entity psync is
    port(
        clkp            : in     vl_logic;
        clks            : in     vl_logic;
        rstp            : in     vl_logic;
        rsts            : in     vl_logic;
        di              : in     vl_logic;
        do              : out    vl_logic
    );
end psync;
