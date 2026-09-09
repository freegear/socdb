library verilog;
use verilog.vl_types.all;
entity dfcrn1 is
    port(
        d               : in     vl_logic;
        cp              : in     vl_logic;
        cdn             : in     vl_logic;
        qn              : out    vl_logic
    );
end dfcrn1;
