library verilog;
use verilog.vl_types.all;
entity or3xl is
    port(
        y               : out    vl_logic;
        a               : in     vl_logic;
        b               : in     vl_logic;
        c               : in     vl_logic
    );
end or3xl;
