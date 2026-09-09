library verilog;
use verilog.vl_types.all;
entity ora211d4 is
    port(
        c2              : in     vl_logic;
        c1              : in     vl_logic;
        b               : in     vl_logic;
        a               : in     vl_logic;
        z               : out    vl_logic
    );
end ora211d4;
