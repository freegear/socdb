library verilog;
use verilog.vl_types.all;
entity su01d2 is
    port(
        a               : in     vl_logic;
        b               : in     vl_logic;
        ci              : in     vl_logic;
        s               : out    vl_logic;
        co              : out    vl_logic
    );
end su01d2;
