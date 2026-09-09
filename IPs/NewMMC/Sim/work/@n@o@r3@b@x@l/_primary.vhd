library verilog;
use verilog.vl_types.all;
entity nor3bxl is
    port(
        y               : out    vl_logic;
        an              : in     vl_logic;
        b               : in     vl_logic;
        c               : in     vl_logic
    );
end nor3bxl;
