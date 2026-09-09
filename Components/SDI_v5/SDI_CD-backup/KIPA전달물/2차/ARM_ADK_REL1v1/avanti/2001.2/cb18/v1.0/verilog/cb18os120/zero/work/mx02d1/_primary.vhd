library verilog;
use verilog.vl_types.all;
entity mx02d1 is
    port(
        i0              : in     vl_logic;
        i1              : in     vl_logic;
        s               : in     vl_logic;
        z               : out    vl_logic
    );
end mx02d1;
