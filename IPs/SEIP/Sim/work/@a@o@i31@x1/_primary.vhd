library verilog;
use verilog.vl_types.all;
entity AOI31X1 is
    port(
        A0              : in     vl_logic;
        A1              : in     vl_logic;
        A2              : in     vl_logic;
        B0              : in     vl_logic;
        Y               : out    vl_logic
    );
end AOI31X1;
