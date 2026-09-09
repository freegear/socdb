library verilog;
use verilog.vl_types.all;
entity dfnrb2 is
    port(
        d               : in     vl_logic;
        cp              : in     vl_logic;
        q               : out    vl_logic;
        qn              : out    vl_logic
    );
end dfnrb2;
