library verilog;
use verilog.vl_types.all;
entity AD8 is
    port(
        H               : in     vl_logic;
        G               : in     vl_logic;
        F               : in     vl_logic;
        E               : in     vl_logic;
        D               : in     vl_logic;
        C               : in     vl_logic;
        B               : in     vl_logic;
        A               : in     vl_logic;
        Y               : out    vl_logic
    );
end AD8;
