library verilog;
use verilog.vl_types.all;
entity invtd1 is
    port(
        i               : in     vl_logic;
        zn              : out    vl_logic;
        en              : in     vl_logic
    );
end invtd1;
