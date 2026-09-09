library verilog;
use verilog.vl_types.all;
entity nor3x4 is
    port(
        y               : out    vl_logic;
        a               : in     vl_logic;
        b               : in     vl_logic;
        c               : in     vl_logic
    );
end nor3x4;
