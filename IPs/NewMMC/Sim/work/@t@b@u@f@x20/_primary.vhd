library verilog;
use verilog.vl_types.all;
entity tbufx20 is
    port(
        y               : out    vl_logic;
        a               : in     vl_logic;
        oe              : in     vl_logic
    );
end tbufx20;
