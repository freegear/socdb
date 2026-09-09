library verilog;
use verilog.vl_types.all;
entity dfprb1 is
    port(
        d               : in     vl_logic;
        cp              : in     vl_logic;
        sdn             : in     vl_logic;
        q               : out    vl_logic;
        qn              : out    vl_logic
    );
end dfprb1;
