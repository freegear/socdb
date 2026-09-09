library verilog;
use verilog.vl_types.all;
entity xnor2xl is
    port(
        y               : out    vl_logic;
        a               : in     vl_logic;
        b               : in     vl_logic
    );
end xnor2xl;
