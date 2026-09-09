library verilog;
use verilog.vl_types.all;
entity jkbrb2 is
    port(
        j               : in     vl_logic;
        kz              : in     vl_logic;
        cp              : in     vl_logic;
        q               : out    vl_logic;
        qn              : out    vl_logic;
        sdn             : in     vl_logic;
        cdn             : in     vl_logic
    );
end jkbrb2;
