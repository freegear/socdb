library verilog;
use verilog.vl_types.all;
entity tlatxl is
    port(
        q               : out    vl_logic;
        qn              : out    vl_logic;
        d               : in     vl_logic;
        g               : in     vl_logic
    );
end tlatxl;
