library verilog;
use verilog.vl_types.all;
entity dfftrx2 is
    port(
        q               : out    vl_logic;
        qn              : out    vl_logic;
        d               : in     vl_logic;
        ck              : in     vl_logic;
        rn              : in     vl_logic
    );
end dfftrx2;
