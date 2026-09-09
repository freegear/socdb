library verilog;
use verilog.vl_types.all;
entity nand4bbx1 is
    port(
        y               : out    vl_logic;
        an              : in     vl_logic;
        bn              : in     vl_logic;
        c               : in     vl_logic;
        d               : in     vl_logic
    );
end nand4bbx1;
