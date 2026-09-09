library verilog;
use verilog.vl_types.all;
entity sdcfq2 is
    port(
        cpn             : in     vl_logic;
        cdn             : in     vl_logic;
        d               : in     vl_logic;
        sc              : in     vl_logic;
        sd              : in     vl_logic;
        q               : out    vl_logic
    );
end sdcfq2;
