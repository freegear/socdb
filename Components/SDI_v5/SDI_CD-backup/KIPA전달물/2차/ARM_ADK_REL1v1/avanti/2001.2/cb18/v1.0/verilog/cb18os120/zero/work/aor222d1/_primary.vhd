library verilog;
use verilog.vl_types.all;
entity aor222d1 is
    port(
        c2              : in     vl_logic;
        c1              : in     vl_logic;
        b2              : in     vl_logic;
        b1              : in     vl_logic;
        a2              : in     vl_logic;
        a1              : in     vl_logic;
        z               : out    vl_logic
    );
end aor222d1;
