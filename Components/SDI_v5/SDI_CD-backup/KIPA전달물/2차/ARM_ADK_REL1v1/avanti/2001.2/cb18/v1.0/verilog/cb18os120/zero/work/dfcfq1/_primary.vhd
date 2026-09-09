library verilog;
use verilog.vl_types.all;
entity dfcfq1 is
    port(
        d               : in     vl_logic;
        cpn             : in     vl_logic;
        cdn             : in     vl_logic;
        q               : out    vl_logic
    );
end dfcfq1;
