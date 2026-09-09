library verilog;
use verilog.vl_types.all;
entity cmpr22x2 is
    port(
        s               : out    vl_logic;
        co              : out    vl_logic;
        a               : in     vl_logic;
        b               : in     vl_logic
    );
end cmpr22x2;
