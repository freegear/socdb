library verilog;
use verilog.vl_types.all;
entity denrq2 is
    port(
        cp              : in     vl_logic;
        d               : in     vl_logic;
        enn             : in     vl_logic;
        q               : out    vl_logic
    );
end denrq2;
