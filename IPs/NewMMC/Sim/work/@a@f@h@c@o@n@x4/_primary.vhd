library verilog;
use verilog.vl_types.all;
entity afhconx4 is
    port(
        s               : out    vl_logic;
        con             : out    vl_logic;
        a               : in     vl_logic;
        b               : in     vl_logic;
        ci              : in     vl_logic
    );
end afhconx4;
