library verilog;
use verilog.vl_types.all;
entity lanln2 is
    port(
        en              : in     vl_logic;
        d               : in     vl_logic;
        qn              : out    vl_logic
    );
end lanln2;
