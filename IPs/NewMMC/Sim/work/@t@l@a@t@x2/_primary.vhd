library verilog;
use verilog.vl_types.all;
entity tlatx2 is
    port(
        q               : out    vl_logic;
        qn              : out    vl_logic;
        d               : in     vl_logic;
        g               : in     vl_logic
    );
end tlatx2;
