library verilog;
use verilog.vl_types.all;
entity accshcinx4 is
    port(
        co0             : out    vl_logic;
        co1             : out    vl_logic;
        a               : in     vl_logic;
        b               : in     vl_logic;
        ci0n            : in     vl_logic;
        ci1n            : in     vl_logic
    );
end accshcinx4;
