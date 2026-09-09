library verilog;
use verilog.vl_types.all;
entity nor3bx2 is
    port(
        y               : out    vl_logic;
        an              : in     vl_logic;
        b               : in     vl_logic;
        c               : in     vl_logic
    );
end nor3bx2;
