library verilog;
use verilog.vl_types.all;
entity nor2bx1 is
    port(
        y               : out    vl_logic;
        an              : in     vl_logic;
        b               : in     vl_logic
    );
end nor2bx1;
