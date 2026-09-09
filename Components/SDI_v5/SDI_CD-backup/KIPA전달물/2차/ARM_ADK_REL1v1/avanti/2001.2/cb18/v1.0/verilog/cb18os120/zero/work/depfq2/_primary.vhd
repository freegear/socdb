library verilog;
use verilog.vl_types.all;
entity depfq2 is
    port(
        cpn             : in     vl_logic;
        sdn             : in     vl_logic;
        d               : in     vl_logic;
        enn             : in     vl_logic;
        q               : out    vl_logic
    );
end depfq2;
