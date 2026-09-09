library verilog;
use verilog.vl_types.all;
entity clkmx2x12 is
    port(
        y               : out    vl_logic;
        a               : in     vl_logic;
        b               : in     vl_logic;
        s0              : in     vl_logic
    );
end clkmx2x12;
