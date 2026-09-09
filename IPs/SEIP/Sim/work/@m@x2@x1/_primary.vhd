library verilog;
use verilog.vl_types.all;
entity MX2X1 is
    port(
        A               : in     vl_logic;
        B               : in     vl_logic;
        S0              : in     vl_logic;
        Y               : out    vl_logic
    );
end MX2X1;
