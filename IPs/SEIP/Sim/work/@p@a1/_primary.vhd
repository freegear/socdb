library verilog;
use verilog.vl_types.all;
entity PA1 is
    port(
        E               : in     vl_logic;
        D               : in     vl_logic;
        C               : in     vl_logic;
        B               : in     vl_logic;
        A               : in     vl_logic;
        CO1             : out    vl_logic;
        S               : out    vl_logic;
        CO2             : out    vl_logic
    );
end PA1;
