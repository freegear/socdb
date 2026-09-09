library verilog;
use verilog.vl_types.all;
entity AO2222D2 is
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
end AO2222D2;
