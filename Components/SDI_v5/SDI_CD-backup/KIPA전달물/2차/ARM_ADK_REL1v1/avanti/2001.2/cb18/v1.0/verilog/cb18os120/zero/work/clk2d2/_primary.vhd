library verilog;
use verilog.vl_types.all;
entity clk2d2 is
    port(
        clk             : in     vl_logic;
        c               : out    vl_logic;
        cn              : out    vl_logic
    );
end clk2d2;
