library verilog;
use verilog.vl_types.all;
entity mx2x4 is
    port(
        y               : out    vl_logic;
        a               : in     vl_logic;
        b               : in     vl_logic;
        s0              : in     vl_logic
    );
end mx2x4;
