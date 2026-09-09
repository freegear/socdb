library verilog;
use verilog.vl_types.all;
entity afcshconx2 is
    port(
        s               : out    vl_logic;
        co0n            : out    vl_logic;
        co1n            : out    vl_logic;
        a               : in     vl_logic;
        b               : in     vl_logic;
        ci0             : in     vl_logic;
        ci1             : in     vl_logic;
        cs              : in     vl_logic
    );
end afcshconx2;
