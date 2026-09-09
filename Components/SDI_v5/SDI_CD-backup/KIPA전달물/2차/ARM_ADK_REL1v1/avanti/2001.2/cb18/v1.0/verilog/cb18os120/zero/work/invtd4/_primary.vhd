library verilog;
use verilog.vl_types.all;
entity invtd4 is
    port(
        i               : in     vl_logic;
        zn              : out    vl_logic;
        en              : in     vl_logic
    );
end invtd4;
