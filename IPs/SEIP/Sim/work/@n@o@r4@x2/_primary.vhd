library verilog;
use verilog.vl_types.all;
entity NOR4X2 is
    port(
        A               : in     vl_logic;
        B               : in     vl_logic;
        C               : in     vl_logic;
        D               : in     vl_logic;
        Y               : out    vl_logic
    );
end NOR4X2;
