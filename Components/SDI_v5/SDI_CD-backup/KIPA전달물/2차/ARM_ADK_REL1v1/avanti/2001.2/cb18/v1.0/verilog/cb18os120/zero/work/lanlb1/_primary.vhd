library verilog;
use verilog.vl_types.all;
entity lanlb1 is
    port(
        en              : in     vl_logic;
        d               : in     vl_logic;
        q               : out    vl_logic;
        qn              : out    vl_logic
    );
end lanlb1;
