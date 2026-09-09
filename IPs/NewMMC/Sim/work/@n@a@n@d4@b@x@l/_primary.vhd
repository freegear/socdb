library verilog;
use verilog.vl_types.all;
entity nand4bxl is
    port(
        y               : out    vl_logic;
        an              : in     vl_logic;
        b               : in     vl_logic;
        c               : in     vl_logic;
        d               : in     vl_logic
    );
end nand4bxl;
