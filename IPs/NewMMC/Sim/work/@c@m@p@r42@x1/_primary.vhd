library verilog;
use verilog.vl_types.all;
entity cmpr42x1 is
    port(
        s               : out    vl_logic;
        co              : out    vl_logic;
        ico             : out    vl_logic;
        a               : in     vl_logic;
        b               : in     vl_logic;
        c               : in     vl_logic;
        d               : in     vl_logic;
        ici             : in     vl_logic
    );
end cmpr42x1;
