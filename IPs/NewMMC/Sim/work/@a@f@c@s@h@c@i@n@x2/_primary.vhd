library verilog;
use verilog.vl_types.all;
entity afcshcinx2 is
    port(
        s               : out    vl_logic;
        co0             : out    vl_logic;
        co1             : out    vl_logic;
        a               : in     vl_logic;
        b               : in     vl_logic;
        ci0n            : in     vl_logic;
        ci1n            : in     vl_logic;
        cs              : in     vl_logic
    );
end afcshcinx2;
