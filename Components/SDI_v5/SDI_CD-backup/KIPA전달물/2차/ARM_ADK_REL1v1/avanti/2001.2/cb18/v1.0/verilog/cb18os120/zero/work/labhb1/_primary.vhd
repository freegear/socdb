library verilog;
use verilog.vl_types.all;
entity labhb1 is
    port(
        e               : in     vl_logic;
        d               : in     vl_logic;
        cdn             : in     vl_logic;
        sdn             : in     vl_logic;
        q               : out    vl_logic;
        qn              : out    vl_logic
    );
end labhb1;
