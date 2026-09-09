library verilog;
use verilog.vl_types.all;
entity dfcrq2 is
    port(
        d               : in     vl_logic;
        cp              : in     vl_logic;
        cdn             : in     vl_logic;
        q               : out    vl_logic
    );
end dfcrq2;
