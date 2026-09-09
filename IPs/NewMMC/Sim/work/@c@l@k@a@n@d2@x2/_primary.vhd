library verilog;
use verilog.vl_types.all;
entity clkand2x2 is
    port(
        y               : out    vl_logic;
        a               : in     vl_logic;
        b               : in     vl_logic
    );
end clkand2x2;
