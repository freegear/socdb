library verilog;
use verilog.vl_types.all;
entity nor2x1 is
    port(
        y               : out    vl_logic;
        a               : in     vl_logic;
        b               : in     vl_logic
    );
end nor2x1;
