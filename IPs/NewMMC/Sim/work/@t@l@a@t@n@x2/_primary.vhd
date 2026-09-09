library verilog;
use verilog.vl_types.all;
entity tlatnx2 is
    port(
        q               : out    vl_logic;
        qn              : out    vl_logic;
        d               : in     vl_logic;
        gn              : in     vl_logic
    );
end tlatnx2;
