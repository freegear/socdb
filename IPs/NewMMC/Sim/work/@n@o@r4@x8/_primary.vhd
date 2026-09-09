library verilog;
use verilog.vl_types.all;
entity nor4x8 is
    port(
        y               : out    vl_logic;
        a               : in     vl_logic;
        b               : in     vl_logic;
        c               : in     vl_logic;
        d               : in     vl_logic
    );
end nor4x8;
