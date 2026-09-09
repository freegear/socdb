library verilog;
use verilog.vl_types.all;
entity dly2x1 is
    port(
        y               : out    vl_logic;
        a               : in     vl_logic
    );
end dly2x1;
