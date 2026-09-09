library verilog;
use verilog.vl_types.all;
entity LMCNT is
    port(
        C               : in     vl_logic;
        B               : in     vl_logic;
        A               : in     vl_logic;
        EN              : in     vl_logic;
        SG              : out    vl_logic;
        S               : out    vl_logic
    );
end LMCNT;
