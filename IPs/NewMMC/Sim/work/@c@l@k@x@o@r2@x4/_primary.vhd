library verilog;
use verilog.vl_types.all;
entity clkxor2x4 is
    port(
        y               : out    vl_logic;
        a               : in     vl_logic;
        b               : in     vl_logic
    );
end clkxor2x4;
