library verilog;
use verilog.vl_types.all;
entity decfq2 is
    port(
        cpn             : in     vl_logic;
        cdn             : in     vl_logic;
        d               : in     vl_logic;
        enn             : in     vl_logic;
        q               : out    vl_logic
    );
end decfq2;
