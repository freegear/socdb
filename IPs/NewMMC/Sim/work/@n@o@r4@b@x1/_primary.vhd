library verilog;
use verilog.vl_types.all;
entity nor4bx1 is
    port(
        y               : out    vl_logic;
        an              : in     vl_logic;
        b               : in     vl_logic;
        c               : in     vl_logic;
        d               : in     vl_logic
    );
end nor4bx1;
