library verilog;
use verilog.vl_types.all;
entity sdnrb2 is
    port(
        d               : in     vl_logic;
        sd              : in     vl_logic;
        sc              : in     vl_logic;
        cp              : in     vl_logic;
        q               : out    vl_logic;
        qn              : out    vl_logic
    );
end sdnrb2;
