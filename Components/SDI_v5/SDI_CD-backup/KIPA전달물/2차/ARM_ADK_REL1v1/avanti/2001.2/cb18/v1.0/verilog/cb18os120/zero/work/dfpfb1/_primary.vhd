library verilog;
use verilog.vl_types.all;
entity dfpfb1 is
    port(
        d               : in     vl_logic;
        cpn             : in     vl_logic;
        sdn             : in     vl_logic;
        q               : out    vl_logic;
        qn              : out    vl_logic
    );
end dfpfb1;
