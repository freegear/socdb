library verilog;
use verilog.vl_types.all;
entity bencx1 is
    port(
        s               : out    vl_logic;
        a               : out    vl_logic;
        x2              : out    vl_logic;
        m2              : in     vl_logic;
        m1              : in     vl_logic;
        m0              : in     vl_logic
    );
end bencx1;
