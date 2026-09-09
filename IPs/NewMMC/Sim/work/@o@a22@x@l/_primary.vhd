library verilog;
use verilog.vl_types.all;
entity oa22xl is
    port(
        y               : out    vl_logic;
        a0              : in     vl_logic;
        a1              : in     vl_logic;
        b0              : in     vl_logic;
        b1              : in     vl_logic
    );
end oa22xl;
