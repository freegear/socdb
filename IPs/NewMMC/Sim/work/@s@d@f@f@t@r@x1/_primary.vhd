library verilog;
use verilog.vl_types.all;
entity sdfftrx1 is
    port(
        q               : out    vl_logic;
        qn              : out    vl_logic;
        d               : in     vl_logic;
        si              : in     vl_logic;
        se              : in     vl_logic;
        ck              : in     vl_logic;
        rn              : in     vl_logic
    );
end sdfftrx1;
