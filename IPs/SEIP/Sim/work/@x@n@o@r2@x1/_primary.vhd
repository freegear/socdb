library verilog;
use verilog.vl_types.all;
entity XNOR2X1 is
    port(
        A               : in     vl_logic;
        B               : in     vl_logic;
        Y               : out    vl_logic
    );
end XNOR2X1;
