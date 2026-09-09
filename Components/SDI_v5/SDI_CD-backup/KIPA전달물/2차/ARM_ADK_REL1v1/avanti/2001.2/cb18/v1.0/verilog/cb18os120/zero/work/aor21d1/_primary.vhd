library verilog;
use verilog.vl_types.all;
entity aor21d1 is
    port(
        b2              : in     vl_logic;
        b1              : in     vl_logic;
        a               : in     vl_logic;
        z               : out    vl_logic
    );
end aor21d1;
