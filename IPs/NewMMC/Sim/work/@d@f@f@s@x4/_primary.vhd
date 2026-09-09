library verilog;
use verilog.vl_types.all;
entity dffsx4 is
    port(
        q               : out    vl_logic;
        qn              : out    vl_logic;
        d               : in     vl_logic;
        ck              : in     vl_logic;
        sn              : in     vl_logic
    );
end dffsx4;
