library verilog;
use verilog.vl_types.all;
entity afcsihconx4 is
    port(
        s               : out    vl_logic;
        co0n            : out    vl_logic;
        co1n            : out    vl_logic;
        a               : in     vl_logic;
        b               : in     vl_logic;
        cs              : in     vl_logic
    );
end afcsihconx4;
