library verilog;
use verilog.vl_types.all;
entity or2x6 is
    port(
        y               : out    vl_logic;
        a               : in     vl_logic;
        b               : in     vl_logic
    );
end or2x6;
