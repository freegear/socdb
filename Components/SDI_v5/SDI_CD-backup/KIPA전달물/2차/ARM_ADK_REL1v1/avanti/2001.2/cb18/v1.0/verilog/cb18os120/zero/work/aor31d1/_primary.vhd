library verilog;
use verilog.vl_types.all;
entity aor31d1 is
    port(
        b3              : in     vl_logic;
        b2              : in     vl_logic;
        b1              : in     vl_logic;
        a               : in     vl_logic;
        z               : out    vl_logic
    );
end aor31d1;
