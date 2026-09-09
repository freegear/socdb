library verilog;
use verilog.vl_types.all;
entity srlab1 is
    port(
        rn              : in     vl_logic;
        sn              : in     vl_logic;
        q               : out    vl_logic;
        qn              : out    vl_logic
    );
end srlab1;
