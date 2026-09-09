library verilog;
use verilog.vl_types.all;
entity xnor2x2 is
    port(
        y               : out    vl_logic;
        a               : in     vl_logic;
        b               : in     vl_logic
    );
end xnor2x2;
