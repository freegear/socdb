library verilog;
use verilog.vl_types.all;
entity sdnrq1 is
    port(
        cp              : in     vl_logic;
        d               : in     vl_logic;
        sc              : in     vl_logic;
        sd              : in     vl_logic;
        q               : out    vl_logic
    );
end sdnrq1;
