library verilog;
use verilog.vl_types.all;
entity ora311d2 is
    port(
        c3              : in     vl_logic;
        c2              : in     vl_logic;
        c1              : in     vl_logic;
        b               : in     vl_logic;
        a               : in     vl_logic;
        z               : out    vl_logic
    );
end ora311d2;
