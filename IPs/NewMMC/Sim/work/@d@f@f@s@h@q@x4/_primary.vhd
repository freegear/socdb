library verilog;
use verilog.vl_types.all;
entity dffshqx4 is
    port(
        q               : out    vl_logic;
        d               : in     vl_logic;
        ck              : in     vl_logic;
        sn              : in     vl_logic
    );
end dffshqx4;
