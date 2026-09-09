library verilog;
use verilog.vl_types.all;
entity OR3X2 is
    port(
        A               : in     vl_logic;
        B               : in     vl_logic;
        C               : in     vl_logic;
        Y               : out    vl_logic
    );
end OR3X2;
