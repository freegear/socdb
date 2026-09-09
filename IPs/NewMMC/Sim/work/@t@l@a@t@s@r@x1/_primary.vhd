library verilog;
use verilog.vl_types.all;
entity tlatsrx1 is
    port(
        q               : out    vl_logic;
        qn              : out    vl_logic;
        d               : in     vl_logic;
        g               : in     vl_logic;
        sn              : in     vl_logic;
        rn              : in     vl_logic
    );
end tlatsrx1;
