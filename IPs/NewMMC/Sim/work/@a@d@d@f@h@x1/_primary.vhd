library verilog;
use verilog.vl_types.all;
entity addfhx1 is
    port(
        s               : out    vl_logic;
        co              : out    vl_logic;
        a               : in     vl_logic;
        b               : in     vl_logic;
        ci              : in     vl_logic
    );
end addfhx1;
