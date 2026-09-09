library verilog;
use verilog.vl_types.all;
entity tbufxl is
    port(
        y               : out    vl_logic;
        a               : in     vl_logic;
        oe              : in     vl_logic
    );
end tbufxl;
