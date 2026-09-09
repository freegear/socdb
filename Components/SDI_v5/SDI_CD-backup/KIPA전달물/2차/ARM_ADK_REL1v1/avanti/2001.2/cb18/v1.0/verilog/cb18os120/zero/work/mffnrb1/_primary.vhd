library verilog;
use verilog.vl_types.all;
entity mffnrb1 is
    port(
        cp              : in     vl_logic;
        d               : in     vl_logic;
        enn             : in     vl_logic;
        q               : out    vl_logic;
        qn              : out    vl_logic
    );
end mffnrb1;
