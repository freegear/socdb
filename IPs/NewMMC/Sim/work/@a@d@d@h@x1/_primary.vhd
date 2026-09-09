library verilog;
use verilog.vl_types.all;
entity addhx1 is
    port(
        s               : out    vl_logic;
        co              : out    vl_logic;
        a               : in     vl_logic;
        b               : in     vl_logic
    );
end addhx1;
