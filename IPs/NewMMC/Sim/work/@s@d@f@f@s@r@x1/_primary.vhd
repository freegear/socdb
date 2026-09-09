library verilog;
use verilog.vl_types.all;
entity sdffsrx1 is
    port(
        q               : out    vl_logic;
        qn              : out    vl_logic;
        d               : in     vl_logic;
        si              : in     vl_logic;
        se              : in     vl_logic;
        ck              : in     vl_logic;
        sn              : in     vl_logic;
        rn              : in     vl_logic
    );
end sdffsrx1;
