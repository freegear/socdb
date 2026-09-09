library verilog;
use verilog.vl_types.all;
entity mx04d4 is
    port(
        i0              : in     vl_logic;
        i1              : in     vl_logic;
        i2              : in     vl_logic;
        i3              : in     vl_logic;
        s0              : in     vl_logic;
        s1              : in     vl_logic;
        z               : out    vl_logic
    );
end mx04d4;
