library verilog;
use verilog.vl_types.all;
entity mypll2x is
    port(
        CLKIN_IN        : in     vl_logic;
        CLKDV_OUT       : out    vl_logic;
        CLKIN_IBUFG_OUT : out    vl_logic;
        CLK0_OUT        : out    vl_logic;
        CLK2X_OUT       : out    vl_logic;
        LOCKED_OUT      : out    vl_logic
    );
end mypll2x;
