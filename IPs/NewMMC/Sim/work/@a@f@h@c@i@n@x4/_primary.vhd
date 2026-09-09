library verilog;
use verilog.vl_types.all;
entity afhcinx4 is
    port(
        s               : out    vl_logic;
        co              : out    vl_logic;
        a               : in     vl_logic;
        b               : in     vl_logic;
        cin             : in     vl_logic
    );
end afhcinx4;
