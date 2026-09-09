library verilog;
use verilog.vl_types.all;
entity s_srlab1 is
    port(
        rn              : in     vl_logic;
        sn              : in     vl_logic;
        q               : out    vl_logic;
        qn              : out    vl_logic;
        notifier        : in     vl_logic
    );
end s_srlab1;
