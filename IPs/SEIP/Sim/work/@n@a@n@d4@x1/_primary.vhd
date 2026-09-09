library verilog;
use verilog.vl_types.all;
entity NAND4X1 is
    port(
        A               : in     vl_logic;
        B               : in     vl_logic;
        C               : in     vl_logic;
        D               : in     vl_logic;
        Y               : out    vl_logic
    );
end NAND4X1;
