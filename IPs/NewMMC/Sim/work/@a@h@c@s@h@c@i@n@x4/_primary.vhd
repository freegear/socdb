library verilog;
use verilog.vl_types.all;
entity ahcshcinx4 is
    port(
        s               : out    vl_logic;
        co              : out    vl_logic;
        a               : in     vl_logic;
        cin             : in     vl_logic;
        cs              : in     vl_logic
    );
end ahcshcinx4;
