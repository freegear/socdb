library verilog;
use verilog.vl_types.all;
entity ao21x4 is
    port(
        y               : out    vl_logic;
        a0              : in     vl_logic;
        a1              : in     vl_logic;
        b0              : in     vl_logic
    );
end ao21x4;
