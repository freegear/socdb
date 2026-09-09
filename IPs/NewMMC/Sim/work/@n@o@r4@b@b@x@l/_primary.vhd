library verilog;
use verilog.vl_types.all;
entity nor4bbxl is
    port(
        y               : out    vl_logic;
        an              : in     vl_logic;
        bn              : in     vl_logic;
        c               : in     vl_logic;
        d               : in     vl_logic
    );
end nor4bbxl;
