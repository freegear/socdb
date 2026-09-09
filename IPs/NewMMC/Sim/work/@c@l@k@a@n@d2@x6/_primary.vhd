library verilog;
use verilog.vl_types.all;
entity clkand2x6 is
    port(
        y               : out    vl_logic;
        a               : in     vl_logic;
        b               : in     vl_logic
    );
end clkand2x6;
